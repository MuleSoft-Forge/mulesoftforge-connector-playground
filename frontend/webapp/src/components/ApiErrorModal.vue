<template>
  <teleport to="body">
    <transition name="modal">
      <div 
        v-if="showErrorModal && apiError"
        class="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4"
        @mousedown.self="handleBackdropMouseDown"
        @mouseup.self="handleBackdropMouseUp"
        style="touch-action: none;"
      >
        <div class="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden flex flex-col">
          <!-- Header -->
          <div class="bg-red-600 text-white p-6 flex items-center justify-between">
            <div class="flex items-center gap-3">
              <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
              </svg>
              <div>
                <h3 class="text-2xl font-bold">MuleSoft API Error</h3>
                <p class="text-sm text-red-100">HTTP {{ apiError.status }} {{ apiError.statusText }}</p>
              </div>
            </div>
            <button @click="showErrorModal = false" class="p-2 hover:bg-red-700 rounded-lg transition-colors">
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>

          <!-- Error Details -->
          <div class="flex-1 overflow-y-auto p-6 space-y-6 bg-gray-50">
            <!-- Timestamp -->
            <div>
              <h4 class="text-xs font-semibold text-gray-500 uppercase mb-1">Timestamp</h4>
              <p class="text-sm font-mono text-gray-800">{{ apiError.timestamp }}</p>
            </div>

            <!-- Endpoint -->
            <div>
              <h4 class="text-xs font-semibold text-gray-500 uppercase mb-1">API Endpoint</h4>
              <div class="flex items-center gap-2 flex-wrap">
                <span 
                  class="px-3 py-1 text-xs font-bold rounded"
                  :class="{
                    'bg-blue-100 text-blue-700': apiError.method === 'GET',
                    'bg-green-100 text-green-700': apiError.method === 'POST',
                    'bg-yellow-100 text-yellow-700': apiError.method === 'PUT',
                    'bg-red-100 text-red-700': apiError.method === 'DELETE'
                  }"
                >
                  {{ apiError.method }}
                </span>
                <code class="text-sm bg-gray-100 px-3 py-1 rounded border border-gray-300 break-all">{{ apiError.endpoint }}</code>
              </div>
            </div>

            <!-- Request Payload -->
            <div v-if="apiError.requestPayload">
              <div class="flex items-center justify-between mb-2">
                <h4 class="text-xs font-semibold text-gray-500 uppercase">Request Payload</h4>
                <button 
                  @click="copyToClipboard(apiError.requestPayload)"
                  class="px-3 py-1 text-xs bg-gray-200 hover:bg-gray-300 rounded transition-colors"
                >
                  📋 Copy JSON
                </button>
              </div>
              <pre class="bg-gray-900 text-green-400 p-4 rounded-lg text-xs overflow-x-auto font-mono border border-gray-700 shadow-inner">{{ formatJson(apiError.requestPayload) }}</pre>
            </div>

            <!-- Response Body -->
            <div>
              <div class="flex items-center justify-between mb-2">
                <h4 class="text-xs font-semibold text-gray-500 uppercase">Response Body</h4>
                <button 
                  @click="copyToClipboard(apiError.responseBody)"
                  class="px-3 py-1 text-xs bg-gray-200 hover:bg-gray-300 rounded transition-colors"
                >
                  📋 Copy JSON
                </button>
              </div>
              <pre class="bg-gray-900 text-red-400 p-4 rounded-lg text-xs overflow-x-auto font-mono border border-red-700 shadow-inner">{{ formatJson(apiError.responseBody) }}</pre>
            </div>
          </div>

          <!-- Footer -->
          <div class="border-t border-gray-200 p-4 bg-white flex justify-end gap-3">
            <button 
              @click="reportIssue"
              class="px-4 py-2 bg-gray-200 text-gray-700 font-semibold rounded-lg hover:bg-gray-300 transition-colors"
            >
              📝 Report Issue
            </button>
            <button 
              @click="showErrorModal = false"
              class="px-6 py-2 bg-gray-600 text-white font-semibold rounded-lg hover:bg-gray-700 transition-colors"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </transition>
  </teleport>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import { showErrorModal, apiError } from '../composables/useApi';

const backdropMouseDownPos = ref<{ x: number, y: number } | null>(null);

function handleBackdropMouseDown(e: MouseEvent) {
  backdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
}

function handleBackdropMouseUp(e: MouseEvent) {
  if (!backdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - backdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - backdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10) {
    showErrorModal.value = false;
  }
  
  backdropMouseDownPos.value = null;
}

function formatJson(data: any): string {
  if (typeof data === 'string') {
    try {
      return JSON.stringify(JSON.parse(data), null, 2);
    } catch {
      return data;
    }
  }
  return JSON.stringify(data, null, 2);
}

function copyToClipboard(data: any) {
  const text = formatJson(data);
  navigator.clipboard.writeText(text).then(() => {
    alert('✓ Copied to clipboard!');
  });
}

function reportIssue() {
  const issueBody = `
## API Error Report

**Timestamp:** ${apiError.value?.timestamp}
**Endpoint:** ${apiError.value?.method} ${apiError.value?.endpoint}
**Status:** ${apiError.value?.status} ${apiError.value?.statusText}

### Request Payload
\`\`\`json
${formatJson(apiError.value?.requestPayload)}
\`\`\`

### Response Body
\`\`\`json
${formatJson(apiError.value?.responseBody)}
\`\`\`
`;
  
  // Open GitHub issue or copy to clipboard
  navigator.clipboard.writeText(issueBody).then(() => {
    alert('✓ Issue details copied to clipboard! Paste into your bug tracking system.');
  });
}
</script>

<style scoped>
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.2s ease;
}

.modal-enter-from, .modal-leave-to {
  opacity: 0;
}

.modal-enter-active .bg-white,
.modal-leave-active .bg-white {
  transition: transform 0.2s ease;
}

.modal-enter-from .bg-white,
.modal-leave-to .bg-white {
  transform: scale(0.95);
}
</style>

