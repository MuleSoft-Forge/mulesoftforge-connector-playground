<template>
  <div>
    <LabTemplate
      header-title="MCP"
      flow-diagram-img="mcp.png"
      flow-doc-url="mcp.html"
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
          <span>Test MCP Client operations to interact with remote MCP servers</span>
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
      <!-- Special handling for toolName parameter -->
      <div v-if="param.apiName === 'toolName'" class="space-y-2">
        <!-- Load Tools Button -->
        <button
          @click="loadAvailableTools"
          :disabled="!lab.selectedRuntimeConfigId.value || loadingTools"
          class="w-full px-3 py-2 text-xs font-medium bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200 transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
        >
          <svg v-if="!loadingTools" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
          </svg>
          <svg v-else class="w-4 h-4 animate-spin" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          {{ loadingTools ? 'Loading Tools...' : availableTools.length > 0 ? `Reload Tools (${availableTools.length} loaded)` : 'Load Available Tools' }}
        </button>
        
        <!-- Dropdown (shown when tools are loaded) -->
        <select 
          v-if="availableTools.length > 0"
          v-model="lab.formData.value[param.apiName]"
          @change="onToolSelected"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        >
          <option value="">-- Select a Tool --</option>
          <option 
            v-for="tool in availableTools" 
            :key="tool.name" 
            :value="tool.name"
          >
            {{ tool.name }} · {{ tool.description }}
          </option>
        </select>
        
        <!-- Manual Input Fallback (always shown) -->
        <input
          v-model="lab.formData.value[param.apiName]"
          type="text"
          :placeholder="availableTools.length > 0 ? 'Or enter tool name manually' : 'Enter tool name (or load tools above)'"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        />
      </div>

      <!-- Special handling for arguments parameter with form builder -->
      <div v-else-if="param.apiName === 'arguments'" class="space-y-2">
        <!-- Toggle between Form and Raw JSON -->
        <div class="flex items-center justify-between mb-2">
          <div class="flex bg-white border border-gray-300 rounded overflow-hidden">
            <button
              @click="argumentsViewMode = 'form'"
              :class="[
                'px-3 py-1.5 text-xs font-medium transition-colors',
                argumentsViewMode === 'form' 
                  ? 'bg-purple-500 text-white' 
                  : 'bg-white text-gray-700 hover:bg-gray-50'
              ]"
              :disabled="!currentToolSchema"
              :title="!currentToolSchema ? 'Select a tool to use form builder' : ''"
            >
              📝 Form
            </button>
            <button
              @click="argumentsViewMode = 'raw'"
              :class="[
                'px-3 py-1.5 text-xs font-medium transition-colors border-l border-gray-300',
                argumentsViewMode === 'raw' 
                  ? 'bg-purple-500 text-white' 
                  : 'bg-white text-gray-700 hover:bg-gray-50'
              ]"
            >
              { } Raw JSON
            </button>
          </div>
          <button
            v-if="argumentsViewMode === 'raw'"
            @click="formatArgumentsJson"
            class="px-2 py-1 text-[10px] bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 transition-colors"
          >
            ✨ Format
          </button>
        </div>

        <!-- Form View -->
        <div v-if="argumentsViewMode === 'form' && currentToolSchema" class="space-y-3 p-3 bg-gray-50 border border-gray-200 rounded-md">
          <div v-if="Object.keys(currentToolSchema.properties || {}).length === 0" class="text-xs text-gray-500 text-center py-2">
            No parameters defined in schema
          </div>
          <div 
            v-for="(propSchema, propKey) in currentToolSchema.properties" 
            :key="propKey"
            class="space-y-1"
          >
            <label class="block text-xs font-semibold text-gray-700">
              {{ propKey }}
              <span v-if="currentToolSchema.required?.includes(propKey)" class="text-red-500">*</span>
              <span v-if="propSchema.type" class="ml-1 text-[10px] font-normal text-gray-500">({{ propSchema.type }})</span>
            </label>
            <p v-if="propSchema.description" class="text-[10px] text-gray-600 mb-1">{{ propSchema.description }}</p>
            
            <!-- String input -->
            <input
              v-if="propSchema.type === 'string'"
              v-model="formArguments[propKey]"
              @input="syncFormToJson"
              type="text"
              :placeholder="propSchema.description || `Enter ${propKey}`"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
            
            <!-- Number input -->
            <input
              v-else-if="propSchema.type === 'number' || propSchema.type === 'integer'"
              v-model.number="formArguments[propKey]"
              @input="syncFormToJson"
              type="number"
              :placeholder="propSchema.description || `Enter ${propKey}`"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
            
            <!-- Boolean checkbox -->
            <label v-else-if="propSchema.type === 'boolean'" class="flex items-center gap-2">
              <input
                type="checkbox"
                v-model="formArguments[propKey]"
                @change="syncFormToJson"
                class="w-4 h-4 text-purple-600 border-gray-300 rounded"
              />
              <span class="text-xs text-gray-700">{{ propSchema.description || 'Enable' }}</span>
            </label>
            
            <!-- Array/Object as JSON textarea -->
            <textarea
              v-else-if="propSchema.type === 'array' || propSchema.type === 'object'"
              v-model="formArguments[propKey]"
              @input="syncFormToJson"
              rows="3"
              :placeholder="propSchema.type === 'array' ? '[]' : '{}'"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
            />
            
            <!-- Fallback for unknown types -->
            <input
              v-else
              v-model="formArguments[propKey]"
              @input="syncFormToJson"
              type="text"
              :placeholder="`Enter ${propKey}`"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
          </div>
        </div>

        <!-- No schema available message for Form view -->
        <div v-else-if="argumentsViewMode === 'form' && !currentToolSchema" class="p-4 bg-blue-50 border border-blue-200 rounded-md text-center">
          <svg class="w-8 h-8 mx-auto text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <p class="text-xs text-blue-800 font-medium">No schema available</p>
          <p class="text-[10px] text-blue-700 mt-1">Select a tool from the dropdown above to enable the form builder</p>
        </div>

        <!-- Raw JSON View -->
        <textarea
          v-if="argumentsViewMode === 'raw'"
          v-model="lab.formData.value[param.apiName]"
          @input="syncJsonToForm"
          rows="6"
          :placeholder="`Enter ${param.displayName.toLowerCase()} as JSON`"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
          :class="{ 'border-red-500': argumentsJsonError }"
        />
        <div v-if="argumentsViewMode === 'raw' && argumentsJsonError" class="text-[10px] text-red-600">
          ⚠️ {{ argumentsJsonError }}
        </div>
      </div>

      <!-- Default handling for other parameters -->
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
          class="w-4 h-4 text-blue-600 border-gray-300 rounded"
        />
        <span class="text-xs text-gray-700">Enable</span>
      </label>
      <textarea
        v-else
        v-model="lab.formData.value[param.apiName]"
        rows="3"
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono"
      />
    </template>

    <!-- Custom Response Display for MCP Tools -->
    <template #response-display="{ lastResponse, executionError, executing, clearResponse }">
      <div v-if="!lastResponse && !executionError && !executing" class="h-full flex items-center justify-center">
        <div class="text-center max-w-md">
          <svg class="w-20 h-20 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
            </svg>
          <h3 class="text-lg font-semibold text-gray-700 mb-2">Ready to Test</h3>
          <p class="text-sm text-gray-600">
            Select an operation and runtime configuration to execute. Results will appear here.
          </p>
        </div>
      </div>

      <div v-else-if="executing" class="bg-gradient-to-br from-blue-50 via-blue-100 to-indigo-50 border border-blue-200 rounded-lg p-20 flex items-center justify-center min-h-[400px]">
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
            <!-- View Toggle for List Tools Operation -->
            <div v-if="isMcpToolsResponse(lastResponse.result.payload)" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedTools = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedTools 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="showFormattedTools = false"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  !showFormattedTools 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                { } Raw
              </button>
            </div>
            <!-- View Toggle for Call Tool Operation -->
            <div v-else-if="isMcpCallToolResponse(lastResponse.result.payload)" class="flex bg-white border border-gray-300 rounded overflow-hidden">
              <button
                @click="showFormattedCallTool = true"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors',
                  showFormattedCallTool 
                    ? 'bg-blue-500 text-white' 
                    : 'bg-white text-gray-700 hover:bg-gray-50'
                ]"
              >
                ✨ Beauty
              </button>
              <button
                @click="showFormattedCallTool = false"
                :class="[
                  'px-2 py-1 text-[10px] font-medium transition-colors border-l border-gray-300',
                  !showFormattedCallTool 
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

        <!-- Smart MCP Tools Rendering -->
        <div v-if="isMcpToolsResponse(lastResponse.result.payload)" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2">
            {{ showFormattedTools ? 'Available Tools' : 'Payload' }}
          </h5>
          
          <!-- Formatted Tools Display -->
          <div v-if="showFormattedTools" class="space-y-2">
            <div class="flex items-center mb-2">
              <svg class="w-4 h-4 mr-1 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
              </svg>
              <span class="text-xs text-gray-600">({{ lastResponse.result.payload.length }} tools)</span>
            </div>
            <div
              v-for="(tool, index) in lastResponse.result.payload"
              :key="index"
              class="border border-blue-200 rounded-lg p-3 bg-blue-50 hover:shadow-md transition-shadow"
            >
              <div class="mb-2">
                <h6 class="text-sm font-semibold text-blue-900">{{ tool.name }}</h6>
                <p class="text-xs text-blue-700 mt-0.5">{{ tool.description }}</p>
              </div>
              <details class="mt-2">
                <summary class="text-xs text-blue-600 hover:text-blue-700 cursor-pointer font-medium">
                  View Input Schema
                </summary>
                <pre class="mt-2 text-[10px] bg-white border border-blue-200 rounded p-2 overflow-x-auto font-mono text-gray-800">{{ formatJsonSchema(tool.inputSchema) }}</pre>
              </details>
            </div>
          </div>
          
          <!-- Raw JSON Display -->
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Smart MCP Call Tool Rendering -->
        <div v-else-if="isMcpCallToolResponse(lastResponse.result.payload)" class="mb-3">
          <h5 class="text-xs font-semibold text-gray-700 mb-2">
            {{ showFormattedCallTool ? 'Tool Response' : 'Payload' }}
          </h5>
          
          <!-- Formatted Call Tool Display -->
          <div v-if="showFormattedCallTool" class="space-y-3">
            <!-- Error Status -->
            <div class="flex items-center gap-2 p-2 rounded-lg" :class="lastResponse.result.payload.error ? 'bg-red-50 border border-red-200' : 'bg-green-50 border border-green-200'">
              <svg v-if="!lastResponse.result.payload.error" class="w-4 h-4 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <svg v-else class="w-4 h-4 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <span class="text-xs font-medium" :class="lastResponse.result.payload.error ? 'text-red-700' : 'text-green-700'">
                {{ lastResponse.result.payload.error ? 'Error Response' : 'Success' }}
              </span>
            </div>

            <!-- Contents -->
            <div v-if="lastResponse.result.payload.contents && lastResponse.result.payload.contents.length > 0" class="space-y-2">
              <div class="flex items-center gap-1 text-xs text-gray-600">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                <span>Contents ({{ lastResponse.result.payload.contents.length }})</span>
              </div>
              <div
                v-for="(content, index) in lastResponse.result.payload.contents"
                :key="index"
                class="border border-purple-200 rounded-lg p-3 bg-purple-50"
              >
                <div class="flex items-center justify-between mb-2">
                  <span class="text-xs font-semibold text-purple-900">{{ content.type || 'Content' }}</span>
                  <span v-if="content.mimeType" class="text-[10px] px-2 py-0.5 bg-purple-200 text-purple-700 rounded">{{ content.mimeType }}</span>
                </div>
                <div v-if="content.text" class="bg-white border border-purple-200 rounded p-2 text-xs text-gray-800 whitespace-pre-wrap">{{ content.text }}</div>
                <div v-if="content.resource" class="mt-2 text-xs text-purple-700">
                  <span class="font-medium">Resource:</span> {{ content.resource }}
                </div>
                <div v-if="content.data" class="mt-2">
                  <details>
                    <summary class="text-xs text-purple-600 hover:text-purple-700 cursor-pointer font-medium">View Data</summary>
                    <pre class="mt-2 text-[10px] bg-white border border-purple-200 rounded p-2 overflow-x-auto font-mono text-gray-800">{{ typeof content.data === 'string' ? content.data : JSON.stringify(content.data, null, 2) }}</pre>
                  </details>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Raw JSON Display -->
          <pre v-else class="bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-900">{{ JSON.stringify(lastResponse.result.payload, null, 2) }}</pre>
        </div>

        <!-- Standard Payload Display (fallback) -->
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

    <!-- MCP Protocol Documentation Modal -->
    <DocsModal ref="protocolDocsModal" title="Model Context Protocol (MCP)">
      <div class="space-y-4">
        <div class="bg-purple-50 border border-purple-200 rounded-lg p-3 text-sm">
          <div class="flex items-start gap-2">
            <svg class="w-5 h-5 text-purple-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
            </svg>
            <div>
              <p class="font-semibold text-purple-900 mb-1">What is MCP?</p>
              <p class="text-purple-800 text-xs leading-relaxed">
                The Model Context Protocol (MCP) is an open-source standard for connecting AI applications to external systems. Think of MCP like a <strong>USB-C port for AI applications</strong>—providing a standardized way to connect to data sources, tools, and workflows.
              </p>
            </div>
          </div>
        </div>

        <!-- Key Concepts -->
        <div class="bg-white border border-gray-200 rounded-lg p-4">
          <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-2 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
            </svg>
            What can MCP enable?
          </h3>
          <ul class="space-y-2 text-xs text-gray-700">
            <li class="flex items-start">
              <span class="text-purple-600 mr-2">•</span>
              <span>Agents can access your Google Calendar and Notion, acting as a more personalized AI assistant</span>
            </li>
            <li class="flex items-start">
              <span class="text-purple-600 mr-2">•</span>
              <span>Claude Code can generate an entire web app using a Figma design</span>
            </li>
            <li class="flex items-start">
              <span class="text-purple-600 mr-2">•</span>
              <span>Enterprise chatbots can connect to multiple databases across an organization</span>
            </li>
            <li class="flex items-start">
              <span class="text-purple-600 mr-2">•</span>
              <span>AI models can create 3D designs on Blender and print them using a 3D printer</span>
            </li>
          </ul>
        </div>

        <!-- Benefits -->
        <div class="bg-white border border-gray-200 rounded-lg p-4">
          <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-2 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
            </svg>
            Why does MCP matter?
          </h3>
          <div class="space-y-2.5 text-xs">
            <div>
              <p class="font-semibold text-gray-900">Developers</p>
              <p class="text-gray-700 mt-0.5">MCP reduces development time and complexity when building, or integrating with, an AI application or agent</p>
            </div>
            <div>
              <p class="font-semibold text-gray-900">AI Applications/Agents</p>
              <p class="text-gray-700 mt-0.5">Access to an ecosystem of data sources, tools and apps which enhance capabilities</p>
            </div>
            <div>
              <p class="font-semibold text-gray-900">End-Users</p>
              <p class="text-gray-700 mt-0.5">More capable AI applications that can access your data and take actions on your behalf</p>
            </div>
          </div>
        </div>

        <!-- Core Components -->
        <div class="bg-white border border-gray-200 rounded-lg p-4">
          <h3 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
            <svg class="w-4 h-4 mr-2 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"/>
            </svg>
            Core Concepts
          </h3>
          <div class="grid grid-cols-2 gap-3 text-xs">
            <div class="bg-purple-50 rounded p-2">
              <p class="font-semibold text-purple-900">Tools</p>
              <p class="text-purple-700 text-[11px] mt-0.5">Functions servers expose for LLMs to call</p>
            </div>
            <div class="bg-purple-50 rounded p-2">
              <p class="font-semibold text-purple-900">Resources</p>
              <p class="text-purple-700 text-[11px] mt-0.5">Data sources servers make available</p>
            </div>
            <div class="bg-purple-50 rounded p-2">
              <p class="font-semibold text-purple-900">Prompts</p>
              <p class="text-purple-700 text-[11px] mt-0.5">Pre-written templates for interactions</p>
            </div>
            <div class="bg-purple-50 rounded p-2">
              <p class="font-semibold text-purple-900">Sampling</p>
              <p class="text-purple-700 text-[11px] mt-0.5">Servers can request LLM completions</p>
            </div>
          </div>
        </div>

        <!-- External Link -->
        <div class="border-t border-gray-200 pt-4">
          <a 
            href="https://modelcontextprotocol.io/docs/getting-started/intro" 
            target="_blank"
            class="flex items-center justify-center gap-2 w-full px-4 py-3 bg-gradient-to-r from-purple-600 to-blue-600 text-white font-semibold rounded-lg hover:from-purple-700 hover:to-blue-700 transition-all"
          >
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
            </svg>
            Read Full Documentation on modelcontextprotocol.io
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
import { ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useLab } from '../../composables/useLab'
import { apiCall } from '../../composables/useApi'
import LabTemplate from '../../components/LabTemplate.vue'
import ConnectorIcon from '../../components/ConnectorIcon.vue'
import LoadingSpinner from '../../components/LoadingSpinner.vue'
import DocsModal from '../../components/DocsModal.vue'
import { logger } from '../../utils/logger'

