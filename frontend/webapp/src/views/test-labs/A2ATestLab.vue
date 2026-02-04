<template>
  <div>
    <LabTemplate
      header-title="A2A (Agent-to-Agent)"
      flow-diagram-img="a2a.png"
      flow-doc-url="a2a.html"
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
      :executing="isExecuting"
      :can-execute="lab.canExecute.value"
      :validation-message="lab.validationMessage.value"
      :last-response="combinedResponse"
      :execution-error="combinedError"
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
      @clear="clearResponse"
    >
      <template #icon>
        <ConnectorIcon :icon-url="getIconSrc(lab.connector.value?.icon)" size="lg" />
      </template>
      
      <template #subtitle>
        <div class="flex items-center gap-3">
          <span>Test A2A Client operations for agent-to-agent communication</span>
          <button
            @click="openProtocolDocs"
            class="inline-flex items-center gap-1 px-2 py-1 text-[10px] font-semibold bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200 transition-colors"
          >
            <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
            </svg>
            Protocol Docs
          </button>
        </div>
      </template>
    
    <template #param-input="{ param }">
      <!-- Custom A2A Message Builder for Send Message operation -->
      <A2AMessageBuilder
        v-if="param.apiName === 'message' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
        :operation-key="lab.selectedOperation.value?.operationKey"
      />
      <!-- REUSE Message Builder for Send Stream Message operation -->
      <A2AMessageBuilder
        v-else-if="param.apiName === 'streamMessage' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
        :operation-key="lab.selectedOperation.value?.operationKey"
      />
      <!-- Task ID Builder for Cancel Task and Task Resubscribe operations -->
      <TaskIdParamsBuilder
        v-else-if="(param.apiName === 'taskIdParams' || param.apiName === 'taskId') && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Task Query Builder for Get Task operation -->
      <TaskQueryParamsBuilder
        v-else-if="param.apiName === 'taskQuery' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Custom Task Push Notification Config Builder -->
      <TaskPushNotificationConfigBuilder
        v-else-if="param.apiName === 'taskPushNotificationConfig' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Custom Get Push Config Builder (taskId + configId) -->
      <GetPushConfigBuilder
        v-else-if="param.apiName === 'getPushConfigParams' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <!-- Delete Push Config Builder (taskId + configId - both mandatory) -->
      <DeletePushConfigBuilder
        v-else-if="param.apiName === 'deletePushConfigParams' && param.dataType === 'JSON'"
        v-model="lab.formData.value[param.apiName]"
      />
      <div v-else-if="param.dataType === 'JSON'" class="space-y-1">
        <textarea
          v-model="lab.formData.value[param.apiName]"
          rows="3"
          :placeholder="`Enter ${param.displayName.toLowerCase()}`"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
        />
        <button
          @click="formatJsonField(param.apiName)"
          class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
        >
          ✨ Format JSON
        </button>
      </div>
      <!-- Default parameter rendering -->
      <textarea
        v-else-if="param.dataType === 'String'"
        v-model="lab.formData.value[param.apiName]"
        rows="3"
        :placeholder="`Enter ${param.displayName.toLowerCase()}`"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y"
      />
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
          class="w-4 h-4 text-blue-600 border-gray-300 rounded-md"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      <textarea
        v-else
        v-model="lab.formData.value[param.apiName]"
        rows="3"
        :placeholder="`Enter ${param.displayName.toLowerCase()}`"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
      />
    </template>

    <!-- A2A Card Side Panel -->
    <template #operation-side-panel>
      <!-- Streaming Operations Info Panel -->
      <div v-if="isSendStreamMessageOperation || isTaskResubscribeOperation" class="mb-4">
        <div class="bg-gradient-to-br from-purple-50 to-blue-50 border border-purple-200 rounded-lg p-4">
          <div class="flex items-start gap-3 mb-3">
            <div class="flex-shrink-0 w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center">
              <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
              </svg>
            </div>
            <div class="flex-1">
              <h4 class="text-sm font-bold text-purple-900 mb-1">
                {{ isSendStreamMessageOperation ? '🌊 SSE Streaming' : '🔄 Reconnect Stream' }}
              </h4>
              <p class="text-xs text-purple-800 leading-relaxed">
                <span v-if="isSendStreamMessageOperation">
                  Establishes Server-Sent Events (SSE) connection for real-time updates as the agent processes your request. Receive status changes, artifacts, and progress events instantly.
                </span>
                <span v-else>
                  Reconnect to an existing streaming session to receive buffered events and continue monitoring task progress from where you left off.
                </span>
              </p>
            </div>
          </div>
          
          <div class="space-y-2 text-xs">
            <div v-if="isSendStreamMessageOperation" class="flex items-start gap-2">
              <span class="text-purple-600">•</span>
              <span class="text-purple-900">Real-time status updates (pending → in-progress → completed)</span>
            </div>
            <div v-if="isSendStreamMessageOperation" class="flex items-start gap-2">
              <span class="text-purple-600">•</span>
              <span class="text-purple-900">Progressive artifact delivery as they're generated</span>
            </div>
            <div class="flex items-start gap-2">
              <span class="text-purple-600">•</span>
              <span class="text-purple-900">{{ isSendStreamMessageOperation ? 'Immediate error notifications' : 'Buffered event replay from disconnection' }}</span>
            </div>
            <div class="flex items-start gap-2">
              <span class="text-purple-600">•</span>
              <span class="text-purple-900">{{ isSendStreamMessageOperation ? 'Lower overhead vs polling' : 'Resume monitoring without data loss' }}</span>
            </div>
          </div>

          <div class="mt-3 pt-3 border-t border-purple-200">
            <p class="text-[10px] text-purple-700 font-medium">
              💡 Tip: Use {{ isSendStreamMessageOperation ? 'this for long-running agent tasks' : 'Task Resubscribe if connection drops' }} to maintain real-time visibility
            </p>
          </div>
        </div>
      </div>

      <div v-if="showA2ACardPanel">
        <div class="flex items-center justify-between mb-3">
          <h4 class="text-sm font-semibold text-gray-900">A2A Card</h4>
          <button
            v-if="!cardResult"
            @click="loadA2ACard"
            :disabled="loadingCard"
            class="px-3 py-1.5 text-xs font-medium bg-blue-600 text-white rounded-md hover:bg-blue-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {{ loadingCard ? 'Loading...' : 'Load' }}
          </button>
          <div v-else class="flex items-center gap-2">
            <!-- Beautiful / Raw Toggle -->
            <div class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="cardView = 'beautiful'"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  cardView === 'beautiful' 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="cardView = 'raw'"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  cardView === 'raw' 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                { } Raw
              </button>
            </div>
            <button
              @click="cardResult = null"
              class="text-xs text-gray-600 hover:text-gray-900 transition-colors"
            >
              Clear
            </button>
          </div>
        </div>

        <!-- Loading State -->
        <div v-if="loadingCard" class="border border-blue-200 rounded-lg p-3 bg-blue-50/30 flex items-center justify-center py-8">
          <LoadingSpinner text="Loading card..." />
        </div>

        <!-- Empty State -->
        <div v-else-if="!cardResult" class="border border-blue-200 rounded-lg p-3 bg-blue-50/30 text-center py-8">
          <svg class="w-12 h-12 mx-auto text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
          </svg>
          <p class="text-xs text-gray-600">Click Load to fetch the A2A Card</p>
        </div>

        <!-- Card Display -->
        <div v-else class="border border-blue-200 rounded-lg p-3 bg-blue-50/30 max-h-[600px] overflow-y-auto">
          <AgentCardDisplay v-if="cardView === 'beautiful'" :payload="cardResult.result.payload" />
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(cardResult.result.payload, null, 2) }}</pre>
        </div>
      </div>
    </template>

    <!-- Custom Response Display -->
    <template #response-display="{ lastResponse, executionError, executing, clearResponse }">
      <div v-if="!lastResponse && !executionError && !executing" class="h-full flex items-center justify-center">
        <div class="text-center max-w-md">
          <svg class="w-20 h-20 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
          </svg>
          <h3 class="text-lg font-semibold text-gray-700 mb-2">Ready to Test</h3>
          <p class="text-sm text-gray-600">
            Select an operation and runtime configuration to execute. Results will appear here.
          </p>
        </div>
      </div>

      <div v-else-if="executing" class="space-y-4">
        <!-- WebSocket Connection Status -->
        <div v-if="wsExecution.connected.value" class="bg-gradient-to-r from-purple-50 to-blue-50 border border-purple-200 rounded-lg p-3">
          <div class="flex items-center gap-2 text-purple-700">
            <div class="w-2 h-2 bg-purple-500 rounded-full animate-pulse"></div>
            <span class="text-xs font-semibold">🌊 WebSocket Streaming Active</span>
          </div>
        </div>

        <!-- Real-time Streaming Events Display -->
        <div v-if="streamingEventsCount > 0" class="space-y-2">
          <div class="text-xs font-semibold text-purple-900 mb-2 flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
            </svg>
            Real-Time Streaming Events ({{ streamingEventsCount }})
          </div>

          <div class="space-y-2 max-h-[400px] overflow-y-auto">
            <div
              v-for="(event, index) in streamingEvents"
              :key="`event-${index}-${event.taskId || ''}`"
              class="bg-white border-2 border-purple-200 rounded-lg p-3 shadow-sm animate-fade-in"
            >
              <!-- Event Header -->
              <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-2">
                  <span v-if="event.kind === 'task'" class="px-2 py-0.5 text-[10px] font-semibold bg-blue-100 text-blue-700 rounded">
                    📋 TASK
                  </span>
                  <span v-else-if="event.kind === 'status-update'" class="px-2 py-0.5 text-[10px] font-semibold bg-green-100 text-green-700 rounded">
                    ✅ STATUS
                  </span>
                  <span v-else-if="event.kind === 'artifact-update'" class="px-2 py-0.5 text-[10px] font-semibold bg-purple-100 text-purple-700 rounded">
                    📦 ARTIFACT
                  </span>
                  <span v-else class="px-2 py-0.5 text-[10px] font-semibold bg-gray-100 text-gray-700 rounded">
                    {{ event.kind }}
                  </span>
                  
                  <span v-if="event.status?.state" class="text-[10px] font-mono text-gray-600">
                    {{ event.status.state.toUpperCase() }}
                  </span>
                </div>
                
                <span class="text-[10px] text-gray-500">Event #{{ index + 1 }}</span>
              </div>

              <!-- Event Content -->
              <div class="space-y-2">
                <!-- Task ID -->
                <div v-if="event.taskId" class="text-[11px]">
                  <span class="font-semibold text-gray-600">Task ID:</span>
                  <span class="font-mono text-gray-800 ml-1">{{ event.taskId }}</span>
                </div>

                <!-- Status Message -->
                <div v-if="event.status?.message?.parts" class="bg-gray-50 rounded p-2">
                  <div class="text-[11px] text-gray-800">
                    {{ event.status.message.parts[0]?.text || 'No message' }}
                  </div>
                </div>

                <!-- Artifact Content -->
                <div v-if="event.artifact?.parts" class="bg-indigo-50 rounded p-2 border border-indigo-200">
                  <div class="text-[10px] font-semibold text-indigo-700 mb-1">Artifact Content:</div>
                  <div class="text-[11px] text-indigo-900 font-mono">
                    {{ event.artifact.parts[0]?.text || JSON.stringify(event.artifact.parts[0]) }}
                  </div>
                </div>

                <!-- Final Flag -->
                <div v-if="event.final !== undefined" class="text-[10px] text-gray-600">
                  {{ event.final ? '🏁 Final event' : '🔄 More events expected' }}
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Loading Spinner -->
        <div class="bg-gradient-to-br from-blue-50 via-blue-100 to-indigo-50 border border-blue-200 rounded-lg p-20 flex items-center justify-center">
          <LoadingSpinner :text="streamingEventsCount > 0 ? 'Receiving streaming events...' : 'Executing operation...'" />
        </div>
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
            <!-- View Toggle for Get Card Operation -->
            <div v-if="isGetCardOperation" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedCard = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedCard 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="showFormattedCard = false"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  !showFormattedCard 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                { } Raw
              </button>
            </div>
            <!-- View Toggle for Task Operations (Send Message, Get Task, Cancel Task, etc.) -->
            <div v-if="isSendMessageOperation || isSendStreamMessageOperation || isTaskResubscribeOperation || isGetTaskOperation || isCancelTaskOperation" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedMessage = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedMessage 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="showFormattedMessage = false"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  !showFormattedMessage 
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

        <!-- Special Display for Get Card Operation -->
        <div v-if="isGetCardOperation" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2">
            {{ showFormattedCard ? 'Agent Card' : 'Payload' }}
          </h5>
          <AgentCardDisplay v-if="showFormattedCard" :payload="lastResponse.result.payload" />
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Special Display for Send Message Operation -->
        <div v-else-if="isSendMessageOperation || isSendStreamMessageOperation" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center gap-2">
            <span>{{ showFormattedMessage ? 'Task/Message' : 'Payload' }}</span>
            <span v-if="isSendStreamMessageOperation" class="px-2 py-0.5 text-[10px] font-semibold bg-purple-100 text-purple-700 rounded">
              🌊 SSE Streaming
            </span>
          </h5>

          <!-- Show Collected Streaming Events for WebSocket operations -->
          <div v-if="isSendStreamMessageOperation && streamingEventsCount > 0" class="mb-4 space-y-2">
            <div class="text-xs font-semibold text-purple-900 mb-2 flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
              </svg>
              Streaming Events Received ({{ streamingEventsCount }})
            </div>

            <div class="space-y-2 max-h-[500px] overflow-y-auto">
              <div
                v-for="(event, index) in streamingEvents"
                :key="`final-event-${index}-${event.taskId || ''}`"
                class="bg-white border-2 border-purple-200 rounded-lg p-3 shadow-sm"
              >
                <!-- Event Header -->
                <div class="flex items-center justify-between mb-2">
                  <div class="flex items-center gap-2">
                    <span v-if="event.kind === 'task'" class="px-2 py-0.5 text-[10px] font-semibold bg-blue-100 text-blue-700 rounded">
                      📋 TASK
                    </span>
                    <span v-else-if="event.kind === 'status-update'" class="px-2 py-0.5 text-[10px] font-semibold bg-green-100 text-green-700 rounded">
                      ✅ STATUS
                    </span>
                    <span v-else-if="event.kind === 'artifact-update'" class="px-2 py-0.5 text-[10px] font-semibold bg-purple-100 text-purple-700 rounded">
                      📦 ARTIFACT
                    </span>
                    <span v-else class="px-2 py-0.5 text-[10px] font-semibold bg-gray-100 text-gray-700 rounded">
                      {{ event.kind }}
                    </span>
                    
                    <span v-if="event.status?.state" class="text-[10px] font-mono text-gray-600">
                      {{ event.status.state.toUpperCase() }}
                    </span>
                  </div>
                  
                  <span class="text-[10px] text-gray-500">Event #{{ index + 1 }}</span>
                </div>

                <!-- Event Content -->
                <div class="space-y-2">
                  <!-- Task ID -->
                  <div v-if="event.taskId" class="text-[11px]">
                    <span class="font-semibold text-gray-600">Task ID:</span>
                    <span class="font-mono text-gray-800 ml-1">{{ event.taskId }}</span>
                  </div>

                  <!-- Status Message -->
                  <div v-if="event.status?.message?.parts" class="bg-gray-50 rounded p-2">
                    <div class="text-[11px] text-gray-800">
                      {{ event.status.message.parts[0]?.text || 'No message' }}
                    </div>
                  </div>

                  <!-- Artifact Content -->
                  <div v-if="event.artifact?.parts" class="bg-indigo-50 rounded p-2 border border-indigo-200">
                    <div class="text-[10px] font-semibold text-indigo-700 mb-1">Artifact Content:</div>
                    <div class="text-[11px] text-indigo-900 font-mono max-h-40 overflow-y-auto">
                      {{ event.artifact.parts[0]?.text || JSON.stringify(event.artifact.parts[0]) }}
                    </div>
                  </div>

                  <!-- Final Flag -->
                  <div v-if="event.final !== undefined" class="text-[10px] text-gray-600">
                    {{ event.final ? '🏁 Final event' : '🔄 More events expected' }}
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Streaming Event Metadata (A2A 1.0.0 Schema) -->
          <div v-if="isSendStreamMessageOperation && hasStreamingMetadata(lastResponse.result.payload)" class="mb-3 bg-gradient-to-r from-indigo-50 to-purple-50 border-2 border-indigo-300 rounded-lg p-3">
            <div class="text-xs font-semibold text-indigo-900 mb-2 flex items-center gap-2">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
              </svg>
              Streaming Event Metadata
            </div>
            <div class="grid grid-cols-2 gap-2">
              <div v-if="'kind' in lastResponse.result.payload" class="bg-white rounded p-2 border border-indigo-200">
                <div class="text-[10px] text-indigo-600 font-semibold mb-0.5">Event Type</div>
                <div class="text-xs font-mono text-indigo-900">{{ lastResponse.result.payload.kind }}</div>
              </div>
              <div v-if="'final' in lastResponse.result.payload" class="bg-white rounded p-2 border border-indigo-200">
                <div class="text-[10px] text-indigo-600 font-semibold mb-0.5">Stream Ended</div>
                <div class="text-xs font-mono" :class="lastResponse.result.payload.final ? 'text-green-700' : 'text-gray-700'">
                  {{ lastResponse.result.payload.final ? '✅ Yes (final)' : '🔄 No (more events)' }}
                </div>
              </div>
              <div v-if="'append' in lastResponse.result.payload" class="bg-white rounded p-2 border border-indigo-200">
                <div class="text-[10px] text-indigo-600 font-semibold mb-0.5">Append Mode</div>
                <div class="text-xs font-mono" :class="lastResponse.result.payload.append ? 'text-purple-700' : 'text-gray-700'">
                  {{ lastResponse.result.payload.append ? '➕ Incremental' : '🆕 Replace' }}
                </div>
              </div>
              <div v-if="'lastChunk' in lastResponse.result.payload" class="bg-white rounded p-2 border border-indigo-200">
                <div class="text-[10px] text-indigo-600 font-semibold mb-0.5">Artifact Chunk</div>
                <div class="text-xs font-mono" :class="lastResponse.result.payload.lastChunk ? 'text-green-700' : 'text-orange-700'">
                  {{ lastResponse.result.payload.lastChunk ? '✅ Complete' : '📦 Partial' }}
                </div>
              </div>
            </div>
            <div class="mt-2 pt-2 border-t border-indigo-200 text-[10px] text-indigo-700">
              💡 These fields are part of the <a href="https://a2a-protocol.org/latest/definitions/" target="_blank" class="underline hover:text-indigo-900">A2A StreamingMessageResponse</a> schema for real-time event handling
            </div>
          </div>

          <TaskOrMessageDisplay v-if="showFormattedMessage" :payload="lastResponse.result.payload" />
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Special Display for Task Resubscribe Operation -->
        <div v-else-if="isTaskResubscribeOperation" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center gap-2">
            <span>{{ showFormattedMessage ? 'Streaming Response' : 'Payload' }}</span>
            <span class="px-2 py-0.5 text-[10px] font-semibold bg-green-100 text-green-700 rounded">
              🔄 Reconnected
            </span>
          </h5>
          <div v-if="showFormattedMessage" class="bg-gradient-to-r from-green-50 to-blue-50 border border-green-200 rounded-lg p-4 space-y-3">
            <div class="flex items-center gap-2 text-sm">
              <svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <span class="font-semibold text-green-800">Successfully Reconnected to Streaming Session</span>
            </div>
            <div class="text-xs text-gray-700">
              <p class="mb-2">You are now receiving buffered events and real-time updates from the SSE stream.</p>

              <!-- Streaming Event Metadata for Task Resubscribe -->
              <div v-if="hasStreamingMetadata(lastResponse.result.payload)" class="mb-3 bg-white border-2 border-green-300 rounded-lg p-3">
                <div class="text-xs font-semibold text-green-900 mb-2 flex items-center gap-2">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                  </svg>
                  Streaming Event Metadata
                </div>
                <div class="grid grid-cols-2 gap-2">
                  <div v-if="'kind' in lastResponse.result.payload" class="bg-gray-50 rounded p-2 border border-gray-200">
                    <div class="text-[10px] text-gray-600 font-semibold mb-0.5">Event Type</div>
                    <div class="text-xs font-mono text-gray-900">{{ lastResponse.result.payload.kind }}</div>
                  </div>
                  <div v-if="'final' in lastResponse.result.payload" class="bg-gray-50 rounded p-2 border border-gray-200">
                    <div class="text-[10px] text-gray-600 font-semibold mb-0.5">Stream Ended</div>
                    <div class="text-xs font-mono" :class="lastResponse.result.payload.final ? 'text-green-700' : 'text-gray-700'">
                      {{ lastResponse.result.payload.final ? '✅ Yes (final)' : '🔄 No (more events)' }}
                    </div>
                  </div>
                  <div v-if="'append' in lastResponse.result.payload" class="bg-gray-50 rounded p-2 border border-gray-200">
                    <div class="text-[10px] text-gray-600 font-semibold mb-0.5">Append Mode</div>
                    <div class="text-xs font-mono" :class="lastResponse.result.payload.append ? 'text-purple-700' : 'text-gray-700'">
                      {{ lastResponse.result.payload.append ? '➕ Incremental' : '🆕 Replace' }}
                    </div>
                  </div>
                  <div v-if="'lastChunk' in lastResponse.result.payload" class="bg-gray-50 rounded p-2 border border-gray-200">
                    <div class="text-[10px] text-gray-600 font-semibold mb-0.5">Artifact Chunk</div>
                    <div class="text-xs font-mono" :class="lastResponse.result.payload.lastChunk ? 'text-green-700' : 'text-orange-700'">
                      {{ lastResponse.result.payload.lastChunk ? '✅ Complete' : '📦 Partial' }}
                    </div>
                  </div>
                </div>
              </div>

              <TaskOrMessageDisplay :payload="lastResponse.result.payload" />
            </div>
          </div>
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Special Display for Get Task Operation -->
        <div v-else-if="isGetTaskOperation" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center gap-2">
            <span>{{ showFormattedMessage ? 'Task Details' : 'Payload' }}</span>
            <span class="px-2 py-0.5 text-[10px] font-semibold bg-blue-100 text-blue-700 rounded">
              📋 Get Task
            </span>
          </h5>
          <div v-if="showFormattedMessage" class="bg-gradient-to-r from-blue-50 to-cyan-50 border border-blue-200 rounded-lg p-4 space-y-3">
            <div class="flex items-center gap-2 text-sm">
              <svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/>
              </svg>
              <span class="font-semibold text-blue-800">Task Retrieved Successfully</span>
            </div>
            <div class="text-xs text-gray-700">
              <p class="mb-3">
                This operation retrieves the current state of a task by its ID, including status, artifacts, and conversation history.
              </p>
              <TaskOrMessageDisplay :payload="lastResponse.result.payload" />
            </div>
          </div>
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Special Display for Cancel Task Operation -->
        <div v-else-if="isCancelTaskOperation" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center gap-2">
            <span>{{ showFormattedMessage ? 'Canceled Task' : 'Payload' }}</span>
            <span class="px-2 py-0.5 text-[10px] font-semibold bg-orange-100 text-orange-700 rounded">
              ⛔ Cancel Task
            </span>
          </h5>
          <div v-if="showFormattedMessage" class="bg-gradient-to-r from-orange-50 to-red-50 border border-orange-200 rounded-lg p-4 space-y-3">
            <div class="flex items-center gap-2 text-sm">
              <svg class="w-5 h-5 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <span class="font-semibold text-orange-800">Task Cancellation Requested</span>
            </div>
            <div class="text-xs text-gray-700">
              <p class="mb-3">
                The agent has been notified to cancel this task. The task status should transition to <code class="bg-orange-100 text-orange-800 px-1 rounded font-mono text-[10px]">canceled</code> or <code class="bg-orange-100 text-orange-800 px-1 rounded font-mono text-[10px]">completed</code> if it finished before cancellation.
              </p>
              <TaskOrMessageDisplay :payload="lastResponse.result.payload" />
            </div>
          </div>
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Default Payload Display -->
        <div v-else class="mb-3">
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

    <!-- A2A Protocol Documentation Modal -->
    <DocsModal ref="protocolDocsModal" title="A2A Protocol - Key Concepts">
      <div class="space-y-4">
        <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 text-sm">
          <div class="flex items-start gap-2">
            <svg class="w-5 h-5 text-blue-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <div>
              <p class="font-semibold text-blue-900 mb-1">What is A2A?</p>
              <p class="text-blue-800 text-xs leading-relaxed">
                The A2A (Agent-to-Agent) protocol is a <strong>standardized communication framework</strong> enabling AI agents to discover, interact, and collaborate with each other. It facilitates tracking of long-running operations and enables multi-turn interactions between agents.
              </p>
            </div>
          </div>
        </div>

        <!-- Core Actors -->
        <div class="bg-white border border-gray-200 rounded-lg p-4">
          <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            Core Actors
          </h3>
          <div class="space-y-2.5 text-xs">
            <div>
              <p class="font-semibold text-gray-900">User</p>
              <p class="text-gray-700 mt-0.5">The end user (human or automated service) that initiates requests or defines goals</p>
            </div>
            <div>
              <p class="font-semibold text-gray-900">A2A Client (Client Agent)</p>
              <p class="text-gray-700 mt-0.5">Application or AI agent that acts on behalf of the user, initiating communication</p>
            </div>
            <div>
              <p class="font-semibold text-gray-900">A2A Server (Remote Agent)</p>
              <p class="text-gray-700 mt-0.5">AI agent that exposes an HTTP endpoint, receives requests, and returns results</p>
            </div>
          </div>
        </div>

        <!-- Communication Elements -->
        <div class="bg-white border border-gray-200 rounded-lg p-4">
          <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
            </svg>
            Fundamental Communication Elements
          </h3>
          <div class="grid grid-cols-2 gap-3 text-xs">
            <div class="bg-blue-50 rounded p-2">
              <p class="font-semibold text-blue-900">Agent Card</p>
              <p class="text-blue-700 text-[11px] mt-0.5">JSON metadata describing agent's identity, capabilities, and endpoint</p>
            </div>
            <div class="bg-blue-50 rounded p-2">
              <p class="font-semibold text-blue-900">Task</p>
              <p class="text-blue-700 text-[11px] mt-0.5">Stateful unit of work with unique ID and defined lifecycle</p>
            </div>
            <div class="bg-blue-50 rounded p-2">
              <p class="font-semibold text-blue-900">Message</p>
              <p class="text-blue-700 text-[11px] mt-0.5">Single turn of communication containing content and role</p>
            </div>
            <div class="bg-blue-50 rounded p-2">
              <p class="font-semibold text-blue-900">Part</p>
              <p class="text-blue-700 text-[11px] mt-0.5">Content container (TextPart, FilePart, DataPart)</p>
            </div>
            <div class="bg-blue-50 rounded p-2">
              <p class="font-semibold text-blue-900">Artifact</p>
              <p class="text-blue-700 text-[11px] mt-0.5">Tangible output generated during a task</p>
            </div>
            <div class="bg-blue-50 rounded p-2">
              <p class="font-semibold text-blue-900">Context</p>
              <p class="text-blue-700 text-[11px] mt-0.5">Groups related tasks across interactions</p>
            </div>
          </div>
        </div>

        <!-- Interaction Mechanisms -->
        <div class="bg-white border border-gray-200 rounded-lg p-4">
          <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
            </svg>
            Interaction Mechanisms
          </h3>
          <ul class="space-y-2 text-xs text-gray-700">
            <li class="flex items-start">
              <span class="text-blue-600 mr-2">•</span>
              <span><strong>Request/Response (Polling):</strong> Client sends request and polls for updates on long-running tasks</span>
            </li>
            <li class="flex items-start">
              <span class="text-blue-600 mr-2">•</span>
              <span><strong>Streaming (SSE):</strong> Real-time incremental results over open HTTP connection</span>
            </li>
            <li class="flex items-start">
              <span class="text-blue-600 mr-2">•</span>
              <span><strong>Push Notifications:</strong> Server actively sends async notifications to client webhook</span>
            </li>
          </ul>
        </div>

        <!-- External Link -->
        <div class="border-t border-gray-200 pt-4">
          <a 
            href="https://a2a-protocol.org/latest/topics/key-concepts/" 
            target="_blank"
            class="flex items-center justify-center gap-2 w-full px-4 py-3 bg-gradient-to-r from-blue-600 to-cyan-600 text-white font-semibold rounded-lg hover:from-blue-700 hover:to-cyan-700 transition-all"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
            </svg>
            Read Full Documentation on a2a-protocol.org
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
            </svg>
          </a>
          <p class="text-center text-[10px] text-gray-500 mt-2">Opens in a new tab</p>
        </div>
      </div>
    </DocsModal>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import { useWebSocketExecution } from '../../composables/useWebSocketExecution'
