<template>
  <LabTemplate
    header-title="OpenAI"
    flow-diagram-img="openai.png"
    flow-doc-url="openai.html"
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
        <span>Access OpenAI's advanced AI models including GPT-4, embeddings, and assistants</span>
        <a
          href="https://platform.openai.com/docs/api-reference"
          target="_blank"
          rel="noopener noreferrer"
          class="inline-flex items-center gap-1 px-2 py-1 text-[10px] font-semibold bg-green-100 text-green-700 rounded-md hover:bg-green-200 transition-colors"
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

    <!-- Custom Operations List for Agent category (Assistants) -->
    <template #operations-list="{ operations, selectedOperation, selectOperation }">
      <div v-if="lab.activeCategory.value === 'Agent'" class="bg-white rounded-lg border border-gray-200 shadow-sm">
        <div class="p-4 border-b border-gray-200 bg-gradient-to-r from-purple-50 to-indigo-50">
          <h3 class="text-sm font-bold text-gray-900">Assistant Operations</h3>
          <p class="text-[10px] text-gray-600 mt-0.5">Organized by resource type</p>
        </div>
        
        <div class="p-4">
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <!-- Assistants Column -->
            <div>
              <div class="flex items-center gap-1 mb-2 pb-1 border-b border-purple-200">
                <svg class="w-3.5 h-3.5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                </svg>
                <h4 class="text-xs font-bold text-purple-900">Assistants</h4>
              </div>
              <div class="space-y-1">
                <button
                  v-for="op in getGroupedOperations(operations).assistants"
                  :key="op.id"
                  @click="selectOperation(op)"
                  :class="[
                    'w-full text-left px-2 py-1.5 rounded text-xs transition-colors',
                    selectedOperation?.id === op.id
                      ? 'bg-purple-100 text-purple-900 font-semibold border border-purple-300'
                      : 'hover:bg-purple-50 text-gray-700'
                  ]"
                >
                  {{ op.displayName.replace('[Assistants] ', '') }}
                </button>
              </div>
            </div>

            <!-- Threads Column -->
            <div>
              <div class="flex items-center gap-1 mb-2 pb-1 border-b border-indigo-200">
                <svg class="w-3.5 h-3.5 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
                </svg>
                <h4 class="text-xs font-bold text-indigo-900">Threads</h4>
              </div>
              <div class="space-y-1">
                <button
                  v-for="op in getGroupedOperations(operations).threads"
                  :key="op.id"
                  @click="selectOperation(op)"
                  :class="[
                    'w-full text-left px-2 py-1.5 rounded text-xs transition-colors',
                    selectedOperation?.id === op.id
                      ? 'bg-indigo-100 text-indigo-900 font-semibold border border-indigo-300'
                      : 'hover:bg-indigo-50 text-gray-700'
                  ]"
                >
                  {{ op.displayName.replace('[Assistants] ', '') }}
                </button>
              </div>
            </div>

            <!-- Messages Column -->
            <div>
              <div class="flex items-center gap-1 mb-2 pb-1 border-b border-blue-200">
                <svg class="w-3.5 h-3.5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z"/>
                </svg>
                <h4 class="text-xs font-bold text-blue-900">Messages</h4>
              </div>
              <div class="space-y-1">
                <button
                  v-for="op in getGroupedOperations(operations).messages"
                  :key="op.id"
                  @click="selectOperation(op)"
                  :class="[
                    'w-full text-left px-2 py-1.5 rounded text-xs transition-colors',
                    selectedOperation?.id === op.id
                      ? 'bg-blue-100 text-blue-900 font-semibold border border-blue-300'
                      : 'hover:bg-blue-50 text-gray-700'
                  ]"
                >
                  {{ op.displayName.replace('[Assistants] ', '') }}
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
  
    <template #param-input="{ param }">
      <!-- MODIFY ASSISTANT: Assistant ID with Load Button -->
      <div v-if="lab.selectedOperation.value?.operationKey === 'openai:modify-assistant' && param.apiName === 'assistant_id'" class="space-y-2">
        <div class="flex gap-2">
          <input
            v-model="lab.formData.value[param.apiName]"
            type="text"
            :placeholder="`Enter ${param.displayName.toLowerCase()}`"
            class="flex-1 px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
          />
          <button
            @click="loadAssistantData"
            :disabled="loadingAssistant || !lab.formData.value[param.apiName]"
            class="px-3 py-1.5 text-xs font-semibold bg-purple-600 text-white rounded-md hover:bg-purple-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-1"
          >
            <svg v-if="!loadingAssistant" class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
            </svg>
            <svg v-else class="w-3.5 h-3.5 animate-spin" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
            {{ loadingAssistant ? 'Loading...' : 'Load Assistant' }}
          </button>
        </div>
        <p class="text-[10px] text-gray-600">
          Click "Load Assistant" to retrieve and pre-fill the current assistant configuration
        </p>
        <div v-if="loadAssistantError" class="text-[10px] text-red-600 bg-red-50 border border-red-200 rounded p-2">
          {{ loadAssistantError }}
        </div>
      </div>

      <!-- ASSISTANT BUILDER: Create & Modify Assistant -->
      <AssistantConfigBuilder
        v-else-if="['openai:create-assistant', 'openai:modify-assistant'].includes(lab.selectedOperation.value?.operationKey || '') && param.apiName === 'body'"
        v-model="lab.formData.value[param.apiName]"
      />

      <!-- JSON Body Parameters (Default) -->
      <div v-else-if="param.dataType === 'JSON'" class="space-y-1">
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
      <div v-if="executing" class="bg-gradient-to-br from-green-50 via-green-100 to-emerald-50 border border-green-200 rounded-lg p-20 flex items-center justify-center min-h-[400px]">
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
            <!-- View Toggle for Chat Completion, List Models, Moderation & Assistants -->
            <div v-if="isChatCompletionResponse(lastResponse.result.payload) || isListModelsOperation || isModerationOperation || isAssistantOperation" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedChat = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedChat 
                    ? 'bg-green-500 text-white' 
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
                    ? 'bg-green-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                { } Raw
              </button>
            </div>
            <button @click="clearResponse" class="text-xs text-gray-600 hover:text-gray-900 transition-colors">Clear</button>
          </div>
        </div>

        <!-- Chat Completion Formatted View -->
        <div v-if="isChatCompletionResponse(lastResponse.result.payload) && showFormattedChat">
          <div class="mb-3">
            <h5 class="text-xs font-semibold text-gray-700 mb-2">Chat Response</h5>
            <div class="bg-gradient-to-br from-green-50 to-emerald-50 border border-green-200 rounded-lg p-4">
              <div class="flex items-start gap-2 mb-2">
                <div class="w-7 h-7 rounded-full bg-green-500 flex items-center justify-center flex-shrink-0">
                  <span class="text-white text-sm">🤖</span>
                </div>
                <div class="flex-1">
                  <div class="text-xs font-semibold text-green-900 mb-1">Assistant</div>
                  <div class="text-xs text-gray-800 whitespace-pre-wrap leading-relaxed">
                    {{ lastResponse.result.payload.choices[0].message.content }}
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
                <div><span class="text-gray-500">Model:</span> {{ lastResponse.result.payload.model }}</div>
                <div v-if="lastResponse.result.payload.choices[0].finish_reason">
                  <span class="text-gray-500">Finish Reason:</span> {{ lastResponse.result.payload.choices[0].finish_reason }}
                </div>
                <div v-if="lastResponse.result.payload.usage">
                  <span class="text-gray-500">Tokens:</span> 
                  {{ lastResponse.result.payload.usage.total_tokens }} 
                  ({{ lastResponse.result.payload.usage.prompt_tokens }} prompt + {{ lastResponse.result.payload.usage.completion_tokens }} completion)
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
        <div v-else-if="isListModelsOperation && showFormattedChat && lastResponse.result.payload?.data">
          <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-1 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/>
            </svg>
            Available Models ({{ lastResponse.result.payload.data.length }})
          </h5>
          
          <!-- Group models by owner -->
          <div v-for="(models, owner) in groupModelsByOwner(lastResponse.result.payload.data)" :key="owner" class="mb-4">
            <h6 class="text-xs font-bold text-gray-800 mb-2 px-2 py-1 bg-gradient-to-r from-green-100 to-emerald-100 rounded">
              {{ owner }}
            </h6>
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
              <div v-for="model in models" :key="model.id" class="bg-white border border-gray-200 rounded-lg p-3 hover:shadow-md transition-shadow">
                <div class="flex items-start justify-between mb-2">
                  <h6 class="text-xs font-semibold text-gray-900 leading-tight flex-1">{{ model.id }}</h6>
                </div>
                <div class="flex items-center gap-2 text-[10px] text-gray-600">
                  <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <span>{{ formatTimestamp(model.created) }}</span>
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

        <!-- Moderation Formatted View -->
        <div v-else-if="isModerationOperation && showFormattedChat && lastResponse.result.payload?.results">
          <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-1 text-pink-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
            </svg>
            Content Moderation Results
          </h5>
          
          <div v-for="(result, idx) in lastResponse.result.payload.results" :key="idx" class="mb-3">
            <div class="bg-gradient-to-br from-pink-50 to-rose-50 border border-pink-200 rounded-lg p-4">
              <div class="flex items-start gap-2 mb-3">
                <div class="w-7 h-7 rounded-full bg-pink-500 flex items-center justify-center flex-shrink-0">
                  <span class="text-white text-sm">🔍</span>
                </div>
                <div class="flex-1">
                  <div class="text-xs font-semibold text-pink-900 mb-1">Moderation Scanner</div>
                  <div class="text-xs font-bold" :class="result.flagged ? 'text-red-700' : 'text-green-700'">
                    {{ result.flagged ? '🚩 Content Flagged - Violates Policy' : '✅ Content Safe - No Violations' }}
                  </div>
                </div>
              </div>

              <!-- Category Scores -->
              <div class="bg-white rounded-lg p-3 border border-pink-200">
                <h6 class="text-xs font-semibold text-gray-800 mb-2">Category Scores:</h6>
                <div class="space-y-1">
                  <div v-for="(score, category) in result.category_scores" :key="category" class="flex items-center justify-between text-[10px]">
                    <div class="flex items-center gap-2">
                      <span v-if="score > 0.5">⚠️</span>
                      <span v-else class="opacity-0">⚠️</span>
                      <span class="font-medium text-gray-700" :class="score > 0.5 ? 'text-red-700' : ''">
                        {{ formatCategoryName(category) }}
                      </span>
                      <span v-if="result.categories[category]" class="px-1.5 py-0.5 bg-red-100 text-red-700 rounded text-[9px] font-bold">
                        FLAGGED
                      </span>
                    </div>
                    <span class="font-mono" :class="score > 0.5 ? 'text-red-700 font-bold' : 'text-gray-600'">
                      {{ (score * 100).toFixed(2) }}%
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

        <!-- List Assistants Formatted View -->
        <div v-else-if="isListAssistantsOperation && showFormattedChat && Array.isArray(lastResponse.result.payload)">
          <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-1 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            Assistants ({{ lastResponse.result.payload.length }})
          </h5>

          <!-- Empty state -->
          <div v-if="lastResponse.result.payload.length === 0" class="bg-gray-50 border border-gray-200 rounded-lg p-8 text-center">
            <svg class="w-12 h-12 mx-auto text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            <p class="text-xs text-gray-600">No assistants found</p>
          </div>
          
          <!-- Assistants list -->
          <div v-else class="space-y-3">
            <div v-for="assistant in lastResponse.result.payload" :key="assistant.id" class="bg-gradient-to-br from-purple-50 to-indigo-50 border border-purple-200 rounded-lg p-4">
              <div class="flex items-start justify-between mb-3">
                <div class="flex-1">
                  <div class="flex items-center gap-2 mb-1">
                    <h6 class="text-sm font-bold text-purple-900">{{ assistant.name || 'Unnamed Assistant' }}</h6>
                    <span class="px-2 py-0.5 bg-purple-100 text-purple-700 rounded text-[9px] font-semibold">
                      {{ assistant.model }}
                    </span>
                  </div>
                  <div class="text-[10px] text-purple-700 font-mono mb-2">{{ assistant.id }}</div>
                  <p v-if="assistant.description" class="text-xs text-gray-700 mb-2">{{ assistant.description }}</p>
                </div>
              </div>

              <!-- Instructions Preview -->
              <div v-if="assistant.instructions" class="bg-white rounded p-2 border border-purple-200 mb-2">
                <div class="text-[10px] font-semibold text-gray-700 mb-1">Instructions:</div>
                <div class="text-[10px] text-gray-600 line-clamp-2">{{ assistant.instructions }}</div>
              </div>

              <!-- Tools -->
              <div v-if="assistant.tools && assistant.tools.length > 0" class="flex flex-wrap gap-1 mb-2">
                <span class="text-[9px] font-medium text-gray-600">Tools:</span>
                <span v-for="(tool, idx) in assistant.tools" :key="idx" class="px-1.5 py-0.5 bg-indigo-100 text-indigo-700 rounded text-[9px] font-medium">
                  {{ formatToolType(tool.type) }}
                </span>
              </div>

              <!-- Metadata -->
              <div class="flex items-center gap-3 text-[10px] text-gray-600">
                <div class="flex items-center gap-1">
                  <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                  </svg>
                  <span>Created {{ formatTimestamp(assistant.created_at) }}</span>
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

        <!-- Single Assistant Formatted View (Create/Modify/Retrieve) -->
        <div v-else-if="isSingleAssistantOperation && showFormattedChat && lastResponse.result.payload?.id">
          <h5 class="text-xs font-semibold text-gray-700 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-1 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
            </svg>
            Assistant Details
          </h5>

          <div class="bg-gradient-to-br from-purple-50 to-indigo-50 border border-purple-200 rounded-lg p-4">
            <!-- Header -->
            <div class="flex items-start justify-between mb-4">
              <div class="flex-1">
                <div class="flex items-center gap-2 mb-2">
                  <h6 class="text-base font-bold text-purple-900">{{ lastResponse.result.payload.name || 'Unnamed Assistant' }}</h6>
                  <span class="px-2 py-1 bg-purple-100 text-purple-700 rounded text-[10px] font-semibold">
                    {{ lastResponse.result.payload.model }}
                  </span>
                </div>
                <div class="text-[11px] text-purple-700 font-mono mb-2">{{ lastResponse.result.payload.id }}</div>
                <p v-if="lastResponse.result.payload.description" class="text-xs text-gray-700">
                  {{ lastResponse.result.payload.description }}
                </p>
              </div>
            </div>

            <!-- Instructions -->
            <div v-if="lastResponse.result.payload.instructions" class="bg-white rounded-lg p-3 border border-purple-200 mb-3">
              <div class="text-xs font-semibold text-gray-800 mb-2 flex items-center gap-1">
                <svg class="w-3.5 h-3.5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Instructions
              </div>
              <div class="text-xs text-gray-700 whitespace-pre-wrap">{{ lastResponse.result.payload.instructions }}</div>
            </div>

            <!-- Tools -->
            <div v-if="lastResponse.result.payload.tools && lastResponse.result.payload.tools.length > 0" class="bg-white rounded-lg p-3 border border-purple-200 mb-3">
              <div class="text-xs font-semibold text-gray-800 mb-2 flex items-center gap-1">
                <svg class="w-3.5 h-3.5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
                </svg>
                Tools ({{ lastResponse.result.payload.tools.length }})
              </div>
              <div class="space-y-2">
                <div v-for="(tool, idx) in lastResponse.result.payload.tools" :key="idx" class="bg-indigo-50 rounded p-2 border border-indigo-200">
                  <div class="text-xs font-semibold text-indigo-900">{{ formatToolType(tool.type) }}</div>
                  <div v-if="tool.function" class="text-[10px] text-indigo-700 mt-1">
                    <strong>{{ tool.function.name }}</strong>
                    <span v-if="tool.function.description"> - {{ tool.function.description }}</span>
                  </div>
                </div>
              </div>
            </div>

            <!-- Tool Resources -->
            <div v-if="lastResponse.result.payload.tool_resources" class="bg-white rounded-lg p-3 border border-purple-200 mb-3">
              <div class="text-xs font-semibold text-gray-800 mb-2">Tool Resources</div>
              <div class="space-y-1 text-[10px]">
                <div v-if="lastResponse.result.payload.tool_resources.code_interpreter?.file_ids?.length > 0">
                  <strong>Code Interpreter:</strong> {{ lastResponse.result.payload.tool_resources.code_interpreter.file_ids.length }} file(s)
                </div>
                <div v-if="lastResponse.result.payload.tool_resources.file_search?.vector_store_ids?.length > 0">
                  <strong>File Search:</strong> {{ lastResponse.result.payload.tool_resources.file_search.vector_store_ids.length }} vector store(s)
                </div>
              </div>
            </div>

            <!-- Configuration -->
            <div class="bg-white rounded-lg p-3 border border-purple-200 mb-3">
              <div class="text-xs font-semibold text-gray-800 mb-2">Configuration</div>
              <div class="grid grid-cols-2 gap-2 text-[10px]">
                <div v-if="lastResponse.result.payload.temperature !== null && lastResponse.result.payload.temperature !== undefined">
                  <span class="text-gray-600">Temperature:</span> <strong>{{ lastResponse.result.payload.temperature }}</strong>
                </div>
                <div v-if="lastResponse.result.payload.top_p !== null && lastResponse.result.payload.top_p !== undefined">
                  <span class="text-gray-600">Top P:</span> <strong>{{ lastResponse.result.payload.top_p }}</strong>
                </div>
                <div v-if="lastResponse.result.payload.response_format">
                  <span class="text-gray-600">Response Format:</span> <strong>{{ lastResponse.result.payload.response_format.type || 'text' }}</strong>
                </div>
              </div>
            </div>

            <!-- Metadata -->
            <div v-if="lastResponse.result.payload.metadata && Object.keys(lastResponse.result.payload.metadata).length > 0" class="bg-white rounded-lg p-3 border border-purple-200 mb-3">
              <div class="text-xs font-semibold text-gray-800 mb-2">Metadata</div>
              <div class="space-y-1 text-[10px]">
                <div v-for="(value, key) in lastResponse.result.payload.metadata" :key="key">
                  <span class="text-gray-600">{{ key }}:</span> <strong>{{ value }}</strong>
                </div>
              </div>
            </div>

            <!-- Timestamps -->
            <div class="flex items-center gap-4 text-[10px] text-gray-600">
              <div class="flex items-center gap-1">
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <span>Created {{ formatTimestamp(lastResponse.result.payload.created_at) }}</span>
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

        <!-- Attributes -->
        <div v-if="lastResponse.result.attributes && !showFormattedChat" class="mb-3">
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
import AssistantConfigBuilder from '../../components/AssistantConfigBuilder.vue'
import { logger } from '../../utils/logger'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

