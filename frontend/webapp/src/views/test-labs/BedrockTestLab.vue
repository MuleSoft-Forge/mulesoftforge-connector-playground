<template>
  <LabTemplate
    header-title="Amazon Bedrock"
    flow-diagram-img="bedrock.png"
    flow-doc-url="https://mac-project.ai/docs/amazon-bedrock/connector-overview"
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
      Access AWS Bedrock foundation models for chat, embedding, image generation, and agents
    </template>

    <!-- Custom 3-column layout for Agent operations -->
    <template #operations-list="{ operations, selectedOperation, selectedRuntimeConfigId, selectOperation }">
      <div v-if="lab.activeCategory.value === 'Agent'" class="bg-white rounded-lg border border-gray-200 shadow-sm">
        <div class="p-4 border-b border-gray-200 bg-gradient-to-r from-amber-50 to-orange-50">
          <h3 class="text-sm font-bold text-gray-900">Agent Operations</h3>
          <p class="text-[10px] text-gray-600 mt-0.5">Organized by function type</p>
        </div>
        
        <div class="p-4">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- Search Column -->
            <div>
              <div class="flex items-center gap-1 mb-2 pb-1 border-b border-amber-200">
                <svg class="w-3.5 h-3.5 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
                <h4 class="text-xs font-bold text-amber-900">Search</h4>
              </div>
              <div class="space-y-1">
                <button
                  v-for="operation in operations.filter((op: any) => 
                    ['Agent list', 'Agent get by name', 'Agent get by id', 'Agent get alias by agent id'].includes(op.displayName)
                  )"
                  :key="operation.id"
                  @click="selectOperation(operation)"
                  :disabled="!selectedRuntimeConfigId"
                  :class="[
                    'w-full text-left px-2 py-1.5 rounded text-xs transition-colors',
                    !selectedRuntimeConfigId ? 'opacity-60 cursor-not-allowed' : '',
                    selectedOperation?.id === operation.id
                      ? 'bg-amber-100 text-amber-900 font-semibold border border-amber-300'
                      : 'hover:bg-amber-50 text-gray-700'
                  ]"
                >
                  {{ operation.displayName }}
                </button>
              </div>
            </div>

            <!-- Maintain Column -->
            <div>
              <div class="flex items-center gap-1 mb-2 pb-1 border-b border-orange-200">
                <svg class="w-3.5 h-3.5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"/>
                </svg>
                <h4 class="text-xs font-bold text-orange-900">Maintain</h4>
              </div>
              <div class="space-y-1">
                <button
                  v-for="operation in operations.filter((op: any) => 
                    ['Agent create', 'Agent create alias', 'Agent delete by id', 'Agent delete agent aliases'].includes(op.displayName)
                  )"
                  :key="operation.id"
                  @click="selectOperation(operation)"
                  :disabled="!selectedRuntimeConfigId"
                  :class="[
                    'w-full text-left px-2 py-1.5 rounded text-xs transition-colors',
                    !selectedRuntimeConfigId ? 'opacity-60 cursor-not-allowed' : '',
                    selectedOperation?.id === operation.id
                      ? 'bg-orange-100 text-orange-900 font-semibold border border-orange-300'
                      : 'hover:bg-orange-50 text-gray-700'
                  ]"
                >
                  {{ operation.displayName }}
                </button>
              </div>
            </div>

            <!-- Interact Column -->
            <div>
              <div class="flex items-center gap-1 mb-2 pb-1 border-b border-yellow-200">
                <svg class="w-3.5 h-3.5 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
                </svg>
                <h4 class="text-xs font-bold text-yellow-900">Interact</h4>
              </div>
              <div class="space-y-1">
                <button
                  v-for="operation in operations.filter((op: any) => 
                    ['Agent define prompt template', 'Agent chat', 'Agent chat streaming (SSE)'].includes(op.displayName)
                  )"
                  :key="operation.id"
                  @click="selectOperation(operation)"
                  :disabled="!selectedRuntimeConfigId"
                  :class="[
                    'w-full text-left px-2 py-1.5 rounded text-xs transition-colors',
                    !selectedRuntimeConfigId ? 'opacity-60 cursor-not-allowed' : '',
                    selectedOperation?.id === operation.id
                      ? 'bg-yellow-100 text-yellow-900 font-semibold border border-yellow-300'
                      : 'hover:bg-yellow-50 text-gray-700'
                  ]"
                >
                  {{ operation.displayName }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Default layout for non-Agent categories -->
      <div v-else class="grid grid-cols-1 gap-2">
        <button
          v-for="operation in operations"
          :key="operation.id"
          @click="selectOperation(operation)"
          :disabled="!selectedRuntimeConfigId"
          :class="[
            'p-3 rounded-md border text-left text-sm',
            !selectedRuntimeConfigId ? 'opacity-60 cursor-not-allowed' : '',
            selectedOperation?.id === operation.id ? 'border-blue-500 bg-blue-50' : 'border-gray-200 hover:border-blue-300 hover:bg-gray-50'
          ]"
        >
          <div class="font-medium text-gray-900">{{ operation.displayName }}</div>
          <div class="text-[11px] text-gray-500 mt-1">{{ operation.operationKey }}</div>
        </button>
      </div>
    </template>
    
    <template #param-input="{ param }">
      <!-- Dynamic modelName selector using Bedrock API -->
      <!-- Special: Model Name Selector -->
      <BedrockModelSelector
        v-if="param.apiName === 'modelName'"
        v-model="lab.formData.value[param.apiName]"
        :runtime-config-id="lab.selectedRuntimeConfigId.value"
        :operation-context="getOperationContext(lab.selectedOperation.value?.operationKey)"
        :operations="lab.operations.value"
      />
      <!-- String parameter with enum (dropdown for non-model fields) -->
      <select
        v-else-if="param.dataType === 'String' && param.validationRules?.enum"
        v-model="lab.formData.value[param.apiName]"
        :disabled="param.validationRules?.readonly"
        :class="[
          'w-full px-2 py-1.5 text-xs border rounded-md',
          param.validationRules?.readonly ? 'bg-gray-100 border-gray-300 text-gray-600 cursor-not-allowed' : 'border-gray-300'
        ]"
      >
        <option value="">Select {{ param.displayName }}...</option>
        <option v-for="val in param.validationRules.enum" :key="val" :value="val">
          {{ val }}
        </option>
      </select>
      <!-- String parameter with model in name (plain input, no enum) -->
      <input
        v-else-if="param.dataType === 'String' && param.apiName.toLowerCase().includes('model')"
        v-model="lab.formData.value[param.apiName]"
        type="text"
        :placeholder="`Enter ${param.displayName.toLowerCase()}`"
        :readonly="param.validationRules?.readonly"
        :class="[
          'w-full px-2 py-1.5 text-xs border rounded-md',
          param.validationRules?.readonly ? 'bg-gray-100 border-gray-300 text-gray-600 cursor-not-allowed' : 'border-gray-300'
        ]"
      />
      <!-- String parameter (textarea) -->
      <textarea
        v-else-if="param.dataType === 'String'"
        v-model="lab.formData.value[param.apiName]"
        rows="3"
        :placeholder="`Enter ${param.displayName.toLowerCase()}`"
        :readonly="param.validationRules?.readonly"
        :class="[
          'w-full px-2 py-1.5 text-xs border rounded-md font-mono',
          param.validationRules?.readonly ? 'bg-gray-100 border-gray-300 text-gray-600 cursor-not-allowed' : 'border-gray-300'
        ]"
      />
      <!-- Number parameter -->
      <input
        v-else-if="param.dataType === 'Number'"
        v-model.number="lab.formData.value[param.apiName]"
        type="number"
        step="0.1"
        :readonly="param.validationRules?.readonly"
        :class="[
          'w-full px-2 py-1.5 text-xs border rounded-md',
          param.validationRules?.readonly ? 'bg-gray-100 border-gray-300 text-gray-600 cursor-not-allowed' : 'border-gray-300'
        ]"
      />
      <!-- Boolean parameter -->
      <label v-else-if="param.dataType === 'Boolean'" class="flex items-center gap-2">
        <input
          type="checkbox"
          v-model="lab.formData.value[param.apiName]"
          class="w-4 h-4 text-blue-600 border-gray-300 rounded"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      <!-- Base64 (file upload) parameter -->
      <div v-else-if="param.dataType === 'Base64'">
        <input
          type="file"
          @change="handleFileUpload($event, param.apiName)"
          class="w-full text-[11px] file:mr-2 file:py-1 file:px-3 file:rounded file:border-0 file:text-xs file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
        />
        <div v-if="fileNames[param.apiName]" class="text-[10px] text-green-600 mt-0.5">
          File selected: {{ fileNames[param.apiName] }}
        </div>
      </div>
      <!-- Fallback -->
      <textarea
        v-else
        v-model="lab.formData.value[param.apiName]"
        rows="2"
        :readonly="param.validationRules?.readonly"
        :class="[
          'w-full px-2 py-1.5 text-xs border rounded-md',
          param.validationRules?.readonly ? 'bg-gray-100 border-gray-300 text-gray-600 cursor-not-allowed' : 'border-gray-300'
        ]"
      />
    </template>

    <!-- Custom Response Display -->
    <template #response-display="{ lastResponse, executionError, executing, clearResponse }">
      <!-- Empty State -->
      <div v-if="!lastResponse && !executionError && !executing" class="h-full flex items-center justify-center">
        <div class="text-center max-w-md">
          <svg class="w-20 h-20 mx-auto text-amber-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"/>
          </svg>
          <h3 class="text-lg font-semibold text-gray-700 mb-2">Ready to Test Amazon Bedrock</h3>
          <p class="text-sm text-gray-600">
            Select an operation and runtime configuration to execute. Results will appear here.
          </p>
        </div>
      </div>

      <!-- Loading State -->
      <div v-else-if="executing" class="bg-gradient-to-br from-amber-50 via-orange-50 to-amber-100 border border-amber-200 rounded-lg p-20 flex items-center justify-center min-h-[400px]">
        <LoadingSpinner text="Executing operation..." />
      </div>

      <!-- Error State -->
      <div v-else-if="executionError" class="bg-red-50 border border-red-200 rounded-md p-3 text-sm text-red-800">
        {{ executionError.title || 'Execution Failed' }}
        <div v-if="executionError.detail" class="text-[11px] mt-1">{{ executionError.detail }}</div>
      </div>

      <!-- Success State -->
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
            <!-- View Toggle for Chat Operations -->
            <div v-if="(isChatOperation && lastResponse.result.payload?.content) || (isImageOperation && lab.responseContainsImage.value) || isFoundationModelsListOperation || isFoundationModelDetailsOperation" class="flex bg-white border border-gray-300 rounded overflow-hidden">
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

        <!-- Chat Response Display -->
        <div v-if="isChatOperation && lastResponse.result.payload?.content && showFormattedChat">
          <div class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-2">Assistant Response</h5>
            <div class="bg-gradient-to-br from-amber-50 to-orange-50 border border-amber-200 rounded-lg p-4">
              <div class="flex items-start gap-2 mb-2">
                <div class="w-7 h-7 rounded-full bg-amber-500 flex items-center justify-center flex-shrink-0">
                  <span class="text-white text-sm">🤖</span>
                </div>
                <div class="flex-1">
                  <div class="text-xs font-semibold text-amber-900 mb-1">Amazon Bedrock</div>
                  <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                    {{ lastResponse.result.payload.content }}
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

        <!-- Default Payload Display -->
        <div v-else>
          <!-- Image Response Display (Beauty View) -->
          <div v-if="isImageOperation && lab.responseContainsImage.value && showFormattedChat" class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center">
              <svg class="w-4 h-4 mr-1 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
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

          <!-- Foundation Models List (Beauty View) -->
          <div v-else-if="isFoundationModelsListOperation && showFormattedChat && lastResponse.result.payload" class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
              <svg class="w-4 h-4 mr-1 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
              </svg>
              Foundation Models
            </h5>
            
            <!-- Group models by provider -->
            <div v-for="(models, provider) in groupModelsByProvider(lastResponse.result.payload)" :key="provider" class="mb-4">
              <h6 class="text-xs font-bold text-gray-800 mb-2 px-2 py-1 bg-gradient-to-r from-amber-100 to-orange-100 rounded">
                {{ provider }}
              </h6>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
                <div v-for="model in models" :key="model.modelId" class="bg-white border border-gray-200 rounded-lg p-3 hover:shadow-md transition-shadow">
                  <div class="flex items-start justify-between mb-2">
                    <h6 class="text-xs font-semibold text-gray-900 leading-tight flex-1">{{ model.modelName }}</h6>
                    <span v-if="model.responseStreamingSupported" class="ml-2 px-1.5 py-0.5 bg-green-100 text-green-700 text-[9px] font-medium rounded">Streaming</span>
                  </div>
                  <p class="text-[10px] text-gray-600 mb-2 font-mono">{{ model.modelId }}</p>
                  <div class="flex flex-wrap gap-1">
                    <span v-for="mod in model.inferenceTypesSupported" :key="mod" class="px-1.5 py-0.5 bg-amber-50 text-amber-700 text-[9px] rounded border border-amber-200">
                      {{ mod }}
                    </span>
                  </div>
                  <div v-if="model.inputModalities?.length" class="mt-2 pt-2 border-t border-gray-100">
                    <span class="text-[9px] text-gray-500">Input: </span>
                    <span class="text-[9px] text-gray-700">{{ model.inputModalities.join(', ') }}</span>
                  </div>
                  <div v-if="model.outputModalities?.length" class="mt-1">
                    <span class="text-[9px] text-gray-500">Output: </span>
                    <span class="text-[9px] text-gray-700">{{ model.outputModalities.join(', ') }}</span>
                  </div>
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

          <!-- Foundation Model Details (Beauty View) -->
          <div v-else-if="isFoundationModelDetailsOperation && showFormattedChat && lastResponse.result.payload" class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
              <svg class="w-4 h-4 mr-1 text-amber-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              Model Details
            </h5>
            
            <div class="bg-gradient-to-br from-amber-50 via-orange-50 to-amber-50 border-2 border-amber-200 rounded-lg p-4">
              <div class="bg-white rounded-lg p-4 shadow-sm">
                <div class="flex items-start justify-between mb-3">
                  <div class="flex-1">
                    <h6 class="text-sm font-bold text-gray-900 mb-1">{{ lastResponse.result.payload.modelName }}</h6>
                    <p class="text-xs text-gray-600 font-mono">{{ lastResponse.result.payload.modelId }}</p>
                  </div>
                  <span v-if="lastResponse.result.payload.responseStreamingSupported" class="ml-2 px-2 py-1 bg-green-100 text-green-700 text-xs font-medium rounded">
                    Streaming Supported
                  </span>
                </div>

                <div class="grid grid-cols-2 gap-3 mb-3">
                  <div class="bg-gray-50 rounded p-2">
                    <span class="text-[10px] text-gray-500 block mb-1">Provider</span>
                    <span class="text-xs font-semibold text-gray-900">{{ lastResponse.result.payload.providerName }}</span>
                  </div>
                  <div class="bg-gray-50 rounded p-2">
                    <span class="text-[10px] text-gray-500 block mb-1">Model ARN</span>
                    <span class="text-[10px] font-mono text-gray-900 break-all">{{ lastResponse.result.payload.modelArn }}</span>
                  </div>
                </div>

                <div v-if="lastResponse.result.payload.inferenceTypesSupported?.length" class="mb-3">
                  <span class="text-[10px] text-gray-500 block mb-1">Inference Types</span>
                  <div class="flex flex-wrap gap-1">
                    <span v-for="type in lastResponse.result.payload.inferenceTypesSupported" :key="type" class="px-2 py-1 bg-amber-100 text-amber-800 text-xs rounded border border-amber-200">
                      {{ type }}
                    </span>
                  </div>
                </div>

                <div class="grid grid-cols-2 gap-3">
                  <div v-if="lastResponse.result.payload.inputModalities?.length">
                    <span class="text-[10px] text-gray-500 block mb-1">Input Modalities</span>
                    <div class="flex flex-wrap gap-1">
                      <span v-for="mod in lastResponse.result.payload.inputModalities" :key="mod" class="px-2 py-1 bg-blue-50 text-blue-700 text-[10px] rounded">
                        {{ mod }}
                      </span>
                    </div>
                  </div>
                  <div v-if="lastResponse.result.payload.outputModalities?.length">
                    <span class="text-[10px] text-gray-500 block mb-1">Output Modalities</span>
                    <div class="flex flex-wrap gap-1">
                      <span v-for="mod in lastResponse.result.payload.outputModalities" :key="mod" class="px-2 py-1 bg-purple-50 text-purple-700 text-[10px] rounded">
                        {{ mod }}
                      </span>
                    </div>
                  </div>
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

          <!-- Raw JSON View (default for non-image or when Raw tab selected) -->
          <div v-else class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-1">Payload</h5>
            <pre class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
          </div>
        </div>

        <!-- Attributes -->
        <div v-if="lastResponse.result.attributes && (!isChatOperation || !showFormattedChat)" class="mb-3">
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
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'
import BedrockModelSelector from '../../components/BedrockModelSelector.vue'
import { getAssetUrl } from '../../config/api'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId) // Let user choose category

