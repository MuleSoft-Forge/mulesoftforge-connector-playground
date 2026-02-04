<template>
  <teleport to="body">
    <transition name="modal">
      <div 
        v-if="true"
        class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
        @mousedown.self="handleBackdropMouseDown"
        @mouseup.self="handleBackdropMouseUp"
        style="touch-action: none;"
      >
        <div class="bg-white rounded-xl shadow-2xl max-w-2xl w-full max-h-[90vh] overflow-hidden flex flex-col">
          <!-- Header -->
          <div class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white p-6 flex items-center justify-between">
            <div>
              <h3 class="text-2xl font-bold">{{ isEditing ? 'Edit' : 'Add' }} Runtime Configuration</h3>
              <p class="text-purple-100 text-sm mt-1">
                <span v-if="displayProvider">{{ displayProvider.displayName }}</span>
                <span v-if="displayProvider && configType"> - </span>
                <span v-if="configType">{{ configType.displayName }}</span>
              </p>
            </div>
            <button 
              @click="$emit('close')" 
              class="p-2 hover:bg-white/20 rounded-lg transition-colors"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>

          <!-- Form Content -->
          <div class="flex-1 overflow-y-auto p-6 space-y-6">
            <!-- Basic Info -->
            <div class="space-y-4">
              <!-- Config Type (read-only) -->
              <div v-if="configType">
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Config Type
                </label>
                <div class="px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-gray-700">
                  {{ configType.displayName }}
                </div>
              </div>

              <!-- Provider Selection (create mode only) -->
              <div v-if="!isEditing">
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Provider <span class="text-red-500">*</span>
                </label>
                <select 
                  v-model="form.providerId" 
                  required
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                >
                  <option :value="null">Select Provider...</option>
                  <option 
                    v-for="prov in availableProviders" 
                    :key="prov.id" 
                    :value="prov.id"
                  >
                    {{ prov.displayName }}
                  </option>
                </select>
              </div>

              <!-- Provider Display (edit mode) -->
              <div v-else-if="provider">
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Provider
                </label>
                <div class="px-4 py-2 bg-gray-100 border border-gray-300 rounded-lg text-gray-700">
                  {{ provider.displayName }}
                </div>
              </div>

              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Config Name <span class="text-red-500">*</span>
                </label>
                <input 
                  v-model="form.name" 
                  type="text" 
                  required
                  placeholder="e.g., Production OpenAI, Dev Salesforce"
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                />
              </div>

              <div>
                <label class="block text-sm font-semibold text-mulesoft-dark mb-2">
                  Description
                </label>
                <textarea 
                  v-model="form.description" 
                  rows="2"
                  placeholder="Optional description..."
                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                ></textarea>
              </div>

              <div class="flex items-center">
                <label class="flex items-center cursor-pointer">
                  <input 
                    type="checkbox" 
                    v-model="form.isActive" 
                    class="w-4 h-4 text-purple-600 border-gray-300 rounded focus:ring-purple-500"
                  />
                  <span class="ml-2 text-sm font-medium text-gray-700">
                    Active 
                    <span class="text-gray-500">(configuration can be used immediately)</span>
                  </span>
                </label>
              </div>
            </div>

            <!-- Parameters Section -->
            <div class="border-t border-gray-200 pt-6">
              <h4 class="text-lg font-semibold text-mulesoft-dark mb-4 flex items-center gap-2">
                <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"></path>
                </svg>
                Configuration Parameters
                <span v-if="displayProvider" class="text-sm font-normal text-gray-500">
                  ({{ displayProvider.displayName }})
                </span>
              </h4>
              
              <!-- Loading State -->
              <div v-if="loadingParameters" class="text-center py-8">
                <div class="inline-block animate-spin rounded-full h-8 w-8 border-4 border-purple-500 border-t-transparent"></div>
                <p class="mt-2 text-sm text-gray-600">Loading parameters...</p>
              </div>
              
              <!-- No Provider Selected -->
              <div v-else-if="!isEditing && !form.providerId" class="text-center py-8 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
                <svg class="w-12 h-12 mx-auto text-gray-400 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path>
                </svg>
                <p class="text-sm text-gray-600">Select a provider above to configure parameters</p>
              </div>
              
              <!-- Parameters Form -->
              <div v-else class="space-y-4">
                <div v-for="param in visibleParameters" :key="param.id" class="bg-gray-50 rounded-lg p-4 border border-gray-200">
                  <label class="block text-sm font-semibold text-gray-700 mb-2">
                    {{ param.displayName }}
                    <span v-if="param.isRequired" class="text-red-500">*</span>
                    <span v-if="isEncryptedParam(param)" class="ml-2 text-xs bg-yellow-100 text-yellow-800 px-2 py-0.5 rounded">
                      🔒 Encrypted
                    </span>
                  </label>
                  
                  <!-- Special handling for authType: render as dropdown -->
                  <select 
                    v-if="param.apiName === 'authType'"
                    v-model="form.parameters[param.apiName]"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                  >
                    <option value="none">None (No Authentication)</option>
                    <option value="basic">Basic Authentication</option>
                    <option value="oauth2-client-credentials">OAuth 2.0 Client Credentials</option>
                  </select>
                  
                  <!-- Regular input fields -->
                  <input 
                    v-else-if="getInputType(param.dataType) !== 'textarea'"
                    v-model="form.parameters[param.apiName]"
                    :type="isEncryptedParam(param) ? 'password' : getInputType(param.dataType)"
                    :step="getInputType(param.dataType) === 'number' ? 'any' : undefined"
                    :required="param.isRequired"
                    :placeholder="param.defaultValue || `Enter ${param.displayName.toLowerCase()}...`"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
                  />
                  
                  <textarea
                    v-else
                    v-model="form.parameters[param.apiName]"
                    :required="param.isRequired"
                    :placeholder="param.defaultValue || `Enter ${param.displayName.toLowerCase()}...`"
                    rows="3"
                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent resize-none"
                  ></textarea>
                  
                  <p v-if="param.description" class="mt-2 text-xs text-gray-600">
                    {{ param.description }}
                  </p>
                </div>
                
                <div v-if="visibleParameters.length === 0" class="text-center py-4 text-gray-500">
                  No parameters defined for this provider
                </div>
              </div>
            </div>
          </div>

          <!-- Footer Actions -->
          <div class="border-t border-gray-200 p-6 bg-gray-50 flex justify-end gap-3">
            <button
              @click="$emit('close')"
              :disabled="saving"
              class="px-6 py-2 border border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
            >
              Cancel
            </button>
            <button
              @click="save"
              :disabled="!isValid || saving"
              class="px-6 py-2 bg-purple-600 text-white font-semibold rounded-lg hover:bg-purple-700 transition-colors shadow-md disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
            >
              <svg v-if="saving" class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
              </svg>
              <span>{{ saving ? 'Saving...' : (isEditing ? 'Update Config' : 'Create Config') }}</span>
            </button>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script lang="ts" setup>
