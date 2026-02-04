<template>
    <LabTemplate
      header-title="Einstein AI"
      flow-diagram-img="einsteinai.png"
      flow-doc-url="einsteinai.html"
      :loading="lab.loading.value"
      :load-error="lab.loadError.value"
    :categories="lab.categories.value"
    :active-category="lab.activeCategory.value"
    @update:active-category="lab.activeCategory.value = $event"
    :filtered-operations="lab.filteredOperations.value"
    :selected-operation="lab.selectedOperation.value"
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
      Execute LLM interactions via the Salesforce Einstein Trust Layer
    </template>
    
    <template #param-input="{ param }">
      <!-- Custom Messages Builder for CHAT Generate From Messages -->
      <ChatMessagesBuilder
        v-if="param.apiName === 'messages' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Custom Tools Config Builder for TOOLS Use AI Service -->
      <ToolsConfigBuilder
        v-else-if="param.apiName === 'inputStream' && lab.selectedOperation.value?.operationKey === 'ms-einstein-ai:tools-use-ai-service'"
        v-model="lab.formData.value[param.apiName]"
        :default-config="crmToolsDefault"
      />
      <div v-else-if="param.dataType === 'String'" class="space-y-1">
        <select
          v-if="param.validationRules?.enum"
          v-model="lab.formData.value[param.apiName]"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        >
          <option value="">Select {{ param.displayName }}...</option>
          <option v-for="val in param.validationRules.enum" :key="val" :value="val">
            {{ val }}
          </option>
        </select>
        <textarea
          v-else
          v-model="lab.formData.value[param.apiName]"
          rows="3"
          :placeholder="`Enter ${param.displayName.toLowerCase()}`"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
        />
        <button
          v-if="!param.validationRules?.enum && isJsonField(param.apiName) && !['template', 'instructions'].includes(param.apiName)"
          @click="formatJsonField(param.apiName)"
          class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
        >
          ✨ Format JSON
        </button>
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
          class="w-4 h-4 text-blue-600 border-gray-300 rounded"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      <div v-else-if="param.dataType === 'Base64'">
        <!-- Conditional: URL or File -->
        <div v-if="param.apiName === 'inputStream' && lab.formData.value.fileType === 'URL'">
          <label class="block text-[10px] font-medium text-blue-600 mb-1">URL Mode: Enter document URL</label>
          <input
            type="text"
            v-model="lab.formData.value[param.apiName]"
            placeholder="https://example.com/document.pdf"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
          />
          <p class="text-[10px] text-gray-500 mt-0.5 italic">When fileType is URL, provide the document URL as a string</p>
        </div>
        <div v-else>
          <label v-if="param.apiName === 'inputStream' && lab.formData.value.fileType" class="block text-[10px] font-medium text-gray-600 mb-1">
            File Upload Mode: {{ lab.formData.value.fileType }} file
          </label>
          <input
            type="file"
            @change="handleFileUpload($event, param.apiName)"
            class="w-full text-[11px] file:mr-2 file:py-1 file:px-3 file:rounded file:border-0 file:text-xs file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
          />
          <div v-if="fileNames[param.apiName]" class="text-[10px] text-green-600 mt-0.5">
            File selected: {{ fileNames[param.apiName] }}
          </div>
        </div>
      </div>
      <textarea
        v-else
        v-model="lab.formData.value[param.apiName]"
        rows="2"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
      />
    </template>

    <!-- Custom Response Display for CHAT Operations -->
    <template #response-display="{ lastResponse, executionError, executing, clearResponse }">
      <div v-if="executing" class="bg-gradient-to-br from-blue-50 via-blue-100 to-indigo-50 border border-blue-200 rounded-lg p-20 flex items-center justify-center min-h-[400px]">
        <LoadingSpinner text="Executing operation..." />
      </div>

      <div v-else-if="executionError" class="bg-red-50 border border-red-200 rounded-md p-3 text-sm text-red-800">
        {{ executionError.title || 'Execution Failed' }}
        <div v-if="executionError.detail" class="text-[11px] mt-1">{{ executionError.detail }}</div>
      </div>

      <div v-else-if="lastResponse">
        <!-- Header -->
        <div class="flex items-center justify-between mb-3">
          <h4 class="text-sm font-semibold text-green-700 flex items-center">
            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Execution Successful
          </h4>
          <div class="flex items-center gap-2">
            <!-- View Toggle for CHAT, TOOLS & RAG Operations -->
            <div v-if="(isChatOperation && (lastResponse.result.payload?.generations?.[0]?.content || lastResponse.result.payload?.response)) || (isToolsOperation && lastResponse.result.payload?.response) || (isRagOperation && lastResponse.result.payload?.response)" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedChat = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedChat 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="showFormattedChat = false"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  !showFormattedChat 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                { } Raw
              </button>
            </div>
            <button @click="clearResponse" class="text-xs text-gray-600 hover:text-gray-900 transition-colors">Clear</button>
          </div>
        </div>

        <!-- Chat Response Display for CHAT Operations -->
        <div v-if="isChatOperation && (lastResponse.result.payload?.generations?.[0]?.content || lastResponse.result.payload?.response)">
          <!-- Formatted Chat View -->
          <div v-if="showFormattedChat">
            <div class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-2">Assistant Response</h5>
              <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-lg p-4">
                <div class="flex items-start gap-2 mb-2">
                  <div class="w-7 h-7 rounded-full bg-blue-500 flex items-center justify-center flex-shrink-0">
                    <span class="text-white text-sm">🤖</span>
                  </div>
                  <div class="flex-1">
                    <div class="text-xs font-semibold text-blue-900 mb-1">Assistant</div>
                    <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                      {{ lastResponse.result.payload.response || lastResponse.result.payload.generations[0].content }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Content Quality & Metadata (collapsible) - Only show if generations exist -->
            <details v-if="lastResponse.result.payload.generations?.[0]" class="mb-3 bg-gray-50 border border-gray-200 rounded-lg">
              <summary class="px-3 py-2 cursor-pointer text-xs font-semibold text-gray-700 hover:bg-gray-100 rounded-lg">
                📊 Response Metadata
              </summary>
              <div class="px-3 pb-3 pt-2 space-y-3">
                <!-- Content Quality -->
                <div v-if="lastResponse.result.payload.generations[0].contentQuality">
                  <h6 class="text-xs font-semibold text-gray-700 mb-1">Content Quality</h6>
                  <div class="bg-white rounded p-2 border border-gray-200">
                    <div v-if="!lastResponse.result.payload.generations[0].contentQuality.scanToxicity.isDetected" class="flex items-center gap-2 text-xs text-green-700">
                      <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
                      </svg>
                      <span class="font-medium">No toxicity detected</span>
                    </div>
                    <div v-else class="text-xs text-amber-700">⚠️ Toxicity detected</div>
                    
                    <details class="mt-2">
                      <summary class="text-[10px] text-gray-600 cursor-pointer hover:text-gray-800">View toxicity scores</summary>
                      <div class="mt-2 space-y-1">
                        <div v-for="cat in lastResponse.result.payload.generations[0].contentQuality.scanToxicity.categories" :key="cat.categoryName" 
                             class="flex justify-between text-[10px] text-gray-600">
                          <span class="capitalize">{{ cat.categoryName }}:</span>
                          <span class="font-mono">{{ cat.score }}</span>
                        </div>
                      </div>
                    </details>
                  </div>
                </div>

                <!-- Parameters -->
                <div v-if="lastResponse.result.payload.generations[0].parameters">
                  <h6 class="text-xs font-semibold text-gray-700 mb-1">Generation Parameters</h6>
                  <div class="bg-white rounded p-2 border border-gray-200 text-[10px] font-mono text-gray-700">
                    <div><span class="text-gray-500">Finish Reason:</span> {{ lastResponse.result.payload.generations[0].parameters.finishReason }}</div>
                    <div><span class="text-gray-500">Index:</span> {{ lastResponse.result.payload.generations[0].parameters.index }}</div>
                    <div v-if="lastResponse.result.payload.generations[0].id"><span class="text-gray-500">ID:</span> {{ lastResponse.result.payload.generations[0].id }}</div>
                  </div>
                </div>
              </div>
            </details>

            <!-- Full Raw JSON (collapsible) -->
            <details class="bg-gray-50 border border-gray-200 rounded-lg">
              <summary class="px-3 py-2 cursor-pointer text-xs font-semibold text-gray-700 hover:bg-gray-100 rounded-lg">
                { } Full Payload (JSON)
              </summary>
              <div class="px-3 pb-3 pt-2">
                <pre class="bg-white border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
              </div>
            </details>
          </div>

          <!-- Raw JSON View -->
          <div v-else>
            <div class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
              <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
            </div>

            <div v-if="lastResponse.result.attributes" class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-1">Attributes</h5>
              <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.attributes, null, 2) }}</pre>
            </div>
          </div>
        </div>

        <!-- Tools Response Display for TOOLS Use AI Service -->
        <div v-else-if="isToolsOperation && lastResponse.result.payload?.response">
          <!-- Formatted Tools View -->
          <div v-if="showFormattedChat">
            <div class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-2">AI Response</h5>
              <div class="bg-gradient-to-br from-green-50 to-emerald-50 border border-green-200 rounded-lg p-4">
                <div class="flex items-start gap-2 mb-2">
                  <div class="w-7 h-7 rounded-full bg-green-500 flex items-center justify-center flex-shrink-0">
                    <span class="text-white text-sm">🤖</span>
                  </div>
                  <div class="flex-1">
                    <div class="text-xs font-semibold text-green-900 mb-1">AI Assistant</div>
                    <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                      {{ lastResponse.result.payload.response }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Full Raw JSON (collapsible) -->
            <details class="bg-gray-50 border border-gray-200 rounded-lg">
              <summary class="px-3 py-2 cursor-pointer text-xs font-semibold text-gray-700 hover:bg-gray-100 rounded-lg">
                { } Full Payload (JSON)
              </summary>
              <div class="px-3 pb-3 pt-2">
                <pre class="bg-white border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
              </div>
            </details>
          </div>

          <!-- Raw JSON View -->
          <div v-else>
            <div class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
              <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
            </div>

            <div v-if="lastResponse.result.attributes" class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-1">Attributes</h5>
              <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.attributes, null, 2) }}</pre>
            </div>
          </div>
        </div>

        <!-- RAG Response Display for RAG Adhoc Load Document -->
        <div v-else-if="isRagOperation && lastResponse.result.payload?.response">
          <!-- Formatted RAG View -->
          <div v-if="showFormattedChat">
            <div class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-2">RAG Response</h5>
              <div class="bg-gradient-to-br from-purple-50 to-violet-50 border border-purple-200 rounded-lg p-4">
                <div class="flex items-start gap-2 mb-2">
                  <div class="w-7 h-7 rounded-full bg-purple-500 flex items-center justify-center flex-shrink-0">
                    <span class="text-white text-sm">📚</span>
                  </div>
                  <div class="flex-1">
                    <div class="text-xs font-semibold text-purple-900 mb-1">RAG Assistant</div>
                    <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                      {{ lastResponse.result.payload.response }}
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Full Raw JSON (collapsible) -->
            <details class="bg-gray-50 border border-gray-200 rounded-lg">
              <summary class="px-3 py-2 cursor-pointer text-xs font-semibold text-gray-700 hover:bg-gray-100 rounded-lg">
                { } Full Payload (JSON)
              </summary>
              <div class="px-3 pb-3 pt-2">
                <pre class="bg-white border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
              </div>
            </details>
          </div>

          <!-- Raw JSON View -->
          <div v-else>
            <div class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
              <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
            </div>

            <div v-if="lastResponse.result.attributes" class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-1">Attributes</h5>
              <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.attributes, null, 2) }}</pre>
            </div>
          </div>
        </div>

        <!-- Default Payload Display for other operations -->
        <div v-else class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
          <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Attributes (only show for non-chat/non-tools/non-rag operations, since they show attributes in raw view above) -->
        <div v-if="lastResponse.result.attributes && !isChatOperation && !isToolsOperation && !isRagOperation" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-1">Attributes</h5>
          <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.attributes, null, 2) }}</pre>
        </div>

        <!-- Correlation ID at bottom -->
        <div class="pt-3 border-t border-gray-100">
          <a 
            href="https://docs.mulesoft.com/mule-runtime/latest/correlation-id"
            target="_blank"
            rel="noopener noreferrer"
            class="text-[10px] text-gray-500 hover:text-blue-600 transition-colors flex items-center gap-1"
          >
            <span>(Correlation ID: {{ lastResponse.executionId }})</span>
            <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
            </svg>
          </a>
        </div>
      </div>
    </template>
  </LabTemplate>
