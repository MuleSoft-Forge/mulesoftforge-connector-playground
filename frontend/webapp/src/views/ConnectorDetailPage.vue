<template>
  <div class="max-w-7xl mx-auto px-6 py-8">
    <!-- Breadcrumbs -->
    <nav class="flex items-center text-sm text-mulesoft-gray mb-6">
      <router-link to="/browse" class="hover:text-mulesoft-cyan transition-colors">Browse</router-link>
      <svg class="w-4 h-4 mx-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
      </svg>
      <span class="text-mulesoft-dark font-medium">{{ connectorName }}</span>
    </nav>

    <!-- Loading State -->
    <LoadingSpinner v-if="loading" text="Loading connector details..." />

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-6">
      <h2 class="text-red-800 font-semibold mb-2">Error Loading Connector</h2>
      <p class="text-red-600">{{ error }}</p>
      <router-link to="/browse" class="inline-block mt-4 text-mulesoft-cyan hover:underline">
        ← Back to Browse
      </router-link>
    </div>

    <!-- Connector Content -->
    <div v-else-if="connector">
      <!-- Header -->
      <div class="bg-white rounded-xl p-8 shadow-sm border border-gray-100 mb-6">
        <div class="flex items-start gap-6">
          <ConnectorIcon 
            :icon-url="getIconSrc(connector.icon)" 
            class="w-20 h-20"
          />
          <div class="flex-1">
            <h1 class="text-3xl font-bold text-mulesoft-dark mb-2">{{ connector.name }}</h1>
            <div class="text-mulesoft-gray mb-4 markdown-content" v-html="parseMarkdown(connector.description)"></div>
            <div class="flex flex-wrap gap-3">
              <span class="px-3 py-1 bg-blue-50 text-mulesoft-cyan text-sm font-medium rounded-full">
                v{{ connector.version }}
              </span>
              <span class="px-3 py-1 bg-gray-100 text-mulesoft-gray text-sm font-medium rounded-full">
                {{ connector.category }}
              </span>
              <span 
                class="px-3 py-1 text-sm font-medium rounded-full flex items-center gap-1"
                :class="connector.isActive ? 'bg-green-50 text-green-700' : 'bg-gray-100 text-gray-600'"
              >
                <span :class="connector.isActive ? 'w-2 h-2 bg-green-500 rounded-full' : 'w-2 h-2 bg-gray-400 rounded-full'"></span>
                {{ connector.isActive ? 'Active' : 'Inactive' }}
              </span>
            </div>
          </div>
          <div class="flex gap-2">
            <button
              v-if="isMCPConnector"
              @click="openMCPProtocolDocs"
              class="inline-flex items-center gap-1 px-3 py-2 text-xs font-semibold bg-purple-100 text-purple-700 rounded-md hover:bg-purple-200 transition-colors"
            >
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
              </svg>
              Protocol Docs
            </button>
            <button
              v-if="isA2AConnector"
              @click="openA2AProtocolDocs"
              class="inline-flex items-center gap-1 px-3 py-2 text-xs font-semibold bg-blue-100 text-blue-700 rounded-md hover:bg-blue-200 transition-colors"
            >
              <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
              </svg>
              Protocol Docs
            </button>
            <DocLink :url="connector.docUrl" variant="button" size="md" />
          </div>
        </div>
      </div>

      <!-- Tabs -->
      <div class="bg-white rounded-t-xl border-b border-gray-200 mb-0 sticky top-20 z-40">
        <div class="flex gap-1 px-6">
          <button
            @click="activeTab = 'overview'"
            :class="activeTab === 'overview' 
              ? 'border-b-2 border-mulesoft-cyan text-mulesoft-cyan font-semibold' 
              : 'text-gray-600 hover:text-mulesoft-cyan'"
            class="px-4 py-4 transition-colors"
          >
            Overview
          </button>
          <button
            @click="activeTab = 'operations'"
            :class="activeTab === 'operations' 
              ? 'border-b-2 border-mulesoft-cyan text-mulesoft-cyan font-semibold' 
              : 'text-gray-600 hover:text-mulesoft-cyan'"
            class="px-4 py-4 transition-colors"
          >
            Operations
            <span class="ml-2 px-2 py-0.5 bg-gray-100 text-xs rounded-full">{{ operations.length }}</span>
          </button>
          <button
            @click="loadConfigurationTab"
            :class="activeTab === 'configuration' 
              ? 'border-b-2 border-mulesoft-cyan text-mulesoft-cyan font-semibold' 
              : 'text-gray-600 hover:text-mulesoft-cyan'"
            class="px-4 py-4 transition-colors"
          >
            Configuration
            <span v-if="configTypes.length > 0" class="ml-2 px-2 py-0.5 bg-gray-100 text-xs rounded-full">{{ configTypes.length }}</span>
          </button>
        </div>
      </div>

      <!-- Tab Content -->
      <div class="bg-white rounded-b-xl p-8 shadow-sm border border-t-0 border-gray-100">
        <!-- Overview Tab -->
        <div v-if="activeTab === 'overview'">
          <h2 class="text-2xl font-bold text-mulesoft-dark mb-6">About this Connector</h2>
          
          <!-- Quick Stats -->
          <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mb-8">
            <div class="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-xl p-5 border border-blue-100">
              <div class="text-3xl font-bold text-mulesoft-cyan mb-1">{{ operations.length }}</div>
              <div class="text-sm text-mulesoft-gray">Operations</div>
            </div>
            <div class="bg-gradient-to-br from-green-50 to-emerald-50 rounded-xl p-5 border border-green-100">
              <div class="text-2xl font-bold text-green-600 mb-1">v{{ connector.version }}</div>
              <div class="text-sm text-mulesoft-gray">Version</div>
            </div>
            <div class="bg-gradient-to-br from-orange-50 to-yellow-50 rounded-xl p-5 border border-orange-100">
              <div class="flex items-center gap-2 mb-1">
                <span :class="connector.isActive ? 'w-3 h-3 bg-green-500 rounded-full' : 'w-3 h-3 bg-gray-400 rounded-full'"></span>
                <span class="text-lg font-bold" :class="connector.isActive ? 'text-green-600' : 'text-gray-500'">
                  {{ connector.isActive ? 'Active' : 'Inactive' }}
                </span>
              </div>
              <div class="text-sm text-mulesoft-gray">Status</div>
            </div>
          </div>
          
          <!-- Connector Details -->
          <div class="bg-white border border-gray-200 rounded-lg p-6 mb-6">
            <h3 class="text-lg font-semibold text-mulesoft-dark mb-4">Connector Details</h3>
            <dl class="space-y-3">
              <div class="flex items-start">
                <dt class="w-40 text-sm font-medium text-mulesoft-gray">Maven Artifact:</dt>
                <dd class="flex-1">
                  <code class="text-sm bg-gray-100 px-3 py-1 rounded border border-gray-200">
                    {{ connector.mavenArtifactId }}
                  </code>
                </dd>
              </div>
              <div class="flex items-start">
                <dt class="w-40 text-sm font-medium text-mulesoft-gray">Category:</dt>
                <dd class="flex-1 text-sm text-mulesoft-dark">{{ connector.category }}</dd>
              </div>
              <div class="flex items-start">
                <dt class="w-40 text-sm font-medium text-mulesoft-gray">Description:</dt>
                <dd class="flex-1 text-sm text-mulesoft-dark leading-relaxed markdown-content" v-html="parseMarkdown(connector.description) || 'No description available'"></dd>
              </div>
            </dl>
          </div>
          
          <!-- Quick Actions -->
          <div class="flex flex-wrap gap-3">
            <a 
              v-if="connector.docUrl" 
              :href="connector.docUrl" 
              target="_blank"
              class="inline-flex items-center px-6 py-3 bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark transition-colors shadow-md"
            >
              📄 View Documentation
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
              </svg>
            </a>
            <button 
              @click="activeTab = 'operations'"
              class="inline-flex items-center px-6 py-3 bg-white text-mulesoft-cyan border-2 border-mulesoft-cyan font-semibold rounded-lg hover:bg-mulesoft-cyan hover:text-white transition-colors shadow-md"
            >
              View {{ operations.length }} Operations
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
              </svg>
            </button>
          </div>
        </div>

        <!-- Operations Tab -->
        <div v-else-if="activeTab === 'operations'">
          <h2 class="text-2xl font-bold text-mulesoft-dark mb-6">All Operations</h2>

          <!-- Empty State -->
          <div v-if="operations.length === 0" class="text-center py-12">
            <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
            </svg>
            <p class="text-mulesoft-gray">No operations configured for this connector</p>
          </div>

          <!-- Operations List -->
          <div v-else class="space-y-4">
            <div 
              v-for="op in operations" 
              :key="op.id"
              class="border border-gray-200 rounded-lg p-5 hover:border-mulesoft-cyan hover:shadow-md transition-all group"
            >
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <div class="flex items-center gap-3 mb-2">
                  <h3 class="text-lg font-semibold text-mulesoft-dark group-hover:text-mulesoft-cyan transition-colors">
                    {{ op.displayName }}
                  </h3>
                  <span class="px-2 py-0.5 bg-gray-100 text-gray-600 text-xs font-medium rounded">
                    {{ op.category }}
                  </span>
                  <span 
                    v-if="!op.isActive"
                    class="px-2 py-0.5 bg-yellow-50 text-yellow-700 text-xs font-medium rounded"
                  >
                    Inactive
                  </span>
                </div>
                <div v-if="op.description" class="text-mulesoft-gray text-sm mb-3 markdown-content" v-html="parseMarkdown(op.description)"></div>
                <div class="flex items-center gap-4 text-sm text-mulesoft-gray">
                  <span>⚡ {{ op.parameters?.length || 0 }} parameters</span>
                  <code class="text-xs bg-gray-100 px-2 py-1 rounded">{{ op.operationKey }}</code>
                </div>
              </div>
              <div class="flex gap-2">
                <DocLink :url="op.helpUrl" variant="button" size="md" />
                <router-link 
                  v-if="op.isActive"
                  :to="`/lab/${connector.id}?operation=${op.id}`"
                  class="inline-flex items-center px-4 py-2 bg-white text-mulesoft-cyan border-2 border-mulesoft-cyan font-semibold rounded-lg hover:bg-mulesoft-cyan hover:text-white transition-colors shadow-md opacity-0 group-hover:opacity-100"
                >
                  Test in Lab →
                </router-link>
              </div>
            </div>

            <!-- Parameters (expandable) -->
            <div v-if="op.parameters && op.parameters.length > 0" class="mt-4 pt-4 border-t border-gray-100">
              <details class="text-sm">
                <summary class="cursor-pointer text-mulesoft-gray hover:text-mulesoft-cyan font-medium">
                  View Parameters ({{ op.parameters.length }})
                </summary>
                <div class="mt-3 space-y-2">
                  <div v-for="param in op.parameters" :key="param.id" class="flex items-start gap-3 text-xs">
                    <code class="bg-gray-100 px-2 py-1 rounded font-mono">{{ param.apiName }}</code>
                    <span class="text-mulesoft-gray">{{ param.dataType }}</span>
                    <span v-if="param.isRequired" class="text-red-600 font-medium">required</span>
                    <span class="text-mulesoft-gray flex-1 markdown-content" v-html="parseMarkdown(param.description)"></span>
                  </div>
                </div>
              </details>
            </div>
            </div>
          </div>
        </div>

        <!-- Configuration Tab -->
        <div v-if="activeTab === 'configuration'">
          <h2 class="text-2xl font-bold text-mulesoft-dark mb-6">Configuration Types & Runtime Configs</h2>
          
          <!-- Loading State -->
          <LoadingSpinner v-if="configLoading" text="Loading configurations..." />
          
          <!-- Empty State -->
          <div v-else-if="configTypes.length === 0" class="text-center py-12 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
            <svg class="w-16 h-16 mx-auto text-gray-400 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>
            <h3 class="text-lg font-semibold text-gray-700 mb-2">No Configuration Types</h3>
            <p class="text-gray-500">This connector doesn't require any configuration types</p>
          </div>

          <!-- Config Types List -->
          <div v-else class="space-y-6">
            <div 
              v-for="configType in configTypes" 
              :key="configType.id"
              class="border border-gray-200 rounded-lg overflow-hidden"
            >
              <!-- Config Type Header -->
              <div class="bg-gradient-to-r from-purple-50 to-blue-50 p-5 border-b border-gray-200">
                <div class="flex items-start justify-between">
                  <div>
                    <h3 class="text-lg font-bold text-mulesoft-dark mb-1">{{ configType.displayName }}</h3>
                    <code class="text-xs bg-white px-2 py-1 rounded text-gray-600">{{ configType.configTypeKey }}</code>
                    <p v-if="configType.description" class="text-sm text-mulesoft-gray mt-2">{{ configType.description }}</p>
                  </div>
                  <span class="px-3 py-1 bg-white text-purple-700 text-sm font-semibold rounded-full shadow-sm">
                    {{ getRuntimeConfigCount(configType.id) }} configs
                  </span>
                </div>
              </div>

              <!-- Runtime Configs -->
              <div class="p-5 bg-white">
                <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center gap-2">
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"></path>
                  </svg>
                  Runtime Configurations
                </h4>

                <!-- Runtime Config Cards -->
                <div v-if="getRuntimeConfigs(configType.id).length > 0" class="grid grid-cols-1 md:grid-cols-2 gap-3">
                  <div 
                    v-for="config in getRuntimeConfigs(configType.id)" 
                    :key="config.id"
                    class="border border-gray-200 rounded-lg p-4 hover:border-mulesoft-cyan transition-colors"
                  >
                    <div class="flex items-start justify-between mb-2">
                      <h5 class="font-semibold text-mulesoft-dark">{{ config.name }}</h5>
                      <span 
                        :class="config.isActive 
                          ? 'bg-green-50 text-green-700' 
                          : 'bg-gray-100 text-gray-600'"
                        class="px-2 py-0.5 text-xs font-medium rounded-full flex items-center gap-1"
                      >
                        <span :class="config.isActive ? 'w-1.5 h-1.5 bg-green-500 rounded-full' : 'w-1.5 h-1.5 bg-gray-400 rounded-full'"></span>
                        {{ config.isActive ? 'Active' : 'Inactive' }}
                      </span>
                    </div>
                    <p v-if="config.description" class="text-xs text-gray-600">{{ config.description }}</p>
                    <p v-else class="text-xs text-gray-400 italic">No description</p>
                  </div>
                </div>

                <!-- Empty State -->
                <div v-else class="text-center py-6 bg-gray-50 rounded-lg border border-dashed border-gray-300">
                  <p class="text-sm text-gray-500">No runtime configurations set up yet</p>
                  <p class="text-xs text-gray-400 mt-1">Configure in Admin → Runtime Configs</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- MCP Protocol Documentation Modal -->
    <DocsModal ref="mcpProtocolDocsModal" title="Model Context Protocol (MCP)">
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

    <!-- A2A Protocol Documentation Modal -->
    <DocsModal ref="a2aProtocolDocsModal" title="A2A Protocol - Key Concepts">
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