import { ref, computed, watch } from 'vue';
import { useApi } from '../composables/useApi';
import { logger } from '../utils/logger';

const { apiCall } = useApi();

const props = defineProps<{
  config: any | null;
  provider: any | null; // For edit mode: existing provider
  availableProviders: any[]; // For create mode: list of providers to choose from
  configType: any | null;
  parameters: any[];
}>();

const emit = defineEmits<{
  (e: 'save', data: any): void;
  (e: 'close'): void;
}>();

// Expose method for parent to reset saving state after API call completes
function closeSavingState() {
  saving.value = false;
}

defineExpose({
  closeSavingState
});

const form = ref({
  name: '',
  description: '',
  isActive: false,
  providerId: null as number | null,
  parameters: {} as Record<string, string>
});

const saving = ref(false);
const loadingParameters = ref(false);
const dynamicParameters = ref<any[]>([]);
const backdropMouseDownPos = ref<{ x: number, y: number } | null>(null);

const isEditing = computed(() => !!props.config);

// For display: use selected provider or existing provider
const displayProvider = computed(() => {
  if (isEditing.value) {
    return props.provider;
  }
  return props.availableProviders.find(p => p.id === form.value.providerId);
});

// Parameters to show: dynamic (if provider selected) or passed from parent
const activeParameters = computed(() => {
  if (isEditing.value) {
    return props.parameters;
  }
  return dynamicParameters.value.length > 0 ? dynamicParameters.value : props.parameters;
});

// Helper function to identify authentication parameters
function isAuthParameter(apiName: string): boolean {
  const authParams = [
    'authType',
    'basicUsername', 'basicPassword',
    'oauthClientId', 'oauthClientSecret', 'oauthTokenUrl', 'oauthScopes'
  ];
  return authParams.includes(apiName);
}