const showFormattedChat = ref(true) // Default to formatted chat view
const loadingAssistant = ref(false)
const loadAssistantError = ref('')

import { getAssetUrl } from '../../config/api'
import { apiCall } from '../../composables/useApi'

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
    // Parse and format the example
    const parsed = JSON.parse(exampleValue)
    lab.formData.value[fieldName] = JSON.stringify(parsed, null, 2)
  } catch (err) {
    // If it's not valid JSON, just use it as-is
    lab.formData.value[fieldName] = exampleValue
  }
}

// Detect if response is from Chat Completion
function isChatCompletionResponse(payload: any): boolean {
  return (
    typeof payload === 'object' &&
    payload !== null &&
    'choices' in payload &&
    Array.isArray(payload.choices) &&
    payload.choices.length > 0 &&
    'message' in payload.choices[0]
  )
}

// Detect if current operation is List Models
const isListModelsOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'openai:list-models'
})

// Detect if current operation is Moderation
const isModerationOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'openai:create-moderation'
})

// Detect if current operation is List Assistants
const isListAssistantsOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return opKey === 'openai:list-assistants'
})

// Detect if current operation is a single assistant operation (Create/Modify/Retrieve)
const isSingleAssistantOperation = computed(() => {
  const opKey = lab.selectedOperation.value?.operationKey
  return ['openai:create-assistant', 'openai:modify-assistant', 'openai:retrieve-assistants'].includes(opKey || '')
})

