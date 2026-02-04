<template>
  <div>
    <LabTemplate
      header-title="Agentforce"
      flow-diagram-img="agentforce.png"
      flow-doc-url="agentforce.html"
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
      @execute="executeOperation"
      @clear="lab.clearResponse"
    >
      <template #icon>
        <ConnectorIcon :icon-url="getIconSrc(lab.connector.value?.icon)" size="lg" />
      </template>
      
      <template #subtitle>
        Test your Agentforce Agents with live execution
      </template>

      <template #additional-controls>
        <!-- Agent Selector -->
        <div v-if="requiresAgentList" class="mb-4 grid grid-cols-2 gap-3">
          <!-- Left: Agent Dropdown -->
          <div class="p-3 bg-gradient-to-r from-blue-50 to-indigo-50 border border-blue-200 rounded-lg">
            <h4 class="text-xs font-semibold text-blue-900 mb-2 flex items-center">
              <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/>
              </svg>
              Salesforce Agent
            </h4>
            
            <div>
              <label class="block text-[11px] font-medium text-gray-700 mb-1">
                Select Agent
                <span v-if="hasAgentListParam && lab.selectedOperation.value?.parameters?.find((p: any) => p.apiName === 'agentList')?.isRequired" class="text-red-500">*</span>
              </label>
              <select
                v-model="selectedAgentId"
                @change="onAgentChange"
                :disabled="loadingAgents || !lab.selectedRuntimeConfigId.value"
                class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md disabled:bg-gray-100 font-mono"
              >
                <option value="">{{ loadingAgents ? 'Loading agents...' : 'Select an Agentforce agent...' }}</option>
                <option 
                  v-for="agent in agentforceAgents" 
                  :key="agent.id" 
                  :value="agent.id"
                  :disabled="!agent.isActive"
                  :class="{ 'text-gray-400': !agent.isActive }"
                >
                  {{ agent.name }} [{{ agent.id }}]{{ agent.isActive ? '' : ' (Inactive)' }}
                </option>
              </select>
              <p v-if="!lab.selectedRuntimeConfigId.value" class="text-[10px] text-amber-600 mt-1">
                ⚠️ Select a runtime configuration first
              </p>
              <p v-else-if="agentforceAgents.length > 0" class="text-[10px] text-green-600 mt-1">
                ✓ {{ agentforceAgents.filter(a => a.isActive).length }} active / {{ agentforceAgents.length }} total
              </p>
            </div>
          </div>

          <!-- Right: Info Panel -->
          <div class="p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
            <h4 class="text-xs font-semibold text-yellow-900 mb-2 flex items-center">
              <svg class="w-4 h-4 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
              </svg>
              Don't See Your Agents?
            </h4>
            <div class="text-[10px] text-yellow-800 space-y-1">
              <p><strong>✓ Only Active agents</strong> are selectable</p>
              <p><strong>✗ System agents filtered:</strong></p>
              <ul class="ml-3 space-y-0.5">
                <li>• Einstein Copilot</li>
                <li>• Agentforce (Default)</li>
              </ul>
              <p class="mt-2 pt-2 border-t border-yellow-300"><strong>To see your agent:</strong> Activate it in Salesforce Setup → Agents</p>
              
              <details class="mt-2 pt-2 border-t border-yellow-300">
                <summary class="cursor-pointer font-semibold hover:text-yellow-900">🔍 Backend Query</summary>
                <div class="mt-2 bg-yellow-100 rounded p-2 text-[9px] font-mono overflow-x-auto">
                  <pre>SELECT Status, BotDefinitionId,
       BotDefinition.MasterLabel
