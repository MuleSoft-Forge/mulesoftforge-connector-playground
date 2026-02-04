<template>
  <div class="bg-gradient-to-r from-blue-50 to-indigo-50 rounded-lg p-3 border border-blue-100">
    <div class="flex items-center justify-between mb-3">
      <h3 class="text-xs font-semibold text-gray-700 flex items-center">
        <svg class="w-4 h-4 mr-1 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Execution History
      </h3>
      <button 
        @click="refresh"
        :disabled="loading"
        class="text-blue-600 hover:text-blue-800 transition-colors disabled:opacity-50"
        title="Refresh"
      >
        <svg class="w-3.5 h-3.5" :class="{ 'animate-spin': loading }" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
        </svg>
      </button>
    </div>

    <!-- Loading State -->
    <div v-if="loading && !executions.length" class="text-center py-6">
      <svg class="animate-spin h-5 w-5 text-blue-600 mx-auto" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      <p class="text-xs text-gray-500 mt-2">Loading history...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-50 border border-red-200 rounded p-2 text-xs text-red-700">
      {{ error }}
    </div>

    <!-- Empty State -->
    <div v-else-if="!executions.length" class="text-center py-6">
      <svg class="w-8 h-8 text-gray-300 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
      </svg>
      <p class="text-xs text-gray-500">No executions yet</p>
    </div>

    <!-- Execution List -->
    <div v-else class="space-y-2 max-h-96 overflow-y-auto">
      <div 
        v-for="execution in executions" 
        :key="execution.executionId"
        class="bg-white rounded-md border border-gray-200 overflow-hidden"
      >
        <!-- Summary Row -->
        <button
          @click="toggleExpand(execution.executionId)"
          class="w-full px-2 py-2 flex items-center justify-between hover:bg-gray-50 transition-colors text-left"
        >
          <div class="flex items-center gap-2 flex-1 min-w-0">
            <!-- Status Badge -->
            <span 
              :class="[
                'flex-shrink-0 w-1.5 h-1.5 rounded-full',
                execution.status === 'success' ? 'bg-green-500' : 
                execution.status === 'error' ? 'bg-red-500' : 
                'bg-yellow-500'
              ]"
            />
            
            <!-- Status Text -->
            <span 
              :class="[
                'text-[11px] font-medium truncate',
                execution.status === 'success' ? 'text-green-700' : 
                execution.status === 'error' ? 'text-red-700' : 
                'text-yellow-700'
              ]"
            >
              {{ execution.status === 'success' ? '✓ Success' : execution.status === 'error' ? '✗ Error' : '◷ Running' }}
            </span>

            <!-- Duration -->
            <span v-if="execution.durationMs" class="text-[10px] text-gray-500">
              {{ formatDuration(execution.durationMs) }}
            </span>

            <!-- Timestamp -->
            <span class="text-[10px] text-gray-400 truncate">
              {{ formatRelativeTime(execution.executionStartedAt) }}
            </span>
          </div>

          <!-- Expand Icon -->
          <svg 
            class="w-3 h-3 text-gray-400 flex-shrink-0 transition-transform"
            :class="{ 'rotate-90': expandedExecutionId === execution.executionId }"
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </button>

        <!-- Expanded Details -->
        <div 
          v-if="expandedExecutionId === execution.executionId"
          class="border-t border-gray-200 bg-gray-50 p-2 space-y-2"
        >
          <!-- Loading Details -->
          <div v-if="loadingDetails" class="text-center py-2">
            <svg class="animate-spin h-4 w-4 text-blue-600 mx-auto" fill="none" viewBox="0 0 24 24">
              <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
              <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          </div>

          <!-- Details Content -->
          <div v-else-if="executionDetails[execution.executionId]" class="space-y-2">
            <div>
              <p class="text-[10px] font-semibold text-gray-700 mb-1">Request Parameters</p>
              <pre class="text-[9px] bg-white border border-gray-200 rounded p-1.5 overflow-x-auto font-mono text-gray-900 max-h-32">{{ JSON.stringify(executionDetails[execution.executionId].requestPayload?.parameters || {}, null, 2) }}</pre>
            </div>

            <div v-if="execution.status === 'success' && executionDetails[execution.executionId].responsePayload">
              <p class="text-[10px] font-semibold text-gray-700 mb-1">Response (Preview)</p>
              <pre class="text-[9px] bg-white border border-gray-200 rounded p-1.5 overflow-x-auto font-mono text-gray-900 max-h-32">{{ formatResponsePreview(executionDetails[execution.executionId].responsePayload) }}</pre>
            </div>

            <div v-else-if="execution.status === 'error' && executionDetails[execution.executionId].errorMessage">
              <p class="text-[10px] font-semibold text-red-700 mb-1">Error Details</p>
              <div class="text-[10px] bg-red-50 border border-red-200 rounded p-1.5">
                <p class="font-medium text-red-800">{{ executionDetails[execution.executionId].errorType }}</p>
                <p class="text-red-700 mt-0.5">{{ executionDetails[execution.executionId].errorMessage }}</p>
              </div>
            </div>

            <!-- Action Button -->
            <button
              @click="loadToResponse(executionDetails[execution.executionId])"
              class="w-full px-2 py-1.5 bg-blue-600 text-white text-[11px] font-medium rounded hover:bg-blue-700 transition-colors flex items-center justify-center gap-1"
            >
              <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/>
              </svg>
              Load to Response Panel
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Pagination -->
    <div v-if="executions.length > 0" class="flex items-center justify-between mt-3 pt-3 border-t border-blue-200">
      <button
        @click="previousPage"
        :disabled="currentPage === 0 || loading"
        class="text-xs text-blue-600 hover:text-blue-800 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
      >
        ← Previous
      </button>
      <span class="text-[10px] text-gray-500">
        Page {{ currentPage + 1 }}
      </span>
      <button
        @click="nextPage"
        :disabled="executions.length < pageSize || loading"
        class="text-xs text-blue-600 hover:text-blue-800 disabled:opacity-30 disabled:cursor-not-allowed transition-colors"
      >
        Next →
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'
import { apiCall } from '../composables/useApi'