const route = useRoute()
const connectorId = Number(route.params.connectorId)
const lab = useLab(connectorId)

const protocolDocsModal = ref<InstanceType<typeof DocsModal> | null>(null)
const showFormattedTools = ref(true) // Default to formatted view for MCP Tools
const showFormattedCallTool = ref(true) // Default to formatted view for Call Tool results
const availableTools = ref<any[]>([])
const loadingTools = ref(false)

// Arguments form builder state
const argumentsViewMode = ref<'form' | 'raw'>('raw') // Default to raw JSON view
const currentToolSchema = ref<any>(null) // Schema of currently selected tool
const formArguments = ref<Record<string, any>>({}) // Form field values
const argumentsJsonError = ref<string>('') // JSON validation error

import { MULE_ORIGIN, getAssetUrl } from '../../config/api'

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '')
}

function openProtocolDocs() {
  protocolDocsModal.value?.open()
}

// Sync form values to JSON textarea
function syncFormToJson() {
  try {
    // Build JSON from form values
    const jsonObj: Record<string, any> = {}
    for (const [key, value] of Object.entries(formArguments.value)) {
      // Skip empty values
      if (value === '' || value === null || value === undefined) continue
      
      // For array/object types stored as strings, parse them
      const propSchema = currentToolSchema.value?.properties?.[key]
      if (propSchema?.type === 'array' || propSchema?.type === 'object') {
        try {
          jsonObj[key] = typeof value === 'string' ? JSON.parse(value) : value
        } catch (e) {
          // If parsing fails, store as string
          jsonObj[key] = value
        }
      } else {
        jsonObj[key] = value
      }
    }
    
    // Update the arguments field
    if (lab.formData.value) {
      lab.formData.value.arguments = JSON.stringify(jsonObj, null, 2)
    }
    argumentsJsonError.value = ''
  } catch (err: any) {
    argumentsJsonError.value = err.message
  }
}

