<template>
  <div class="max-w-7xl mx-auto px-6 py-8">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
      <div>
        <h1 class="text-3xl font-bold text-mulesoft-dark mb-2 flex items-center gap-3">
          <img :src="manageCenterIcon" alt="Manage" class="w-10 h-10" />
          <span>Manage Connectors</span>
        </h1>
        <p class="text-mulesoft-gray">Add, edit, and manage MuleSoft connectors</p>
      </div>
      <router-link 
        to="/admin/connectors/new"
        class="inline-flex items-center px-6 py-3 bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark transition-colors shadow-md"
      >
        <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path>
        </svg>
        Add Connector
      </router-link>
    </div>

    <!-- Loading State -->
    <LoadingSpinner v-if="loading" text="Loading connectors..." />

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-6">
      <h2 class="text-red-800 font-semibold mb-2">Error Loading Connectors</h2>
      <p class="text-red-600">{{ error }}</p>
    </div>

    <!-- Connectors Table -->
    <div v-else class="bg-white rounded-xl shadow-sm border border-gray-200 overflow-hidden">
      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50 border-b border-gray-200">
            <tr>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Connector
              </th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Version
              </th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Category
              </th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Operations
              </th>
              <th class="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Status
              </th>
              <th class="px-6 py-4 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Actions
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr 
              v-for="c in connectors" 
              :key="c.id"
              @click="$router.push(`/admin/connectors/${c.id}/edit`)"
              class="hover:bg-gray-50 transition-colors cursor-pointer"
            >
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <ConnectorIcon 
                    :icon-url="getIconSrc(c.icon)" 
                    size="sm"
                  />
                  <div>
                    <div class="font-semibold text-mulesoft-dark">{{ c.name }}</div>
                    <code class="text-xs text-mulesoft-gray">{{ c.mavenArtifactId }}</code>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4 text-sm text-mulesoft-gray">
                v{{ c.version }}
              </td>
              <td class="px-6 py-4">
                <span class="px-3 py-1 bg-gray-100 text-gray-700 text-xs font-medium rounded-full">
                  {{ c.category }}
                </span>
              </td>
              <td class="px-6 py-4 text-sm text-mulesoft-gray">
                {{ c.operationCount ?? 0 }}
              </td>
              <td class="px-6 py-4">
                <span 
                  :class="c.isActive 
                    ? 'bg-green-100 text-green-700 border border-green-300' 
                    : 'bg-gray-100 text-gray-500 border border-gray-300'"
                  class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-semibold"
                >
                  <span :class="c.isActive ? 'w-1.5 h-1.5 bg-green-500 rounded-full' : 'w-1.5 h-1.5 bg-gray-400 rounded-full'"></span>
                  {{ c.isActive ? 'Active' : 'Inactive' }}
                </span>
              </td>
              <td class="px-6 py-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <router-link 
                    :to="`/connectors/${c.id}`"
                    @click.stop
                    class="p-2 text-gray-400 hover:text-mulesoft-cyan transition-colors"
                    title="View Details"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>
                    </svg>
                  </router-link>
                  <router-link
                    :to="`/admin/connectors/${c.id}/edit`"
                    @click.stop
                    class="p-2 text-gray-400 hover:text-blue-600 transition-colors"
                    title="Edit"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                    </svg>
                  </router-link>
                  <button 
                    @click.stop="openDeleteConfirm(c)"
                    class="p-2 text-gray-400 hover:text-red-600 transition-colors"
                    title="Delete"
                  >
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <!-- Empty State -->
      <div v-if="connectors.length === 0" class="text-center py-12">
        <svg class="w-16 h-16 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
        </svg>
        <h3 class="text-lg font-semibold text-mulesoft-dark mb-2">No connectors found</h3>
        <p class="text-mulesoft-gray mb-6">Get started by adding your first connector</p>
        <router-link 
          to="/admin/connectors/new"
          class="inline-flex items-center px-6 py-3 bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark transition-colors"
        >
          Add Connector
        </router-link>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <teleport to="body">
      <transition name="modal">
        <div 
          v-if="showDeleteConfirm"
          class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
          @mousedown.self="handleDeleteBackdropMouseDown"
          @mouseup.self="handleDeleteBackdropMouseUp"
          style="touch-action: none;"
        >
          <div class="bg-white rounded-xl shadow-2xl max-w-md w-full p-6">
            <div class="flex items-start gap-4 mb-4">
              <div class="w-12 h-12 bg-red-100 rounded-full flex items-center justify-center flex-shrink-0">
                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L2.35 16c-.77 1.333.192 3 1.732 3z"></path>
                </svg>
              </div>
              <div>
                <h3 class="text-lg font-bold text-mulesoft-dark mb-2">Delete Connector?</h3>
                <p class="text-sm text-mulesoft-gray mb-4">
                  Are you sure you want to delete <strong>{{ deletingConnector?.name }}</strong>? 
                  This will also delete all associated operations and cannot be undone.
                </p>
              </div>
            </div>
            
            <div class="flex items-center justify-end gap-3">
              <button 
                @click="closeDeleteConfirm"
                class="px-6 py-2 border border-gray-300 text-gray-700 font-medium rounded-lg hover:bg-gray-50 transition-colors"
              >
                Cancel
              </button>
              <button 
                @click="deleteConnector"
                :disabled="deleting"
                class="px-6 py-2 bg-red-600 text-white font-semibold rounded-lg hover:bg-red-700 transition-colors disabled:opacity-50"
              >
                {{ deleting ? 'Deleting...' : 'Delete Connector' }}
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
import LoadingSpinner from '../../components/LoadingSpinner.vue';
import ConnectorIcon from '../../components/ConnectorIcon.vue';
import { useApi } from '../../composables/useApi';
import { PLAYGROUND_MANAGE_ICON } from '../../constants/assets';

