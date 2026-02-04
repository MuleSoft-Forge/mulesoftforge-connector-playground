<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-5xl mx-auto px-6">
      <!-- Header -->
      <div class="mb-8">
        <router-link 
          to="/admin/connectors" 
          class="text-sm text-mulesoft-cyan hover:text-mulesoft-cyan-dark mb-4 inline-flex items-center gap-1"
        >
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
          </svg>
          Back to Connectors
        </router-link>
        <h1 class="text-3xl font-bold text-mulesoft-dark mt-2">
          {{ isEditing ? 'Edit Connector' : 'Create New Connector' }}
        </h1>
        <p class="text-mulesoft-gray mt-1">{{ isEditing ? 'Update connector details and configuration' : 'Follow the steps to create a new connector' }}</p>
      </div>

      <!-- Loading State -->
      <!-- Loading with Race Track -->
      <div v-if="loading" class="flex flex-col items-center justify-center min-h-[500px] px-8">
        <div class="w-full max-w-3xl">
          <h3 class="text-center text-xl font-bold text-mulesoft-dark mb-8">Max the Mule is fetching your data!</h3>
          
          <!-- Race Track -->
          <div class="relative">
            <!-- The Track (rounded rectangle) -->
            <svg viewBox="0 0 800 300" class="w-full h-auto">
              <!-- Track outline -->
              <rect x="50" y="50" width="700" height="200" rx="100" ry="100" 
                fill="none" stroke="#e5e7eb" stroke-width="40" stroke-dasharray="20,10"/>
              
              <!-- Progress track -->
              <rect x="50" y="50" width="700" height="200" rx="100" ry="100" 
                fill="none" stroke="url(#progressGradient)" stroke-width="40" 
                :stroke-dasharray="`${loadingProgress * 21} 2100`"
                stroke-linecap="round"
                class="transition-all duration-500"/>
              
              <!-- Gradient definition -->
              <defs>
                <linearGradient id="progressGradient" x1="0%" y1="0%" x2="100%" y2="0%">
                  <stop offset="0%" style="stop-color:#00A3E0;stop-opacity:1" />
                  <stop offset="100%" style="stop-color:#0077A3;stop-opacity:1" />
                </linearGradient>
              </defs>
              
              <!-- Checkpoints -->
              <!-- Checkpoint 1: Top-left (Connector) -->
              <g transform="translate(150, 50)">
                <circle cx="0" cy="0" r="20" :fill="loadingSteps[0].status === 'complete' ? '#10b981' : loadingSteps[0].status === 'loading' ? '#3b82f6' : '#d1d5db'" />
                <text v-if="loadingSteps[0].status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
                <text v-else-if="loadingSteps[0].status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
                <text x="0" y="45" text-anchor="middle" fill="#374151" font-size="14" font-weight="600">Connector</text>
              </g>
              
              <!-- Checkpoint 2: Top-right (Config Types) -->
              <g transform="translate(650, 50)">
                <circle cx="0" cy="0" r="20" :fill="loadingSteps[1].status === 'complete' ? '#10b981' : loadingSteps[1].status === 'loading' ? '#3b82f6' : '#d1d5db'" />
                <text v-if="loadingSteps[1].status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
                <text v-else-if="loadingSteps[1].status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
                <text x="0" y="45" text-anchor="middle" fill="#374151" font-size="14" font-weight="600">Configs</text>
              </g>
              
              <!-- Checkpoint 3: Bottom-right (Operations) -->
              <g transform="translate(650, 250)">
                <circle cx="0" cy="0" r="20" :fill="loadingSteps[2].status === 'complete' ? '#10b981' : loadingSteps[2].status === 'loading' ? '#3b82f6' : '#d1d5db'" />
                <text v-if="loadingSteps[2].status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
                <text v-else-if="loadingSteps[2].status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
                <text x="0" y="-30" text-anchor="middle" fill="#374151" font-size="14" font-weight="600">Operations</text>
              </g>
              
              <!-- Checkpoint 4: Bottom-left (Parameters) -->
              <g transform="translate(150, 250)">
                <circle cx="0" cy="0" r="20" :fill="loadingSteps[3].status === 'complete' ? '#10b981' : loadingSteps[3].status === 'loading' ? '#3b82f6' : '#d1d5db'" />
                <text v-if="loadingSteps[3].status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
                <text v-else-if="loadingSteps[3].status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
                <text x="0" y="-30" text-anchor="middle" fill="#374151" font-size="14" font-weight="600">Parameters</text>
              </g>
              
              <!-- Spinning Mule Shield in Center -->
              <foreignObject x="300" y="75" width="200" height="150">
                <div xmlns="http://www.w3.org/1999/xhtml" class="flex items-center justify-center h-full">
                  <LoadingSpinner text="" />
                </div>
              </foreignObject>
              
              <!-- Max the Mule (animated position) -->
              <g :transform="getCarPosition()">
                <image 
                  :href="maxTheMule" 
                  x="-50" 
                  y="-50" 
                  width="100" 
                  height="100"
                  class="transition-transform duration-300"
                />
              </g>
            </svg>
          </div>
          
          <!-- Current Status Text -->
          <div class="text-center mt-6">
            <p class="text-lg font-semibold text-mulesoft-cyan">
              {{ getCurrentLoadingText() }}
            </p>
            <p class="text-sm text-gray-500 mt-1">{{ Math.round(loadingProgress) }}% complete</p>
          </div>
        </div>
      </div>

      <!-- Wizard Content -->
      <div v-else class="space-y-6">
        <!-- Step Indicator -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <div class="flex items-center justify-between">
            <div 
              v-for="(step, index) in steps" 
              :key="index"
              class="flex items-center"
              :class="{ 'flex-1': index < steps.length - 1 }"
            >
              <!-- Step Circle -->
              <div class="flex items-center gap-3">
                <div 
                  class="w-10 h-10 rounded-full flex items-center justify-center font-bold text-sm transition-all"
                  :class="currentStep === index 
                    ? 'bg-mulesoft-cyan text-white shadow-lg' 
                    : currentStep > index 
                      ? 'bg-green-500 text-white' 
                      : 'bg-gray-200 text-gray-500'"
                >
                  <svg v-if="currentStep > index" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
                  </svg>
                  <span v-else>{{ index + 1 }}</span>
                </div>
                <div class="hidden md:block">
                  <div 
                    class="font-semibold text-sm"
                    :class="currentStep === index ? 'text-mulesoft-cyan' : currentStep > index ? 'text-green-600' : 'text-gray-500'"
                  >
                    {{ step.title }}
                  </div>
                  <div class="text-xs text-gray-500">{{ step.subtitle }}</div>
                </div>
              </div>

              <!-- Connector Line -->
              <div 
                v-if="index < steps.length - 1"
                class="flex-1 h-0.5 mx-4"
                :class="currentStep > index ? 'bg-green-500' : 'bg-gray-200'"
              ></div>
            </div>
          </div>
        </div>

        <!-- Step Content -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200">
          <!-- Step 1: Connector Info -->
          <div v-show="currentStep === 0" class="p-8">
            <h2 class="text-2xl font-bold text-mulesoft-dark mb-6">Connector Information</h2>
            <div class="space-y-5 max-w-2xl">
              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Connector Name <span class="text-red-500">*</span>
                </label>
                <input 
                  v-model="form.name"
                  type="text"
                  required
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
                  placeholder="e.g., Agentforce"
                />
              </div>

              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Maven Artifact ID <span class="text-red-500">*</span>
                </label>
                <input 
                  v-model="form.mavenArtifactId"
                  type="text"
                  required
                  :disabled="isEditing"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent disabled:bg-gray-100 disabled:cursor-not-allowed"
                  placeholder="e.g., mule4-agentforce-connector"
                />
                <p v-if="isEditing" class="text-xs text-mulesoft-gray mt-1">
                  Maven Artifact ID cannot be changed after creation
                </p>
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                    Version <span class="text-red-500">*</span>
                  </label>
                  <input 
                    v-model="form.version"
                    type="text"
                    required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
                    placeholder="e.g., 1.2.0"
                  />
                </div>

                <div>
                  <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                    Category <span class="text-red-500">*</span>
                  </label>
                  <select 
                    v-model="form.category"
                    required
                    class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
                  >
                    <option value="">Select category</option>
                    <option value="AI">AI</option>
                    <option value="Database">Database</option>
                    <option value="SaaS">SaaS</option>
                    <option value="Integration">Integration</option>
                    <option value="Messaging">Messaging</option>
                  </select>
                </div>
              </div>

              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Description
                </label>
                <textarea 
                  v-model="form.description"
                  rows="3"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent resize-none"
                  placeholder="Brief description of the connector..."
                ></textarea>
              </div>

              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Documentation URL
                </label>
                <input 
                  v-model="form.docUrl"
                  type="url"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
                  placeholder="https://docs.mulesoft.com/..."
                />
              </div>

              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Icon Path
                </label>
                <input 
                  v-model="form.icon"
                  type="text"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
                  placeholder="/webapp/assets/logos/connector.svg"
                />
                <p class="text-xs text-mulesoft-gray mt-1">
                  Path to connector icon (relative to server root)
                </p>
              </div>

              <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
                <div>
                  <div class="font-semibold text-mulesoft-dark">Active Status</div>
                  <p class="text-xs text-mulesoft-gray">Enable this connector for use</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    v-model="form.isActive"
                    class="sr-only peer"
                  />
                  <div class="w-11 h-6 bg-gray-300 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-mulesoft-cyan/20 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-mulesoft-cyan"></div>
                </label>
              </div>
            </div>
          </div>

          <!-- Step 2: Config Types -->
          <div v-show="currentStep === 1" class="p-8">
            <h2 class="text-2xl font-bold text-mulesoft-dark mb-2">Configuration Types</h2>
            <p class="text-mulesoft-gray mb-6">Define configuration types for this connector</p>
            
            <div class="space-y-4 mb-6">
              <!-- Config Type Cards (Expandable) -->
              <div 
                v-for="(ct, index) in form.configTypes" 
                :key="index"
                class="border border-gray-200 rounded-lg overflow-hidden"
              >
                <!-- Config Type Header (Clickable) -->
                <div 
                  @click="toggleConfigType(index)"
                  class="p-4 hover:bg-gray-50 transition-colors cursor-pointer flex items-start justify-between"
                >
                  <div class="flex items-center gap-3 flex-1">
                    <svg 
                      class="w-5 h-5 text-gray-400 transition-transform flex-shrink-0"
                      :class="{ 'rotate-90': expandedConfigTypes.includes(index) }"
                      fill="none" 
                      stroke="currentColor" 
                      viewBox="0 0 24 24"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                    </svg>
                    <div class="flex-1">
                      <div class="font-semibold text-gray-800">{{ ct.displayName }}</div>
                      <code class="text-xs text-gray-600">{{ ct.configTypeKey }}</code>
                      <div v-if="ct.description" class="text-sm text-gray-500 mt-1">{{ ct.description }}</div>
                    </div>
                  </div>
                  <div class="flex items-center gap-2 ml-3">
                    <span class="text-sm text-gray-500 bg-gray-100 px-3 py-1 rounded-full">
                      {{ getProviderCount(ct) }} provider(s)
                    </span>
                    <button 
                      @click.stop="editConfigType(index)"
                      :disabled="saving"
                      class="p-2 text-gray-400 hover:text-mulesoft-cyan transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                      title="Edit Config Type"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                      </svg>
                    </button>
                    <button 
                      @click.stop="removeConfigType(index)"
                      :disabled="saving"
                      class="p-2 text-gray-400 hover:text-red-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                      title="Delete Config Type"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                      </svg>
                    </button>
                  </div>
                </div>

                <!-- Providers Section (Expanded) -->
                <div v-show="expandedConfigTypes.includes(index)" class="border-t border-gray-200 bg-gray-50 p-4">
                  <h4 class="text-sm font-semibold text-gray-700 mb-3 flex items-center gap-2">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"></path>
                    </svg>
                    Providers
                  </h4>

                  <!-- Provider List -->
                  <div v-if="ct.providers && ct.providers.length > 0" class="space-y-2 mb-3">
                    <div 
                      v-for="(prov, provIndex) in ct.providers" 
                      :key="provIndex"
                      class="bg-white border border-gray-200 rounded-lg p-3 hover:border-purple-300 transition-colors"
                    >
                      <div class="flex items-start justify-between">
                        <div class="flex-1">
                          <div class="font-semibold text-gray-800">{{ prov.displayName }}</div>
                          <code class="text-xs text-gray-600">{{ prov.providerKey }}</code>
                          <div v-if="prov.description" class="text-xs text-gray-500 mt-1">{{ prov.description }}</div>
                          <div class="text-xs text-gray-500 mt-1">
                            {{ (prov.parameters || []).length }} parameter(s)
                          </div>
                        </div>
                        <div class="flex gap-2 ml-3">
                          <button 
                            @click="manageProviderParameters(ct, index, provIndex)"
                            :disabled="saving || !prov.id"
                            class="p-1.5 text-gray-400 hover:text-blue-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                            title="Manage Parameters"
                          >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
                            </svg>
                          </button>
                          <button 
                            @click="editProvider(ct, index, provIndex)"
                            :disabled="saving"
                            class="p-1.5 text-gray-400 hover:text-purple-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                            title="Edit Provider"
                          >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                            </svg>
                          </button>
                          <button 
                            @click="removeProvider(ct, index, provIndex)"
                            :disabled="saving"
                            class="p-1.5 text-gray-400 hover:text-red-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                            title="Delete Provider"
                          >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                            </svg>
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>

                  <!-- No Providers -->
                  <div v-else class="text-center py-4 text-gray-500 text-sm bg-white border border-dashed border-gray-300 rounded-lg mb-3">
                    No providers defined yet
                  </div>

                  <!-- Add Provider Button -->
                  <button 
                    @click="showAddProviderForm(ct, index)"
                    :disabled="saving || (selectedConfigTypeForProvider?.index === index && showProviderForm)"
                    class="w-full py-2 border border-dashed border-gray-300 rounded-lg text-gray-600 hover:border-purple-400 hover:text-purple-600 text-sm font-medium transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    + Add Provider
                  </button>
                </div>
              </div>

              <!-- Empty State -->
              <div v-if="form.configTypes.length === 0" class="text-center py-8 text-gray-500 border-2 border-dashed border-gray-300 rounded-lg">
                <p>No configuration types defined yet</p>
                <p class="text-xs mt-1">Click "Add Configuration Type" below to get started</p>
              </div>
            </div>

            <!-- Add/Edit Config Type Form -->
            <div v-if="showConfigTypeForm" class="border-2 border-mulesoft-cyan rounded-lg p-4 bg-blue-50 mb-4">
              <h4 class="font-semibold text-gray-800 mb-4">
                {{ editingConfigTypeIndex !== null ? 'Edit Configuration Type' : 'Add Configuration Type' }}
              </h4>
              <div class="grid grid-cols-2 gap-4 mb-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Config Key *</label>
                  <input 
                    v-model="configTypeForm.configTypeKey" 
                    type="text" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="config-key"
                  >
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Display Name *</label>
                  <input 
                    v-model="configTypeForm.displayName" 
                    type="text" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                    placeholder="Config Name"
                  >
                </div>
              </div>
              <div class="mb-4">
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea 
                  v-model="configTypeForm.description" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg" 
                  rows="2"
                ></textarea>
              </div>
              <div class="flex gap-2">
                <button 
                  @click="cancelConfigTypeForm"
                  :disabled="saving"
                  class="px-4 py-2 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Cancel
                </button>
                <button 
                  @click="addConfigType"
                  :disabled="saving"
                  class="px-6 py-2 bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span v-if="saving">Saving...</span>
                  <span v-else>{{ editingConfigTypeIndex !== null ? 'Update Config Type' : 'Add Config Type' }}</span>
                </button>
              </div>
            </div>

            <button 
              v-if="!showConfigTypeForm"
              @click="showConfigTypeForm = true"
              :disabled="saving"
              class="w-full py-3 border-2 border-dashed border-gray-300 rounded-lg text-gray-500 hover:border-mulesoft-cyan hover:text-mulesoft-cyan font-medium disabled:opacity-50 disabled:cursor-not-allowed"
            >
              + Add Configuration Type
            </button>

            <!-- Add/Edit Provider Form (Modal-like) -->
            <div v-if="showProviderForm" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
              <div class="bg-white rounded-lg shadow-2xl max-w-lg w-full p-6">
                <h4 class="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
                  <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"></path>
                  </svg>
                  {{ editingProviderIndex !== null ? 'Edit Provider' : 'Add Provider' }}
                </h4>
                
                <div class="space-y-4 mb-6">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Provider Key *</label>
                    <input 
                      v-model="providerForm.providerKey" 
                      type="text" 
                      class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                      placeholder="openai-connection"
                    >
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Display Name *</label>
                    <input 
                      v-model="providerForm.displayName" 
                      type="text" 
                      class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                      placeholder="OpenAI"
                    >
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea 
                      v-model="providerForm.description" 
                      class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent" 
                      rows="2"
                      placeholder="Optional description of this provider"
                    ></textarea>
                  </div>
                </div>

                <div class="flex gap-3">
                  <button 
                    @click="cancelProviderForm"
                    :disabled="saving"
                    class="flex-1 px-4 py-2 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    Cancel
                  </button>
                  <button 
                    @click="addProvider"
                    :disabled="saving || !providerForm.providerKey || !providerForm.displayName"
                    class="flex-1 px-6 py-2 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <span v-if="saving">Saving...</span>
                    <span v-else>{{ editingProviderIndex !== null ? 'Update Provider' : 'Add Provider' }}</span>
                  </button>
                </div>
              </div>
            </div>
          </div>

          <!-- Config Parameter Management Modal -->
          <teleport to="body">
            <transition name="modal">
              <div 
                v-if="showConfigParamModal"
                class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
                @mousedown.self="handleConfigParamBackdropMouseDown"
                @mouseup.self="handleConfigParamBackdropMouseUp"
                style="touch-action: none;"
              >
                <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
                  <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
                    <div>
                      <h3 class="text-xl font-bold">Manage Config Parameters</h3>
                      <p class="text-sm text-gray-600">{{ selectedProviderForParams?.displayName }}</p>
                    </div>
                    <button @click="closeConfigParamModal" class="p-2 hover:bg-gray-100 rounded-lg">
                      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                      </svg>
                    </button>
                  </div>

                  <div class="p-6 space-y-4">
                    <!-- Existing Parameters List -->
                    <div v-if="configParametersList.length > 0" class="space-y-2 mb-4">
                      <h4 class="font-semibold text-sm text-gray-700">Current Parameters</h4>
                      <div v-for="(param, idx) in configParametersList" :key="idx" 
                           class="flex items-center justify-between p-3 bg-gray-50 rounded border border-gray-200">
                        <div class="flex-1">
                          <code class="font-mono text-sm">{{ param.apiName }}</code>
                          <span class="text-sm text-gray-600 ml-2">{{ param.displayName }}</span>
                          <span class="px-2 py-0.5 bg-gray-200 text-gray-700 text-xs rounded ml-2">{{ param.dataType }}</span>
                          <span v-if="param.isRequired" class="px-2 py-0.5 bg-red-100 text-red-700 text-xs rounded ml-1">required</span>
                        </div>
                        <button 
                          @click="deleteConfigParameter(param.id, idx)"
                          :disabled="saving"
                          class="text-gray-400 hover:text-red-600 transition-colors disabled:opacity-50"
                          title="Delete"
                        >
                          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                          </svg>
                        </button>
                      </div>
                    </div>

                    <div v-else class="text-center py-4 text-gray-500 border-2 border-dashed border-gray-300 rounded-lg">
                      No parameters defined yet
                    </div>

                    <!-- Add Parameter Form -->
                    <div v-if="showConfigParamForm" class="border border-gray-300 rounded-lg p-4 bg-blue-50">
                      <h5 class="font-semibold text-sm mb-3">Add Config Parameter</h5>
                      <div class="grid grid-cols-2 gap-3 mb-3">
                        <div>
                          <label class="block text-xs font-medium mb-1">API Name *</label>
                          <input v-model="configParamForm.apiName" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                        </div>
                        <div>
                          <label class="block text-xs font-medium mb-1">Display Name *</label>
                          <input v-model="configParamForm.displayName" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                        </div>
                      </div>
                      <div class="grid grid-cols-2 gap-3 mb-3">
                        <div>
                          <label class="block text-xs font-medium mb-1">Data Type *</label>
                          <select v-model="configParamForm.dataType" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                            <option value="String">String</option>
                            <option value="Number">Number</option>
                            <option value="Boolean">Boolean</option>
                            <option value="Base64">Base64</option>
                            <option value="JSON">JSON</option>
                          </select>
                        </div>
                        <div>
                          <label class="block text-xs font-medium mb-1">Default Value</label>
                          <input v-model="configParamForm.defaultValue" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                        </div>
                      </div>
                      <div class="mb-3">
                        <label class="block text-xs font-medium mb-1">Description</label>
                        <textarea v-model="configParamForm.description" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm" rows="2"></textarea>
                      </div>
                      <div class="mb-3">
                        <label class="flex items-center cursor-pointer">
                          <input type="checkbox" v-model="configParamForm.isRequired" class="w-4 h-4">
                          <span class="ml-2 text-sm">Required</span>
                        </label>
                      </div>
                      <div class="flex gap-2">
                        <button @click="cancelConfigParamForm" :disabled="saving" class="px-3 py-1.5 border border-gray-300 rounded text-sm">
                          Cancel
                        </button>
                        <button @click="addConfigParameter" :disabled="saving" class="px-4 py-1.5 bg-blue-600 text-white rounded text-sm font-medium disabled:opacity-50 disabled:cursor-not-allowed">
                          <span v-if="saving">Saving...</span>
                          <span v-else>Add Parameter</span>
                        </button>
                      </div>
                    </div>

                    <button 
                      v-if="!showConfigParamForm"
                      @click="showConfigParamForm = true"
                      :disabled="saving"
                      class="w-full py-2 border-2 border-dashed border-gray-300 rounded text-sm text-gray-500 hover:border-blue-500 hover:text-blue-600"
                    >
                      + Add Parameter
                    </button>
                  </div>
                </div>
              </div>
            </transition>
          </teleport>

          <!-- Step 3: Operations & Parameters -->
          <div v-show="currentStep === 2" class="p-8">
            <h2 class="text-2xl font-bold text-mulesoft-dark mb-2">Operations & Parameters</h2>
            <p class="text-mulesoft-gray mb-6">Define operations and their parameters</p>
            
            <div class="space-y-4 mb-6">
              <div 
                v-for="(op, opIndex) in form.operations" 
                :key="opIndex"
                class="border border-gray-200 rounded-lg p-4"
              >
                <div class="flex items-start justify-between mb-3">
                  <div class="flex-1">
                    <div class="font-semibold text-gray-800">{{ op.displayName }}</div>
                    <code class="text-xs text-gray-600">{{ op.operationKey }}</code>
                  </div>
                  <div class="flex gap-2">
                    <DocLink :url="op.helpUrl" variant="icon" size="md" />
                    <button 
                      @click="editOperation(opIndex)"
                      :disabled="saving"
                      class="p-2 text-gray-400 hover:text-blue-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                      title="Edit"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                      </svg>
                    </button>
                    <button 
                      @click="removeOperation(opIndex)"
                      :disabled="saving"
                      class="p-2 text-gray-400 hover:text-red-600 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
                      title="Remove"
                    >
                      <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                      </svg>
                    </button>
                  </div>
                </div>
                
                <div class="text-sm text-gray-600 mb-2">{{ op.description }}</div>
                
                <div class="flex items-center gap-2 text-xs mb-3">
                  <span class="px-2 py-1 bg-gray-100 rounded">{{ op.category }}</span>
                  <span v-if="op.configType" class="px-2 py-1 bg-blue-100 text-blue-700 rounded">Config: {{ op.configType }}</span>
                  <span :class="op.isActive ? 'px-2 py-1 bg-green-100 text-green-700 rounded' : 'px-2 py-1 bg-gray-100 text-gray-600 rounded'">
                    {{ op.isActive ? 'Active' : 'Inactive' }}
                  </span>
                </div>

                <!-- Parameters -->
                <div v-if="op.parameters.length > 0" class="mt-3 pt-3 border-t border-gray-200">
                  <div class="text-xs font-semibold text-gray-700 mb-2">Parameters ({{ op.parameters.length }})</div>
                  <div class="space-y-1">
                    <div v-for="(param, pIndex) in op.parameters" :key="pIndex" class="flex items-center justify-between text-xs bg-gray-50 p-2 rounded">
                      <div class="flex items-center gap-2">
                        <code class="font-mono">{{ param.apiName }}</code>
                        <span class="text-gray-500">{{ param.dataType }}</span>
                        <span v-if="param.isRequired" class="text-red-600 font-medium">required</span>
                      </div>
                      <button 
                        @click="removeParameter(opIndex, pIndex)"
                        class="text-gray-400 hover:text-red-600 transition-colors"
                      >
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
              </div>

              <div v-if="form.operations.length === 0" class="text-center py-8 text-gray-500 border-2 border-dashed border-gray-300 rounded-lg">
                <p>No operations defined yet</p>
                <p class="text-xs mt-1">Click "Add Operation" below to get started</p>
              </div>
            </div>

            <button 
              @click="openOperationDialog"
              :disabled="saving"
              class="w-full py-3 border-2 border-dashed border-gray-300 rounded-lg text-gray-500 hover:border-mulesoft-cyan hover:text-mulesoft-cyan font-medium disabled:opacity-50 disabled:cursor-not-allowed"
            >
              + Add Operation
            </button>
          </div>

          <!-- Step 4: Review -->
          <div v-show="currentStep === 3" class="p-8">
            <h2 class="text-2xl font-bold text-mulesoft-dark mb-6">Review & Save</h2>
            
            <div class="space-y-6 max-w-3xl">
              <!-- Connector Summary -->
              <div class="border border-gray-200 rounded-lg p-6">
                <h3 class="font-semibold text-lg text-mulesoft-dark mb-4">Connector Information</h3>
                <dl class="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <dt class="text-gray-500">Name</dt>
                    <dd class="font-medium">{{ form.name }}</dd>
                  </div>
                  <div>
                    <dt class="text-gray-500">Maven Artifact ID</dt>
                    <dd class="font-mono text-sm">{{ form.mavenArtifactId }}</dd>
                  </div>
                  <div>
                    <dt class="text-gray-500">Version</dt>
                    <dd class="font-medium">{{ form.version }}</dd>
                  </div>
                  <div>
                    <dt class="text-gray-500">Category</dt>
                    <dd class="font-medium">{{ form.category }}</dd>
                  </div>
                  <div class="col-span-2">
                    <dt class="text-gray-500">Description</dt>
                    <dd class="font-medium">{{ form.description || '—' }}</dd>
                  </div>
                  <div>
                    <dt class="text-gray-500">Status</dt>
                    <dd>
                      <span :class="form.isActive ? 'px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium' : 'px-2 py-1 bg-gray-100 text-gray-600 rounded text-xs font-medium'">
                        {{ form.isActive ? 'Active' : 'Inactive' }}
                      </span>
                    </dd>
                  </div>
                </dl>
              </div>

              <!-- Config Types Summary -->
              <div class="border border-gray-200 rounded-lg p-6">
                <h3 class="font-semibold text-lg text-mulesoft-dark mb-4">Configuration Types ({{ form.configTypes.length }})</h3>
                <div v-if="form.configTypes.length > 0" class="space-y-2">
                  <div v-for="(ct, index) in form.configTypes" :key="index" class="flex items-center justify-between p-3 bg-gray-50 rounded">
                    <div>
                      <div class="font-medium">{{ ct.displayName }}</div>
                      <code class="text-xs text-gray-600">{{ ct.configTypeKey }}</code>
                    </div>
                  </div>
                </div>
                <p v-else class="text-gray-500 text-sm">No configuration types defined</p>
              </div>

              <!-- Operations Summary -->
              <div class="border border-gray-200 rounded-lg p-6">
                <h3 class="font-semibold text-lg text-mulesoft-dark mb-4">Operations ({{ form.operations.length }})</h3>
                <div v-if="form.operations.length > 0" class="space-y-3">
                  <div v-for="(op, index) in form.operations" :key="index" class="p-3 bg-gray-50 rounded">
                    <div class="flex items-start justify-between">
                      <div class="flex-1">
                        <div class="font-medium">{{ op.displayName }}</div>
                        <div class="text-xs text-gray-600 mt-1">{{ op.parameters.length }} parameter(s)</div>
                      </div>
                      <DocLink :url="op.helpUrl" variant="text" size="sm" />
                    </div>
                  </div>
                </div>
                <p v-else class="text-gray-500 text-sm">No operations defined</p>
              </div>

            </div>
          </div>
        </div>

        <!-- Navigation Buttons -->
        <div class="bg-white rounded-lg shadow-sm border border-gray-200 p-6 flex items-center justify-between">
          <button 
            v-if="currentStep > 0"
            @click="previousStep"
            :disabled="saving"
            class="px-6 py-2 border border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
          >
            ← Previous
          </button>
          <div v-else></div>

          <div class="text-sm text-gray-500">
            Step {{ currentStep + 1 }} of {{ steps.length }}
          </div>

          <button 
            v-if="currentStep < steps.length - 1"
            @click="nextStep"
            :disabled="!canProceed || saving"
            class="px-6 py-2 bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark transition-colors shadow-md disabled:opacity-50 disabled:cursor-not-allowed"
          >
            <span v-if="saving">Saving...</span>
            <span v-else>Next →</span>
          </button>
          <button 
            v-else
            @click="router.push('/admin/connectors')"
            class="px-8 py-2 bg-green-600 text-white font-semibold rounded-lg hover:bg-green-700 transition-colors shadow-md"
          >
            ✓ Done - Return to Connectors
          </button>
        </div>
      </div>
    </div>

    <!-- Operation Dialog Modal -->
    <teleport to="body">
      <transition name="modal">
        <div 
          v-if="showOperationDialog"
          class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          @mousedown.self="handleOperationDialogBackdropMouseDown"
          @mouseup.self="handleOperationDialogBackdropMouseUp"
          style="touch-action: none;"
        >
          <div class="bg-white rounded-xl shadow-2xl max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div class="sticky top-0 bg-white border-b border-gray-200 p-6 flex items-center justify-between">
              <h3 class="text-xl font-bold">{{ editingOperationIndex !== null ? 'Edit Operation' : 'Add Operation' }}</h3>
              <button @click="closeOperationDialog" class="p-2 hover:bg-gray-100 rounded-lg">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                </svg>
              </button>
            </div>

            <div class="p-6 space-y-4">
              <!-- Operation Details -->
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Display Name *</label>
                  <input 
                    v-model="operationForm.displayName" 
                    type="text" 
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  >
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Category *</label>
                  <select v-model="operationForm.category" class="w-full px-3 py-2 border border-gray-300 rounded-lg">
                    <option value="Agent">Agent</option>
                    <option value="Chat">Chat</option>
                    <option value="Embedding">Embedding</option>
                    <option value="RAG">RAG</option>
                    <option value="Tools">Tools</option>
                    <option value="Image">Image</option>
                    <option value="Vision">Vision</option>
                    <option value="Moderation">Moderation</option>
                    <option value="Text">Text</option>
                    <option value="General">General</option>
                  </select>
                </div>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Operation Key *</label>
                <input 
                  v-model="operationForm.operationKey" 
                  type="text" 
                  :disabled="editingOperationIndex !== null"
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg disabled:bg-gray-100 disabled:cursor-not-allowed"
                  placeholder="ms-connector:operation-name"
                >
                <p v-if="editingOperationIndex !== null" class="text-xs text-mulesoft-gray mt-1">
                  Operation Key cannot be changed after creation
                </p>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                <textarea 
                  v-model="operationForm.description" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg" 
                  rows="2"
                ></textarea>
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Help URL</label>
                <input 
                  v-model="operationForm.helpUrl" 
                  type="url" 
                  class="w-full px-3 py-2 border border-gray-300 rounded-lg"
                  placeholder="https://docs.mulesoft.com/..."
                >
              </div>

              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Config Type</label>
                <select v-model="operationForm.configType" class="w-full px-3 py-2 border border-gray-300 rounded-lg">
                  <option value="">None</option>
                  <option v-for="ct in form.configTypes" :key="ct.configTypeKey" :value="ct.displayName">
                    {{ ct.displayName }}
                  </option>
                </select>
              </div>

              <div class="flex items-center">
                <label class="flex items-center cursor-pointer">
                  <input type="checkbox" v-model="operationForm.isActive" class="w-4 h-4 text-mulesoft-cyan">
                  <span class="ml-2 text-sm">Active</span>
                </label>
              </div>

              <!-- Parameters -->
              <div class="border-t border-gray-200 pt-4 mt-4">
                <h4 class="font-semibold mb-3">Parameters</h4>
                
                <div v-if="operationForm.parameters.length > 0" class="space-y-2 mb-4">
                  <div v-for="(param, pIndex) in operationForm.parameters" :key="pIndex" class="flex items-center justify-between p-3 bg-gray-50 rounded group">
                    <div class="flex items-center gap-3 flex-1">
                      <div class="flex flex-col gap-1">
                        <button 
                          @click="moveParameterUp(pIndex)"
                          :disabled="pIndex === 0"
                          class="text-gray-400 hover:text-blue-600 disabled:opacity-30 disabled:cursor-not-allowed"
                          title="Move up"
                        >
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 15l7-7 7 7"></path>
                          </svg>
                        </button>
                        <button 
                          @click="moveParameterDown(pIndex)"
                          :disabled="pIndex === operationForm.parameters.length - 1"
                          class="text-gray-400 hover:text-blue-600 disabled:opacity-30 disabled:cursor-not-allowed"
                          title="Move down"
                        >
                          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                          </svg>
                        </button>
                      </div>
                      <div class="flex items-center gap-3">
                        <span class="text-gray-400 text-xs font-medium w-6">#{{ pIndex + 1 }}</span>
                        <code class="font-mono text-sm">{{ param.apiName }}</code>
                        <span class="text-sm text-gray-600">{{ param.displayName }}</span>
                        <span class="px-2 py-0.5 bg-gray-200 text-gray-700 text-xs rounded">{{ param.dataType }}</span>
                        <span v-if="param.isRequired" class="px-2 py-0.5 bg-red-100 text-red-700 text-xs rounded">required</span>
                      </div>
                    </div>
                    <div class="flex gap-2">
                      <button 
                        @click="editParameter(pIndex)"
                        class="text-gray-400 hover:text-blue-600"
                        title="Edit"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                        </svg>
                      </button>
                      <button 
                        @click="removeOperationParameter(pIndex)"
                        class="text-gray-400 hover:text-red-600"
                        title="Delete"
                      >
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>

                <!-- Add/Edit Parameter Form -->
                <div v-if="showParameterForm" class="border border-gray-300 rounded-lg p-4 bg-blue-50 mb-3">
                  <h5 class="font-semibold text-sm mb-3">{{ editingParameterIndex !== null ? 'Edit Parameter' : 'Add Parameter' }}</h5>
                  <div class="grid grid-cols-2 gap-3 mb-3">
                    <div>
                      <label class="block text-xs font-medium mb-1">API Name *</label>
                      <input v-model="parameterForm.apiName" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                    </div>
                    <div>
                      <label class="block text-xs font-medium mb-1">Display Name *</label>
                      <input v-model="parameterForm.displayName" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                    </div>
                  </div>
                  <div class="grid grid-cols-2 gap-3 mb-3">
                    <div>
                      <label class="block text-xs font-medium mb-1">Data Type *</label>
                      <select v-model="parameterForm.dataType" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                        <option value="String">String</option>
                        <option value="Integer">Integer</option>
                        <option value="Boolean">Boolean</option>
                        <option value="Number">Number</option>
                        <option value="Base64">Base64</option>
                        <option value="Object">Object</option>
                        <option value="Array">Array</option>
                      </select>
                    </div>
                    <div>
                      <label class="block text-xs font-medium mb-1">Default Value</label>
                      <input v-model="parameterForm.defaultValue" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm">
                    </div>
                  </div>
                  <div class="mb-3">
                    <label class="block text-xs font-medium mb-1">Description</label>
                    <textarea v-model="parameterForm.description" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm" rows="2"></textarea>
                  </div>
                  <div class="mb-3">
                    <label class="block text-xs font-medium mb-1">Validation Rules (JSON)</label>
                    <input v-model="parameterForm.validationRules" class="w-full px-2 py-1.5 border border-gray-300 rounded text-sm font-mono" placeholder='{"enum": ["option1", "option2"]}'>
                    <p class="text-xs text-gray-500 mt-1">Optional: JSON object with validation rules like enum values</p>
                  </div>
                  <div class="flex items-center gap-3 mb-3">
                    <label class="flex items-center cursor-pointer">
                      <input type="checkbox" v-model="parameterForm.isRequired" class="w-4 h-4">
                      <span class="ml-2 text-sm">Required</span>
                    </label>
                  </div>
                  <div class="flex gap-2">
                    <button @click="cancelParameterForm" class="px-3 py-1.5 border border-gray-300 rounded text-sm">Cancel</button>
                    <button @click="saveParameter" class="px-4 py-1.5 bg-mulesoft-cyan text-white rounded text-sm font-medium">
                      {{ editingParameterIndex !== null ? 'Save Changes' : 'Add Parameter' }}
                    </button>
                  </div>
                </div>

                <button 
                  v-if="!showParameterForm"
                  @click="showParameterForm = true"
                  class="w-full py-2 border-2 border-dashed border-gray-300 rounded text-sm text-gray-500 hover:border-mulesoft-cyan hover:text-mulesoft-cyan"
                >
                  + Add Parameter
                </button>
              </div>

              <!-- Save Operation Button -->
              <div class="flex justify-end gap-3 pt-4 border-t border-gray-200">
                <button 
                  @click="closeOperationDialog"
                  :disabled="saving"
                  class="px-4 py-2 border border-gray-300 rounded-lg font-medium disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Cancel
                </button>
                <button 
                  @click="saveOperation"
                  :disabled="saving"
                  class="px-6 py-2 bg-mulesoft-cyan text-white rounded-lg font-semibold disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <span v-if="saving">Saving...</span>
                  <span v-else>{{ editingOperationIndex !== null ? 'Save Changes' : 'Add Operation' }}</span>
                </button>
              </div>
            </div>
          </div>
        </div>
      </transition>
    </teleport>
  </div>
