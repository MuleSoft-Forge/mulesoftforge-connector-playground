<template>
  <LabTemplate
    header-title="IDP"
    flow-diagram-img="idp.png"
    flow-doc-url="idp.html"
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
    :operations-grid-class="operationsGridClass"
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
      Test IDP Runtime Services (document processing, reviews) and Platform Services (action management)
    </template>

    <template #additional-controls>
      <!-- IDP Action & Version Selector -->
      <div v-if="requiresAction" class="mb-4 p-3 bg-purple-50 border border-purple-200 rounded-lg">
        <h4 class="text-xs font-semibold text-purple-900 mb-2 flex items-center">
          <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
          </svg>
          IDP Document Action
        </h4>
        
        <!-- Action Dropdown -->
        <div class="mb-3">
          <label class="block text-[11px] font-medium text-gray-700 mb-1">
            Select Action
            <span v-if="hasActionIdParam && lab.selectedOperation.value?.parameters?.find((p: any) => p.apiName === 'actionId')?.isRequired" class="text-red-500">*</span>
          </label>
          <select
            v-model="selectedActionId"
            @change="onActionChange"
            :disabled="loadingActions || !lab.selectedRuntimeConfigId.value"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md disabled:bg-gray-100 font-mono"
          >
            <option value="">{{ loadingActions ? 'Loading actions...' : 'Select an IDP action...' }}</option>
            <option v-for="action in idpActions" :key="action.id" :value="action.id">
              {{ action.name }} - {{ action.id }}
            </option>
          </select>
          <p v-if="!lab.selectedRuntimeConfigId.value" class="text-[10px] text-amber-600 mt-1">
            ⚠️ Select a runtime configuration first
          </p>
        </div>

        <!-- Version Dropdown (shown only after action is selected and if versionSemantic param exists) -->
        <div v-if="selectedActionId && hasVersionParam">
          <label class="block text-[11px] font-medium text-gray-700 mb-1">
            Select Version
            <span v-if="lab.selectedOperation.value?.parameters?.find((p: any) => p.apiName === 'versionSemantic')?.isRequired" class="text-red-500">*</span>
          </label>
          <select
            v-model="selectedVersion"
            @change="onVersionChange"
            :disabled="loadingVersions"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md disabled:bg-gray-100"
          >
            <option value="">{{ loadingVersions ? 'Loading versions...' : 'Select a version...' }}</option>
            <option v-for="version in idpActionVersions" :key="version.version" :value="version.version">
              v{{ version.version }}
            </option>
          </select>
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
        <input
          v-else-if="param.validationRules?.inputType === 'text'"
          v-model="lab.formData.value[param.apiName]"
          type="text"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        />
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
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
      />
      <label v-else-if="param.dataType === 'Boolean'" class="flex items-center gap-2">
        <input
          type="checkbox"
          v-model="lab.formData.value[param.apiName]"
          class="w-4 h-4 text-indigo-600 border-gray-300 rounded"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      <div v-else-if="param.dataType === 'Base64'">
        <input
          type="file"
          @change="handleFileUpload($event, param.apiName)"
          class="w-full text-[11px] file:mr-2 file:py-1 file:px-3 file:rounded file:border-0 file:text-xs file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100"
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
      </div>
    </template>
  </LabTemplate>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import { apiGet } from '../../composables/useApi'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import { logger } from '../../utils/logger'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

import { MULE_ORIGIN, getAssetUrl } from '../../config/api'

// IDP Action & Version State
const idpActions = ref<any[]>([])
const idpActionVersions = ref<any[]>([])
const selectedActionId = ref('')
const selectedVersion = ref('')
const loadingActions = ref(false)
const loadingVersions = ref(false)

// Computed: Does current operation require action selection?
const requiresAction = computed(() => {
  return hasActionIdParam.value
})

const hasActionIdParam = computed(() => {
  return lab.selectedOperation.value?.parameters?.some((p: any) => p.apiName === 'actionId')
})