</template>

<script setup lang="ts">
import { ref, watch, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import ChatMessagesBuilder from '../../components/ChatMessagesBuilder.vue'
import { logger } from '../../utils/logger'
import ToolsConfigBuilder from '../../components/ToolsConfigBuilder.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

const crmToolsDefault = `[
  {
    "action": "Execute POST requests for API endpoints.",
    "url": "http://check-inventory-material.cloudhub.io/mmbe",
    "name": "Check Inventory",
    "method": "POST",
    "headers": "Basic XXX",
    "example-payload": "{\\n \\"materialNo\\": \\"paramValue\\"}",
    "query": [
      "Check inventory in SAP",
      "Check Stock Overview",
      "Show product availability for MULETEST0",
      "Check the inventory for MULETEST0",
      "Check Stock for 400-110"
    ],
    "description": "Check inventory details for material in SAP by providing the materialNo as input for paramValue. Please use the materialNo and not materialNumber. This action applies whenever users' intent is 'Stock overview', 'product availability', 'Inventory', 'available stock'. Use the headers to perform the request."
  },
  {
    "action": "Execute GET requests for API endpoints.",
    "url": "https://anypoint.mulesoft.com/mocking/api/v1/sources/exchange/assets/612eb739-4266-4f4c-bf2f-29953c153d80/accounts-api/1.0.1/m/accounts",
    "name": "Show Accounts",
    "method": "GET",
    "headers": "",
    "example-payload": "{}",
    "query": [
      "Get all accounts",
      "Show all accounts from CRM"
    ],
    "description": "Get all accounts from a CRM. This action applies whenever users' intent is 'CRM accounts', 'customers', 'customer accounts', 'accounts'."
  },
  {
    "action": "Execute GET requests for API endpoints.",
    "url": "https://anypoint.mulesoft.com/mocking/api/v1/sources/exchange/assets/7b99cead-a984-497b-9e6c-c16a3b4dcb76/employee-api/1.0.1/m/employees",
    "name": "Show Employees",
    "method": "GET",
    "headers": "",
    "example-payload": "{}",
    "query": [
      "Get all employee information",
      "Show employees for the country Switzerland",
      "How many employees do we have",
      "Show a list of all employees"
    ],
    "description": "Get all information about employees. This action applies whenever users' intent is 'employees', 'workforce'."
  }
]`

const fileNames = ref<Record<string, string>>({})
const showFormattedChat = ref(true) // Default to formatted chat view

import { MULE_ORIGIN, getAssetUrl } from '../../config/api'

// Detect if current operation supports Beauty view (has generations with content or response)
const isChatOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'ms-einstein-ai:chat-generate-from-messages' ||
         opKey === 'ms-einstein-ai:chat-answer-prompt' ||
         opKey === 'ms-einstein-ai:agent-define-prompt-template'
})

const isToolsOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'ms-einstein-ai:tools-use-ai-service'
})

const isRagOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'ms-einstein-ai:rag-adhoc-load-document'
})

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

function isJsonField(fieldName: string): boolean {
  // Common JSON field names
  const jsonFields = ['inputStream', 'template', 'data', 'instructions']
  return jsonFields.includes(fieldName)
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

watch(() => lab.formData.value.fileType, (newFileType, oldFileType) => {
  if (newFileType !== oldFileType && lab.formData.value.inputStream !== undefined) {
    lab.formData.value.inputStream = null
    if (fileNames.value.inputStream) {
      delete fileNames.value.inputStream
    }
  }
})

function handleFileUpload(event: Event, paramName: string) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) {
    delete lab.formData.value[paramName]
    delete fileNames.value[paramName]
    return
  }
  
  fileNames.value[paramName] = file.name
  
  const reader = new FileReader()
  reader.onload = (e) => {
    const base64 = e.target?.result as string
    const base64Data = base64.includes(',') ? base64.split(',')[1] : base64
    lab.formData.value[paramName] = base64Data
  }
  reader.readAsDataURL(file)
}
</script>