import { apiPost } from '../../composables/useApi'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'
import DocsModal from '../../components/DocsModal.vue'
import A2AMessageBuilder from '../../components/A2AMessageBuilder.vue'
import TaskPushNotificationConfigBuilder from '../../components/TaskPushNotificationConfigBuilder.vue'
import GetPushConfigBuilder from '../../components/GetPushConfigBuilder.vue'
import DeletePushConfigBuilder from '../../components/DeletePushConfigBuilder.vue'
import TaskIdParamsBuilder from '../../components/TaskIdParamsBuilder.vue'
import TaskQueryParamsBuilder from '../../components/TaskQueryParamsBuilder.vue'
import AgentCardDisplay from '../../components/AgentCardDisplay.vue'
import { logger } from '../../utils/logger'
import { API_BASE } from '../../config/api'
import TaskOrMessageDisplay from '../../components/TaskOrMessageDisplay.vue'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)
const wsExecution = useWebSocketExecution()

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

const protocolDocsModal = ref<InstanceType<typeof DocsModal> | null>(null)
const showFormattedCard = ref(true) // Default to formatted view for Agent Cards
const showFormattedMessage = ref(true) // Default to formatted view for Messages

// A2A Card panel state
const cardResult = ref<any>(null)
const loadingCard = ref(false)
const cardView = ref<'beautiful' | 'raw'>('beautiful')

