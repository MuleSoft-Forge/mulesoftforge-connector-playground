<template>
  <div class="max-w-7xl mx-auto px-6 py-8">
    <!-- Page Header -->
    <div class="mb-8">
      <h1 class="text-4xl font-bold text-mulesoft-dark mb-2 flex items-center gap-3">
        <img :src="playgroundIcon" alt="Lab" class="w-10 h-10" />
        <span>Connector Lab</span>
      </h1>
      <p class="text-lg text-mulesoft-gray">Test and experiment with active connectors in a live environment</p>
    </div>

    <!-- Loading State -->
    <LoadingSpinner v-if="loading" text="Loading active connectors..." />

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-lg p-4 mb-6">
      <div class="flex items-center">
        <svg class="w-5 h-5 text-red-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
        </svg>
        <span class="text-red-800">{{ error }}</span>
      </div>
    </div>

    <!-- Connectors Grid -->
    <div v-else>
      <!-- Connectors Grid -->
      <div v-if="connectors.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <router-link 
          v-for="c in connectors" 
          :key="c.id"
          :to="`/lab/${c.id}`"
          class="group relative bg-white rounded-xl p-6 shadow-sm border-2 border-gray-100 hover:shadow-2xl hover:border-mulesoft-cyan transition-all duration-300 cursor-pointer transform hover:-translate-y-2 block overflow-hidden"
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
            
            <!-- Play icon (appears on hover) -->
            <div class="opacity-0 group-hover:opacity-100 transition-opacity">
              <svg class="w-5 h-5 text-mulesoft-cyan" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"></path>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
            </div>
          </div>
          
          <!-- Subtle gradient overlay on hover -->
          <div class="absolute inset-0 bg-gradient-to-br from-green-500/5 to-blue-500/5 opacity-0 group-hover:opacity-100 transition-opacity pointer-events-none"></div>
        </router-link>
      </div>

      <!-- Empty State -->
      <div v-else class="text-center py-20 bg-white rounded-xl border border-gray-200">
        <svg class="w-20 h-20 text-gray-300 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path>
        </svg>
        <h3 class="text-lg font-semibold text-mulesoft-dark mb-2">No active connectors</h3>
        <p class="text-mulesoft-gray mb-6">
          There are no active connectors available to test in the lab.
        </p>
        <router-link 
          to="/admin/connectors"
          class="inline-block px-6 py-3 bg-mulesoft-cyan text-white rounded-lg hover:bg-mulesoft-cyan-dark transition-colors"
        >
          Manage Connectors
        </router-link>
      </div>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from 'vue';
import ConnectorIcon from '../components/ConnectorIcon.vue';
import LoadingSpinner from '../components/LoadingSpinner.vue';
import { useApi } from '../composables/useApi';
import { useMarkdown } from '../composables/useMarkdown';
import { PLAYGROUND_LAB_ICON } from '../constants/assets';

const playgroundIcon = PLAYGROUND_LAB_ICON;
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
    connectors.value = await apiCall('/connectors?filter=active', 'GET');
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
