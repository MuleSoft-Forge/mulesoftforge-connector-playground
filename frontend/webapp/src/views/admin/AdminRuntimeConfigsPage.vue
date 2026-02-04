<template>
  <div class="max-w-7xl mx-auto px-6 py-8">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-mulesoft-dark mb-2">Runtime Configurations</h1>
      <p class="text-mulesoft-gray">Manage runtime configuration instances for connector operations</p>
    </div>

    <!-- Loading State -->
    <div v-if="initialLoading" class="flex justify-center py-12">
      <LoadingSpinner text="Loading connectors..." />
    </div>

    <!-- Connector Grid (when no connector selected) -->
    <div v-else-if="!selectedConnectorId">
      <div class="mb-6">
        <h2 class="text-xl font-semibold text-mulesoft-dark mb-2">Select a Connector</h2>
        <p class="text-mulesoft-gray">Choose a connector to manage its runtime configurations</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div 
          v-for="c in connectors" 
          :key="c.id"
          @click="selectConnector(c.id)"
          class="group relative bg-white rounded-xl p-6 shadow-sm border-2 border-gray-100 hover:shadow-2xl hover:border-mulesoft-cyan transition-all duration-300 cursor-pointer transform hover:-translate-y-2 overflow-hidden"
        >
          <div class="flex items-start space-x-4 mb-4">
            <ConnectorIcon 
              :icon-url="getIconSrc(c.icon)" 
              class="w-16 h-16"
            />
            <div class="flex-1 min-w-0 pt-1">
              <h3 class="text-xl font-bold text-mulesoft-dark group-hover:text-mulesoft-cyan transition-colors truncate mb-1">
                {{ c.name }}
              </h3>
              <p class="text-sm text-mulesoft-gray">v{{ c.version }}</p>
            </div>
          </div>
          
          <p v-if="c.description" class="text-sm text-mulesoft-gray mb-5 line-clamp-3 leading-relaxed">
            {{ c.description }}
          </p>
          
          <!-- Footer with badges -->
          <div class="flex flex-wrap items-center justify-between gap-2 pt-3 border-t border-gray-100">
            <div class="flex flex-wrap gap-2">
              <span class="px-3 py-1.5 bg-purple-50 text-purple-700 text-xs font-semibold rounded-full flex items-center gap-1.5">
                <img :src="manageCenterIcon" alt="Config" class="w-3.5 h-3.5" />
                Config
              </span>
              <span v-if="c.category" class="px-3 py-1.5 bg-gray-100 text-mulesoft-gray text-xs font-semibold rounded-full">
                {{ c.category }}
              </span>
            </div>
            
            <!-- Arrow icon (appears on hover) -->
            <div class="opacity-0 group-hover:opacity-100 transition-opacity">
              <svg class="w-5 h-5 text-mulesoft-cyan" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
              </svg>
            </div>
          </div>
          
          <!-- Subtle gradient overlay on hover -->
          <div class="absolute inset-0 bg-gradient-to-br from-purple-500/5 to-blue-500/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none"></div>
        </div>
      </div>
    </div>

    <!-- Config Types Tree View -->
    <div v-else>
      <!-- Back Button -->
      <div class="mb-6">
        <button
          @click="selectedConnectorId = ''"
          class="inline-flex items-center gap-2 px-4 py-2 text-mulesoft-cyan hover:text-mulesoft-cyan-dark font-medium transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"></path>
          </svg>
          Back to Connector Selection
        </button>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex justify-center py-12">
        <LoadingSpinner text="Loading configurations..." />
      </div>

      <!-- Empty State -->
      <div v-else-if="configTypes.length === 0" class="bg-gray-50 rounded-lg border-2 border-dashed border-gray-300 p-12 text-center">
        <h3 class="text-lg font-semibold text-gray-700 mb-2">No Configuration Types</h3>
        <p class="text-gray-500">This connector has no configuration types defined yet</p>
      </div>

      <!-- Hierarchical Tree: Config Types → Providers → Runtime Configs -->
      <div v-else class="space-y-6">
      <div v-for="configType in configTypes" :key="configType.id" class="bg-white rounded-lg shadow-sm border border-gray-200">
        <!-- Config Type Header -->
        <div 
          @click="toggleConfigType(configType.id)"
          class="flex items-center justify-between p-6 cursor-pointer hover:bg-gray-50 transition-colors"
        >
          <div class="flex items-center gap-3">
            <svg 
              class="w-5 h-5 text-gray-400 transition-transform"
              :class="{ 'rotate-90': expandedConfigTypes.includes(configType.id) }"
              fill="none" 
              stroke="currentColor" 
              viewBox="0 0 24 24"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
            <div>
              <h3 class="text-lg font-semibold text-mulesoft-dark">{{ configType.displayName }}</h3>
              <code class="text-xs text-gray-600">{{ configType.configTypeKey }}</code>
            </div>
          </div>
          <div class="text-sm text-gray-500">
            {{ configType.providers.length }} provider(s)
          </div>
        </div>

        <!-- Providers (Collapsed/Expanded) -->
        <div v-show="expandedConfigTypes.includes(configType.id)" class="border-t border-gray-200 bg-gray-50 p-6">
          <div v-for="provider in configType.providers" :key="provider.id" class="mb-6 last:mb-0">
            <!-- Provider Header -->
            <div class="flex items-center justify-between mb-4">
              <div class="flex items-center gap-3">
                <div class="w-10 h-10 bg-purple-100 rounded-lg flex items-center justify-center flex-shrink-0">
                  <svg class="w-5 h-5 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 3v2m6-2v2M9 19v2m6-2v2M5 9H3m2 6H3m18-6h-2m2 6h-2M7 19h10a2 2 0 002-2V7a2 2 0 00-2-2H7a2 2 0 00-2 2v10a2 2 0 002 2zM9 9h6v6H9V9z"></path>
                  </svg>
                </div>
                <div>
                  <h4 class="font-semibold text-gray-800">{{ provider.displayName }}</h4>
                  <p class="text-xs text-gray-500">{{ provider.description || 'No description' }}</p>
                </div>
              </div>
              <button
                @click="addConfig(provider, configType)"
                class="px-4 py-2 bg-mulesoft-cyan text-white rounded-lg hover:bg-mulesoft-cyan-dark font-medium transition-colors shadow-sm"
              >
                + Add Config
              </button>
            </div>

            <!-- Runtime Configs Table -->
            <div class="bg-white rounded-lg border border-gray-200 overflow-hidden">
              <table class="w-full">
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Name</th>
                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Description</th>
                    <th class="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">Status</th>
                    <th class="px-6 py-3 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">Actions</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-if="getProviderConfigs(configType.id, provider.id).length === 0">
                    <td colspan="4" class="px-6 py-8 text-center text-gray-500 text-sm">
                      No configurations yet. Click "Add Config" to create one.
                    </td>
                  </tr>
                  <tr v-for="config in getProviderConfigs(configType.id, provider.id)" :key="config.id" class="hover:bg-gray-50">
                    <td class="px-6 py-4">
                      <div class="font-medium text-gray-900">{{ config.name }}</div>
                    </td>
                    <td class="px-6 py-4 text-sm text-gray-600">
                      {{ config.description || '—' }}
                    </td>
                    <td class="px-6 py-4">
                      <span 
                        :class="config.isActive 
                          ? 'px-2 py-1 bg-green-100 text-green-700 rounded text-xs font-medium' 
                          : 'px-2 py-1 bg-gray-100 text-gray-600 rounded text-xs font-medium'"
                      >
                        {{ config.isActive ? 'Active' : 'Inactive' }}
                      </span>
                    </td>
                    <td class="px-6 py-4 text-right">
                      <button
                        @click="editConfig(config, provider, configType)"
                        :disabled="loadingConfigId === config.id"
                        class="text-blue-600 hover:text-blue-800 font-medium text-sm mr-4 disabled:opacity-50 disabled:cursor-not-allowed inline-flex items-center gap-1"
                      >
                        <svg v-if="loadingConfigId === config.id" class="animate-spin h-3.5 w-3.5" fill="none" viewBox="0 0 24 24">
                          <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                          <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <span>{{ loadingConfigId === config.id ? 'Loading...' : 'Edit' }}</span>
                      </button>
                      <button
                        @click="openDeleteConfirm(config)"
                        :disabled="loadingConfigId !== null"
                        class="text-red-600 hover:text-red-800 font-medium text-sm disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        Delete
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
      </div>
    </div>

    <!-- Runtime Config Modal -->
    <RuntimeConfigModal
      v-if="showModal"
      ref="modalRef"
      :config="editingConfig"
      :provider="selectedProvider"
      :available-providers="selectedConfigType?.providers || []"
      :configType="selectedConfigType"
      :parameters="providerParameters"
      @save="saveConfig"
      @close="closeModal"
    />

    <!-- Delete Confirmation Modal -->
    <teleport to="body">
      <transition name="modal">
        <div 
          v-if="deletingConfig"
          class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          @mousedown.self="handleDeleteBackdropMouseDown"
          @mouseup.self="handleDeleteBackdropMouseUp"
          style="touch-action: none;"
        >
          <div class="bg-white rounded-xl shadow-2xl max-w-md w-full p-6">
            <h3 class="text-xl font-bold text-gray-900 mb-4">Delete Configuration?</h3>
            <p class="text-gray-600 mb-6">
              Are you sure you want to delete <span class="font-semibold">{{ deletingConfig.name }}</span>? 
              This action cannot be undone.
            </p>
            <div class="flex justify-end gap-3">
              <button
                @click="closeDeleteConfirm"
                :disabled="deleting"
                class="px-4 py-2 border border-gray-300 rounded-lg font-medium hover:bg-gray-50 disabled:opacity-50"
              >
                Cancel
              </button>
              <button
                @click="deleteConfig"
                :disabled="deleting"
                class="px-4 py-2 bg-red-600 text-white rounded-lg font-medium hover:bg-red-700 disabled:opacity-50"
              >
                {{ deleting ? 'Deleting...' : 'Delete' }}
              </button>
            </div>
          </div>
        </div>
      </transition>
    </teleport>
  </div>