// Detect if any assistant operation (for view toggle)
const isAssistantOperation = computed(() => {
  return isListAssistantsOperation.value || isSingleAssistantOperation.value
})

// Group models by owner (OpenAI, system, user, etc.)
function groupModelsByOwner(models: any[]): Record<string, any[]> {
  if (!Array.isArray(models)) return {}
  
  return models.reduce((acc, model) => {
    const owner = model.owned_by || 'unknown'
    if (!acc[owner]) {
      acc[owner] = []
    }
    acc[owner].push(model)
    return acc
  }, {} as Record<string, any[]>)
}

// Format Unix timestamp to readable date
function formatTimestamp(timestamp: number): string {
  if (!timestamp) return 'Unknown'
  const date = new Date(timestamp * 1000)
  return date.toLocaleDateString('en-US', { 
    year: 'numeric', 
    month: 'short', 
    day: 'numeric' 
  })
}

// Format category name for display (convert snake_case to Title Case)
function formatCategoryName(category: string | number): string {
  const categoryStr = String(category)
  return categoryStr
    .split(/[_/]/)
    .map(word => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ')
}

// Format tool type for display
function formatToolType(type: string): string {
  const types: Record<string, string> = {
    'code_interpreter': '🐍 Code Interpreter',
    'file_search': '🔍 File Search',
    'function': '⚡ Function'
  }
  return types[type] || type
}

// Group operations by resource type for Agent category
function getGroupedOperations(operations: any[]) {
  const groups = {
    assistants: [] as any[],
    threads: [] as any[],
    messages: [] as any[]
  }

  operations.forEach(op => {
    const displayName = op.displayName.toLowerCase()
    if (displayName.includes('assistant') && !displayName.includes('thread') && !displayName.includes('message')) {
      groups.assistants.push(op)
    } else if (displayName.includes('thread')) {
      groups.threads.push(op)
    } else if (displayName.includes('message')) {
      groups.messages.push(op)
    }
  })

  return groups
}

// Load assistant data for modify operation
async function loadAssistantData() {
  const assistantId = lab.formData.value['assistant_id']
  if (!assistantId) {
    loadAssistantError.value = 'Please enter an Assistant ID first'
    return
  }

  loadingAssistant.value = true
  loadAssistantError.value = ''

  try {
    // Find the retrieve-assistants operation
    const retrieveOperation = lab.operations.value?.find(
      op => op.operationKey === 'openai:retrieve-assistants'
    )

    if (!retrieveOperation) {
      throw new Error('Retrieve Assistants operation not found')
    }

    // Execute the retrieve operation
    const response = await apiCall('/execute', 'POST', {
      operationId: retrieveOperation.id,
      runtimeConfigId: lab.selectedRuntimeConfigId.value,
      parameters: {
        assistant_id: assistantId
      },
      enableLogging: lab.enableLogging.value,
      enableValidation: lab.enableValidation.value
    })

    if (response?.result?.payload) {
      // Pre-fill the body with the assistant data
      const assistant = response.result.payload
      
      // Remove read-only fields that shouldn't be in modify request
      const modifyBody: any = {
        model: assistant.model
      }
      
      if (assistant.name) modifyBody.name = assistant.name
      if (assistant.description) modifyBody.description = assistant.description
      if (assistant.instructions) modifyBody.instructions = assistant.instructions
      if (assistant.tools && assistant.tools.length > 0) modifyBody.tools = assistant.tools
      if (assistant.tool_resources) modifyBody.tool_resources = assistant.tool_resources
      if (assistant.metadata) modifyBody.metadata = assistant.metadata
      if (assistant.temperature !== null && assistant.temperature !== undefined) modifyBody.temperature = assistant.temperature
      if (assistant.top_p !== null && assistant.top_p !== undefined) modifyBody.top_p = assistant.top_p
      if (assistant.response_format) modifyBody.response_format = assistant.response_format

      lab.formData.value['body'] = JSON.stringify(modifyBody, null, 2)
      
      logger.info('Assistant data loaded successfully')
    } else {
      throw new Error('Invalid response format')
    }
  } catch (err: any) {
    logger.error('Failed to load assistant data:', err)
    loadAssistantError.value = err.response?.data?.detail || err.message || 'Failed to load assistant'
  } finally {
    loadingAssistant.value = false
  }
}

</script>