// Sync JSON textarea to form values
function syncJsonToForm() {
  try {
    const jsonText = lab.formData.value?.arguments || '{}'
    const parsed = JSON.parse(jsonText)
    
    // Update form arguments
    formArguments.value = { ...parsed }
    argumentsJsonError.value = ''
  } catch (err: any) {
    argumentsJsonError.value = 'Invalid JSON'
  }
}

// Format JSON in the arguments textarea
function formatArgumentsJson() {
  try {
    if (lab.formData.value?.arguments) {
      const parsed = JSON.parse(lab.formData.value.arguments)
      lab.formData.value.arguments = JSON.stringify(parsed, null, 2)
      argumentsJsonError.value = ''
    }
  } catch (err: any) {
    argumentsJsonError.value = 'Cannot format: Invalid JSON'
  }
}

// Load schema for the selected tool
function loadToolSchema(toolName: string) {
  const tool = availableTools.value.find(t => t.name === toolName)
  if (!tool) {
    currentToolSchema.value = null
    return
  }
  
  try {
    const schema = JSON.parse(tool.inputSchema)
    currentToolSchema.value = schema
    
    // Initialize form arguments from schema
    formArguments.value = {}
    if (schema.properties) {
      Object.keys(schema.properties).forEach(key => {
        const prop = schema.properties[key]
        // Set initial values based on type
        if (prop.type === 'string') {
          formArguments.value[key] = ''
        } else if (prop.type === 'number' || prop.type === 'integer') {
          formArguments.value[key] = 0
        } else if (prop.type === 'boolean') {
          formArguments.value[key] = false
        } else if (prop.type === 'array') {
          formArguments.value[key] = '[]'
        } else if (prop.type === 'object') {
          formArguments.value[key] = '{}'
        }
      })
    }
    
    // Try to parse existing arguments if any
    if (lab.formData.value?.arguments) {
      try {
        const existing = JSON.parse(lab.formData.value.arguments)
        formArguments.value = { ...formArguments.value, ...existing }
      } catch (e) {
        // Ignore parse errors
      }
    }
  } catch (e) {
    logger.error('Failed to parse inputSchema:', e)
    currentToolSchema.value = null
  }
}