// Detect if the current operation is Get Card to show special display
const isGetCardOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:get-card'
})

// Detect if the current operation is Send Message to show special display
const isSendMessageOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:send-message'
})

// Detect if the current operation is Send Stream Message (NEW in 1.0.0)
const isSendStreamMessageOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:send-stream-message'
})

// Detect if the current operation is Task Resubscribe (NEW in 1.0.0)
const isTaskResubscribeOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:task-resubscribe'
})

// Detect if the current operation is Get Task
const isGetTaskOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:get-task'
})

// Detect if the current operation is Cancel Task
const isCancelTaskOperation = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:cancel-task'
})

// Show A2A Card panel on Send Message and Send Stream Message operations
const showA2ACardPanel = computed(() => {
  return lab.selectedOperation.value?.operationKey === 'a2a:send-message' ||
         lab.selectedOperation.value?.operationKey === 'a2a:send-stream-message'
})

// Custom execution handler that routes to WebSocket for streaming operations
function executeOperation() {
  const isStreaming = isSendStreamMessageOperation.value || isTaskResubscribeOperation.value
  
  if (isStreaming) {
    // Use WebSocket for streaming operations
    logger.info('Using WebSocket for streaming operation')
    wsExecution.executeViaWebSocket({
      operationId: lab.selectedOperation.value!.id,
      runtimeConfigId: Number(lab.selectedRuntimeConfigId.value),
      parameters: lab.formData.value,
      enableLogging: lab.enableLogging.value,
      enableValidation: lab.enableValidation.value
    })
  } else {
    // Use regular HTTP for non-streaming operations
    lab.executeOperation()
  }
}

