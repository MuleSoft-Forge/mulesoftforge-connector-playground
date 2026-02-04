<template>
  <div class="border border-gray-300 rounded-md bg-white">
    <!-- Header -->
    <div class="flex items-center justify-between bg-gray-50 px-3 py-2 border-b border-gray-300">
      <div class="flex items-center gap-2">
        <span class="text-xs font-semibold text-gray-700">Task Query Parameters</span>
      </div>
      
      <!-- View Toggle -->
      <div class="flex bg-white border border-gray-300 rounded overflow-hidden">
        <button
          @click="currentView = 'form'"
          :class="[
            'px-3 py-1 text-xs font-medium transition-colors',
            currentView === 'form' 
              ? 'bg-blue-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          📝 Form
        </button>
        <button
          @click="currentView = 'json'"
          :class="[
            'px-3 py-1 text-xs font-medium transition-colors border-l border-gray-300',
            currentView === 'json' 
              ? 'bg-blue-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          { } JSON
        </button>
      </div>
    </div>

    <!-- Form View -->
    <div v-if="currentView === 'form'" class="p-4 space-y-4">
      <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 text-xs text-blue-800">
        <div class="flex items-start gap-2">
          <svg class="w-4 h-4 text-blue-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <div>
            <p class="font-semibold mb-1">TaskQueryParams</p>
            <p class="text-[11px] leading-relaxed">
              Parameters for querying a task in A2A protocol
            </p>
          </div>
        </div>
      </div>

      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          id *
        </label>
        <input
          v-model="formData.id"
          @input="syncToJson"
          type="text"
          placeholder="task-abc123"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <p class="text-[10px] text-gray-500 mt-1">Unique identifier of the task to query</p>
      </div>

      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          historyLength
          <span class="text-gray-500 font-normal ml-1">(optional)</span>
        </label>
        <input
          v-model.number="formData.historyLength"
          @input="syncToJson"
          type="number"
          placeholder="10"
          min="0"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <p class="text-[10px] text-gray-500 mt-1">Number of history entries to include in the response</p>
      </div>

      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          pushNotificationConfigId
          <span class="text-gray-500 font-normal ml-1">(optional)</span>
        </label>
        <input
          v-model="formData.pushNotificationConfigId"
          @input="syncToJson"
          type="text"
          placeholder="config-xyz789"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <p class="text-[10px] text-gray-500 mt-1">Server generated id of the push notification config</p>
      </div>

      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          metadata
          <span class="text-gray-500 font-normal ml-1">(optional)</span>
        </label>
        <textarea
          v-model="metadataJson"
          @input="syncMetadataToForm"
          rows="3"
          placeholder='{"key": "value"}'
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
        />
        <p class="text-[10px] text-gray-500 mt-1">Additional metadata for the query</p>
      </div>
    </div>

    <!-- JSON View -->
    <div v-else class="p-4">
      <textarea
        v-model="jsonValue"
        @input="syncFromJson"
        rows="10"
        placeholder='{"id": "task-123"}'
        class="w-full px-3 py-2 text-xs border border-gray-300 rounded-md font-mono resize-y"
      />
      <div class="flex gap-2 mt-2">
        <button
          @click="formatJson"
          class="px-3 py-1.5 text-xs bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
        >
          ✨ Format
        </button>
        <button
          @click="validateJson"
          class="px-3 py-1.5 text-xs bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
        >
          ✓ Validate
        </button>
      </div>
      <div v-if="jsonError" class="mt-2 text-xs text-red-600">
        {{ jsonError }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { logger } from '../utils/logger'

interface TaskQueryParams {
  id: string
  historyLength?: number
  pushNotificationConfigId?: string
  metadata?: Record<string, any>
}

const props = defineProps<{
  modelValue?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const currentView = ref<'form' | 'json'>('form')
const jsonValue = ref('')
const jsonError = ref('')
const metadataJson = ref('')

const formData = ref<TaskQueryParams>({
  id: '',
  historyLength: undefined,
  pushNotificationConfigId: undefined,
  metadata: undefined
})

// Initialize from prop
if (props.modelValue) {
  try {
    const parsed = JSON.parse(props.modelValue)
    formData.value = {
      id: parsed.id || '',
      historyLength: parsed.historyLength,
      pushNotificationConfigId: parsed.pushNotificationConfigId,
      metadata: parsed.metadata
    }
    if (parsed.metadata) {
      metadataJson.value = JSON.stringify(parsed.metadata, null, 2)
    }
    jsonValue.value = props.modelValue
  } catch (err) {
    logger.error('Failed to parse initial value:', err)
    jsonValue.value = props.modelValue
  }
}

function syncToJson() {
  try {
    const obj: TaskQueryParams = {
      id: formData.value.id
    }
    
    if (formData.value.historyLength !== undefined && formData.value.historyLength !== null && formData.value.historyLength.toString() !== '') {
      obj.historyLength = formData.value.historyLength
    }
    
    if (formData.value.pushNotificationConfigId) {
      obj.pushNotificationConfigId = formData.value.pushNotificationConfigId
    }
    
    if (formData.value.metadata && Object.keys(formData.value.metadata).length > 0) {
      obj.metadata = formData.value.metadata
    }
    
    const jsonStr = JSON.stringify(obj, null, 2)
    jsonValue.value = jsonStr
    emit('update:modelValue', jsonStr)
    jsonError.value = ''
  } catch (err) {
    logger.error('Failed to sync to JSON:', err)
    jsonError.value = 'Failed to generate JSON'
  }
}

function syncMetadataToForm() {
  try {
    if (metadataJson.value.trim()) {
      formData.value.metadata = JSON.parse(metadataJson.value)
    } else {
      formData.value.metadata = undefined
    }
    syncToJson()
  } catch (err) {
    // Don't update if invalid JSON
    logger.debug('Invalid metadata JSON (will not sync):', err)
  }
}

function syncFromJson() {
  try {
    const parsed = JSON.parse(jsonValue.value)
    formData.value = {
      id: parsed.id || '',
      historyLength: parsed.historyLength,
      pushNotificationConfigId: parsed.pushNotificationConfigId,
      metadata: parsed.metadata
    }
    if (parsed.metadata) {
      metadataJson.value = JSON.stringify(parsed.metadata, null, 2)
    } else {
      metadataJson.value = ''
    }
    emit('update:modelValue', jsonValue.value)
    jsonError.value = ''
  } catch (err) {
    jsonError.value = 'Invalid JSON format'
    logger.error('Failed to parse JSON:', err)
  }
}

function formatJson() {
  try {
    const parsed = JSON.parse(jsonValue.value)
    jsonValue.value = JSON.stringify(parsed, null, 2)
    syncFromJson()
  } catch (err) {
    jsonError.value = 'Cannot format invalid JSON'
  }
}

function validateJson() {
  try {
    JSON.parse(jsonValue.value)
    jsonError.value = ''
    alert('✓ Valid JSON')
  } catch (err) {
    jsonError.value = 'Invalid JSON format'
  }
}

// Watch for external changes
watch(() => props.modelValue, (newVal) => {
  if (newVal && newVal !== jsonValue.value) {
    try {
      const parsed = JSON.parse(newVal)
      formData.value = {
        id: parsed.id || '',
        historyLength: parsed.historyLength,
        pushNotificationConfigId: parsed.pushNotificationConfigId,
        metadata: parsed.metadata
      }
      if (parsed.metadata) {
        metadataJson.value = JSON.stringify(parsed.metadata, null, 2)
      }
      jsonValue.value = newVal
    } catch (err) {
      logger.error('Failed to parse updated value:', err)
      jsonValue.value = newVal || ''
    }
  }
})
</script>