// Load available tools from MCP server using List Tools operation
async function loadAvailableTools() {
  if (!lab.selectedRuntimeConfigId.value) {
    alert('Please select a runtime configuration first')
    return
  }

  // Find the "List Tools" operation
  const listToolsOperation = lab.operations.value.find((op: any) => 
    op.operationKey === 'mcp:list-tools' || 
    op.displayName.toLowerCase().includes('list tools')
  )
  
  if (!listToolsOperation) {
    alert('List Tools operation not found')
    return
  }

  try {
    loadingTools.value = true
    const response = await apiCall('/execute', 'POST', {
      operationId: listToolsOperation.id,
      runtimeConfigId: Number(lab.selectedRuntimeConfigId.value),
      parameters: {}
    })
    
    // Extract tools from response
    if (response?.result?.payload && Array.isArray(response.result.payload)) {
      availableTools.value = response.result.payload
      logger.debug(`[MCP] Loaded ${availableTools.value.length} tools`)
    } else {
      logger.error('[MCP] Unexpected response format:', response)
      alert('Failed to load tools: Unexpected response format')
    }
  } catch (err: any) {
    logger.error('[MCP] Error loading tools:', err)
    alert(`Failed to load tools: ${err.message}`)
  } finally {
    loadingTools.value = false
  }
}