// Custom clear handler that clears both HTTP and WebSocket state
function clearResponse() {
  lab.clearResponse()
  wsExecution.clearResults()
}

// Compute combined execution state (HTTP or WebSocket)
const isExecuting = computed(() => {
  return lab.executing.value || wsExecution.executing.value
})

// Compute combined response (prefer WebSocket for streaming ops)
const combinedResponse = computed(() => {
  const isStreaming = isSendStreamMessageOperation.value || isTaskResubscribeOperation.value
  return isStreaming ? wsExecution.lastResponse.value : lab.lastResponse.value
})

// Compute combined error
const combinedError = computed(() => {
  return lab.executionError.value || wsExecution.executionError.value
})

// Computed property for streaming events to ensure reactivity
const streamingEvents = computed(() => {
  return wsExecution.streamingEvents.value
})

const streamingEventsCount = computed(() => {
  return wsExecution.streamingEvents.value.length
})

// Debug: Watch for response changes
watch(combinedResponse, (newResponse) => {
  if (newResponse && isSendStreamMessageOperation.value) {
    logger.info('🔍 Combined response updated for streaming operation')
    logger.info(`🔍 Streaming events count: ${wsExecution.streamingEvents.value.length}`)
    logger.info('🔍 Events array:', wsExecution.streamingEvents.value)
  }
})