interface ExecutionLogSummary {
  executionId: string
  operationId: number
  operationKey: string
  connectorId: number
  connectorName: string
  mavenArtifactId: string
  runtimeConfigId: number
  runtimeConfigName: string
  status: string
  executionStartedAt: string
  executionCompletedAt: string | null
  durationMs: number | null
  httpStatusCode: number | null
  sourceIp: string | null
}

interface ExecutionLogDetail {
  executionId: string
  operationId: number
  operationKey: string
  runtimeConfigId: number
  connectorId: number
  mavenArtifactId: string
  status: string
  executionStartedAt: string
  executionCompletedAt: string | null
  durationMs: number | null
  httpStatusCode: number | null
  sourceIp: string
  userAgent: string
  requestPayload: any
  responsePayload: any
  errorType: string | null
  errorMessage: string | null
  errorCode: string | null
  errorDescription: string | null
}

const props = defineProps<{
  operationId: number
  latestExecutionId: string | null
}>()

const emit = defineEmits<{
  loadToResponse: [execution: ExecutionLogDetail]
}>()

const executions = ref<ExecutionLogSummary[]>([])
const executionDetails = ref<Record<string, ExecutionLogDetail>>({})
const expandedExecutionId = ref<string | null>(null)
const loading = ref(false)
const loadingDetails = ref(false)
const error = ref<string | null>(null)
const currentPage = ref(0)
const pageSize = 10

async function fetchHistory() {
  if (!props.operationId) return
  
  try {
    loading.value = true
    error.value = null
    const offset = currentPage.value * pageSize
    const result = await apiCall(
      `/execution-logs?operationId=${props.operationId}&limit=${pageSize}&offset=${offset}`,
      'GET'
    )
    executions.value = result
  } catch (err: any) {
    error.value = err.message || 'Failed to load execution history'
    executions.value = []
  } finally {
    loading.value = false
  }
}

async function fetchDetails(executionId: string) {
  if (executionDetails.value[executionId]) return // Already loaded
  
  try {
    loadingDetails.value = true
    const detail = await apiCall(`/execution-logs/${executionId}`, 'GET')
    executionDetails.value[executionId] = detail
  } catch (err: any) {
    error.value = err.message || 'Failed to load execution details'
  } finally {
    loadingDetails.value = false
  }
}

function toggleExpand(executionId: string) {
  if (expandedExecutionId.value === executionId) {
    expandedExecutionId.value = null
  } else {
    expandedExecutionId.value = executionId
    fetchDetails(executionId)
  }
}

function loadToResponse(execution: ExecutionLogDetail) {
  emit('loadToResponse', execution)
  expandedExecutionId.value = null // Collapse after loading
}

function formatDuration(ms: number): string {
  if (ms < 1000) return `${ms}ms`
  return `${(ms / 1000).toFixed(1)}s`
}

function formatRelativeTime(timestamp: string): string {
  const date = new Date(timestamp)
  const now = new Date()
  const diffMs = now.getTime() - date.getTime()
  const diffSec = Math.floor(diffMs / 1000)
  const diffMin = Math.floor(diffSec / 60)
  const diffHour = Math.floor(diffMin / 60)
  const diffDay = Math.floor(diffHour / 24)

  if (diffSec < 60) return 'just now'
  if (diffMin < 60) return `${diffMin}m ago`
  if (diffHour < 24) return `${diffHour}h ago`
  return `${diffDay}d ago`
}

function formatResponsePreview(response: any): string {
  const preview = JSON.stringify(response, null, 2)
  if (preview.length > 300) {
    return preview.substring(0, 300) + '\n...'
  }
  return preview
}

function nextPage() {
  currentPage.value++
  fetchHistory()
  expandedExecutionId.value = null
}

function previousPage() {
  if (currentPage.value > 0) {
    currentPage.value--
    fetchHistory()
    expandedExecutionId.value = null
  }
}

function refresh() {
  currentPage.value = 0
  fetchHistory()
}

// Watch for operation changes
watch(() => props.operationId, () => {
  currentPage.value = 0
  expandedExecutionId.value = null
  executionDetails.value = {}
  fetchHistory()
})

// Watch for new executions (auto-refresh)
watch(() => props.latestExecutionId, (newId) => {
  if (newId && currentPage.value === 0) {
    // Only auto-refresh if on first page
    fetchHistory()
  }
})

// Initial load
onMounted(() => {
  if (props.operationId) {
    fetchHistory()
  }
})
</script>

