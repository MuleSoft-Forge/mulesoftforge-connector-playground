<template>
  <div v-if="configDetails" class="mt-2 p-3 bg-blue-50 border border-blue-200 rounded-lg">
    <div class="flex items-start">
      <svg class="w-4 h-4 text-blue-600 mt-0.5 mr-2 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
      </svg>
      <div class="flex-1 text-xs">
        <div class="font-semibold text-blue-900 mb-1">Configuration Details:</div>
        
        <!-- API Key-based (MuleSoft Inference) -->
        <div v-if="isApiKeyBased" class="space-y-1 text-blue-800">
          <div v-if="configTypeName" class="flex items-center mb-1 pb-1 border-b border-blue-200">
            <span class="font-medium mr-1">Type:</span>
            <span class="text-blue-700">{{ configTypeName }}</span>
          </div>
          <!-- Show all parameters -->
          <div v-for="(value, key) in configDetails.parameters" :key="key" class="flex items-start">
            <span class="font-medium mr-1 whitespace-nowrap">{{ formatParamName(key) }}:</span>
            <span v-if="value === '••••••••'" class="flex items-center font-mono bg-gray-200 px-1.5 py-0.5 rounded text-xs text-gray-600">
              <svg class="w-3 h-3 mr-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/>
              </svg>
              {{ value }}
            </span>
            <span v-else class="font-mono bg-blue-100 px-1.5 py-0.5 rounded text-xs break-all">{{ value }}</span>
            <span v-if="key === 'temperature'" class="text-blue-600 ml-1 text-xs whitespace-nowrap">(controls randomness)</span>
            <span v-if="key === 'maxTokens'" class="text-blue-600 ml-1 text-xs whitespace-nowrap">(response length)</span>
          </div>
        </div>
        
        <!-- OAuth-based (Einstein AI, Agentforce) -->
        <div v-else-if="isOAuthBased" class="space-y-1 text-blue-800">
          <div v-if="configTypeName" class="flex items-center mb-1 pb-1 border-b border-blue-200">
            <span class="font-medium mr-1">Type:</span>
            <span class="text-blue-700">{{ configTypeName }}</span>
          </div>
          <!-- Show all parameters -->
          <div v-for="(value, key) in configDetails.parameters" :key="key" class="flex items-start">
            <span class="font-medium mr-1 whitespace-nowrap">{{ formatParamName(key) }}:</span>
            <span v-if="value === '••••••••'" class="flex items-center font-mono bg-gray-200 px-1.5 py-0.5 rounded text-xs text-gray-600">
              <svg class="w-3 h-3 mr-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/>
              </svg>
              {{ value }}
            </span>
            <span v-else class="font-mono bg-blue-100 px-1.5 py-0.5 rounded text-xs break-all">{{ value }}</span>
          </div>
        </div>
        
        <!-- Fallback: Show all parameters -->
        <div v-else class="space-y-1 text-blue-800">
          <div v-if="configTypeName" class="flex items-center">
            <span class="font-medium mr-1">Type:</span>
            <span class="text-blue-700">{{ configTypeName }}</span>
          </div>
          <div v-if="providerName" class="flex items-center">
            <span class="font-medium mr-1">Provider:</span>
            <span class="text-blue-700">{{ providerName }}</span>
          </div>
          <!-- Display all parameters (including masked sensitive ones) as fallback -->
          <div v-if="Object.keys(configDetails.parameters || {}).length === 0" class="text-blue-600 italic">
            No parameter values configured yet
          </div>
          <div v-else>
            <div v-for="(value, key) in configDetails.parameters" :key="key" class="flex items-start">
              <span class="font-medium mr-1 whitespace-nowrap">{{ formatParamName(key) }}:</span>
              <span v-if="value === '••••••••'" class="flex items-center font-mono bg-gray-200 px-1.5 py-0.5 rounded text-xs text-gray-600">
                <svg class="w-3 h-3 mr-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd"/>
                </svg>
                {{ value }}
              </span>
              <span v-else class="font-mono bg-blue-100 px-1.5 py-0.5 rounded text-xs break-all">{{ value }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { apiCall } from '../composables/useApi'
import { logger } from '../utils/logger'

const props = defineProps<{
  runtimeConfigId: number | string | null
  configTypeName?: string
  providerName?: string
}>()

const configDetails = ref<any>(null)
const loading = ref(false)

// Helper function to format parameter names for display
function formatParamName(apiName: string): string {
  // Convert camelCase to Title Case with spaces
  return apiName
    .replace(/([A-Z])/g, ' $1')
    .replace(/^./, str => str.toUpperCase())
    .trim()
}

// Computed properties for different config patterns
const isApiKeyBased = computed(() => {
  return configDetails.value?.parameters?.modelName !== undefined
})

const isOAuthBased = computed(() => {
  return configDetails.value?.parameters?.tokenUrl !== undefined
})

// Watch for changes to runtimeConfigId and fetch details
watch(() => props.runtimeConfigId, async (newId) => {
  if (!newId) {
    configDetails.value = null
    return
  }
  
  try {
    loading.value = true
    // Fetch runtime config details
    const config = await apiCall(`/runtime-configs/${newId}`, 'GET')
    
    // Transform config parameters into a flat parameters object
    // Show ALL parameters, but mask encrypted ones (as marked in database)
    const parameters: Record<string, string> = {}
    if (config.parameters && Array.isArray(config.parameters)) {
      config.parameters.forEach((param: any) => {
        // API returns: { apiName, value, isEncrypted, ... }
        if (param.apiName && param.value != null) {
          // Only mask if database says it's encrypted
          if (param.isEncrypted) {
            parameters[param.apiName] = '••••••••'
          } else {
            parameters[param.apiName] = param.value
          }
        }
      })
    }
    
    logger.debug('RuntimeConfigSummary: Loaded config', config.name, 'with parameters:', Object.keys(parameters))
    
    configDetails.value = {
      ...config,
      parameters
    }
  } catch (err) {
    logger.error('Failed to fetch runtime config details:', err)
    configDetails.value = null
  } finally {
    loading.value = false
  }
}, { immediate: true })
</script>

