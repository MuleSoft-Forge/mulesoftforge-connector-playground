import { ref, computed, onMounted, watch } from 'vue'
import { apiCall } from './useApi'
import { STORAGE_KEYS } from '../config/constants'

export interface LabState {
  connector: any
  operations: any[]
  selectedOperation: any | null
  formData: Record<string, any>
  loading: boolean
  loadError: string | null
  executing: boolean
  executionError: any
  lastResponse: any
  configTypes: any[]
  runtimeConfigs: any[]
  selectedRuntimeConfigId: number | ''
  categories: string[]
  activeCategory: string
}

export function useLab(connectorId: number) {
  const connector = ref<any>(null)
  const operations = ref<any[]>([])
  const selectedOperation = ref<any | null>(null)
  const formData = ref<Record<string, any>>({})
  const loading = ref<boolean>(true)
  const loadError = ref<string | null>(null)
  const executing = ref<boolean>(false)
  const executionError = ref<any>(null)
  const lastResponse = ref<any>(null)

  const configTypes = ref<any[]>([])
  const runtimeConfigs = ref<any[]>([])
  const selectedRuntimeConfigId = ref<number | ''>('')

  // Execution settings (default to true)
  const enableLogging = ref<boolean>(localStorage.getItem(STORAGE_KEYS.ENABLE_LOGGING) !== 'false')
  const enableValidation = ref<boolean>(localStorage.getItem(STORAGE_KEYS.ENABLE_VALIDATION) !== 'false')

  watch(selectedRuntimeConfigId, (newValue) => {
    if (newValue) {
      sessionStorage.setItem(STORAGE_KEYS.RUNTIME_CONFIG, String(newValue))
    } else {
      sessionStorage.removeItem(STORAGE_KEYS.RUNTIME_CONFIG)
    }
  })

  watch(enableLogging, (newValue) => {
    localStorage.setItem(STORAGE_KEYS.ENABLE_LOGGING, String(newValue))
  })

  watch(enableValidation, (newValue) => {
    localStorage.setItem(STORAGE_KEYS.ENABLE_VALIDATION, String(newValue))
  })

  const categories = computed<string[]>(() => {
    const set = new Set<string>()
    for (const op of operations.value) {
      if (op.category) set.add(op.category)
    }
    return Array.from(set)
  })

  const activeCategory = ref<string>('')

  const filteredOperations = computed(() => {
    if (!activeCategory.value) return operations.value
    return operations.value.filter(op => op.category === activeCategory.value)
  })

  // Auto-select first operation when category changes
  watch(activeCategory, () => {
    if (filteredOperations.value.length > 0 && !loading.value) {
      selectOperation(filteredOperations.value[0])
    }
  })

  function getCategoryOperationCount(category: string): number {
    return operations.value.filter(op => op.category === category).length
  }

  const filteredConfigTypes = computed(() => {
    if (!selectedOperation.value?.requiredConfigTypeId) {
      return configTypes.value
    }
    return configTypes.value.filter(ct => ct.id === selectedOperation.value.requiredConfigTypeId)
  })

  function getProviderConfigs(configTypeId: number, providerId: number) {
    return runtimeConfigs.value.filter(
      (config: any) => config.configType?.id === configTypeId && config.provider?.id === providerId
    )
  }

  function selectOperation(operation: any) {
    if (!operation) return
    selectedOperation.value = operation
    formData.value = {}
    executionError.value = null

    if (selectedRuntimeConfigId.value) {
      const selectedConfig = runtimeConfigs.value.find((rc: any) => rc.id === Number(selectedRuntimeConfigId.value))
      const isConfigValidForOperation = selectedConfig && (!operation.requiredConfigTypeId || selectedConfig.configType?.id === operation.requiredConfigTypeId)
      if (!isConfigValidForOperation) {
        selectedRuntimeConfigId.value = ''
      }
    }

    if (operation.parameters) {
      for (const param of operation.parameters) {
        if (param.defaultValue) {
          formData.value[param.apiName] = param.dataType === 'Boolean' ? param.defaultValue === 'true' : param.defaultValue
        } else if (param.exampleValue && param.dataType !== 'Boolean' && param.isRequired) {
          // Use exampleValue only for REQUIRED parameters if no defaultValue exists
          formData.value[param.apiName] = param.exampleValue
        } else if (param.dataType === 'Boolean') {
          formData.value[param.apiName] = false
        }
      }
    }
  }

  function getRequiredConfigTypeName(): string {
    if (!selectedOperation.value?.requiredConfigTypeId) return ''
    const configType = configTypes.value.find(ct => ct.id === selectedOperation.value.requiredConfigTypeId)
    return configType ? configType.displayName : ''
  }

  function getSelectedProviderName(): string {
    if (!selectedRuntimeConfigId.value) return ''
    const config = runtimeConfigs.value.find((rc: any) => rc.id === Number(selectedRuntimeConfigId.value))
    return config?.provider?.displayName || ''
  }

  const canExecute = computed(() => {
    if (!selectedOperation.value || !selectedRuntimeConfigId.value) return false
    if (selectedOperation.value.parameters) {
      for (const param of selectedOperation.value.parameters) {
        if (param.isRequired) {
          const value = formData.value[param.apiName]
          if (value === undefined || value === null || value === '') {
            return false
          }
        }
      }
    }
    return true
  })

  const validationMessage = computed(() => {
    if (!selectedRuntimeConfigId.value) {
      return 'Please select a runtime configuration'
    }
    if (!selectedOperation.value) return ''
    const missing: string[] = []
    if (selectedOperation.value.parameters) {
      for (const param of selectedOperation.value.parameters) {
        const value = formData.value[param.apiName]
        if (param.isRequired && (value === undefined || value === null || value === '')) {
          missing.push(param.displayName)
        }
      }
    }
    if (missing.length > 0) {
      return `Required fields missing: ${missing.join(', ')}`
    }
    return ''
  })

  async function executeOperation() {
    if (!selectedOperation.value || !connector.value || !selectedRuntimeConfigId.value) return
    try {
      executing.value = true
      executionError.value = null
      const response = await apiCall('/execute', 'POST', {
        operationId: selectedOperation.value.id,
        runtimeConfigId: Number(selectedRuntimeConfigId.value),
        parameters: formData.value,
        enableLogging: enableLogging.value,
        enableValidation: enableValidation.value
      })
      lastResponse.value = response
    } catch (err: any) {
      executionError.value = err
    } finally {
      executing.value = false
    }
  }

  function clearResponse() {
    lastResponse.value = null
    executionError.value = null
  }

  // Detect and format chat responses
  const responseChatMessage = computed(() => {
    if (!lastResponse.value?.result?.payload) return null
    
    const payload = lastResponse.value.result.payload
    
    // Check if response contains a chat message
    if (payload.response && typeof payload.response === 'string') {
      try {
        // Try to extract JSON from markdown code blocks
        const jsonMatch = payload.response.match(/```json\s*\n([\s\S]*?)\n```/)
        if (jsonMatch) {
          const parsed = JSON.parse(jsonMatch[1])
          return parsed.response || parsed.answer || parsed.message || payload.response
        }
        
        // Try parsing as direct JSON
        const parsed = JSON.parse(payload.response)
        return parsed.response || parsed.answer || parsed.message || payload.response
      } catch {
        // If not JSON, check if it looks like a chat response (not base64 image)
        if (payload.response.length < 10000 && !payload.response.startsWith('data:image/')) {
          return payload.response
        }
      }
    }
    
    return null
  })

  // Detect image responses
  const responseContainsImage = computed(() => {
    if (!lastResponse.value?.result?.payload) return null
    
    const payload = lastResponse.value.result.payload
    
    // Check payload.response field
    if (payload.response && typeof payload.response === 'string' && payload.response.length > 100) {
      if (payload.response.startsWith('data:image/')) {
        return payload.response
      }
      // Check if it's a base64 image (very long string without spaces)
      if (payload.response.length > 10000 && !payload.response.includes(' ')) {
        return `data:image/png;base64,${payload.response.trim()}`
      }
    }
    
    // Check if payload itself is a string (direct Base64)
    if (typeof payload === 'string' && payload.length > 10000) {
      if (payload.startsWith('data:image/')) {
        return payload
      }
      if (!payload.includes(' ')) {
        return `data:image/png;base64,${payload}`
      }
    }
    
    // Check other common image field names
    const imageFields = ['image', 'data', 'result', 'imageData', 'base64', 'returnBase64ForMCPG']
    for (const field of imageFields) {
      if (payload[field] && typeof payload[field] === 'string' && payload[field].length > 10000) {
        if (payload[field].startsWith('data:image/')) {
          return payload[field]
        }
        if (!payload[field].includes(' ')) {
          return `data:image/png;base64,${payload[field]}`
        }
      }
    }
    
    return null
  })

  onMounted(async () => {
    try {
      loading.value = true
      loadError.value = null

      connector.value = await apiCall(`/connectors/${connectorId}`, 'GET')
      operations.value = (connector.value.operations || []).filter((op: any) => op.isActive)

      // Default active category to first available
      activeCategory.value = categories.value[0] || ''

      configTypes.value = await apiCall(`/connectors/${connectorId}/config-types`, 'GET')

      const configPromises = configTypes.value.map(ct => apiCall(`/runtime-configs?configTypeId=${ct.id}`, 'GET'))
      const allConfigs = await Promise.all(configPromises)
      // Only load active runtime configs into labs
      runtimeConfigs.value = allConfigs.flat().filter((config: any) => config.isActive)

      const persisted = sessionStorage.getItem(STORAGE_KEYS.RUNTIME_CONFIG)
      if (persisted) {
        const exists = runtimeConfigs.value.some((rc: any) => rc.id === Number(persisted))
        if (exists) selectedRuntimeConfigId.value = Number(persisted)
      }

      if (filteredOperations.value.length > 0) {
        selectOperation(filteredOperations.value[0])
      }
    } catch (err: any) {
      loadError.value = err.message || 'Failed to load connector'
    } finally {
      loading.value = false
    }
  })

  return {
    connector,
    operations,
    selectedOperation,
    formData,
    loading,
    loadError,
    executing,
    executionError,
    lastResponse,
    configTypes,
    runtimeConfigs,
    selectedRuntimeConfigId,
    categories,
    activeCategory,
    filteredOperations,
    filteredConfigTypes,
    getCategoryOperationCount,
    getProviderConfigs,
    selectOperation,
    getRequiredConfigTypeName,
    getSelectedProviderName,
    canExecute,
    validationMessage,
    executeOperation,
    clearResponse,
    responseChatMessage,
    responseContainsImage,
    enableLogging,
    enableValidation
  }
}


