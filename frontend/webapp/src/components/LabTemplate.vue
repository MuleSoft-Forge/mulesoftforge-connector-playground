<template>
  <div>  <!-- Single root wrapper for Transition component compatibility -->
  <div class="min-h-screen py-6" style="background: #2d3e5f url('/webapp/assets/backgrounds/lab-pattern.png') repeat;">
    <div class="flex gap-6 max-w-screen-2xl mx-auto px-4">
      <!-- Main Content Area -->
      <div class="flex-1 min-w-0">
        <div class="max-w-6xl mx-auto">
    
    <!-- Header Container - Two Regions -->
    <div class="mb-4">
      <!-- Breadcrumbs -->
      <nav class="flex items-center text-xs text-gray-300 mb-3">
        <router-link to="/lab" class="hover:text-mulesoft-cyan transition-colors">Lab</router-link>
        <svg class="w-3 h-3 mx-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
        </svg>
        <span class="text-white font-medium">{{ headerTitle }}</span>
      </nav>

      <!-- Two Column Layout: 2/3 Title | 1/3 Flow -->
      <div class="grid grid-cols-3 gap-4">
        <!-- Left Region: Title (2/3) -->
        <div class="col-span-2 bg-white rounded-lg shadow-sm p-4 border border-gray-200">
          <div class="flex items-center gap-3">
            <slot name="icon"></slot>
            <div>
              <h2 class="text-2xl font-bold text-gray-900">{{ headerTitle }} Test Lab</h2>
              <p v-if="$slots.subtitle" class="mt-0.5 text-xs text-gray-600">
                <slot name="subtitle"></slot>
              </p>
            </div>
          </div>
        </div>
        
        <!-- Right Region: Flow Docs (1/3) -->
        <div 
          v-if="flowDiagramImg"
          @mouseenter="showFlowPreview = true"
          @mouseleave="showFlowPreview = false"
          class="relative bg-white rounded-lg shadow-sm border border-gray-200 overflow-visible"
        >
          <button
            @click="openFlowDocs"
            class="w-full h-full p-2 bg-gradient-to-br from-orange-50 via-red-50 to-pink-50 rounded-lg hover:shadow-lg transition-all group cursor-pointer flex flex-col items-center justify-center gap-1.5"
          >
            <!-- Flow Diagram Image - Always Visible (Compact) -->
            <div class="relative overflow-hidden rounded border-2 border-orange-300 bg-white shadow-sm w-full h-16 group-hover:border-orange-500 transition-all">
              <img 
                :src="`${baseUrl}/webapp/mulesoft-connector-playground-app/img/${flowDiagramImg}`"
                :alt="`${headerTitle} Flow Diagram`"
                class="w-full h-full object-contain p-1"
              />
              <!-- Overlay on hover -->
              <div class="absolute inset-0 bg-gradient-to-t from-orange-500/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
            </div>
            
            <!-- Label -->
            <div class="flex items-center justify-center gap-1">
              <svg class="w-3 h-3 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
              </svg>
              <span class="text-[11px] font-bold text-gray-900">View Flow Docs</span>
              <svg class="w-2.5 h-2.5 text-orange-600 group-hover:translate-x-0.5 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </div>
          </button>
          
          <!-- Hover Preview Popover - Larger View (stays visible when hovering over it) -->
          <Transition name="fade">
            <div 
              v-if="showFlowPreview"
              @mouseenter="showFlowPreview = true"
              @mouseleave="showFlowPreview = false"
              class="absolute top-full right-0 mt-2 z-50 bg-white rounded-xl shadow-2xl border-2 border-orange-400 p-4 w-96 max-h-[600px] overflow-y-auto"
            >
              <p class="text-sm font-semibold text-gray-900 mb-3 flex items-center gap-2">
                <svg class="w-4 h-4 text-orange-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                </svg>
                {{ headerTitle }} Mule Flow
              </p>
              <div class="bg-gray-50 rounded-lg border border-gray-200 p-2">
                <img 
                  :src="`${baseUrl}/webapp/mulesoft-connector-playground-app/img/${flowDiagramImg}`"
                  :alt="`${headerTitle} Flow Diagram`"
                  class="w-full rounded"
                />
              </div>
              <p class="text-xs text-gray-600 text-center mt-3 flex items-center justify-center gap-1">
                <svg class="w-3 h-3 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4-5 2zm0 0l5 5M7.188 2.239l.777 2.897M5.136 7.965l-2.898-.777M13.95 4.05l-2.122 2.122m-5.657 5.656l-2.12 2.122"/>
                </svg>
                Click card to view full technical documentation
              </p>
            </div>
          </Transition>
        </div>
      </div>
    </div>

    <!-- Loading / Error -->
    <div v-if="loading" class="flex items-center justify-center py-12">
      <LoadingSpinner text="Loading connector..." />
    </div>
    <div v-else-if="loadError" class="bg-red-50 border border-red-200 rounded-lg p-3 mb-4 text-sm text-red-800">
      {{ loadError }}
    </div>

    <!-- Content -->
    <div v-else class="space-y-4">
      <!-- Runtime Config First - Two Column Layout -->
      <div class="bg-white rounded-lg shadow-sm p-4">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
          
          <!-- Left: Selection -->
          <div>
            <label class="block text-xs font-semibold text-gray-900 mb-2 flex items-center">
              <svg class="w-4 h-4 text-purple-600 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
              </svg>
              Runtime Configuration <span class="text-red-600 ml-1">*</span>
              <span v-if="selectedOperation?.requiredConfigTypeId" class="ml-2 text-[10px] text-purple-700 bg-purple-50 px-2 py-0.5 rounded">
                {{ getRequiredConfigTypeName() }}
              </span>
            </label>
            <select
              :value="selectedRuntimeConfigId"
              @change="$emit('update:selectedRuntimeConfigId', ($event.target as HTMLSelectElement).value === '' ? '' : Number(($event.target as HTMLSelectElement).value))"
              :class="[
                'w-full px-3 py-2 border rounded-md text-sm transition-all',
                !selectedRuntimeConfigId ? 'border-purple-300 bg-purple-50' : 'border-green-300 bg-green-50'
              ]"
            >
              <option value="">Choose a configuration...</option>
              <optgroup v-for="ct in filteredConfigTypes" :key="ct.id" :label="ct.displayName">
                <template v-for="prov in ct.providers">
                  <option v-for="rc in getProviderConfigs(ct.id, prov.id)" :key="rc.id" :value="rc.id">
                    {{ prov.displayName }} → {{ rc.name }}
                  </option>
                </template>
              </optgroup>
            </select>
            <p v-if="!selectedRuntimeConfigId" class="text-[11px] text-gray-600 mt-1 flex items-center">
              <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clip-rule="evenodd"/>
              </svg>
              Select a config to enable operations
            </p>
          </div>

          <!-- Right: Details (Collapsible) -->
          <div v-if="selectedRuntimeConfigId" class="border-l border-gray-200 pl-4">
            <div class="flex items-center justify-between mb-2">
              <label class="block text-xs font-semibold text-gray-900 flex items-center">
                <svg class="w-3.5 h-3.5 text-blue-600 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Configuration Details
              </label>
              <button
                @click="configDetailsExpanded = !configDetailsExpanded"
                class="text-xs text-blue-600 hover:text-blue-700 font-medium flex items-center transition-colors"
              >
                {{ configDetailsExpanded ? 'Hide' : 'Show' }}
                <svg :class="['w-3.5 h-3.5 ml-0.5 transition-transform', configDetailsExpanded ? 'rotate-180' : '']" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                </svg>
              </button>
            </div>
            
            <!-- Collapsed View: Just show name -->
            <div v-if="!configDetailsExpanded" class="text-xs text-gray-700 bg-blue-50 rounded px-2 py-1.5 border border-blue-200">
              <span class="font-medium">{{ getSelectedProviderName() }}</span>
              <span v-if="getRequiredConfigTypeName()" class="text-gray-600 ml-1">• {{ getRequiredConfigTypeName() }}</span>
            </div>
            
            <!-- Expanded View: Full details -->
            <div v-else class="transition-all">
              <RuntimeConfigSummary 
                :runtime-config-id="selectedRuntimeConfigId"
                :config-type-name="getRequiredConfigTypeName()"
                :provider-name="getSelectedProviderName()"
              />
            </div>
          </div>

          <!-- Placeholder for right column when no config selected -->
          <div v-else class="border-l border-gray-200 pl-4 flex items-center justify-center">
            <p class="text-xs text-gray-400 italic text-center">
              Details will appear here once<br/>a configuration is selected
            </p>
          </div>

        </div>
      </div>

      <!-- Categories + Operations (with optional side content) -->
      <div class="bg-white rounded-lg shadow-sm p-3">
        <div v-if="categories.length" class="flex flex-wrap gap-1 mb-3">
          <button
            v-for="category in categories"
            :key="category"
            @click="$emit('update:activeCategory', category)"
            :class="[
              'px-3 py-1.5 rounded-md text-xs font-medium transition-colors',
              activeCategory === category ? 'bg-blue-600 text-white' : 'bg-blue-100 text-blue-700 hover:bg-blue-200'
            ]"
          >
            {{ category }} <span class="ml-1 opacity-75">({{ getCategoryOperationCount(category) }})</span>
          </button>
        </div>
        
        <!-- Two Column Layout: Operations + Side Content -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
          <!-- Left: Operations -->
          <div v-if="$slots['operations-list']">
            <!-- Custom operations list slot -->
            <slot name="operations-list" 
              :operations="filteredOperations"
              :selected-operation="selectedOperation"
              :selected-runtime-config-id="selectedRuntimeConfigId"
              :select-operation="(op: any) => $emit('selectOperation', op)"
            ></slot>
          </div>
          <div v-else :class="operationsGridClass || 'grid grid-cols-1 gap-2'">
            <!-- Default operations list -->
            <button
              v-for="operation in filteredOperations"
              :key="operation.id"
              @click="$emit('selectOperation', operation)"
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
          
          <!-- Right: Custom Side Content Slot -->
          <div v-if="$slots['operations-side']">
            <slot name="operations-side"></slot>
          </div>
        </div>
      </div>

      <!-- Operation Details + Params + Execute -->
      <div v-if="selectedOperation" class="bg-white rounded-lg shadow-sm p-4">
        <div class="flex items-start justify-between mb-3">
          <div class="flex-1 pr-2">
            <h3 class="text-base font-semibold text-gray-900">{{ selectedOperation.displayName }}</h3>
            <details class="text-xs text-gray-600 mt-1">
              <summary class="cursor-pointer text-blue-600 hover:text-blue-700 font-medium">Show description</summary>
              <div class="mt-1 markdown-content" v-html="parseMarkdown(selectedOperation.description)"></div>
            </details>
          </div>
          <DocLink :url="selectedOperation.helpUrl" variant="button" size="sm" />
        </div>

        <div class="space-y-3 mb-4">
          <!-- Two-column layout: Parameters + Optional Side Panel -->
          <div :class="$slots['operation-side-panel'] ? 'grid grid-cols-1 lg:grid-cols-2 gap-4' : ''">
            <!-- Left: Input Parameters -->
            <div>
              <h4 class="text-sm font-semibold text-gray-900">Input Parameters</h4>
              
              <!-- Additional Controls Slot -->
              <slot name="additional-controls"></slot>
              
              <!-- Regular Parameters -->
              <div v-if="regularParameters.length" :class="$slots['operation-side-panel'] ? 'grid grid-cols-1 gap-3 mt-3' : 'grid grid-cols-1 md:grid-cols-2 gap-3 mt-3'">
                  <div v-for="param in regularParameters" :key="param.apiName" class="border border-gray-200 rounded-md p-3">
                    <label class="block text-xs font-medium text-gray-700 mb-1">
                      {{ param.displayName }}<span v-if="param.isRequired" class="text-red-500">*</span>
                    </label>
                    <slot name="param-input" :param="param"></slot>
                    <p class="text-[10px] text-gray-400 font-mono mt-1">Type: {{ param.dataType }}</p>
                    <div v-if="param.description" class="mt-2 text-[11px] text-gray-600 markdown-content" v-html="parseMarkdown(param.description)"></div>
                  </div>
              </div>
              
              <!-- Advanced/Additional Parameters (Collapseable) -->
              <div v-if="advancedParameters.length" class="mt-3">
                <button
                  @click="showAdvancedParams = !showAdvancedParams"
                  class="flex items-center gap-2 text-xs font-medium text-blue-600 hover:text-blue-700 transition-colors"
                >
                  <svg :class="['w-3.5 h-3.5 transition-transform', showAdvancedParams ? 'rotate-90' : '']" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                  </svg>
                  {{ showAdvancedParams ? 'Hide' : 'Show' }} Additional Properties ({{ advancedParameters.length }})
                </button>
                
                <div v-if="showAdvancedParams" :class="$slots['operation-side-panel'] ? 'grid grid-cols-1 gap-3 mt-3' : 'grid grid-cols-1 md:grid-cols-2 gap-3 mt-3'">
                  <div v-for="param in advancedParameters" :key="param.apiName" class="border border-gray-200 rounded-md p-3 bg-gray-50">
                    <label class="block text-xs font-medium text-gray-700 mb-1">
                      {{ param.displayName }}<span v-if="param.isRequired" class="text-red-500">*</span>
                    </label>
                    <slot name="param-input" :param="param"></slot>
                    <p class="text-[10px] text-gray-400 font-mono mt-1">Type: {{ param.dataType }}</p>
                    <div v-if="param.description" class="mt-2 text-[11px] text-gray-600 markdown-content" v-html="parseMarkdown(param.description)"></div>
                  </div>
                </div>
              </div>
              
              <!-- No parameters at all -->
              <div v-if="!regularParameters.length && !advancedParameters.length" class="text-xs text-gray-500 italic p-3 bg-gray-50 rounded-md">
                No input parameters required.
              </div>
            </div>

            <!-- Right: Operation Side Panel Slot -->
            <div v-if="$slots['operation-side-panel']">
              <slot name="operation-side-panel"></slot>
            </div>
          </div>
        </div>

        <div class="pt-3 border-t border-gray-200">
          <!-- Execution Settings -->
          <details class="mb-3 group">
            <summary class="cursor-pointer text-xs font-medium text-gray-600 hover:text-gray-900 flex items-center gap-1 py-1 select-none">
              <svg class="w-3 h-3 transition-transform group-open:rotate-90" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
              Execution Settings
            </summary>
            <div class="mt-2 p-2 bg-gray-50 rounded-md space-y-2">
              <label class="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  :checked="enableLogging"
                  @change="$emit('update:enableLogging', ($event.target as HTMLInputElement).checked)"
                  class="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded"
                />
                <span class="text-xs text-gray-700">
                  <span class="font-medium">Enable Logging</span>
                  <span class="text-gray-500 text-[10px] ml-1">(tracks execution history)</span>
                </span>
              </label>
              <label class="flex items-center gap-2 cursor-pointer">
                <input
                  type="checkbox"
                  :checked="enableValidation"
                  @change="$emit('update:enableValidation', ($event.target as HTMLInputElement).checked)"
                  class="w-3.5 h-3.5 text-blue-600 border-gray-300 rounded"
                />
                <span class="text-xs text-gray-700">
                  <span class="font-medium">Enable Validation</span>
                  <span class="text-gray-500 text-[10px] ml-1">(validates parameters)</span>
                </span>
              </label>
              <p class="text-[10px] text-gray-500 pt-1 border-t border-gray-200">
                💡 Disable for faster execution during testing
              </p>
            </div>
          </details>

          <button
            @click="$emit('execute')"
            :disabled="executing || !canExecute"
            :class="[
              'w-full px-5 py-2.5 rounded-md text-sm font-medium flex items-center justify-between',
              executing || !canExecute ? 'bg-gray-300 text-gray-500 cursor-not-allowed' : 'bg-blue-600 text-white hover:bg-blue-700'
            ]"
          >
            <div class="flex items-center gap-2 flex-1 justify-center">
              <svg v-if="executing" class="animate-spin h-4 w-4 text-white" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <span>{{ executing ? 'Executing...' : 'Execute Operation' }}</span>
            </div>
            <span v-if="!executing && canExecute" class="text-[10px] opacity-75 font-mono">
              {{ isMac ? '⌘' : 'Ctrl' }}+↵
            </span>
          </button>
          <p v-if="validationMessage" class="text-[11px] text-amber-600 mt-2">{{ validationMessage }}</p>
        </div>
      </div>

      <!-- Response Area with Slot Support -->
      <div v-if="executing || lastResponse || executionError" data-response-panel class="bg-white rounded-lg p-4 border border-gray-200 shadow-sm">
        <slot 
          name="response-display" 
          :last-response="lastResponse" 
          :execution-error="executionError"
          :executing="executing"
          :clear-response="() => $emit('clear')"
        >
          <!-- Executing State - Beautiful Blue Spinner -->
          <div v-if="executing" class="bg-gradient-to-br from-blue-50 via-blue-100 to-indigo-50 border border-blue-200 rounded-lg p-20 flex items-center justify-center min-h-[400px]">
            <LoadingSpinner text="Executing operation..." />
          </div>

          <!-- Default Response Display (fallback) -->
          <div v-else-if="executionError" class="bg-red-50 border border-red-200 rounded-md p-3 text-sm text-red-800 mb-3">
            {{ executionError.title || 'Execution Failed' }}
            <div v-if="executionError.detail" class="text-[11px]">{{ executionError.detail }}</div>
          </div>
          <div v-else-if="lastResponse">
            <div class="flex items-center justify-between mb-3">
              <h4 class="text-sm font-semibold text-green-700 flex items-center">
                <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                Execution Successful
              </h4>
              <button @click="$emit('clear')" class="text-xs text-gray-600 hover:text-gray-900 transition-colors">Clear</button>
            </div>
            
            <!-- Chat Response Display -->
            <div v-if="responseChatMessage" class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center">
                <svg class="w-4 h-4 mr-1 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
                </svg>
                Chat Response
              </h5>
              <div class="bg-gradient-to-r from-purple-50 to-blue-50 border border-purple-200 rounded-lg p-4">
                <p class="text-sm text-gray-800 leading-relaxed whitespace-pre-wrap">{{ responseChatMessage }}</p>
              </div>
            </div>

            <!-- Image Response Display -->
            <div v-if="responseContainsImage" class="mb-3">
              <h5 class="text-xs font-semibold text-gray-700 mb-2 flex items-center">
                <svg class="w-4 h-4 mr-1 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                Generated Image
              </h5>
              <div class="bg-gray-900 rounded-lg p-4 flex items-center justify-center" style="min-height: 200px">
                <img 
                  :src="responseContainsImage" 
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
        </slot>
      </div>
    </div> <!-- End v-else space-y-4 -->
    </div> <!-- End max-w-6xl -->
    </div> <!-- End Main Content Area -->

  <!-- Collapsible Right Sidebar (Execution History) -->
  <div 
    v-if="selectedOperation?.id"
    :class="[
      'flex-shrink-0 mt-8 sticky top-8 self-start transition-all duration-300',
      sidebarCollapsed ? 'w-12' : 'w-96'
    ]"
  >
    <div class="bg-white rounded-lg shadow-sm border border-blue-200 overflow-hidden h-full">
      <!-- Collapsed State: Vertical Icon Button -->
      <div v-if="sidebarCollapsed" class="h-full flex flex-col items-center py-4">
        <button 
          @click="sidebarCollapsed = false"
          class="p-2 hover:bg-blue-50 rounded-lg transition-colors group"
          title="Expand Execution History"
        >
          <svg class="w-5 h-5 text-blue-600 transform rotate-90" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
        </button>
        <div class="mt-2 text-xs font-medium text-blue-600 writing-mode-vertical transform rotate-180 select-none">
          History
        </div>
      </div>

      <!-- Expanded State: Full Sidebar -->
      <div v-else>
        <!-- Header with Collapse Button -->
        <div class="bg-gradient-to-br from-blue-50 via-blue-100 to-indigo-50 border-b border-blue-200 p-4">
          <div class="flex items-center justify-between">
            <div class="flex items-center flex-1 min-w-0">
              <svg class="w-4 h-4 mr-2 text-blue-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <div class="min-w-0 flex-1">
                <h2 class="text-sm font-semibold text-gray-800">Execution History</h2>
                <p class="text-xs text-gray-600 mt-0.5 truncate">
                  {{ selectedOperation?.name }}
                </p>
              </div>
            </div>
            <button 
              @click="sidebarCollapsed = true"
              class="ml-2 p-1 hover:bg-blue-200/50 rounded transition-colors flex-shrink-0"
              title="Collapse Sidebar"
            >
              <svg class="w-4 h-4 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
              </svg>
            </button>
          </div>
        </div>
        
        <!-- Content -->
        <div class="p-3 max-h-[calc(100vh-8rem)] overflow-y-auto">
          <p v-if="!enableLogging" class="text-xs text-amber-600 bg-amber-50 border border-amber-200 rounded p-2 mb-3">
            ⚠️ Logging is disabled. Enable it in settings to track executions.
          </p>
          
          <ExecutionHistory
            v-if="enableLogging"
            :operation-id="selectedOperation.id"
            :latest-execution-id="latestExecutionId"
            @load-to-response="handleLoadToResponse"
          />
        </div>
      </div>
    </div>
  </div>

  </div> <!-- End flex container -->
  </div> <!-- End background wrapper -->

  <!-- Flow Documentation Modal -->
  <Teleport to="body">
    <Transition name="modal">
      <div
        v-if="showDocsModal && flowDocUrl"
        class="fixed inset-0 z-[9999] flex items-center justify-center bg-black bg-opacity-50 p-4"
        @mousedown.self="handleDocsBackdropMouseDown"
        @mouseup.self="handleDocsBackdropMouseUp"
        style="touch-action: none;"
      >
        <div class="relative bg-white rounded-xl shadow-2xl w-full h-full max-w-7xl max-h-[90vh] flex flex-col">
          <!-- Modal Header -->
          <div class="flex items-center justify-between p-4 border-b border-gray-200">
            <h3 class="text-xl font-bold text-gray-900">{{ headerTitle }} - Technical Documentation</h3>
            <button
              @click="closeDocsModal"
              class="p-2 hover:bg-gray-100 rounded-lg transition-colors"
              aria-label="Close"
            >
              <svg class="w-6 h-6 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>
          
          <!-- Modal Body with iframe -->
          <div class="flex-1 overflow-hidden">
            <iframe
              :src="`${baseUrl}/webapp/mulesoft-connector-playground-app/${flowDocUrl}`"
              class="w-full h-full border-0"
              title="Technical Documentation"
            />
          </div>
          
          <!-- Modal Footer -->
          <div class="p-4 border-t border-gray-200 bg-gray-50 flex justify-end">
            <button
              @click="closeDocsModal"
              class="px-6 py-2 bg-gray-600 text-white rounded-lg hover:bg-gray-700 transition-colors font-medium"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
  </div> <!-- End single root wrapper -->
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import LoadingSpinner from '../components/LoadingSpinner.vue'
import DocLink from '../components/DocLink.vue'
import RuntimeConfigSummary from '../components/RuntimeConfigSummary.vue'
import ExecutionHistory from '../components/ExecutionHistory.vue'
import { useMarkdown } from '../composables/useMarkdown'

