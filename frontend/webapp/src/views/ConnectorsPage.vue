<template>
  <div class="max-w-7xl mx-auto px-6 py-8">
    <!-- Page Header -->
    <div class="mb-8">
      <h1 class="text-4xl font-bold text-mulesoft-dark mb-2 flex items-center gap-3">
        <img :src="connectorsIcon" alt="Library" class="w-10 h-10" />
        <span>Connector Library</span>
      </h1>
      <p class="text-lg text-mulesoft-gray">Discover and explore MuleSoft connectors for your integration needs</p>
    </div>

    <!-- Loading State -->
    <LoadingSpinner v-if="loading" text="Loading connectors..." />

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
      <div class="flex items-center">
        <svg class="w-5 h-5 text-red-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <span class="text-red-800">{{ error }}</span>
      </div>
    </div>

    <!-- Connector Grid -->
    <div v-else>
      <!-- Connectors Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <router-link 
          v-for="c in connectors" 
          :key="c.id"
          :to="`/connectors/${c.id}`"
          class="group relative bg-white rounded-xl p-6 shadow-sm border-2 border-gray-100 hover:shadow-2xl hover:border-mulesoft-cyan transition-all duration-300 cursor-pointer transform hover:-translate-y-2 block overflow-hidden"
        >
          <!-- Active status indicator (top right) -->
          <div class="absolute top-4 right-4">
            <span 
              :class="c.isActive 
                ? 'bg-green-100 text-green-700 border border-green-300' 
                : 'bg-gray-100 text-gray-500 border border-gray-300'"
              class="px-2 py-1 rounded-full text-xs font-semibold flex items-center gap-1"
            >
              <span :class="c.isActive ? 'w-1.5 h-1.5 bg-green-500 rounded-full' : 'w-1.5 h-1.5 bg-gray-400 rounded-full'"></span>
              {{ c.isActive ? 'Active' : 'Inactive' }}
            </span>
          </div>
          
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
          
          <div 
            v-if="c.description" 
            class="text-sm text-mulesoft-gray mb-5 line-clamp-3 leading-relaxed markdown-content"
            v-html="parseMarkdown(c.description)"
          ></div>
          
          <!-- Footer with badges -->
          <div class="flex flex-wrap items-center justify-between gap-2 pt-3 border-t border-gray-100">
            <div class="flex flex-wrap gap-2">
              <span class="px-3 py-1.5 bg-blue-50 text-mulesoft-cyan text-xs font-semibold rounded-full flex items-center gap-1">
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                </svg>
                {{ c.operationCount ?? 0 }}
              </span>
              <span v-if="c.category" class="px-3 py-1.5 bg-gray-100 text-mulesoft-gray text-xs font-semibold rounded-full">
                {{ c.category }}
              </span>
            </div>
            
            <!-- View arrow (appears on hover) -->
            <div class="opacity-0 group-hover:opacity-100 transition-opacity">
              <svg class="w-5 h-5 text-mulesoft-cyan" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
              </svg>
            </div>
          </div>
          
          <!-- Subtle gradient overlay on hover -->
          <div class="absolute inset-0 bg-gradient-to-br from-mulesoft-cyan/5 to-blue-500/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none"></div>
        </router-link>
      </div>

      <!-- Empty State -->
      <div v-if="connectors.length === 0 && !loading" class="text-center py-20 bg-white rounded-xl border border-gray-200">
        <svg class="w-20 h-20 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
        </svg>
        <h3 class="text-lg font-semibold text-mulesoft-dark mb-2">No connectors available</h3>
        <p class="text-mulesoft-gray mb-6">
          No connectors have been loaded into the system yet.
        </p>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref, computed } from 'vue';
import ConnectorIcon from '../components/ConnectorIcon.vue';
import LoadingSpinner from '../components/LoadingSpinner.vue';
import { useApi } from '../composables/useApi';
import { useMarkdown } from '../composables/useMarkdown';
import { PLAYGROUND_BROWSE_ICON } from '../constants/assets';

const connectorsIcon = PLAYGROUND_BROWSE_ICON;
const { parseMarkdown } = useMarkdown();

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

// In dev mode (port 5173), point to Mule server. In production, use relative paths.
import { MULE_ORIGIN, getAssetUrl } from '../config/api';

const loading = ref(true);
const error = ref<string | null>(null);
const connectors = ref<ConnectorSummary[]>([]);

onMounted(async () => {
  try {
    connectors.value = await apiCall('/connectors?filter=all', 'GET');
  } catch (e: any) {
    error.value = e?.message || 'Failed to load connectors';
  } finally {
    loading.value = false;
  }
});

function getIconSrc(icon?: string) {
  return getAssetUrl(icon || '');
}
</script>

<style scoped>
.line-clamp-3 {
  display: -webkit-box;
  -webkit-line-clamp: 3;
  line-clamp: 3;
  -webkit-box-orient: vertical;
  overflow: hidden;
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