<script lang="ts" setup>
import { ref, onMounted, computed } from 'vue';
import { useRoute } from 'vue-router';
import ConnectorIcon from '../components/ConnectorIcon.vue';
import DocLink from '../components/DocLink.vue';
import LoadingSpinner from '../components/LoadingSpinner.vue';
import DocsModal from '../components/DocsModal.vue';
import { useApi } from '../composables/useApi';
import { useMarkdown } from '../composables/useMarkdown';
import { logger } from '../utils/logger';

const { parseMarkdown } = useMarkdown();

type Operation = {
  id: number;
  operationKey: string;
  displayName: string;
  description?: string;
  category: string;
  helpUrl?: string;
  isActive: boolean;
  parameters?: Array<{
    id: number;
    apiName: string;
    displayName: string;
    dataType: string;
    isRequired: boolean;
    description?: string;
  }>;
};

type Connector = {
  id: number;
  name: string;
  version: string;
  category: string;
  description?: string;
  docUrl?: string;
  icon?: string;
  isActive: boolean;
  mavenArtifactId: string;
  operations?: Operation[];
};

const route = useRoute();
const { apiCall } = useApi();

const loading = ref(true);
const error = ref<string | null>(null);
const connector = ref<Connector | null>(null);
const activeTab = ref<'overview' | 'operations' | 'configuration'>('overview');
const configTypes = ref<any[]>([]);
const runtimeConfigs = ref<any[]>([]);
const configLoading = ref(false);
const mcpProtocolDocsModal = ref<InstanceType<typeof DocsModal> | null>(null);
const a2aProtocolDocsModal = ref<InstanceType<typeof DocsModal> | null>(null);

