<template>
  <LabTemplate
    header-title="MuleSoft Vectors"
    flow-diagram-img="vectors.png"
    flow-doc-url="index.html#_execute_vectors"
    :loading="lab.loading.value"
    :load-error="lab.loadError.value"
    :categories="lab.categories.value"
    :active-category="lab.activeCategory.value"
    @update:active-category="lab.activeCategory.value = $event"
    :filtered-operations="lab.filteredOperations.value"
    :selected-operation="filteredOperation"
    @select-operation="lab.selectOperation"
    :selected-runtime-config-id="lab.selectedRuntimeConfigId.value"
    @update:selected-runtime-config-id="lab.selectedRuntimeConfigId.value = $event"
    :filtered-config-types="lab.filteredConfigTypes.value"
    :executing="lab.executing.value"
    :can-execute="lab.canExecute.value"
    :validation-message="lab.validationMessage.value"
    :last-response="lab.lastResponse.value"
    @update:last-response="lab.lastResponse.value = $event"
    :execution-error="lab.executionError.value"
    @update:execution-error="lab.executionError.value = $event"
    :response-chat-message="lab.responseChatMessage.value"
    :response-contains-image="lab.responseContainsImage.value"
    :enable-logging="lab.enableLogging.value"
    @update:enable-logging="lab.enableLogging.value = $event"
    :enable-validation="lab.enableValidation.value"
    @update:enable-validation="lab.enableValidation.value = $event"
    :get-category-operation-count="lab.getCategoryOperationCount"
    :get-provider-configs="lab.getProviderConfigs"
    :get-required-config-type-name="lab.getRequiredConfigTypeName"
    :get-selected-provider-name="lab.getSelectedProviderName"
    @execute="lab.executeOperation"
    @clear="lab.clearResponse"
  >
    <template #icon>
      <ConnectorIcon :icon-url="getIconSrc(lab.connector.value?.icon)" size="lg" />
    </template>
    
    <template #subtitle>
      Test MuleSoft Vectors operations for embeddings, vector storage, and document transformation
    </template>
    
    <!-- Custom two-column layout for [Store] Add operation -->
    <template #operation-side-panel v-if="lab.selectedOperation.value?.operationKey === 'ms-vectors:store-add'">
      <div>
        <h4 class="text-sm font-semibold text-gray-900 mb-3">&nbsp;</h4>
        <div class="border border-gray-200 rounded-md p-3">
        <label class="block text-xs font-medium text-gray-700 mb-1">
          Metadata Entries
        </label>
        <textarea
          v-model="lab.formData.value['metadataEntries']"
          placeholder='{"key": "value"}'
          rows="3"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <button
          @click="formatJsonField('metadataEntries')"
          class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors mt-1"
        >
          ✨ Format JSON
        </button>
        <button
          v-if="lab.selectedOperation.value?.parameters.find((p: any) => p.apiName === 'metadataEntries')?.exampleValue"
          @click="loadExample('metadataEntries')"
          class="ml-2 px-2 py-1 text-[10px] bg-purple-50 border border-purple-300 text-purple-700 rounded hover:bg-purple-100 transition-colors mt-1"
        >
          📝 Load Example
        </button>
        <p class="text-[10px] text-gray-400 font-mono mt-1">Type: JSON</p>
        </div>
      </div>
    </template>

    <!-- Custom two-column layout for [Store] Query operation -->
    <template #operation-side-panel v-if="lab.selectedOperation.value?.operationKey === 'ms-vectors:query'">
      <div>
        <h4 class="text-sm font-semibold text-gray-900 mb-3">&nbsp;</h4>
        <div class="border border-gray-200 rounded-md p-3">
        <label class="block text-xs font-medium text-gray-700 mb-1">
          Metadata Condition
        </label>
        <textarea
          v-model="lab.formData.value['metadataConditions']"
          placeholder="index=1 AND CONTAINS(file_name,'example.pdf')"
          rows="3"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <p class="text-[10px] text-gray-400 font-mono mt-1">Type: String</p>
        </div>
      </div>
    </template>
    
    <template #param-input="{ param }">
      <div v-if="param.dataType === 'String'">
        <select
          v-if="param.validationRules?.enum"
          v-model="lab.formData.value[param.apiName]"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        >
          <option value="">Select {{ param.displayName }}...</option>
          <option v-for="option in param.validationRules.enum" :key="option" :value="option">
            {{ option }}
          </option>
        </select>
        <textarea
          v-else
          v-model="lab.formData.value[param.apiName]"
          rows="3"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y"
        />
      </div>
      <input
        v-else-if="param.dataType === 'Number'"
        v-model.number="lab.formData.value[param.apiName]"
        type="number"
        step="0.1"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
      />
      <label v-else-if="param.dataType === 'Boolean'" class="flex items-center gap-2">
        <input
          type="checkbox"
          v-model="lab.formData.value[param.apiName]"
          class="w-4 h-4 text-purple-600 border-gray-300 rounded"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      <div v-else-if="param.dataType === 'Base64'">
        <input
          type="file"
          @change="handleFileUpload($event, param.apiName)"
          class="w-full text-[11px] file:mr-2 file:py-1 file:px-3 file:rounded file:border-0 file:text-xs file:bg-purple-50 file:text-purple-700 hover:file:bg-purple-100"
        />
        <p class="text-[10px] text-gray-500 mt-0.5">File will be converted to Base64</p>
      </div>
      <div v-else class="space-y-1">
        <textarea
          v-model="lab.formData.value[param.apiName]"
          :placeholder="getJsonPlaceholder(param)"
          rows="3"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <button
          @click="formatJsonField(param.apiName)"
          class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
        >
          ✨ Format JSON
        </button>
        <p v-if="param.validationRules?.itemType" class="text-[10px] text-blue-600 mt-1 flex items-center">
          <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
          </svg>
          Array of {{ param.validationRules.itemType }}s - use JSON array format
        </p>
        <p v-if="param.exampleValue" class="text-[10px] text-purple-600 mt-1 font-mono bg-purple-50 px-2 py-0.5 rounded">
          Example: {{ param.exampleValue }}
        </p>
      </div>
    </template>
  </LabTemplate>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import { logger } from '../../utils/logger'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