FROM BotVersion 
WHERE Status = 'Active'
  AND BotDefinition.MasterLabel NOT LIKE '%Einstein Copilot%'
  AND BotDefinition.MasterLabel NOT LIKE '%Agentforce (Default)%'</pre>
                </div>
              </details>
            </div>
          </div>
        </div>
      </template>
      
      <template #param-input="{ param }">
        <!-- Skip agentList param if using dynamic selector -->
        <div v-if="param.apiName === 'agentList' && requiresAgentList">
          <!-- Render nothing - handled by additional-controls above -->
        </div>
        <div v-else-if="param.dataType === 'String'">
          <select
            v-if="param.validationRules?.enum"
            v-model="lab.formData.value[param.apiName]"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            :class="{ 'bg-blue-50 border-blue-300': isAutoPopulated(param.apiName) }"
          >
            <option value="">Select {{ param.displayName }}...</option>
            <option v-for="val in param.validationRules.enum" :key="val" :value="val">
              {{ val }}
            </option>
          </select>
        <div v-else class="space-y-1">
          <textarea
            v-model="lab.formData.value[param.apiName]"
            rows="3"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y"
            :class="{ 'bg-blue-50 border-blue-300': isAutoPopulated(param.apiName) }"
          />
          <button
            v-if="isJsonField(param.apiName)"
            @click="formatJsonField(param.apiName)"
            class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
          >
            ✨ Format JSON
          </button>
        </div>
        </div>
        <input
          v-else-if="param.dataType === 'Number'"
          v-model.number="lab.formData.value[param.apiName]"
          type="number"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
          :class="{ 'bg-blue-50 border-blue-300': isAutoPopulated(param.apiName) }"
        />
        <label v-else-if="param.dataType === 'Boolean'" class="flex items-center gap-2">
          <input
            type="checkbox"
            v-model="lab.formData.value[param.apiName]"
            class="w-4 h-4 text-blue-600 border-gray-300 rounded"
          />
          <span class="text-xs text-gray-700">Enable</span>
        </label>
        <div v-else class="space-y-1">
          <textarea
            v-model="lab.formData.value[param.apiName]"
            rows="2"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
          />
          <button
            v-if="isJsonField(param.apiName)"
            @click="formatJsonField(param.apiName)"
            class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
          >
            ✨ Format JSON
          </button>
        </div>
      </template>

      <!-- Conversation Flow Indicator (side by side with operations) -->
      <template #operations-side>
        <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg p-3 border border-blue-100 h-full">
          <h3 class="text-xs font-semibold text-gray-700 mb-3">Conversation Flow</h3>
          <div class="space-y-2">
            <div :class="['p-2 rounded-md text-xs font-medium flex items-center justify-between', conversationState.hasSession ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-600']">
              <span>1. Start</span>
              <svg v-if="conversationState.hasSession" class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
              </svg>
            </div>
            <div :class="['p-2 rounded-md text-xs font-medium flex items-center justify-between', conversationState.messageCount > 0 ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-600']">
              <span>2. Continue ({{ conversationState.messageCount }})</span>
              <svg v-if="conversationState.messageCount > 0" class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
              </svg>
            </div>
            <div :class="['p-2 rounded-md text-xs font-medium flex items-center justify-between', conversationState.hasEnded ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-600']">
              <span>3. End</span>
              <svg v-if="conversationState.hasEnded" class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/>
              </svg>
            </div>
          </div>
          <div v-if="conversationState.sessionId" class="mt-3 pt-3 border-t border-blue-200">
            <p class="text-[10px] font-semibold text-gray-700 mb-1">Session ID</p>
            <p class="text-[11px] text-gray-600 font-mono bg-white rounded px-2 py-1 border border-gray-200 break-all">
              {{ conversationState.sessionId }}
            </p>
          </div>
        </div>
      </template>

      <!-- Custom Response Display with Toggle -->
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
          <div class="flex items-center justify-between mb-2">
            <h4 class="text-sm font-semibold text-green-700 flex items-center">
              <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              Execution Successful
            </h4>
            <div class="flex items-center gap-2">
              <button @click="clearResponse" class="text-xs text-gray-600 hover:text-gray-900 transition-colors">Clear</button>
            </div>
          </div>

          <!-- Raw JSON View Only -->
          <div class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
            <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
          </div>

          <!-- Attributes -->
          <div v-if="lastResponse.result.attributes" class="mb-3">
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
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import { apiGet } from '../../composables/useApi'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'
import { logger } from '../../utils/logger'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

const conversationState = ref({
  sessionId: '',
  messageCount: 0,
  hasSession: false,
  hasEnded: false
})


// Agentforce Agent State
const agentforceAgents = ref<any[]>([])
const selectedAgentId = ref('')
const loadingAgents = ref(false)