// Debug: Watch streaming events array changes
watch(streamingEvents, (newEvents) => {
  logger.info(`🔔 Streaming events array changed! New count: ${newEvents.length}`)
}, { deep: true })

// Load A2A Card by executing Get Card operation
async function loadA2ACard() {
  loadingCard.value = true
  try {
    // Find Get Card operation
    const getCardOp = lab.operations.value.find((op: any) => op.operationKey === 'a2a:get-card')
    if (!getCardOp) {
      logger.error('Get Card operation not found')
      return
    }

    // Build the request to execute Get Card with authentication
    const result = await apiPost('/execute', {
      operationId: getCardOp.id,
      runtimeConfigId: lab.selectedRuntimeConfigId.value,
      parameters: { useExtendedCard: false },
      enableLogging: false,
      enableValidation: false
    })
    
    cardResult.value = result
  } catch (error) {
    logger.error('Error loading A2A card:', error)
  } finally {
    loadingCard.value = false
  }
}

import { MULE_ORIGIN, getAssetUrl } from '../../config/api'

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

function openProtocolDocs() {
  protocolDocsModal.value?.open()
}

// Check if payload has streaming-specific metadata (A2A 1.0.0 StreamingMessageResponse schema)
function hasStreamingMetadata(payload: any): boolean {
  if (!payload || typeof payload !== 'object') return false
  // Check for any streaming-specific fields from the schema
  return 'final' in payload || 'append' in payload || 'lastChunk' in payload || 
         (payload.kind && ['task', 'task-status-update', 'task-artifact-update'].includes(payload.kind))
}

</script>

<style scoped>
@keyframes fade-in {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.animate-fade-in {
  animation: fade-in 0.3s ease-out;
}
</style>