import { MULE_ORIGIN, getAssetUrl } from '../../config/api'

// Filter out parameters that are rendered in side panel
const filteredOperation = computed(() => {
  const op = lab.selectedOperation.value
  if (!op) return null
  
  // For [Store] Add, exclude metadataEntries from parameters list
  if (op.operationKey === 'ms-vectors:store-add' && op.parameters) {
    return {
      ...op,
      parameters: op.parameters.filter((p: any) => p.apiName !== 'metadataEntries')
    }
  }
  
  // For [Store] Query, exclude metadataConditions from parameters list
  if (op.operationKey === 'ms-vectors:query' && op.parameters) {
    return {
      ...op,
      parameters: op.parameters.filter((p: any) => p.apiName !== 'metadataConditions')
    }
  }
  
  // For [Transform] Parse document, handle conditional parameters
  if (op.operationKey === 'ms-vectors:transform-parse-document' && op.parameters) {
    const documentParserValue = lab.formData.value['documentParser']
    
    return {
      ...op,
      parameters: op.parameters.filter((p: any) => {
        // Check if parameter has conditional rules
        const conditional = p.validationRules?.conditional
        if (!conditional) return true
        
        // Filter based on documentParser value
        if (conditional.parentParameter === 'documentParser') {
          return documentParserValue === conditional.showWhen
        }
        
        return true
      })
    }
  }
  
  return op
})

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

function getJsonPlaceholder(param: any): string {
  if (param.apiName === 'texts' && param.validationRules?.itemType === 'string') {
    return '["Text to generate embeddings from"]'
  }
  if (param.apiName === 'textSegmentsAndEmbeddings') {
    return 'Output from [Embedding] Generate from text operation'
  }
  if (param.apiName === 'metadataEntries') {
    return '{"key1": "value1", "key2": "value2"}'
  }
  if (param.apiName === 'ids') {
    return '["id1", "id2", "id3"]'
  }
  if (param.validationRules?.itemType === 'string') {
    return '["item1", "item2"]'
  }
  return `Enter ${param.displayName} (JSON format)`
}

function formatJsonField(fieldName: string) {
  try {
    const value = lab.formData.value[fieldName]
    if (value) {
      const parsed = JSON.parse(value)
      lab.formData.value[fieldName] = JSON.stringify(parsed, null, 2)
    }
  } catch (err) {
    logger.error('Failed to format JSON:', err)
  }
}

function loadExample(fieldName: string) {
  try {
    const param = lab.selectedOperation.value?.parameters.find((p: any) => p.apiName === fieldName)
    if (param?.exampleValue) {
      // Format the example value for better readability
      const parsed = JSON.parse(param.exampleValue)
      lab.formData.value[fieldName] = JSON.stringify(parsed, null, 2)
    }
  } catch (err) {
    // If parsing fails, just use the raw example value
    const param = lab.selectedOperation.value?.parameters.find((p: any) => p.apiName === fieldName)
    if (param?.exampleValue) {
      lab.formData.value[fieldName] = param.exampleValue
    }
    logger.error('Failed to load example:', err)
  }
}

async function handleFileUpload(event: Event, paramName: string) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  try {
    const base64 = await fileToBase64(file)
    const base64Content = base64.split(',')[1]
    lab.formData.value[paramName] = base64Content
    
    // Auto-populate fileName if parameter exists
    if (lab.selectedOperation.value?.parameters?.some((p: any) => p.apiName === 'fileName')) {
      lab.formData.value.fileName = file.name
    }
  } catch (error) {
    logger.error('Failed to convert file:', error)
    alert('Failed to convert file to Base64')
  }
}

function fileToBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.onload = () => resolve(reader.result as string)
    reader.onerror = reject
    reader.readAsDataURL(file)
  })
}
</script>