const hasVersionParam = computed(() => {
  return lab.selectedOperation.value?.parameters?.some((p: any) => p.apiName === 'versionSemantic')
})

// Use 2-column grid for Platform category operations
const operationsGridClass = computed(() => {
  return lab.activeCategory.value === 'Platform' 
    ? 'grid grid-cols-2 gap-2' 
    : 'grid grid-cols-1 gap-2'
})

// Watch runtime config changes - fetch actions when config is selected
watch(() => lab.selectedRuntimeConfigId.value, (newConfigId) => {
  if (newConfigId && requiresAction.value) {
    fetchIdpActions(newConfigId)
  } else {
    idpActions.value = []
    selectedActionId.value = ''
    selectedVersion.value = ''
    idpActionVersions.value = []
  }
})

// Watch operation changes - auto-populate if selections exist
watch(() => lab.selectedOperation.value, () => {
  if (!requiresAction.value) {
    // Operation doesn't need action/version, clear UI selections but keep them in memory
    // Don't clear idpActions or selectedActionId - they might be needed for next operation
  } else {
    // Operation needs action/version
    if (lab.selectedRuntimeConfigId.value && idpActions.value.length === 0) {
      // Fetch actions if we don't have them yet
      fetchIdpActions(lab.selectedRuntimeConfigId.value)
    }
    
    // Auto-populate form data if action/version are already selected
    if (selectedActionId.value && hasActionIdParam.value) {
      lab.formData.value.actionId = selectedActionId.value
    }
    if (selectedVersion.value && hasVersionParam.value) {
      lab.formData.value.versionSemantic = selectedVersion.value
    }
  }
})

// Fetch IDP Actions from backend
async function fetchIdpActions(configId: number) {
  loadingActions.value = true
  try {
    idpActions.value = await apiGet(`/runtime-configs/${configId}/idp/actions`)
  } catch (error) {
    logger.error('Error fetching IDP actions:', error)
    idpActions.value = []
  } finally {
    loadingActions.value = false
  }
}

// Fetch IDP Action Versions from backend
async function fetchIdpActionVersions(configId: number, actionId: string) {
  loadingVersions.value = true
  try {
    idpActionVersions.value = await apiGet(`/runtime-configs/${configId}/idp/actions/${actionId}/versions`)
  } catch (error) {
    logger.error('Error fetching IDP action versions:', error)
    idpActionVersions.value = []
  } finally {
    loadingVersions.value = false
  }
}

// Handle action selection
function onActionChange() {
  // Update formData with selected actionId
  if (selectedActionId.value) {
    lab.formData.value.actionId = selectedActionId.value
    
    // Fetch versions if this operation needs them
    if (hasVersionParam.value && lab.selectedRuntimeConfigId.value) {
      fetchIdpActionVersions(lab.selectedRuntimeConfigId.value, selectedActionId.value)
    }
  } else {
    lab.formData.value.actionId = ''
    selectedVersion.value = ''
    idpActionVersions.value = []
  }
  
  // Clear version when action changes
  selectedVersion.value = ''
  lab.formData.value.versionSemantic = ''
}

// Handle version selection
function onVersionChange() {
  if (selectedVersion.value) {
    lab.formData.value.versionSemantic = selectedVersion.value
  } else {
    lab.formData.value.versionSemantic = ''
  }
}

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

function getJsonPlaceholder(param: any): string {
  if (param.apiName === 'contents') {
    return '{"analyzersResults": [], "queriesResults": {}, "results": {}, "signaturesResults": {}}'
  }
  if (param.apiName === 'callbackUrl') {
    return '{"noAuthUrl": "https://my.service.com/callback"}'
  }
  return `Enter ${param.displayName} (JSON format)`
}

async function handleFileUpload(event: Event, paramName: string) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  try {
    const base64 = await fileToBase64(file)
    const base64Content = base64.split(',')[1]
    lab.formData.value[paramName] = base64Content
    
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