const { parseMarkdown } = useMarkdown()

// Collapsible states
const configDetailsExpanded = ref(false)
const showAdvancedParams = ref(false)

// Flow docs state
const showFlowPreview = ref(false)
const showDocsModal = ref(false)
const docsBackdropMouseDownPos = ref<{ x: number, y: number } | null>(null)

// Execution history state
const latestExecutionId = ref<string | null>(null)

// Load sidebar state from localStorage (defaults to collapsed)
const savedState = typeof window !== 'undefined' ? localStorage.getItem('mce-execution-history-collapsed') : null
const sidebarCollapsed = ref(savedState === null ? true : savedState === 'true')

// Save sidebar state to localStorage when it changes
watch(sidebarCollapsed, (newValue) => {
  if (typeof window !== 'undefined') {
    localStorage.setItem('mce-execution-history-collapsed', String(newValue))
  }
})

// Base URL for docs
import { API_BASE as baseUrl } from '../config/api'

// Detect Mac for keyboard shortcut display
const isMac = computed(() => {
  return typeof window !== 'undefined' && navigator.platform.toUpperCase().indexOf('MAC') >= 0
})

const props = defineProps<{
  headerTitle: string
  loading: boolean
  loadError: string | null
  categories: string[]
  activeCategory: string
  filteredOperations: any[]
  selectedOperation: any | null
  selectedRuntimeConfigId: number | ''
  filteredConfigTypes: any[]
  executing: boolean
  canExecute: boolean
  validationMessage: string
  lastResponse: any
  executionError: any
  responseChatMessage: string | null
  responseContainsImage: string | null
  operationsGridClass?: string
  flowDiagramImg?: string  // e.g., "mcp.png"
  flowDocUrl?: string       // e.g., "mcp.html"
  enableLogging: boolean
  enableValidation: boolean
  getCategoryOperationCount: (c: string) => number
  getProviderConfigs: (ctId: number, provId: number) => any[]
  getRequiredConfigTypeName: () => string
  getSelectedProviderName: () => string
}>()

