<template>
  <LabTemplate
    header-title="Google Gemini"
    flow-diagram-img="gemini.png"
    flow-doc-url="gemini.html"
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
      <div class="flex items-center gap-3">
        <span>Access Google's Gemini AI models for multimodal content generation</span>
        <a
          href="https://ai.google.dev/gemini-api/docs"
          target="_blank"
          rel="noopener noreferrer"
          class="inline-flex items-center gap-1 px-2 py-1 text-[10px] font-semibold bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200 transition-colors"
        >
          <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
          </svg>
          API Docs
          <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
          </svg>
        </a>
      </div>
    </template>

    <template #param-input="{ param }">
      <!-- JSON Body Parameters -->
      <div v-if="param.dataType === 'JSON'" class="space-y-1">
        <textarea
          v-model="lab.formData.value[param.apiName]"
          rows="8"
          :placeholder="param.exampleValue || `Enter ${param.displayName.toLowerCase()} as JSON`"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
        />
        <div class="flex items-center justify-between">
          <button
            @click="formatJsonField(param.apiName)"
            class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
          >
            ✨ Format JSON
          </button>
          <button
            v-if="param.exampleValue"
            @click="loadExample(param.apiName, param.exampleValue)"
            class="px-2 py-1 text-[10px] bg-blue-100 border border-blue-300 text-blue-700 rounded hover:bg-blue-200 transition-colors"
          >
            📋 Load Example
          </button>
        </div>
      </div>
      
      <!-- String Parameters -->
      <input
        v-else-if="param.dataType === 'String'"
        v-model="lab.formData.value[param.apiName]"
        type="text"
        :placeholder="`Enter ${param.displayName.toLowerCase()}`"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
      />
      
      <!-- Number Parameters -->
      <input
        v-else-if="param.dataType === 'Number'"
        v-model.number="lab.formData.value[param.apiName]"
        type="number"
        :min="param.validationRules?.min"
        :max="param.validationRules?.max"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
      />
      
      <!-- Boolean Parameters -->
      <label v-else-if="param.dataType === 'Boolean'" class="flex items-center gap-2">
        <input
          type="checkbox"
          v-model="lab.formData.value[param.apiName]"
          class="w-4 h-4 text-blue-600 border-gray-300 rounded"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      
      <!-- Default fallback -->
      <textarea
        v-else
        v-model="lab.formData.value[param.apiName]"
        rows="3"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
      />
    </template>

    <!-- Custom Response Display -->
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
          <h4 class="text-sm font-semibold text-blue-700 flex items-center">
            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            Execution Successful
          </h4>
          <div class="flex items-center gap-2">
            <!-- View Toggle for Generate Content -->
            <div v-if="isGenerateContentResponse(lastResponse.result.payload)" class="flex bg-white border border-gray-300 rounded overflow-hidden">
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

        <!-- Generate Content Formatted View -->
        <div v-if="isGenerateContentResponse(lastResponse.result.payload) && showFormattedChat">
          <div class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-2">AI Response</h5>
            <div class="bg-gradient-to-br from-blue-50 to-indigo-50 border border-blue-200 rounded-lg p-4">
              <div class="flex items-start gap-2 mb-2">
                <div class="w-7 h-7 rounded-full bg-blue-500 flex items-center justify-center flex-shrink-0">
                  <span class="text-white text-sm">✨</span>
                </div>
                <div class="flex-1">
                  <div class="text-xs font-semibold text-blue-900 mb-1">Gemini</div>
                  <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                    {{ extractGeminiText(lastResponse.result.payload) }}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Metadata (collapsible) -->
          <details class="mb-3 bg-gray-50 border border-gray-200 rounded-lg">
            <summary class="px-3 py-2 cursor-pointer text-xs font-semibold text-gray-700 hover:bg-gray-100 rounded-lg">
              📊 Response Metadata
            </summary>
            <div class="px-3 pb-3 pt-2 space-y-2">
              <div class="bg-white rounded p-2 border border-gray-200 text-[10px] font-mono text-gray-700 space-y-1">
                <div v-if="lastResponse.result.payload.candidates?.[0]?.finishReason">
                  <span class="text-gray-500">Finish Reason:</span> {{ lastResponse.result.payload.candidates[0].finishReason }}
                </div>
                <div v-if="lastResponse.result.payload.candidates?.[0]?.index !== undefined">
                  <span class="text-gray-500">Candidate Index:</span> {{ lastResponse.result.payload.candidates[0].index }}
                </div>
                <div v-if="lastResponse.result.payload.promptFeedback">
                  <span class="text-gray-500">Safety Ratings:</span> 
                  {{ lastResponse.result.payload.promptFeedback.safetyRatings?.length || 0 }} checks
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

        <!-- List Models Formatted View -->
        <div v-else-if="isListModelsResponse(lastResponse.result.payload) && showFormattedChat">
          <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-1 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
            </svg>
            Available Models ({{ lastResponse.result.payload.models?.length || 0 }})
          </h5>
          
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
            <div v-for="model in lastResponse.result.payload.models" :key="model.name" class="bg-white border border-gray-200 rounded-lg p-3 hover:shadow-md transition-shadow">
              <div class="flex items-start justify-between mb-2">
                <h6 class="text-xs font-semibold text-gray-900 leading-tight flex-1">{{ model.displayName || model.name }}</h6>
              </div>
              <div class="text-[10px] text-gray-600 font-mono mb-2">{{ model.name }}</div>
              <div v-if="model.description" class="text-[10px] text-gray-600 mb-2 line-clamp-2">{{ model.description }}</div>
              <div class="flex flex-wrap gap-1">
                <span v-for="method in model.supportedGenerationMethods" :key="method" class="px-1.5 py-0.5 bg-blue-100 text-blue-700 rounded text-[9px] font-medium">
                  {{ method }}
                </span>
              </div>
            </div>
          </div>

          <!-- Full Raw JSON (collapsible) -->
          <details class="bg-gray-50 border border-gray-200 rounded-lg mt-3">
            <summary class="px-3 py-2 cursor-pointer text-xs font-semibold text-gray-700 hover:bg-gray-100 rounded-lg">
              { } Full Payload (JSON)
            </summary>
            <div class="px-3 pb-3 pt-2">
              <pre class="bg-white border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
            </div>
          </details>
        </div>

        <!-- Default Payload Display -->
        <div v-else class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
          <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
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
import { ref } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'
import { logger } from '../../utils/logger'
import { getAssetUrl } from '../../config/api'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