// Filter parameters based on selected authType
const visibleParameters = computed(() => {
  const authType = form.value.parameters['authType'] || 'none';
  
  return activeParameters.value.filter(param => {
    // Always show core connection params and authType itself
    if (!isAuthParameter(param.apiName)) return true;
    if (param.apiName === 'authType') return true;
    
    // Show auth-specific params based on selected authType
    if (authType === 'none') return false;
    if (authType === 'basic') return ['basicUsername', 'basicPassword'].includes(param.apiName);
    if (authType === 'oauth2-client-credentials') {
      return ['oauthClientId', 'oauthClientSecret', 'oauthTokenUrl', 'oauthScopes'].includes(param.apiName);
    }
    
    return false;
  });
});

const isValid = computed(() => {
  // Name is required
  if (!form.value.name.trim()) return false;
  
  // Provider is required (for create mode)
  if (!isEditing.value && !form.value.providerId) return false;
  
  // Check required parameters (only validate visible parameters)
  for (const param of visibleParameters.value) {
    if (param.isRequired) {
      const value = form.value.parameters[param.apiName];
      // Handle different data types
      if (param.dataType === 'Number') {
        if (value === null || value === undefined || value === '') return false;
      } else if (param.dataType === 'Boolean') {
        // Boolean is always valid (true/false)
        continue;
      } else {
        // String, Base64, JSON - check for empty string after trim
        if (!value || (typeof value === 'string' && !value.trim())) return false;
      }
    }
  }
  
  return true;
});

// Watch provider selection to load parameters
watch(() => form.value.providerId, async (newProviderId) => {
  if (!newProviderId || isEditing.value || !props.configType) return;
  
  loadingParameters.value = true;
  try {
    // Fetch provider details which includes parameters
    const providerDetail = await apiCall(`/config-types/${props.configType.id}/providers/${newProviderId}`, 'GET');
    dynamicParameters.value = providerDetail.parameters || [];
    
    // Initialize parameter values with defaults
    form.value.parameters = {};
    (providerDetail.parameters || []).forEach((param: any) => {
      form.value.parameters[param.apiName] = param.defaultValue || '';
    });
  } catch (error) {
    logger.error('Failed to load parameters for provider:', error);
  } finally {
    loadingParameters.value = false;
  }
});

// Initialize form when config changes
watch(() => props.config, (config) => {
  if (config) {
    form.value.name = config.name || '';
    form.value.description = config.description || '';
    form.value.isActive = config.isActive || false;
    form.value.providerId = props.provider?.id || null;
    
    // Populate parameters from config
    form.value.parameters = {};
    if (config.parameters && Array.isArray(config.parameters)) {
      config.parameters.forEach((p: any) => {
        form.value.parameters[p.apiName] = p.value || '';
      });
    }
  } else {
    // New config
    form.value.name = '';
    form.value.description = '';
    form.value.isActive = false;
    form.value.providerId = null;
    form.value.parameters = {};
    dynamicParameters.value = [];
  }
}, { immediate: true });

function getInputType(dataType: string): string {
  switch (dataType) {
    case 'Number':
      return 'number';
    case 'Boolean':
      return 'checkbox';
    case 'JSON':
    case 'Base64':
      return 'textarea';
    default:
      return 'text';
  }
}

function isEncryptedParam(param: any): boolean {
  const encryptedNames = ['secret', 'password', 'token', 'apikey', 'key', 'apikeyvalue', 'basicpassword', 'oauthclientsecret'];
  return encryptedNames.some(name => param.apiName.toLowerCase().includes(name));
}

function handleBackdropMouseDown(e: MouseEvent) {
  backdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
}

function handleBackdropMouseUp(e: MouseEvent) {
  if (!backdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - backdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - backdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10) {
    emit('close');
  }
  
  backdropMouseDownPos.value = null;
}

async function save() {
  if (!isValid.value || saving.value) return;
  
  saving.value = true;
  
  try {
    // Convert all parameter values to strings (APIKit expects string values)
    const stringifiedParams: Record<string, string> = {};
    for (const [key, value] of Object.entries(form.value.parameters)) {
      stringifiedParams[key] = value != null ? String(value) : '';
    }
    
    const payload: any = {
      name: form.value.name.trim(),
      providerId: form.value.providerId || props.provider?.id, // Include for both create and update
      parameters: stringifiedParams,
      isActive: form.value.isActive
    };
    
    if (form.value.description.trim()) {
      payload.description = form.value.description.trim();
    }
    
    emit('save', payload);
    // Note: Parent component must call closeSavingState() after API completes
  } catch (error) {
    saving.value = false;
    throw error;
  }
}
</script>

<style scoped>
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.2s ease;
}
.modal-enter-from, .modal-leave-to {
  opacity: 0;
}
</style>