</template>

<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import ConnectorIcon from '../../components/ConnectorIcon.vue';
import LoadingSpinner from '../../components/LoadingSpinner.vue';
import RuntimeConfigModal from '../../components/RuntimeConfigModal.vue';
import { useApi } from '../../composables/useApi';
import { PLAYGROUND_MANAGE_ICON } from '../../constants/assets';
import { logger } from '../../utils/logger';

const manageCenterIcon = PLAYGROUND_MANAGE_ICON;

const { apiCall } = useApi();

// In dev mode (port 5173), point to Mule server. In production, use relative paths.
import { MULE_ORIGIN, getAssetUrl } from '../../config/api';

const connectors = ref<any[]>([]);
const selectedConnectorId = ref('');
const configTypes = ref<any[]>([]);
const runtimeConfigs = ref<any[]>([]);
const expandedConfigTypes = ref<number[]>([]);
const initialLoading = ref(true);
const loading = ref(false);

// Modal state
const showModal = ref(false);
const editingConfig = ref<any>(null);
const selectedProvider = ref<any>(null);
const selectedConfigType = ref<any>(null);
const providerParameters = ref<any[]>([]);
const modalRef = ref<InstanceType<typeof RuntimeConfigModal> | null>(null);

// Delete state
const deletingConfig = ref<any>(null);
const deleting = ref(false);
const deleteBackdropMouseDownPos = ref<{ x: number, y: number } | null>(null);