// Handle tool selection from dropdown
function onToolSelected(event: Event) {
  const toolName = (event.target as HTMLSelectElement).value
  if (!toolName) {
    currentToolSchema.value = null
    return
  }
  
  const selectedTool = availableTools.value.find(t => t.name === toolName)
  if (!selectedTool) {
    currentToolSchema.value = null
    return
  }
  
  // Load schema and initialize form
  loadToolSchema(toolName)
  
  // Pre-populate arguments based on inputSchema
  let initialArguments: Record<string, any> = {}
  try {
    const schema = JSON.parse(selectedTool.inputSchema)
    if (schema.properties) {
      Object.keys(schema.properties).forEach(key => {
        const prop = schema.properties[key]
        if (prop.type === 'string') {
          initialArguments[key] = prop.description ? `<${prop.description}>` : ''
        } else if (prop.type === 'number' || prop.type === 'integer') {
          initialArguments[key] = 0
        } else if (prop.type === 'boolean') {
          initialArguments[key] = false
        } else if (prop.type === 'array') {
          initialArguments[key] = []
        } else if (prop.type === 'object') {
          initialArguments[key] = {}
        }
      })
    }
  } catch (e) {
    logger.error('Failed to parse inputSchema:', e)
  }
  
  // Update form data with arguments
  if (lab.formData.value) {
    lab.formData.value.arguments = JSON.stringify(initialArguments, null, 2)
  }
  
  // Switch to form view if schema is available
  if (currentToolSchema.value) {
    argumentsViewMode.value = 'form'
  }
}

