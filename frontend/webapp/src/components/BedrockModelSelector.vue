<template>
  <div class="bedrock-model-selector">
    <input
      type="text"
      :value="modelValue"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      :disabled="loading || !runtimeConfigId"
      :placeholder="loading ? 'Loading models...' : (runtimeConfigId ? 'Enter or select a model...' : 'Select runtime config first')"
      list="bedrock-models-datalist"
      :class="[
        'w-full px-2 py-1.5 text-xs border rounded-md',
        loading ? 'bg-gray-100 cursor-wait' : 'border-gray-300'
      ]"
    />
    <datalist id="bedrock-models-datalist">
      <template v-for="group in groupedModels" :key="group.provider">
        <option v-for="model in group.models" :key="model.modelId" :value="model.modelId">
          {{ group.provider }} - {{ model.modelId }}
        </option>
      </template>
    </datalist>
    
    <div v-if="error" class="text-[10px] text-red-600 mt-1">
      ⚠️ {{ error }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed, onMounted } from 'vue'
import { apiCall } from '../composables/useApi'

interface BedrockModel {
  modelId: string
  modelName: string
  provider: string
  inputModalities: string[]
  outputModalities: string[]
  modelLifecycleStatus: string
}

interface Props {
  modelValue?: string
  runtimeConfigId: number | '' | null
  operationContext?: string
  operations: any[]
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: '',
  operationContext: 'default'
})

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const models = ref<BedrockModel[]>([])
const loading = ref(false)
const error = ref('')
const cachedModels = ref<Record<number, BedrockModel[]>>({})

// Debug component mount
onMounted(() => {
  console.log('[BedrockModelSelector] Component mounted', {
    runtimeConfigId: props.runtimeConfigId,
    operationContext: props.operationContext,
    hasOperations: props.operations.length > 0
  })
})

const groupedModels = computed(() => {
  const groups = new Map<string, BedrockModel[]>()
  
  models.value.forEach(model => {
    const providerName = model.modelName
    if (!groups.has(providerName)) {
      groups.set(providerName, [])
    }
    groups.get(providerName)!.push(model)
  })
  
  return Array.from(groups.entries()).map(([provider, models]) => ({
    provider,
    models: models.sort((a, b) => a.provider.localeCompare(b.provider))
  })).sort((a, b) => a.provider.localeCompare(b.provider))
})

function filterModelsByContext(allModels: BedrockModel[]): BedrockModel[] {
  return allModels.filter(model => {
    const isActive = model.modelLifecycleStatus === 'ACTIVE'
    const inputMods = model.inputModalities || []
    const outputMods = model.outputModalities || []
    
    if (!isActive) return false
    
    switch (props.operationContext) {
      case 'chat':
        return outputMods.includes('TEXT') && inputMods.includes('TEXT')
      case 'embedding':
        return outputMods.includes('EMBEDDING')
      case 'image-generation':
        return outputMods.includes('IMAGE')
      case 'vision':
        return inputMods.includes('IMAGE') && outputMods.includes('TEXT')
      default:
        return outputMods.includes('TEXT')
    }
  })
}

async function fetchModels() {
  console.log('[BedrockModelSelector] fetchModels called', {
    runtimeConfigId: props.runtimeConfigId,
    operationContext: props.operationContext,
    operationsCount: props.operations.length
  })
  
  if (!props.runtimeConfigId) {
    console.log('[BedrockModelSelector] No runtime config selected')
    models.value = []
    return
  }
  
  // Check cache first
  if (props.runtimeConfigId && cachedModels.value[props.runtimeConfigId]) {
    models.value = filterModelsByContext(cachedModels.value[props.runtimeConfigId])
    return
  }
  
  loading.value = true
  error.value = ''
  
  try {
    console.log('[BedrockModelSelector] Operations available:', props.operations.length)
    console.log('[BedrockModelSelector] Looking for foundational-models-list operation')
    
    // Find the foundational-models-list operation
    const modelsListOp = props.operations.find(
      op => op.operationKey === 'mac-bedrock:foundational-models-list'
    )
    
    console.log('[BedrockModelSelector] Found operation:', modelsListOp)
    
    if (!modelsListOp) {
      throw new Error('Foundational models list operation not found. Available operations: ' + 
        props.operations.map(o => o.operationKey).join(', '))
    }
    
    // Call /execute endpoint
    const data = await apiCall('/execute', 'POST', {
      operationId: modelsListOp.id,
      runtimeConfigId: props.runtimeConfigId,
      parameters: {},
      enableValidation: false,
      enableLogging: false
    })
    
    console.log('[BedrockModelSelector] API Response:', data)
    
    // Extract models from response - the path varies based on connector response structure
    let allModels: BedrockModel[] = []
    
    if (data.result?.payload?.modelSummaries) {
      allModels = data.result.payload.modelSummaries
    } else if (data.result?.payload) {
      // Sometimes the payload is directly the array or has different structure
      allModels = Array.isArray(data.result.payload) ? data.result.payload : []
    }
    
    console.log('[BedrockModelSelector] Extracted models:', allModels.length)
    
    if (allModels.length === 0) {
      throw new Error('No models returned from API. Check response structure.')
    }
    
    // Cache the raw results
    cachedModels.value[props.runtimeConfigId] = allModels
    
    // Filter and display
    models.value = filterModelsByContext(allModels)
    
    console.log('[BedrockModelSelector] Filtered models:', models.value.length)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to load models'
    models.value = []
  } finally {
    loading.value = false
  }
}

// Fetch models when runtime config or context changes
watch([() => props.runtimeConfigId, () => props.operationContext], () => {
  if (props.runtimeConfigId && typeof props.runtimeConfigId === 'number' && cachedModels.value[props.runtimeConfigId]) {
    // Re-filter from cache
    models.value = filterModelsByContext(cachedModels.value[props.runtimeConfigId])
  } else {
    fetchModels()
  }
}, { immediate: true })
</script>

<style scoped>
.bedrock-model-selector select {
  font-family: 'Inter', system-ui, sans-serif;
}
</style>