// Loading state for edit
const loadingConfigId = ref<number | null>(null);

onMounted(async () => {
  await loadConnectors();
});

async function loadConnectors() {
  try {
    connectors.value = await apiCall('/connectors?filter=all', 'GET');
  } catch (e) {
    logger.error('Failed to load connectors:', e);
  } finally {
    initialLoading.value = false;
  }
}

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '');
}

function selectConnector(connectorId: number) {
  selectedConnectorId.value = connectorId.toString();
  loadConnectorData();
}

async function loadConnectorData() {
  if (!selectedConnectorId.value) {
    configTypes.value = [];
    runtimeConfigs.value = [];
    return;
  }

  loading.value = true;
  try {
    // Load config types with providers
    configTypes.value = await apiCall(`/connectors/${selectedConnectorId.value}/config-types`, 'GET');
    
    // Load runtime configs for each config type
    runtimeConfigs.value = [];
    for (const configType of configTypes.value) {
      const configs = await apiCall(`/runtime-configs?configTypeId=${configType.id}`, 'GET');
      runtimeConfigs.value.push(...configs);
    }
    
    // Start with everything collapsed
    expandedConfigTypes.value = [];
  } catch (e) {
    logger.error('Failed to load connector data:', e);
  } finally {
    loading.value = false;
  }
}