// Clear available tools when runtime config changes
watch(() => lab.selectedRuntimeConfigId.value, () => {
  availableTools.value = []
  currentToolSchema.value = null
  argumentsViewMode.value = 'raw'
})

// Clear schema when operation changes
watch(() => lab.selectedOperation.value, () => {
  // Only clear if not on Call Tool operation
  const isCallTool = lab.selectedOperation.value?.operationKey === 'mcp:call-tool' || 
                     lab.selectedOperation.value?.displayName?.toLowerCase().includes('call tool')
  if (!isCallTool) {
    currentToolSchema.value = null
    argumentsViewMode.value = 'raw'
  }
})

// Detect if response is from "List MCP Tools" operation
// Response is directly an array: [{name, description, inputSchema}, ...]
function isMcpToolsResponse(payload: any): boolean {
  logger.debug('[MCP Debug] Checking if tools response:', payload)
  logger.debug('[MCP Debug] Is array?', Array.isArray(payload))
  
  // Must be an array
  if (!Array.isArray(payload)) {
    logger.debug('[MCP Debug] Not an array, showing standard response')
    return false
  }
  if (payload.length === 0) {
    logger.debug('[MCP Debug] Empty array, showing standard response')
    return false
  }
  
  // Check if first item has MCP tool structure
  const firstItem = payload[0]
  const isToolsResponse = (
    typeof firstItem === 'object' &&
    firstItem !== null &&
    'name' in firstItem &&
    'description' in firstItem &&
    'inputSchema' in firstItem
  )
  
  logger.debug('[MCP Debug] First item:', firstItem)
  logger.debug('[MCP Debug] Is MCP tools response?', isToolsResponse)
  
  return isToolsResponse
}