</template>

<script lang="ts" setup>
import { ref, computed, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { MAX_THE_MULE } from '../../constants/assets';
import LoadingSpinner from '../../components/LoadingSpinner.vue';
import DocLink from '../../components/DocLink.vue';
import { useApi } from '../../composables/useApi';
import { logger } from '../../utils/logger';

const maxTheMule = MAX_THE_MULE;

const route = useRoute();
const router = useRouter();
const { apiCall } = useApi();

const connectorId = computed(() => route.params.id ? Number(route.params.id) : null);
const isEditing = computed(() => !!connectorId.value);

const loading = ref(false);
const saving = ref(false);

// Loading progress
const loadingProgress = ref(0);
const loadingSteps = ref([
  { label: 'Loading connector & operations', status: 'pending' },
  { label: 'Loading configuration types', status: 'pending' },
  { label: 'Processing data', status: 'pending' },
  { label: 'Ready to edit', status: 'pending' }
]);

const currentStep = ref(0);
const steps = [
  { title: 'Connector Info', subtitle: 'Basic details' },
  { title: 'Config Types', subtitle: 'Configuration' },
  { title: 'Operations', subtitle: 'Add operations' },
  { title: 'Review', subtitle: 'View saved data' }
];

// Track the saved connector ID (for new connectors)
const savedConnectorId = ref<number | null>(null);
const actualConnectorId = computed(() => savedConnectorId.value || connectorId.value);

const form = ref({
  name: '',
  mavenArtifactId: '',
  version: '',
  category: '',
  description: '',
  docUrl: '',
  icon: '',
  isActive: true,
  configTypes: [] as any[],
  operations: [] as any[]
});

// Store original connector data for change detection
const originalConnectorData = ref<{
  name: string;
  mavenArtifactId: string;
  version: string;
  category: string;
  description: string;
  docUrl: string;
  icon: string;
  isActive: boolean;
} | null>(null);

// Config Type Form
const showConfigTypeForm = ref(false);
const editingConfigTypeIndex = ref<number | null>(null);
const configTypeForm = ref({
  configTypeKey: '',
  displayName: '',
  description: ''
});

// Provider Management
const expandedConfigTypes = ref<number[]>([]);
const showProviderForm = ref(false);
const editingProviderIndex = ref<number | null>(null);
const selectedConfigTypeForProvider = ref<any>(null);
const providerForm = ref({
  providerKey: '',
  displayName: '',
  description: ''
});

// Config Parameter Management
const showConfigParamModal = ref(false);
const configParamBackdropMouseDownPos = ref<{ x: number, y: number } | null>(null);
const showConfigParamForm = ref(false);
const selectedProviderForParams = ref<any>(null);
const selectedConfigTypeForParams = ref<any>(null);
const configParametersList = ref<any[]>([]);
const configParamForm = ref({
  apiName: '',
  displayName: '',
  dataType: 'String',
  description: '',
  defaultValue: '',
  isRequired: false
});

// Operation Dialog
const showOperationDialog = ref(false);
const operationDialogBackdropMouseDownPos = ref<{ x: number, y: number } | null>(null);
const editingOperationIndex = ref<number | null>(null);
const operationForm = ref({
  displayName: '',
  operationKey: '',
  description: '',
  category: 'General',
  configType: '',
  helpUrl: '',
  isActive: true,
  operationOrder: 0,
  parameters: [] as any[]
});

// Parameter Form (within operation dialog)
const showParameterForm = ref(false);
const editingParameterIndex = ref<number | null>(null);
const parameterForm = ref({
  apiName: '',
  displayName: '',
  dataType: 'String',
  description: '',
  defaultValue: '',
  isRequired: false,
  validationRules: ''
});

import { API_BASE } from '../../config/api';

const canProceed = computed(() => {
  if (currentStep.value === 0) {
    return form.value.name && form.value.mavenArtifactId && form.value.version && form.value.category;
  }
  return true;
});

// Race track animation helpers
function getCarPosition() {
  const progress = loadingProgress.value / 100;
  
  // Track dimensions (matching the SVG)
  const trackWidth = 700;
  const trackHeight = 200;
  const cornerRadius = 100;
  const startX = 50;
  const startY = 50;
  
  // Calculate the perimeter of the rounded rectangle
  const straightWidth = trackWidth - 2 * cornerRadius;
  const straightHeight = trackHeight - 2 * cornerRadius;
  const perimeter = 2 * straightWidth + 2 * straightHeight + 2 * Math.PI * cornerRadius;
  
  // Distance traveled
  const distance = progress * perimeter;
  
  let x = 0, y = 0;
  
  // Top straight (left to right)
  if (distance < straightWidth) {
    x = startX + cornerRadius + distance;
    y = startY;
  }
  // Top-right corner
  else if (distance < straightWidth + Math.PI * cornerRadius / 2) {
    const angle = (distance - straightWidth) / cornerRadius;
    x = startX + trackWidth - cornerRadius + cornerRadius * Math.sin(angle);
    y = startY + cornerRadius - cornerRadius * Math.cos(angle);
  }
  // Right straight (top to bottom)
  else if (distance < straightWidth + Math.PI * cornerRadius / 2 + straightHeight) {
    const straightDist = distance - (straightWidth + Math.PI * cornerRadius / 2);
    x = startX + trackWidth;
    y = startY + cornerRadius + straightDist;
  }
  // Bottom-right corner
  else if (distance < straightWidth + Math.PI * cornerRadius + straightHeight) {
    const angle = (distance - (straightWidth + Math.PI * cornerRadius / 2 + straightHeight)) / cornerRadius;
    x = startX + trackWidth - cornerRadius + cornerRadius * Math.cos(angle);
    y = startY + trackHeight - cornerRadius + cornerRadius * Math.sin(angle);
  }
  // Bottom straight (right to left)
  else if (distance < 2 * straightWidth + Math.PI * cornerRadius + straightHeight) {
    const straightDist = distance - (straightWidth + Math.PI * cornerRadius + straightHeight);
    x = startX + trackWidth - cornerRadius - straightDist;
    y = startY + trackHeight;
  }
  // Bottom-left corner
  else if (distance < 2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + straightHeight) {
    const angle = (distance - (2 * straightWidth + Math.PI * cornerRadius + straightHeight)) / cornerRadius;
    x = startX + cornerRadius - cornerRadius * Math.sin(angle);
    y = startY + trackHeight - cornerRadius + cornerRadius * Math.cos(angle);
  }
  // Left straight (bottom to top)
  else if (distance < 2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + 2 * straightHeight) {
    const straightDist = distance - (2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + straightHeight);
    x = startX;
    y = startY + trackHeight - cornerRadius - straightDist;
  }
  // Top-left corner
  else {
    const angle = (distance - (2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + 2 * straightHeight)) / cornerRadius;
    x = startX + cornerRadius - cornerRadius * Math.cos(angle);
    y = startY + cornerRadius - cornerRadius * Math.sin(angle);
  }
  
  return `translate(${x}, ${y})`;
}

function getCurrentLoadingText() {
  const activeStep = loadingSteps.value.find(s => s.status === 'loading');
  return activeStep ? activeStep.label : 'Almost there...';
}

// Check if connector data has changed
function hasConnectorDataChanged(): boolean {
  if (!originalConnectorData.value) return true; // No original data = new connector or force save
  
  return (
    form.value.name !== originalConnectorData.value.name ||
    form.value.mavenArtifactId !== originalConnectorData.value.mavenArtifactId ||
    form.value.version !== originalConnectorData.value.version ||
    form.value.category !== originalConnectorData.value.category ||
    (form.value.description || '') !== (originalConnectorData.value.description || '') ||
    (form.value.docUrl || '') !== (originalConnectorData.value.docUrl || '') ||
    (form.value.icon || '') !== (originalConnectorData.value.icon || '') ||
    form.value.isActive !== originalConnectorData.value.isActive
  );
}

async function nextStep() {
  if (!canProceed.value || saving.value) return; // Prevent double-click
  
  saving.value = true;
  
  try {
    // Step 0: Save connector info
    if (currentStep.value === 0 && !actualConnectorId.value) {
      // New connector - always save
      // Build connector payload (only include fields that have values)
      const connectorPayload: any = {
        mavenArtifactId: form.value.mavenArtifactId,
        name: form.value.name,
        version: form.value.version,
        category: form.value.category,
        isActive: form.value.isActive
      };
      
      // Only include optional fields if they have values
      if (form.value.description) {
        connectorPayload.description = form.value.description;
      }
      if (form.value.docUrl) {
        connectorPayload.docUrl = form.value.docUrl;
      }
      if (form.value.icon) {
        connectorPayload.icon = form.value.icon;
      }
      
      const newConnector = await apiCall('/connectors', 'POST', connectorPayload);
      savedConnectorId.value = newConnector.id;
    }
    // If editing, only update if data changed
    else if (currentStep.value === 0 && actualConnectorId.value && hasConnectorDataChanged()) {
      // Build connector payload (only include fields that have values)
      const connectorPayload: any = {
        mavenArtifactId: form.value.mavenArtifactId,
        name: form.value.name,
        version: form.value.version,
        category: form.value.category,
        isActive: form.value.isActive
      };
      
      // Only include optional fields if they have values
      if (form.value.description) {
        connectorPayload.description = form.value.description;
      }
      if (form.value.docUrl) {
        connectorPayload.docUrl = form.value.docUrl;
      }
      if (form.value.icon) {
        connectorPayload.icon = form.value.icon;
      }
      
      await apiCall(`/connectors/${actualConnectorId.value}`, 'PUT', connectorPayload);
      
      // Update original data after successful save
      originalConnectorData.value = {
        name: form.value.name,
        mavenArtifactId: form.value.mavenArtifactId,
        version: form.value.version,
        category: form.value.category,
        description: form.value.description,
        docUrl: form.value.docUrl,
        icon: form.value.icon,
        isActive: form.value.isActive
      };
    }

    // Move to next step
    if (currentStep.value < steps.length - 1) {
      currentStep.value++;
    }
  } catch (error) {
    logger.error('Failed to save:', error);
  } finally {
    saving.value = false;
  }
}

function previousStep() {
  if (currentStep.value > 0) {
    currentStep.value--;
  }
}

// Config Type Management
async function addConfigType() {
  if (!configTypeForm.value.configTypeKey || !configTypeForm.value.displayName) {
    return;
  }

  if (!actualConnectorId.value) {
    alert('Please save connector info first (Step 1)');
    return;
  }

  if (saving.value) return; // Prevent double-click
  saving.value = true;
  try {
    // Build config type payload (only include fields that have values)
    const configTypePayload: any = {
      configTypeKey: configTypeForm.value.configTypeKey,
      displayName: configTypeForm.value.displayName
    };
    
    // Only include description if it has a value
    if (configTypeForm.value.description) {
      configTypePayload.description = configTypeForm.value.description;
    }
    
    if (editingConfigTypeIndex.value !== null) {
      // Edit existing config type
      const existingConfigType = form.value.configTypes[editingConfigTypeIndex.value];
      const updatedConfigType = await apiCall(`/connectors/${actualConnectorId.value}/config-types/${existingConfigType.id}`, 'PUT', configTypePayload);
      
      // Update in place (preserve existing data like providers array)
      form.value.configTypes[editingConfigTypeIndex.value] = {
        ...existingConfigType,  // Keep existing data (especially providers!)
        ...updatedConfigType,   // Apply API response
        ...configTypeForm.value // Apply form updates
      };
    } else {
      // Create new config type
      const createdConfigType = await apiCall(`/connectors/${actualConnectorId.value}/config-types`, 'POST', configTypePayload);
      
      form.value.configTypes.push({
        id: createdConfigType.id,
        ...configTypeForm.value
      });
    }
    
    cancelConfigTypeForm();
  } catch (error) {
    logger.error('Failed to save config type:', error);
  } finally {
    saving.value = false;
  }
}

function editConfigType(index: number) {
  editingConfigTypeIndex.value = index;
  const ct = form.value.configTypes[index];
  configTypeForm.value = {
    configTypeKey: ct.configTypeKey,
    displayName: ct.displayName,
    description: ct.description || ''
  };
  showConfigTypeForm.value = true;
}

function cancelConfigTypeForm() {
  showConfigTypeForm.value = false;
  editingConfigTypeIndex.value = null;
  configTypeForm.value = {
    configTypeKey: '',
    displayName: '',
    description: ''
  };
}

async function removeConfigType(index: number) {
  const ct = form.value.configTypes[index];
  
  if (!confirm(`Are you sure you want to delete "${ct.displayName}"?`)) {
    return;
  }
  
  // If config type has an ID, delete it from the API
  if (ct.id && actualConnectorId.value) {
    try {
      await apiCall(`/connectors/${actualConnectorId.value}/config-types/${ct.id}`, 'DELETE');
    } catch (error) {
      logger.error('Failed to delete config type:', error);
      return; // Don't remove from UI if API call fails
    }
  }
  
  form.value.configTypes.splice(index, 1);
}

// Provider Management
function toggleConfigType(index: number) {
  const idx = expandedConfigTypes.value.indexOf(index);
  if (idx > -1) {
    expandedConfigTypes.value.splice(idx, 1);
  } else {
    expandedConfigTypes.value.push(index);
  }
}

function getProviderCount(configType: any) {
  return configType.providers ? configType.providers.length : 0;
}

function showAddProviderForm(configType: any, configTypeIndex: number) {
  selectedConfigTypeForProvider.value = { ...configType, index: configTypeIndex };
  editingProviderIndex.value = null;
  providerForm.value = {
    providerKey: '',
    displayName: '',
    description: ''
  };
  showProviderForm.value = true;
}

function editProvider(configType: any, configTypeIndex: number, providerIndex: number) {
  selectedConfigTypeForProvider.value = { ...configType, index: configTypeIndex };
  editingProviderIndex.value = providerIndex;
  const provider = configType.providers[providerIndex];
  providerForm.value = {
    providerKey: provider.providerKey,
    displayName: provider.displayName,
    description: provider.description || ''
  };
  showProviderForm.value = true;
}

async function addProvider() {
  if (!providerForm.value.providerKey || !providerForm.value.displayName) {
    alert('Provider Key and Display Name are required');
    return;
  }

  if (!selectedConfigTypeForProvider.value) {
    alert('No config type selected');
    return;
  }

  const configTypeIndex = selectedConfigTypeForProvider.value.index;
  const configType = form.value.configTypes[configTypeIndex];

  if (!configType.id || !actualConnectorId.value) {
    alert('Please save the config type first before adding providers');
    return;
  }

  if (saving.value) return; // Prevent double-click
  saving.value = true;

  const providerPayload: any = {
    providerKey: providerForm.value.providerKey,
    displayName: providerForm.value.displayName
  };

  if (providerForm.value.description) {
    providerPayload.description = providerForm.value.description;
  }

  try {
    if (editingProviderIndex.value !== null) {
      // Edit existing provider
      const existingProvider = configType.providers[editingProviderIndex.value];
      const updatedProvider = await apiCall(
        `/config-types/${configType.id}/providers/${existingProvider.id}`,
        'PUT',
        providerPayload
      );
      // Update in-place
      configType.providers[editingProviderIndex.value] = {
        ...updatedProvider,
        ...providerForm.value
      };
    } else {
      // Create new provider
      const createdProvider = await apiCall(
        `/config-types/${configType.id}/providers`,
        'POST',
        providerPayload
      );
      // Initialize providers array if needed
      if (!configType.providers) {
        configType.providers = [];
      }
      configType.providers.push({
        id: createdProvider.id,
        ...providerForm.value
      });
    }
    cancelProviderForm();
  } catch (error) {
    logger.error('Failed to save provider:', error);
  } finally {
    saving.value = false;
  }
}

async function removeProvider(configType: any, configTypeIndex: number, providerIndex: number) {
  const provider = configType.providers[providerIndex];

  if (!confirm(`Are you sure you want to delete "${provider.displayName}"?`)) {
    return;
  }

  // If provider has an ID, delete it from the API
  if (provider.id && configType.id) {
    try {
      await apiCall(
        `/config-types/${configType.id}/providers/${provider.id}`,
        'DELETE'
      );
    } catch (error) {
      logger.error('Failed to delete provider:', error);
      return; // Don't remove from UI if API call fails
    }
  }

  configType.providers.splice(providerIndex, 1);
}

function cancelProviderForm() {
  showProviderForm.value = false;
  editingProviderIndex.value = null;
  selectedConfigTypeForProvider.value = null;
  providerForm.value = {
    providerKey: '',
    displayName: '',
    description: ''
  };
}

// Config Parameter Management Functions
async function manageProviderParameters(configType: any, configTypeIndex: number, providerIndex: number) {
  const provider = configType.providers[providerIndex];
  
  if (!provider.id) {
    alert('Provider must be saved before managing parameters');
    return;
  }
  
  selectedProviderForParams.value = provider;
  selectedConfigTypeForParams.value = configType;
  
  // Load existing parameters
  try {
    const providerDetail = await apiCall(
      `/config-types/${configType.id}/providers/${provider.id}`,
      'GET'
    );
    configParametersList.value = providerDetail.parameters || [];
    showConfigParamModal.value = true;
  } catch (error) {
    logger.error('Failed to load provider parameters:', error);
  }
}

function handleConfigParamBackdropMouseDown(e: MouseEvent) {
  configParamBackdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
}

function handleConfigParamBackdropMouseUp(e: MouseEvent) {
  if (!configParamBackdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - configParamBackdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - configParamBackdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10) {
    closeConfigParamModal();
  }
  
  configParamBackdropMouseDownPos.value = null;
}

function closeConfigParamModal() {
  showConfigParamModal.value = false;
  showConfigParamForm.value = false;
  selectedProviderForParams.value = null;
  selectedConfigTypeForParams.value = null;
  configParametersList.value = [];
  cancelConfigParamForm();
}

function cancelConfigParamForm() {
  showConfigParamForm.value = false;
  configParamForm.value = {
    apiName: '',
    displayName: '',
    dataType: 'String',
    description: '',
    defaultValue: '',
    isRequired: false
  };
}

async function addConfigParameter() {
  if (!configParamForm.value.apiName || !configParamForm.value.displayName) {
    alert('API Name and Display Name are required');
    return;
  }
  
  if (!selectedProviderForParams.value?.id) {
    alert('No provider selected');
    return;
  }
  
  if (saving.value) return; // Prevent double-click
  saving.value = true;
  try {
    const payload: any = {
      apiName: configParamForm.value.apiName,
      displayName: configParamForm.value.displayName,
      dataType: configParamForm.value.dataType,
      isRequired: configParamForm.value.isRequired,
      parameterOrder: configParametersList.value.length
    };
    
    if (configParamForm.value.description) {
      payload.description = configParamForm.value.description;
    }
    if (configParamForm.value.defaultValue) {
      payload.defaultValue = configParamForm.value.defaultValue;
    }
    
    const createdParam = await apiCall(
      `/providers/${selectedProviderForParams.value.id}/parameters`,
      'POST',
      payload
    );
    
    // Add to list
    configParametersList.value.push(createdParam);
    
    // Update provider's parameter count in UI
    if (selectedProviderForParams.value.parameters) {
      selectedProviderForParams.value.parameters.push(createdParam);
    } else {
      selectedProviderForParams.value.parameters = [createdParam];
    }
    
    cancelConfigParamForm();
  } catch (error) {
    logger.error('Failed to create config parameter:', error);
  } finally {
    saving.value = false;
  }
}

async function deleteConfigParameter(parameterId: number, index: number) {
  if (!confirm('Are you sure you want to delete this parameter?')) {
    return;
  }
  
  saving.value = true;
  try {
    await apiCall(`/config-parameters/${parameterId}`, 'DELETE');
    
    // Remove from list
    configParametersList.value.splice(index, 1);
    
    // Update provider's parameter count
    if (selectedProviderForParams.value.parameters) {
      const paramIdx = selectedProviderForParams.value.parameters.findIndex((p: any) => p.id === parameterId);
      if (paramIdx > -1) {
        selectedProviderForParams.value.parameters.splice(paramIdx, 1);
      }
    }
  } catch (error) {
    logger.error('Failed to delete config parameter:', error);
  } finally {
    saving.value = false;
  }
}

// Operation Management
function openOperationDialog() {
  showOperationDialog.value = true;
}

function editOperation(index: number) {
  editingOperationIndex.value = index;
  const op = form.value.operations[index];
  operationForm.value = {
    displayName: op.displayName,
    operationKey: op.operationKey,
    description: op.description || '',
    category: op.category,
    configType: op.configType || '',
    helpUrl: op.helpUrl || '',
    isActive: op.isActive,
    operationOrder: op.operationOrder ?? 0,
    parameters: [...op.parameters]
  };
  showOperationDialog.value = true;
}

function handleOperationDialogBackdropMouseDown(e: MouseEvent) {
  operationDialogBackdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
}

function handleOperationDialogBackdropMouseUp(e: MouseEvent) {
  if (!operationDialogBackdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - operationDialogBackdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - operationDialogBackdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10) {
    closeOperationDialog();
  }
  
  operationDialogBackdropMouseDownPos.value = null;
}

function closeOperationDialog() {
  showOperationDialog.value = false;
  showParameterForm.value = false;
  editingOperationIndex.value = null;
  editingParameterIndex.value = null;
  operationForm.value = {
    displayName: '',
    operationKey: '',
    description: '',
    category: 'General',
    configType: '',
    helpUrl: '',
    isActive: true,
    operationOrder: 0,
    parameters: []
  };
}

async function saveOperation() {
  if (!operationForm.value.displayName) {
    return;
  }
  
  // Operation key is only required for new operations
  if (editingOperationIndex.value === null && !operationForm.value.operationKey) {
    return;
  }

  if (!actualConnectorId.value) {
    alert('Please save connector info first (Step 1)');
    return;
  }

  if (saving.value) return; // Prevent double-click
  saving.value = true;
  try {
    const isEditing = editingOperationIndex.value !== null;
    const existingOperation = isEditing ? form.value.operations[editingOperationIndex.value] : null;
    
    // Find config type ID if specified
    const configTypeId = operationForm.value.configType 
      ? form.value.configTypes.find(ct => ct.displayName === operationForm.value.configType)?.id 
      : undefined;

    let operationId: number;
    
    if (isEditing && existingOperation?.id) {
      // UPDATE existing operation - preserve operationOrder
      const updatePayload: any = {
        displayName: operationForm.value.displayName,
        category: operationForm.value.category,
        operationOrder: operationForm.value.operationOrder,
        isActive: operationForm.value.isActive
      };

      // Only include optional fields if they have values
      if (operationForm.value.description) {
        updatePayload.description = operationForm.value.description;
      }
      if (operationForm.value.helpUrl) {
        updatePayload.helpUrl = operationForm.value.helpUrl;
      }
      if (configTypeId !== undefined) {
        updatePayload.requiredConfigTypeId = configTypeId;
      }

      await apiCall(`/connectors/${actualConnectorId.value}/operations/${existingOperation.id}`, 'PUT', updatePayload);
      operationId = existingOperation.id;
    } else {
      // CREATE new operation - use next available order number
      const maxOrder = form.value.operations.reduce((max, op) => Math.max(max, op.operationOrder ?? 0), 0);
      const createPayload: any = {
        displayName: operationForm.value.displayName,
        operationKey: operationForm.value.operationKey,
        category: operationForm.value.category,
        operationOrder: operationForm.value.operationOrder || maxOrder + 1,
        isActive: operationForm.value.isActive
      };

      // Only include optional fields if they have values
      if (operationForm.value.description) {
        createPayload.description = operationForm.value.description;
      }
      if (operationForm.value.helpUrl) {
        createPayload.helpUrl = operationForm.value.helpUrl;
      }
      if (configTypeId !== undefined) {
        createPayload.requiredConfigTypeId = configTypeId;
      }

      const createdOperation = await apiCall(`/connectors/${actualConnectorId.value}/operations`, 'POST', createPayload);
      operationId = createdOperation.id;
    }

    // Smart parameter sync: only update/create/delete what changed
    if (isEditing) {
      // Get existing parameters from server
      const existingParams = await apiCall(`/connectors/${actualConnectorId.value}/operations/${operationId}/parameters`, 'GET');
      
      // Build maps for efficient lookup
      const existingParamsMap = new Map(existingParams.map((p: any) => [p.apiName, p]));
      const formParamsMap = new Map(operationForm.value.parameters.map((p: any) => [p.apiName, p]));
      
      // 1. Update or Create parameters
      for (let i = 0; i < operationForm.value.parameters.length; i++) {
        const param = operationForm.value.parameters[i];
        const existing = existingParamsMap.get(param.apiName);
        
        const paramPayload: any = {
          apiName: param.apiName,
          displayName: param.displayName,
          dataType: param.dataType,
          parameterOrder: i,
          isRequired: param.isRequired
        };
        
        if (param.description) {
          paramPayload.description = param.description;
        }
        if (param.defaultValue) {
          paramPayload.defaultValue = param.defaultValue;
        }
        if (param.validationRules) {
          paramPayload.validationRules = param.validationRules;
        }
        
        if (existing) {
          // UPDATE existing parameter
          await apiCall(`/parameters/${existing.id}`, 'PUT', paramPayload);
        } else {
          // CREATE new parameter
          await apiCall(`/connectors/${actualConnectorId.value}/operations/${operationId}/parameters`, 'POST', paramPayload);
        }
      }
      
      // 2. Delete parameters that were removed
      for (const existing of existingParams) {
        if (!formParamsMap.has(existing.apiName)) {
          await apiCall(`/parameters/${existing.id}`, 'DELETE');
        }
      }
    } else {
      // Creating new operation - just create all parameters
      for (let i = 0; i < operationForm.value.parameters.length; i++) {
        const param = operationForm.value.parameters[i];
        
        const paramPayload: any = {
          apiName: param.apiName,
          displayName: param.displayName,
          dataType: param.dataType,
          parameterOrder: i,
          isRequired: param.isRequired
        };
        
        if (param.description) {
          paramPayload.description = param.description;
        }
        if (param.defaultValue) {
          paramPayload.defaultValue = param.defaultValue;
        }
        if (param.validationRules) {
          paramPayload.validationRules = param.validationRules;
        }
        
        await apiCall(`/connectors/${actualConnectorId.value}/operations/${operationId}/parameters`, 'POST', paramPayload);
      }
    }

    // Update local form
    if (editingOperationIndex.value !== null) {
      form.value.operations[editingOperationIndex.value] = { 
        id: operationId,
        ...operationForm.value 
      };
    } else {
      form.value.operations.push({ 
        id: operationId,
        ...operationForm.value 
      });
    }
    
    closeOperationDialog();
  } catch (error) {
    logger.error('Failed to save operation:', error);
  } finally {
    saving.value = false;
  }
}

async function removeOperation(index: number) {
  const operation = form.value.operations[index];
  
  // If operation has an ID, it exists in the database - confirm and delete via API
  if (operation.id && actualConnectorId.value) {
    if (!confirm(`Are you sure you want to delete "${operation.displayName}"?`)) {
      return;
    }
    
    try {
      await apiCall(
        `/connectors/${actualConnectorId.value}/operations/${operation.id}`,
        'DELETE'
      );
    } catch (error) {
      logger.error('Failed to delete operation:', error);
      return; // Don't remove from UI if API call fails
    }
  }
  
  // Remove from UI
  form.value.operations.splice(index, 1);
}

// Parameter Management (within operation)
function editParameter(index: number) {
  editingParameterIndex.value = index;
  const param = operationForm.value.parameters[index];
  parameterForm.value = {
    apiName: param.apiName,
    displayName: param.displayName,
    dataType: param.dataType,
    description: param.description || '',
    defaultValue: param.defaultValue || '',
    isRequired: param.isRequired,
    validationRules: param.validationRules ? (typeof param.validationRules === 'string' ? param.validationRules : JSON.stringify(param.validationRules)) : ''
  };
  showParameterForm.value = true;
  
  // Scroll form into view after it renders
  setTimeout(() => {
    const formElement = document.querySelector('.bg-blue-50.border-gray-300');
    if (formElement) {
      formElement.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }
  }, 100);
}

function saveParameter() {
  if (!parameterForm.value.apiName || !parameterForm.value.displayName) {
    return;
  }

  // Parse validation rules if provided
  let parsedValidationRules = null;
  if (parameterForm.value.validationRules && parameterForm.value.validationRules.trim()) {
    try {
      parsedValidationRules = JSON.parse(parameterForm.value.validationRules);
    } catch (e) {
      alert('Invalid JSON in validation rules. Please check your syntax.');
      return;
    }
  }

  const paramData = {
    apiName: parameterForm.value.apiName,
    displayName: parameterForm.value.displayName,
    dataType: parameterForm.value.dataType,
    description: parameterForm.value.description,
    defaultValue: parameterForm.value.defaultValue,
    isRequired: parameterForm.value.isRequired,
    validationRules: parsedValidationRules
  };

  if (editingParameterIndex.value !== null) {
    // Update existing parameter
    operationForm.value.parameters[editingParameterIndex.value] = paramData;
  } else {
    // Add new parameter
    operationForm.value.parameters.push(paramData);
  }
  
  cancelParameterForm();
}

function cancelParameterForm() {
  showParameterForm.value = false;
  editingParameterIndex.value = null;
  parameterForm.value = {
    apiName: '',
    displayName: '',
    dataType: 'String',
    description: '',
    defaultValue: '',
    isRequired: false,
    validationRules: ''
  };
}

function removeOperationParameter(index: number) {
  operationForm.value.parameters.splice(index, 1);
}

function moveParameterUp(index: number) {
  if (index === 0) return;
  const params = operationForm.value.parameters;
  [params[index - 1], params[index]] = [params[index], params[index - 1]];
}

function moveParameterDown(index: number) {
  const params = operationForm.value.parameters;
  if (index === params.length - 1) return;
  [params[index], params[index + 1]] = [params[index + 1], params[index]];
}

function removeParameter(opIndex: number, pIndex: number) {
  form.value.operations[opIndex].parameters.splice(pIndex, 1);
}

// Save Connector
// Load existing connector if editing
onMounted(async () => {
  if (isEditing.value) {
    loading.value = true;
    loadingProgress.value = 0;
    loadingSteps.value.forEach(step => step.status = 'pending');
    
    try {
      // Step 1: Load connector with operations and parameters (all in one call!)
      loadingSteps.value[0].status = 'loading';
      const connector = await apiCall(`/connectors/${connectorId.value}`, 'GET');
      form.value.name = connector.name;
      form.value.mavenArtifactId = connector.mavenArtifactId;
      form.value.version = connector.version;
      form.value.category = connector.category;
      form.value.description = connector.description || '';
      form.value.docUrl = connector.docUrl || '';
      form.value.icon = connector.icon || '';
      form.value.isActive = connector.isActive;
      
      // Store original data for change detection
      originalConnectorData.value = {
        name: connector.name,
        mavenArtifactId: connector.mavenArtifactId,
        version: connector.version,
        category: connector.category,
        description: connector.description || '',
        docUrl: connector.docUrl || '',
        icon: connector.icon || '',
        isActive: connector.isActive
      };
      
      loadingSteps.value[0].status = 'complete';
      loadingProgress.value = 33;

      // Step 2: Load config types
      loadingSteps.value[1].status = 'loading';
      const configTypes = await apiCall(`/connectors/${connectorId.value}/config-types`, 'GET');
      
      form.value.configTypes = configTypes.map((ct: any) => ({
        id: ct.id,
        configTypeKey: ct.configTypeKey,
        displayName: ct.displayName,
        description: ct.description || '',
        providers: ct.providers || []
      }));
      
      loadingSteps.value[1].status = 'complete';
      loadingProgress.value = 66;

      // Step 3: Process operations (already loaded with connector!)
      loadingSteps.value[2].status = 'loading';
      const operations = connector.operations || [];
      
      for (const op of operations) {
        // Find config type name from ID
        let configTypeName = '';
        if (op.requiredConfigTypeId) {
          const ct = form.value.configTypes.find((c: any) => c.id === op.requiredConfigTypeId);
          configTypeName = ct ? ct.displayName : '';
        }

        form.value.operations.push({
          id: op.id,
          displayName: op.displayName,
          operationKey: op.operationKey,
          description: op.description || '',
          category: op.category,
          configType: configTypeName,
          helpUrl: op.helpUrl || '',
          isActive: op.isActive,
          parameters: (op.parameters || []).map((p: any) => ({
            apiName: p.apiName,
            displayName: p.displayName,
            dataType: p.dataType,
            description: p.description || '',
            defaultValue: p.defaultValue || '',
            isRequired: p.isRequired,
            validationRules: p.validationRules
          }))
        });
      }
      
      loadingSteps.value[2].status = 'complete';
      loadingSteps.value[3].status = 'complete';
      loadingProgress.value = 100;
    } catch (e) {
      logger.error('Failed to load connector:', e);
      // Error modal will show automatically
    } finally {
      loading.value = false;
    }
  }
});
</script>

<style scoped>
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.2s ease;
}
.modal-enter-from, .modal-leave-to {
  opacity: 0;
}
</style>