function toggleConfigType(configTypeId: number) {
  const index = expandedConfigTypes.value.indexOf(configTypeId);
  if (index > -1) {
    expandedConfigTypes.value.splice(index, 1);
  } else {
    expandedConfigTypes.value.push(configTypeId);
  }
}

function getProviderConfigs(configTypeId: number, providerId: number) {
  return runtimeConfigs.value.filter(
    (config: any) => config.configType?.id === configTypeId && config.provider?.id === providerId
  );
}

async function addConfig(provider: any, configType: any) {
  editingConfig.value = null;
  selectedProvider.value = provider;
  selectedConfigType.value = configType;
  
  // Load provider parameters
  try {
    const providerDetail = await apiCall(`/config-types/${configType.id}/providers/${provider.id}`, 'GET');
    providerParameters.value = providerDetail.parameters || [];
    showModal.value = true;
  } catch (e) {
    logger.error('Failed to load provider parameters:', e);
  }
}

async function editConfig(config: any, provider: any, configType: any) {
  // Prevent double-click
  if (loadingConfigId.value !== null) return;
  
  loadingConfigId.value = config.id;
  selectedProvider.value = provider;
  selectedConfigType.value = configType;
  
  // Load full config details
  try {
    const configDetail = await apiCall(`/runtime-configs/${config.id}`, 'GET');
    editingConfig.value = configDetail;
    
    // Load provider parameters
    const providerDetail = await apiCall(`/config-types/${configType.id}/providers/${provider.id}`, 'GET');
    providerParameters.value = providerDetail.parameters || [];
    
    showModal.value = true;
  } catch (e) {
    logger.error('Failed to load config details:', e);
  } finally {
    loadingConfigId.value = null;
  }
}

async function saveConfig(data: any) {
  try {
    if (editingConfig.value) {
      // Update existing config
      await apiCall(`/runtime-configs/${editingConfig.value.id}`, 'PUT', data);
    } else {
      // Create new config
      await apiCall('/runtime-configs', 'POST', data);
    }
    
    // Reload data
    await loadConnectorData();
    closeModal();
  } catch (e) {
    logger.error('Failed to save config:', e);
    // Reset saving state on error so user can retry
    modalRef.value?.closeSavingState();
  }
}

function closeModal() {
  showModal.value = false;
  editingConfig.value = null;
  selectedProvider.value = null;
  selectedConfigType.value = null;
  providerParameters.value = [];
}

function openDeleteConfirm(config: any) {
  deletingConfig.value = config;
}

function handleDeleteBackdropMouseDown(e: MouseEvent) {
  deleteBackdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
}

function handleDeleteBackdropMouseUp(e: MouseEvent) {
  if (!deleteBackdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - deleteBackdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - deleteBackdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10) {
    closeDeleteConfirm();
  }
  
  deleteBackdropMouseDownPos.value = null;
}

function closeDeleteConfirm() {
  deletingConfig.value = null;
}

async function deleteConfig() {
  if (!deletingConfig.value) return;
  
  deleting.value = true;
  try {
    await apiCall(`/runtime-configs/${deletingConfig.value.id}`, 'DELETE');
    await loadConnectorData();
    closeDeleteConfirm();
  } catch (e) {
    logger.error('Failed to delete config:', e);
  } finally {
    deleting.value = false;
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