const showFormattedChat = ref(true)

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
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

function loadExample(fieldName: string, exampleValue: string) {
  try {
    const parsed = JSON.parse(exampleValue)
    lab.formData.value[fieldName] = JSON.stringify(parsed, null, 2)
  } catch (err) {
    lab.formData.value[fieldName] = exampleValue
  }
}

// Detect if response is from Generate Content
function isGenerateContentResponse(payload: any): boolean {
  return (
    typeof payload === 'object' &&
    payload !== null &&
    'candidates' in payload &&
    Array.isArray(payload.candidates)
  )
}

// Detect if response is from List Models
function isListModelsResponse(payload: any): boolean {
  return (
    typeof payload === 'object' &&
    payload !== null &&
    'models' in payload &&
    Array.isArray(payload.models)
  )
}

// Extract text from Gemini response
function extractGeminiText(payload: any): string {
  try {
    if (payload.candidates && payload.candidates.length > 0) {
      const candidate = payload.candidates[0]
      if (candidate.content && candidate.content.parts && candidate.content.parts.length > 0) {
        return candidate.content.parts.map((part: any) => part.text).join('\n')
      }
    }
    return 'No text content found in response'
  } catch (err) {
    logger.error('Failed to extract Gemini text:', err)
    return 'Error extracting response text'
  }
}
</script>