import { API_BASE } from '../config/api';

const connectorId = computed(() => route.params.id as string);
const connectorName = computed(() => connector.value?.name || 'Loading...');
const operations = computed(() => connector.value?.operations || []);
const isMCPConnector = computed(() => connector.value?.mavenArtifactId === 'mule4-mcp-connector');
const isA2AConnector = computed(() => connector.value?.mavenArtifactId === 'mule4-a2a-connector');

function getIconSrc(icon?: string) {
  if (!icon) return '';
  if (icon.startsWith('http://') || icon.startsWith('https://') || icon.startsWith('data:')) return icon;
  return `${API_BASE}${icon.startsWith('/') ? '' : '/'}${icon}`;
}

async function loadConfigurationTab() {
  activeTab.value = 'configuration';
  
  // Only load runtime configs if not already loaded
  if (runtimeConfigs.value.length > 0) {
    logger.debug('Runtime configs already loaded:', runtimeConfigs.value.length);
    return;
  }
  
  configLoading.value = true;
  try {
    // Load runtime configs for each config type (config types already loaded on mount)
    const configPromises = configTypes.value.map(ct => {
      logger.debug(`Loading runtime configs for config type ${ct.id}...`);
      return apiCall(`/runtime-configs?configTypeId=${ct.id}`, 'GET');
    });
    const allConfigs = await Promise.all(configPromises);
    runtimeConfigs.value = allConfigs.flat();
    logger.debug('Loaded runtime configs:', runtimeConfigs.value);
  } catch (e: any) {
    logger.error('Failed to load configurations:', e);
  } finally {
    configLoading.value = false;
  }
}

function getRuntimeConfigs(configTypeId: number) {
  return runtimeConfigs.value.filter((config: any) => 
    config.configTypeId === configTypeId || config.configType?.id === configTypeId
  );
}

function getRuntimeConfigCount(configTypeId: number) {
  return getRuntimeConfigs(configTypeId).length;
}

function openMCPProtocolDocs() {
  mcpProtocolDocsModal.value?.open();
}

function openA2AProtocolDocs() {
  a2aProtocolDocsModal.value?.open();
}

onMounted(async () => {
  try {
    connector.value = await apiCall(`/connectors/${connectorId.value}`, 'GET');
    // Load config types count for tab badge
    configTypes.value = await apiCall(`/connectors/${connectorId.value}/config-types`, 'GET');
  } catch (e: any) {
    error.value = e?.message || 'Failed to load connector';
  } finally {
    loading.value = false;
  }
});
</script>

<style scoped>
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