const manageCenterIcon = PLAYGROUND_MANAGE_ICON;

type ConnectorSummary = {
  id: number;
  mavenArtifactId: string;
  name: string;
  version: string;
  category: string;
  description?: string;
  docUrl?: string;
  icon?: string;
  isActive: boolean;
  operationCount?: number;
};

const { apiCall } = useApi();

import { MULE_ORIGIN, getAssetUrl } from '../../config/api';

const loading = ref(true);
const error = ref<string | null>(null);
const connectors = ref<ConnectorSummary[]>([]);

const showDeleteConfirm = ref(false);
const deletingConnector = ref<ConnectorSummary | null>(null);
const deleting = ref(false);
const deleteBackdropMouseDownPos = ref<{ x: number, y: number } | null>(null);

async function loadConnectors() {
  loading.value = true;
  error.value = null;
  try {
    connectors.value = await apiCall('/connectors?filter=all', 'GET');
  } catch (e: any) {
    error.value = e?.message || 'Failed to load connectors';
  } finally {
    loading.value = false;
  }
}

function openDeleteConfirm(connector: ConnectorSummary) {
  deletingConnector.value = connector;
  showDeleteConfirm.value = true;
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
  showDeleteConfirm.value = false;
  deletingConnector.value = null;
}

async function deleteConnector() {
  if (!deletingConnector.value) return;
  
  deleting.value = true;
  try {
    await apiCall(`/connectors/${deletingConnector.value.id}`, 'DELETE');
    await loadConnectors();
    closeDeleteConfirm();
  } catch (e: any) {
    // Error modal will show automatically with full details
  } finally {
    deleting.value = false;
  }
}

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '');
}

onMounted(() => {
  loadConnectors();
});
</script>

<style scoped>
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-enter-active .bg-white,
.modal-leave-active .bg-white {
  transition: transform 0.3s ease;
}

.modal-enter-from .bg-white {
  transform: scale(0.95) translateY(20px);
}

.modal-leave-to .bg-white {
  transform: scale(0.95) translateY(20px);
}
</style>