// Open flow documentation modal
function openFlowDocs() {
  showDocsModal.value = true
}

function handleDocsBackdropMouseDown(e: MouseEvent) {
  docsBackdropMouseDownPos.value = { x: e.clientX, y: e.clientY }
}

function handleDocsBackdropMouseUp(e: MouseEvent) {
  if (!docsBackdropMouseDownPos.value) return
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - docsBackdropMouseDownPos.value.x)
  const deltaY = Math.abs(e.clientY - docsBackdropMouseDownPos.value.y)
  
  if (deltaX < 10 && deltaY < 10) {
    closeDocsModal()
  }
  
  docsBackdropMouseDownPos.value = null
}

function closeDocsModal() {
  showDocsModal.value = false
}

// Separate regular vs advanced parameters
// Advanced parameters are optional params with certain keywords or metadata types
const regularParameters = computed(() => {
  if (!props.selectedOperation?.parameters) return []
  return props.selectedOperation.parameters.filter((param: any) => {
    // If required, it's always regular
    if (param.isRequired) return true
    
    // Check if parameter name suggests it's advanced/additional
    const name = param.apiName?.toLowerCase() || ''
    const displayName = param.displayName?.toLowerCase() || ''
    const isAdvancedName = 
      name.includes('additional') ||
      name.includes('advanced') ||
      name.includes('extra') ||
      name.includes('metadata') ||
      name.includes('properties') ||
      displayName.includes('additional') ||
      displayName.includes('advanced')
    
    return !isAdvancedName
  })
})