const showFormattedChat = ref(true) // Default to formatted chat view
const fileNames = ref<Record<string, string>>({}) // Track uploaded file names

// Handle file upload and convert to base64
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

// Determine operation context for model filtering
function getOperationContext(operationKey?: string): string {
  if (!operationKey) return 'default'
  
  if (operationKey.includes('chat')) return 'chat'
  if (operationKey.includes('embedding')) return 'embedding'
  if (operationKey.includes('image-generate')) return 'image-generation'
  if (operationKey.includes('agent-chat')) return 'vision'
  
  return 'default'
}

// Group foundation models by provider
function groupModelsByProvider(models: any[]): Record<string, any[]> {
  if (!Array.isArray(models)) return {}
  
  return models.reduce((acc, model) => {
    const provider = model.providerName || 'Unknown'
    if (!acc[provider]) {
      acc[provider] = []
    }
    acc[provider].push(model)
    return acc
  }, {} as Record<string, any[]>)
}

// Detect if current operation is a chat operation (has text response)
const isChatOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'mac-bedrock:chat-answer-prompt' ||
         opKey === 'mac-bedrock:chat-answer-prompt-memory' ||
         opKey === 'mac-bedrock:agent-chat' ||
         opKey === 'mac-bedrock:agent-define-prompt-template' ||
         opKey === 'mac-bedrock:sentiment-analyze'
})

const isImageOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'mac-bedrock:image-generate'
})

const isFoundationModelsListOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'mac-bedrock:foundational-models-list'
})

const isFoundationModelDetailsOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'mac-bedrock:foundational-model-details'
})

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}
</script>

