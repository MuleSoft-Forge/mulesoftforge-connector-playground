<template>
  <LabTemplate
    header-title="MuleSoft Inference"
    flow-diagram-img="inference.png"
    flow-doc-url="index.html"
    :loading="lab.loading.value"
    :load-error="lab.loadError.value"
    :categories="lab.categories.value"
    :active-category="lab.activeCategory.value"
    @update:active-category="lab.activeCategory.value = $event"
    :filtered-operations="lab.filteredOperations.value"
    :selected-operation="lab.selectedOperation.value"
    @select-operation="selectOperation"
    :selected-runtime-config-id="lab.selectedRuntimeConfigId.value"
    @update:selected-runtime-config-id="lab.selectedRuntimeConfigId.value = $event"
    :filtered-config-types="lab.filteredConfigTypes.value"
    :executing="lab.executing.value"
    :can-execute="canExecuteWithMCPCheck"
    :validation-message="validationMessageWithMCPCheck"
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
      Harness the world of AI with one connector
    </template>

    <template #additional-controls>
      <!-- MCP Server Configuration (only for MCP Tooling operation) -->
      <div v-if="isMCPToolingOperation" class="mb-4 p-3 bg-amber-50 border border-amber-300 rounded-lg">
        <div class="flex items-start gap-2 mb-2">
          <svg class="w-4 h-4 mt-0.5 text-amber-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
          </svg>
          <div class="flex-1">
            <h4 class="text-xs font-bold text-amber-900">MCP Server Required</h4>
            <p class="text-[10px] text-amber-700 mt-0.5">
              This operation connects to an MCP server. Select which MCP client configuration to use.
            </p>
          </div>
        </div>
        
        <button
          @click="loadMCPClientConfigs"
          :disabled="loadingMCPConfigs"
          class="w-full mb-2 px-3 py-2 text-xs font-medium bg-amber-100 text-amber-800 rounded-md hover:bg-amber-200 transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
        >
          <svg v-if="!loadingMCPConfigs" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
          </svg>
          <svg v-else class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          {{ loadingMCPConfigs ? 'Loading MCP Configs...' : mcpClientConfigs.length > 0 ? `Reload (${mcpClientConfigs.length} found)` : 'Load Available MCP Configs' }}
        </button>
        
        <select 
          v-if="mcpClientConfigs.length > 0"
          v-model="selectedMCPConfigId"
          @change="updateMCPConfigInAttributes"
          class="w-full px-2 py-1.5 text-xs border border-amber-300 rounded-md bg-white"
        >
          <option value="">-- Select MCP Client Config --</option>
          <option v-for="config in mcpClientConfigs" :key="config.id" :value="config.id">
            {{ config.name }}
          </option>
        </select>
        <p class="text-[10px] text-amber-700 mt-1">
          Selected MCP config ID will be stored in Additional Request Attributes for backend processing.
        </p>

        <!-- Collapsible MCP Tools Section -->
        <div v-if="selectedMCPConfigId" class="mt-3 border-t border-amber-300 pt-3">
          <button
            @click="showMCPToolsSection = !showMCPToolsSection"
            class="w-full flex items-center justify-between px-2 py-1.5 text-xs font-medium text-amber-900 hover:bg-amber-100 rounded transition-colors"
          >
            <span class="flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
              </svg>
              Available MCP Tools
              <span v-if="availableMCPTools.length > 0" class="text-[10px] bg-amber-200 px-1.5 py-0.5 rounded">
                {{ availableMCPTools.length }}
              </span>
            </span>
            <svg 
              class="w-4 h-4 transition-transform"
              :class="{ 'rotate-180': showMCPToolsSection }"
              fill="none" 
              stroke="currentColor" 
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
            </svg>
          </button>

          <div v-if="showMCPToolsSection" class="mt-2 space-y-2">
            <button
              @click="loadMCPTools"
              :disabled="loadingMCPTools"
              class="w-full px-3 py-2 text-xs font-medium bg-amber-100 text-amber-800 rounded-md hover:bg-amber-200 transition-colors disabled:opacity-50 flex items-center justify-center gap-2"
            >
              <svg v-if="!loadingMCPTools" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
              </svg>
              <svg v-else class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              {{ loadingMCPTools ? 'Loading Tools...' : availableMCPTools.length > 0 ? `Reload (${availableMCPTools.length} found)` : 'Load Tools from Server' }}
            </button>

            <div v-if="availableMCPTools.length > 0" class="max-h-60 overflow-y-auto space-y-1 bg-white border border-amber-200 rounded-md p-2">
              <div
                v-for="tool in availableMCPTools"
                :key="tool.name"
                class="p-2 bg-amber-50 border border-amber-200 rounded text-[10px]"
              >
                <div class="font-semibold text-amber-900">{{ tool.name }}</div>
                <div class="text-amber-700 mt-0.5">{{ tool.description }}</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    
    <template #param-input="{ param }">
      <!-- Custom Messages Builder for Chat Completions -->
      <ChatMessagesBuilder
        v-if="param.apiName === 'messages' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Custom Tools Config Builder for [Tools] Native Template -->
      <ToolsConfigBuilder
        v-else-if="param.apiName === 'tools' && lab.selectedOperation.value?.operationKey === 'ms-inference:tools-native-template'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Special: Image Input (for Vision operations) -->
      <div v-else-if="param.apiName === 'image' && param.dataType === 'String'">
        <div class="flex gap-3 mb-2">
          <label class="flex items-center cursor-pointer">
            <input
              v-model="imageInputMode"
              type="radio"
              value="url"
              class="w-3 h-3 text-blue-600 border-gray-300"
            />
            <span class="ml-1 text-[11px] text-gray-700">Image URL</span>
          </label>
          <label class="flex items-center cursor-pointer">
            <input
              v-model="imageInputMode"
              type="radio"
              value="file"
              class="w-3 h-3 text-blue-600 border-gray-300"
            />
            <span class="ml-1 text-[11px] text-gray-700">Upload File</span>
          </label>
        </div>
        <textarea
          v-if="imageInputMode === 'url'"
          :value="lab.formData.value[param.apiName]"
          @input="handleImageUrlInput(($event.target as HTMLTextAreaElement).value)"
          rows="2"
          placeholder="https://example.com/image.jpg or paste Base64 data"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y"
        />
        <input
          v-else
          type="file"
          accept="image/*"
          @change="handleImageFileUpload"
          class="w-full text-[11px] file:mr-2 file:py-1 file:px-3 file:rounded file:border-0 file:text-xs file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
        />
        <div v-if="imagePreviewUrl" class="mt-2 p-2 bg-gray-50 rounded border border-gray-200">
          <div class="text-[10px] font-medium text-gray-700 mb-1">Preview:</div>
          <img 
            :src="imagePreviewUrl" 
            alt="Preview" 
            class="max-w-full max-h-32 rounded border border-gray-300"
            @error="imagePreviewUrl = null"
          />
        </div>
      </div>

      <!-- Standard inputs -->
      <div v-else-if="param.dataType === 'String'" class="space-y-1">
        <textarea
          v-model="lab.formData.value[param.apiName]"
          :rows="['template', 'instructions', 'data', 'prompt', 'messages', 'tools'].includes(param.apiName) ? 12 : 3"
          :placeholder="`Enter ${param.displayName.toLowerCase()}`"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y font-mono"
        />
        <button
          v-if="isJsonField(param.apiName) && !['template', 'instructions'].includes(param.apiName)"
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
      <div v-else>
        <textarea
          v-model="lab.formData.value[param.apiName]"
          :rows="['messages', 'tools'].includes(param.apiName) ? 12 : 3"
          :placeholder="`Enter ${param.displayName.toLowerCase()}`"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
        />
      </div>
    </template>

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
            <!-- View Toggle for text-based operations -->
            <div v-if="showsBeautyView(lastResponse)" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedView = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedView 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="showFormattedView = false"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  !showFormattedView 
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

        <!-- Beauty View for text-based operations -->
        <div v-if="showsBeautyView(lastResponse) && showFormattedView">
          <div class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-2">{{ getResponseTitle() }}</h5>
            <div :class="getBeautyContainerClass()">
              <div class="flex items-start gap-2 mb-2">
                <div :class="getIconContainerClass()">
                  <span class="text-white text-sm">{{ getResponseIcon() }}</span>
                </div>
                <div class="flex-1">
                  <div :class="getLabelClass()">{{ getResponseLabel() }}</div>
                  <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                    {{ getResponseContent(lastResponse) }}
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

        <!-- Raw JSON View or Default View -->
        <div v-else>
          <!-- Image Response Display -->
          <div v-if="lab.responseContainsImage.value" class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center">
              <svg class="w-4 h-4 mr-1 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
              </svg>
              Generated Image
            </h5>
            <div class="bg-gray-900 rounded-lg p-4 flex items-center justify-center" style="min-height: 200px">
              <img 
                :src="lab.responseContainsImage.value" 
                alt="Generated image" 
                class="max-w-full max-h-96 rounded shadow-lg"
                style="object-fit: contain"
              />
            </div>
            <p class="text-[10px] text-gray-500 mt-1">Right-click image to save</p>
          </div>

          <div class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
            <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
          </div>

          <div v-if="lastResponse.result.attributes" class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-1">Attributes</h5>
            <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.attributes, null, 2) }}</pre>
          </div>
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
import { ref, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'
import ChatMessagesBuilder from '../../components/ChatMessagesBuilder.vue'
import ToolsConfigBuilder from '../../components/ToolsConfigBuilder.vue'
import { logger } from '../../utils/logger'
import { apiCall } from '../../composables/useApi'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

const showFormattedView = ref(true)

const imageInputMode = ref<'url' | 'file'>('url')
const imagePreviewUrl = ref<string | null>(null)

// MCP Config Selection
const mcpClientConfigs = ref<any[]>([])
const loadingMCPConfigs = ref(false)
const selectedMCPConfigId = ref<number | string>('')

// MCP Tools Loading
const showMCPToolsSection = ref(false)
const availableMCPTools = ref<any[]>([])
const loadingMCPTools = ref(false)

const isMCPToolingOperation = computed(() => 
  lab.selectedOperation.value?.operationKey === 'ms-inference:mcp-tools-native-template'
)

// Extended canExecute check for MCP Tooling operation
const canExecuteWithMCPCheck = computed(() => {
  // First check the base lab.canExecute
  if (!lab.canExecute.value) return false
  
  // If MCP Tooling operation, also require MCP config selection
  if (isMCPToolingOperation.value && !selectedMCPConfigId.value) {
    return false
  }
  
  return true
})

// Extended validation message for MCP Tooling operation
const validationMessageWithMCPCheck = computed(() => {
  // First check base validation
  if (lab.validationMessage.value) return lab.validationMessage.value
  
  // If MCP Tooling operation, check for MCP config
  if (isMCPToolingOperation.value && !selectedMCPConfigId.value) {
    return 'Please select an MCP Client Configuration'
  }
  
  return ''
})

// Watch for image field changes and update preview for URL-based images
watch(() => lab.formData.value.image, (newImageValue) => {
  if (lab.selectedOperation.value?.operationKey === 'ms-inference:read-image') {
    if (newImageValue && typeof newImageValue === 'string') {
      if (newImageValue.startsWith('http')) {
        imagePreviewUrl.value = newImageValue
      } else if (newImageValue.startsWith('data:image')) {
        imagePreviewUrl.value = newImageValue
      }
    }
  }
})

import { getAssetUrl } from '../../config/api'

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

function isJsonField(fieldName: string): boolean {
  const jsonFields = ['messages', 'tools', 'data', 'instructions', 'template']
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

function selectOperation(operation: any) {
  lab.selectOperation(operation)
  imagePreviewUrl.value = null
  imageInputMode.value = 'url'
}

async function handleImageFileUpload(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  if (!file.type.startsWith('image/')) {
    alert('Please select an image file')
    return
  }
  
  try {
    const base64 = await fileToBase64(file)
    lab.formData.value.image = base64
    imagePreviewUrl.value = base64
  } catch (error) {
    logger.error('Failed to convert image:', error)
    alert('Failed to convert image to Base64')
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

function handleImageUrlInput(url: string) {
  lab.formData.value.image = url
  imagePreviewUrl.value = url
}

// MCP Config Management
async function loadMCPClientConfigs() {
  loadingMCPConfigs.value = true
  try {
    const connectors = await apiCall('/connectors', 'GET')
    const mcpConnector = connectors.find((c: any) => c.mavenArtifactId === 'mule4-mcp-connector')
    
    if (!mcpConnector) {
      alert('MCP Connector not found. Please ensure MCP connector is configured.')
      return
    }
    
    const configTypes = await apiCall(`/connectors/${mcpConnector.id}/config-types`, 'GET')
    const clientConfigType = configTypes.find((ct: any) => ct.configTypeKey === 'mcp:client-config')
    
    if (!clientConfigType) {
      alert('MCP Client config type not found.')
      return
    }
    
    const runtimeConfigs = await apiCall(`/runtime-configs?configTypeId=${clientConfigType.id}`, 'GET')
    
    mcpClientConfigs.value = runtimeConfigs
      .filter((rc: any) => rc.isActive)
      .map((rc: any) => ({
        id: rc.id,
        name: rc.name
      }))
    
    logger.debug(`[Inference MCP] Loaded ${mcpClientConfigs.value.length} MCP client configs`)
  } catch (err: any) {
    logger.error('[Inference MCP] Error loading MCP configs:', err)
    alert(`Failed to load MCP configs: ${err.message}`)
  } finally {
    loadingMCPConfigs.value = false
  }
}

function updateMCPConfigInAttributes() {
  if (!selectedMCPConfigId.value) {
    return
  }
  
  // Get current additionalRequestAttributes
  let currentAttrs = {}
  try {
    if (lab.formData.value.additionalRequestAttributes) {
      currentAttrs = JSON.parse(lab.formData.value.additionalRequestAttributes)
    }
  } catch (e) {
    logger.warn('Failed to parse existing additionalRequestAttributes, starting fresh')
  }
  
  // Merge in the mcpClientConfigId
  const updatedAttrs = {
    ...currentAttrs,
    mcpClientConfigId: selectedMCPConfigId.value
  }
  
  // Update the field
  lab.formData.value.additionalRequestAttributes = JSON.stringify(updatedAttrs, null, 2)
  logger.debug('[Inference MCP] Updated additionalRequestAttributes with mcpClientConfigId:', selectedMCPConfigId.value)
}

// Load MCP Tools from selected MCP server
async function loadMCPTools() {
  if (!selectedMCPConfigId.value) {
    alert('Please select an MCP Client Configuration first')
    return
  }

  try {
    loadingMCPTools.value = true
    
    // Find the MCP connector
    const connectors = await apiCall('/connectors', 'GET')
    const mcpConnector = connectors.find((c: any) => c.mavenArtifactId === 'mule4-mcp-connector')
    
    if (!mcpConnector) {
      alert('MCP Connector not found')
      return
    }

    // Get connector details to find the List Tools operation
    const connectorDetail = await apiCall(`/connectors/${mcpConnector.id}`, 'GET')
    
    // Find the List Tools operation
    const listToolsOperation = connectorDetail.operations?.find((op: any) => 
      op.operationKey === 'mcp:list-tools' || 
      op.displayName.toLowerCase().includes('list tools')
    )
    
    if (!listToolsOperation) {
      alert('MCP List Tools operation not found')
      return
    }

    // Execute the List Tools operation with the selected MCP config
    const result = await apiCall('/execute', 'POST', {
      operationId: listToolsOperation.id,
      runtimeConfigId: Number(selectedMCPConfigId.value),
      parameters: {},
      enableLogging: false,
      enableValidation: false
    })
    
    // Extract tools from response
    if (result?.result?.payload && Array.isArray(result.result.payload)) {
      availableMCPTools.value = result.result.payload
      logger.debug(`[Inference MCP] Loaded ${availableMCPTools.value.length} tools from MCP server`)
    } else {
      logger.error('[Inference MCP] Unexpected response format:', result)
      alert('Failed to load tools: Unexpected response format')
    }
  } catch (err: any) {
    logger.error('[Inference MCP] Error loading tools:', err)
    alert(`Failed to load tools: ${err.message}`)
  } finally {
    loadingMCPTools.value = false
  }
}

// Watch for operation changes - clear MCP config when switching away
watch(() => lab.selectedOperation.value, (newOp) => {
  if (newOp?.operationKey !== 'ms-inference:mcp-tools-native-template') {
    // Clear when switching away from MCP Tooling
    selectedMCPConfigId.value = ''
    mcpClientConfigs.value = []
    availableMCPTools.value = []
    showMCPToolsSection.value = false
  }
})

// Watch for MCP config changes - clear tools
watch(() => selectedMCPConfigId.value, () => {
  availableMCPTools.value = []
  showMCPToolsSection.value = false
})

// Helper functions for Beauty view
function showsBeautyView(response: any): boolean {
  const opKey = lab.selectedOperation.value?.operationKey
  const payload = response?.result?.payload
  
  // Check if operation has text response content
  return !!(
    (opKey === 'ms-inference:agent-define-prompt-template' && payload?.response) ||
    (opKey === 'ms-inference:chat-answer-prompt' && payload?.response) ||
    (opKey === 'ms-inference:chat-completions' && payload?.response) ||
    (opKey === 'ms-inference:tools-native-template' && payload?.response) ||
    (opKey === 'ms-inference:mcp-tools-native-template' && payload?.response) ||
    (opKey === 'ms-inference:read-image' && payload?.response) ||
    (opKey === 'ms-inference:toxicity-detection-text' && payload)
  )
}

function getResponseContent(response: any): string {
  const opKey = lab.selectedOperation.value?.operationKey
  const payload = response?.result?.payload
  
  if (opKey === 'ms-inference:toxicity-detection-text') {
    // Format toxicity results using 'flagged' field
    const isFlagged = payload?.flagged === true
    const categoriesArray = payload?.categories || []
    let result = `Toxicity Detected: ${isFlagged ? '🚩 YES - Content Flagged' : '✅ NO - Content Safe'}\n\n`
    result += 'Category Scores:\n'
    
    // Handle categories as array of objects with key-value pairs
    categoriesArray.forEach((categoryObj: any) => {
      Object.entries(categoryObj).forEach(([categoryName, score]) => {
        const scoreValue = typeof score === 'number' ? score.toFixed(4) : score
        const warningIcon = (score as number) > 0.5 ? '⚠️' : '  '
        result += `  ${warningIcon} ${categoryName}: ${scoreValue}\n`
      })
    })
    return result
  }
  
  return payload?.response || JSON.stringify(payload, null, 2)
}

function getResponseTitle(): string {
  const opKey = lab.selectedOperation.value?.operationKey
  if (opKey === 'ms-inference:agent-define-prompt-template') return 'Agent Response'
  if (opKey === 'ms-inference:chat-answer-prompt') return 'Chat Response'
  if (opKey === 'ms-inference:chat-completions') return 'Chat Completion'
  if (opKey === 'ms-inference:tools-native-template') return 'Tools Response'
  if (opKey === 'ms-inference:mcp-tools-native-template') return 'MCP Tools Response'
  if (opKey === 'ms-inference:read-image') return 'Vision Analysis'
  if (opKey === 'ms-inference:toxicity-detection-text') return 'Toxicity Detection Results'
  return 'Response'
}

function getBeautyContainerClass(): string {
  const opKey = lab.selectedOperation.value?.operationKey
  if (opKey === 'ms-inference:agent-define-prompt-template') return 'bg-gradient-to-br from-orange-50 to-amber-50 border border-orange-200 rounded-lg p-4'
  if (opKey === 'ms-inference:chat-answer-prompt' || opKey === 'ms-inference:chat-completions') return 'bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-lg p-4'
  if (opKey === 'ms-inference:tools-native-template' || opKey === 'ms-inference:mcp-tools-native-template') return 'bg-gradient-to-br from-green-50 to-emerald-50 border border-green-200 rounded-lg p-4'
  if (opKey === 'ms-inference:read-image') return 'bg-gradient-to-br from-violet-50 to-purple-50 border border-violet-200 rounded-lg p-4'
  if (opKey === 'ms-inference:toxicity-detection-text') return 'bg-gradient-to-br from-pink-50 to-rose-50 border border-pink-200 rounded-lg p-4'
  return 'bg-gradient-to-br from-gray-50 to-gray-100 border border-gray-200 rounded-lg p-4'
}

function getIconContainerClass(): string {
  const opKey = lab.selectedOperation.value?.operationKey
  if (opKey === 'ms-inference:agent-define-prompt-template') return 'w-7 h-7 rounded-full bg-orange-500 flex items-center justify-center flex-shrink-0'
  if (opKey === 'ms-inference:chat-answer-prompt' || opKey === 'ms-inference:chat-completions') return 'w-7 h-7 rounded-full bg-blue-500 flex items-center justify-center flex-shrink-0'
  if (opKey === 'ms-inference:tools-native-template' || opKey === 'ms-inference:mcp-tools-native-template') return 'w-7 h-7 rounded-full bg-green-500 flex items-center justify-center flex-shrink-0'
  if (opKey === 'ms-inference:read-image') return 'w-7 h-7 rounded-full bg-violet-500 flex items-center justify-center flex-shrink-0'
  if (opKey === 'ms-inference:toxicity-detection-text') return 'w-7 h-7 rounded-full bg-pink-500 flex items-center justify-center flex-shrink-0'
  return 'w-7 h-7 rounded-full bg-gray-500 flex items-center justify-center flex-shrink-0'
}

function getResponseIcon(): string {
  const opKey = lab.selectedOperation.value?.operationKey
  if (opKey === 'ms-inference:agent-define-prompt-template') return '🤖'
  if (opKey === 'ms-inference:chat-answer-prompt' || opKey === 'ms-inference:chat-completions') return '💬'
  if (opKey === 'ms-inference:tools-native-template' || opKey === 'ms-inference:mcp-tools-native-template') return '🛠️'
  if (opKey === 'ms-inference:read-image') return '👁️'
  if (opKey === 'ms-inference:toxicity-detection-text') return '🔍'
  return '📄'
}

function getLabelClass(): string {
  const opKey = lab.selectedOperation.value?.operationKey
  if (opKey === 'ms-inference:agent-define-prompt-template') return 'text-xs font-semibold text-orange-900 mb-1'
  if (opKey === 'ms-inference:chat-answer-prompt' || opKey === 'ms-inference:chat-completions') return 'text-xs font-semibold text-blue-900 mb-1'
  if (opKey === 'ms-inference:tools-native-template' || opKey === 'ms-inference:mcp-tools-native-template') return 'text-xs font-semibold text-green-900 mb-1'
  if (opKey === 'ms-inference:read-image') return 'text-xs font-semibold text-violet-900 mb-1'
  if (opKey === 'ms-inference:toxicity-detection-text') return 'text-xs font-semibold text-pink-900 mb-1'
  return 'text-xs font-semibold text-gray-900 mb-1'
}

function getResponseLabel(): string {
  const opKey = lab.selectedOperation.value?.operationKey
  if (opKey === 'ms-inference:agent-define-prompt-template') return 'Agent'
  if (opKey === 'ms-inference:chat-answer-prompt' || opKey === 'ms-inference:chat-completions') return 'AI Assistant'
  if (opKey === 'ms-inference:tools-native-template' || opKey === 'ms-inference:mcp-tools-native-template') return 'Tools Assistant'
  if (opKey === 'ms-inference:read-image') return 'Vision AI'
  if (opKey === 'ms-inference:toxicity-detection-text') return 'Toxicity Scanner'
  return 'Response'
}
</script>