const advancedParameters = computed(() => {
  if (!props.selectedOperation?.parameters) return []
  
  // Get regular parameter API names to exclude
  const regularParamNames = new Set(regularParameters.value.map((p: any) => p.apiName))
  
  const advanced = props.selectedOperation.parameters.filter((param: any) => {
    // Skip if already in regular parameters
    if (regularParamNames.has(param.apiName)) return false
    
    // Required params are never advanced
    if (param.isRequired) return false
    
    // Check if parameter name suggests it's advanced/additional
    const name = param.apiName?.toLowerCase() || ''
    const displayName = param.displayName?.toLowerCase() || ''
    return (
      name.includes('additional') ||
      name.includes('advanced') ||
      name.includes('extra') ||
      name.includes('metadata') ||
      name.includes('properties') ||
      displayName.includes('additional') ||
      displayName.includes('advanced')
    )
  })
  return advanced
})

const emit = defineEmits<{
  (e: 'update:activeCategory', value: string): void
  (e: 'update:selectedRuntimeConfigId', value: number | ''): void
  (e: 'update:lastResponse', value: any): void
  (e: 'update:executionError', value: any): void
  (e: 'selectOperation', op: any): void
  (e: 'execute'): void
  (e: 'clear'): void
}>()

// Watch for execution completion to track latest execution ID
watch(() => props.lastResponse, (newResponse) => {
  if (newResponse?.executionId) {
    latestExecutionId.value = newResponse.executionId
  }
})