// Check if response is from Call Tool operation
function isMcpCallToolResponse(payload: any): boolean {
  return (
    typeof payload === 'object' &&
    payload !== null &&
    'contents' in payload &&
    Array.isArray(payload.contents)
  )
}

// Format JSON schema string for display
function formatJsonSchema(schemaString: string): string {
  try {
    const schema = JSON.parse(schemaString)
    return JSON.stringify(schema, null, 2)
  } catch (e) {
    return schemaString
  }
}

// Use this tool - switch to Call Tool operation and pre-fill parameters
function useThisTool(tool: any) {
  // Find the "Call Tool" operation
  const callToolOperation = lab.operations.value.find((op: any) => 
    op.operationKey === 'mcp:call-tool' || 
    op.displayName.toLowerCase().includes('call tool')
  )
  
  if (!callToolOperation) {
    alert('Call Tool operation not found')
    return
  }
  
  // Switch to Call Tool operation
  lab.selectOperation(callToolOperation)
  
  // Pre-fill the form data
  // Parse the inputSchema to create initial arguments
  let initialArguments = {}
  try {
    const schema = JSON.parse(tool.inputSchema)
    if (schema.properties) {
      // Create empty object with property keys from schema
      Object.keys(schema.properties).forEach(key => {
        const prop = schema.properties[key]
        // Set default values based on type
        if (prop.type === 'string') {
          initialArguments[key] = prop.description ? `<${prop.description}>` : ''
        } else if (prop.type === 'number' || prop.type === 'integer') {
          initialArguments[key] = 0
        } else if (prop.type === 'boolean') {
          initialArguments[key] = false
        } else if (prop.type === 'array') {
          initialArguments[key] = []
        } else if (prop.type === 'object') {
          initialArguments[key] = {}
        }
      })
    }
  } catch (e) {
    logger.error('Failed to parse inputSchema:', e)
  }
  
  // Update form data
  setTimeout(() => {
    // Set tool name (parameter name is 'toolName' not 'name')
    if (lab.formData.value) {
      lab.formData.value.toolName = tool.name
      
      // Set arguments as formatted JSON string (parse inputSchema and create template)
      lab.formData.value.arguments = JSON.stringify(initialArguments, null, 2)
    }
    
    // Load schema for form builder
    loadToolSchema(tool.name)
    
    // Switch to form view if schema is available
    if (currentToolSchema.value) {
      argumentsViewMode.value = 'form'
    }
    
    // Scroll to parameters section
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }, 100)
}
</script>