// Computed: Does current operation require agent selection?
const requiresAgentList = computed(() => {
  return hasAgentListParam.value
})

const hasAgentListParam = computed(() => {
  return lab.selectedOperation.value?.parameters?.some((p: any) => p.apiName === 'agentList')
})

import { MULE_ORIGIN, getAssetUrl } from '../../config/api'

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

// Fetch Agentforce Agents from backend
async function fetchAgentforceAgents(configId: number) {
  loadingAgents.value = true
  try {
    agentforceAgents.value = await apiGet(`/runtime-configs/${configId}/agentforce/agents`)
  } catch (error) {
    logger.error('Error fetching Agentforce agents:', error)
    agentforceAgents.value = []
  } finally {
    loadingAgents.value = false
  }
}

// Handle agent selection
function onAgentChange() {
  if (selectedAgentId.value) {
    lab.formData.value.agentList = selectedAgentId.value
  } else {
    lab.formData.value.agentList = ''
  }
}

function selectOperation(operation: any) {
  lab.selectOperation(operation)
  
  // Auto-populate conversation-specific fields
  if (operation.parameters) {
    for (const param of operation.parameters) {
      if (param.apiName === 'sessionId' && conversationState.value.sessionId) {
        lab.formData.value[param.apiName] = conversationState.value.sessionId
      } else if (param.apiName === 'messageSequenceNumber') {
        lab.formData.value[param.apiName] = conversationState.value.messageCount + 1
      } else if (param.apiName === 'agentList' && selectedAgentId.value) {
        lab.formData.value[param.apiName] = selectedAgentId.value
      }
    }
  }
}

function isAutoPopulated(paramName: string): boolean {
  return (paramName === 'sessionId' && !!conversationState.value.sessionId) || 
         paramName === 'messageSequenceNumber' ||
         (paramName === 'agentList' && !!selectedAgentId.value)
}

// Watch runtime config changes - fetch agents when config is selected
watch(() => lab.selectedRuntimeConfigId.value, (newConfigId) => {
  if (newConfigId && requiresAgentList.value) {
    fetchAgentforceAgents(newConfigId)
  } else {
    agentforceAgents.value = []
    selectedAgentId.value = ''
  }
})

// Watch operation changes - auto-populate if selections exist
watch(() => lab.selectedOperation.value, () => {
  if (!requiresAgentList.value) {
    // Operation doesn't need agent, keep selections in memory
  } else {
    // Operation needs agent
    if (lab.selectedRuntimeConfigId.value && agentforceAgents.value.length === 0) {
      // Fetch agents if we don't have them yet
      fetchAgentforceAgents(lab.selectedRuntimeConfigId.value)
    }
    
    // Auto-populate form data if agent is already selected
    if (selectedAgentId.value && hasAgentListParam.value) {
      lab.formData.value.agentList = selectedAgentId.value
    }
  }
})

watch(() => conversationState.value.sessionId, (newSessionId) => {
  if (lab.formData.value.hasOwnProperty('sessionId')) {
    lab.formData.value.sessionId = newSessionId
  }
})

async function executeOperation() {
  await lab.executeOperation()
  
  if (lab.lastResponse.value && lab.selectedOperation.value) {
    const opKey = lab.selectedOperation.value.operationKey
    const payload = lab.lastResponse.value.result.payload
    
    if (opKey === 'ms-agentforce:start-agent-conversation') {
      conversationState.value.sessionId = payload.sessionId || ''
      conversationState.value.hasSession = true
      conversationState.value.messageCount = 0
      lab.formData.value.sessionId = conversationState.value.sessionId
    } else if (opKey === 'ms-agentforce:continue-agent-conversation') {
      conversationState.value.messageCount++
      if (lab.formData.value.messageSequenceNumber !== undefined) {
        lab.formData.value.messageSequenceNumber = conversationState.value.messageCount + 1
      }
    } else if (opKey === 'ms-agentforce:end-agent-conversation') {
      conversationState.value.hasEnded = true
    }
  }
}

function isJsonField(fieldName: string): boolean {
  // Common JSON field names that might appear in Agentforce params
  return fieldName.toLowerCase().includes('json') || 
         fieldName.toLowerCase().includes('data') ||
         fieldName.toLowerCase().includes('payload')
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

</script>