// Handle loading execution from history to response panel
function handleLoadToResponse(execution: any) {
  // Debug: log the execution data
  console.log('[LabTemplate] Loading execution from history:', execution)
  console.log('[LabTemplate] Response payload:', execution.responsePayload)
  
  // Load execution response into the main response panel
  // responsePayload already has the correct structure: { result: {...}, status, timestamp, executionId }
  // We just need to extract the result and use the execution's status/id
  const responseData = {
    executionId: execution.executionId,
    status: execution.status,
    result: execution.responsePayload?.result || { payload: {}, attributes: {} }
  }
  
  console.log('[LabTemplate] Constructed responseData:', responseData)
  emit('update:lastResponse', responseData)
  
  if (execution.status === 'error') {
    emit('update:executionError', {
      type: execution.errorType,
      title: execution.errorType,
      detail: execution.errorMessage,
      code: execution.errorCode
    })
  } else {
    emit('update:executionError', null)
  }
  
  // Scroll to response panel
  setTimeout(() => {
    const responsePanel = document.querySelector('[data-response-panel]')
    if (responsePanel) {
      responsePanel.scrollIntoView({ behavior: 'smooth', block: 'nearest' })
    }
  }, 100)
}

// Keyboard shortcuts: Ctrl+Enter or Cmd+Enter to execute
function handleKeydown(event: KeyboardEvent) {
  // Check for Ctrl+Enter (Windows/Linux) or Cmd+Enter (Mac)
  const isExecuteShortcut = (event.ctrlKey || event.metaKey) && event.key === 'Enter'
  
  if (isExecuteShortcut && props.canExecute && !props.executing) {
    event.preventDefault()
    emit('execute')
  }
}

// Set up keyboard listener on mount
onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

// Clean up keyboard listener on unmount
onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped>
/* Vertical text for collapsed sidebar */
.writing-mode-vertical {
  writing-mode: vertical-rl;
  text-orientation: mixed;
}

/* Modal animations */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .relative,
.modal-leave-active .relative {
  transition: transform 0.3s ease;
}

.modal-enter-from .relative,
.modal-leave-to .relative {
  transform: scale(0.95);
}

/* Fade animation for popover */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

/* Drawer animations - slide from right */
.drawer-enter-active,
.drawer-leave-active {
  transition: opacity 0.3s ease;
}

.drawer-enter-from,
.drawer-leave-to {
  opacity: 0;
}

.drawer-enter-active .relative,
.drawer-leave-active .relative {
  transition: transform 0.3s ease;
}

.drawer-enter-from .relative {
  transform: translateX(100%);
}

.drawer-leave-to .relative {
  transform: translateX(100%);
}

.markdown-content :deep(p) {
  margin-bottom: 0;
}

.markdown-content :deep(strong) {
  font-weight: 600;
  color: inherit;
}

.markdown-content :deep(em) {
  font-style: italic;
}

.markdown-content :deep(a) {
  color: #00A0DF;
  text-decoration: underline;
}

.markdown-content :deep(a:hover) {
  color: #0074A6;
}

.markdown-content :deep(code) {
  background: rgba(0, 0, 0, 0.05);
  padding: 0.125rem 0.25rem;
  border-radius: 0.25rem;
  font-size: 0.875em;
}
</style>


