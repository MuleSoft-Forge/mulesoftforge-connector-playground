<template>
  <div>
    <div class="min-h-screen bg-gradient-to-b from-gray-50 to-white py-12">
      <div class="max-w-7xl mx-auto px-6">
        <!-- Page Header -->
      <div class="text-center mb-12">
        <div class="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-br from-white via-blue-50 to-cyan-50 rounded-3xl shadow-2xl mb-6 p-4 ring-4 ring-blue-100 ring-opacity-50">
          <img :src="MULESOFT_SHIELD" alt="MuleSoft" class="w-full h-full object-contain transform hover:scale-110 transition-transform duration-300" />
        </div>
        <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          Mule Flow Documentation
        </h1>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          View detailed Mule flow diagrams, XML configurations, and technical architecture for each connector
        </p>
      </div>

      <!-- Flow Documentation Cards -->
      <div class="bg-white rounded-2xl shadow-lg border border-gray-200 p-8">
        <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
          <!-- MuleSoftForge Connector Playground App -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/mulesoft-connector-playground.html`, 'MuleSoftForge Connector Playground')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-cyan-50 to-blue-50 border-2 border-cyan-200 rounded-lg hover:border-cyan-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="MULESOFT_SHIELD" alt="MuleSoft" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">MuleSoftForge Connector Playground</div>
                <div class="text-xs text-gray-600">Main application flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-cyan-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- MCP -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/mcp.html`, 'MCP Server')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-blue-50 to-cyan-50 border-2 border-blue-200 rounded-lg hover:border-blue-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="MCP_ICON" alt="MCP" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">MCP Server</div>
                <div class="text-xs text-gray-600">Model Context Protocol flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-blue-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- A2A -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/a2a.html`, 'A2A Server')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-purple-50 to-pink-50 border-2 border-purple-200 rounded-lg hover:border-purple-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="A2A_ICON" alt="A2A" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">A2A Server</div>
                <div class="text-xs text-gray-600">Agent-to-Agent flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-purple-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- Agentforce -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/agentforce.html`, 'Agentforce')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-200 rounded-lg hover:border-green-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="AGENTFORCE_ICON" alt="Agentforce" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">Agentforce</div>
                <div class="text-xs text-gray-600">Salesforce Agent flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-green-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- Einstein AI -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/einsteinai.html`, 'Einstein AI')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-indigo-50 to-blue-50 border-2 border-indigo-200 rounded-lg hover:border-indigo-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="EINSTEIN_AI_ICON" alt="Einstein AI" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">Einstein AI</div>
                <div class="text-xs text-gray-600">Einstein AI flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-indigo-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- IDP -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/idp.html`, 'IDP')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-yellow-50 to-orange-50 border-2 border-yellow-200 rounded-lg hover:border-yellow-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="IDP_ICON" alt="IDP" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">IDP</div>
                <div class="text-xs text-gray-600">Document Processing flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-yellow-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- Amazon Bedrock -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/bedrock.html`, 'Amazon Bedrock')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-emerald-50 to-teal-50 border-2 border-emerald-200 rounded-lg hover:border-emerald-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="BEDROCK_ICON" alt="Amazon Bedrock" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">Amazon Bedrock</div>
                <div class="text-xs text-gray-600">Foundation models and agents</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-emerald-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- OpenAI -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/openai.html`, 'OpenAI')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-slate-50 to-gray-50 border-2 border-slate-200 rounded-lg hover:border-slate-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="OPENAI_ICON" alt="OpenAI" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">OpenAI</div>
                <div class="text-xs text-gray-600">GPT models and assistants</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-slate-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- Google Gemini -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/gemini.html`, 'Google Gemini')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-blue-50 to-indigo-50 border-2 border-blue-200 rounded-lg hover:border-blue-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="GEMINI_ICON" alt="Google Gemini" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">Google Gemini</div>
                <div class="text-xs text-gray-600">Multimodal AI models</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-blue-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- MuleSoft Inference -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/index.html`, 'MuleSoft Inference')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-pink-50 to-rose-50 border-2 border-pink-200 rounded-lg hover:border-pink-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="MULESOFT_INFERENCE_ICON" alt="MuleSoft Inference" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">MuleSoft Inference</div>
                <div class="text-xs text-gray-600">Inference API flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-pink-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- MuleSoft Vectors -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/index.html#_execute_vectors`, 'MuleSoft Vectors')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-teal-50 to-cyan-50 border-2 border-teal-200 rounded-lg hover:border-teal-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="MULESOFT_VECTORS_ICON" alt="MuleSoft Vectors" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">MuleSoft Vectors</div>
                <div class="text-xs text-gray-600">Vector DB flows</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-teal-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>

          <!-- Global Elements -->
          <button
            @click="openDoc(`${baseUrl}/webapp/mulesoft-connector-playground-app/global-elements.html`, 'Global Elements')"
            class="w-full text-left flex items-center justify-between p-4 bg-gradient-to-r from-gray-50 to-slate-50 border-2 border-gray-200 rounded-lg hover:border-gray-400 hover:shadow-md transition-all group cursor-pointer"
          >
            <div class="flex items-center gap-3">
              <div class="w-10 h-10 bg-white rounded-lg shadow-sm flex items-center justify-center p-1.5">
                <img :src="MULESOFT_SHIELD" alt="Global Elements" class="w-full h-full object-contain" />
              </div>
              <div>
                <div class="font-semibold text-gray-900">Global Elements</div>
                <div class="text-xs text-gray-600">Shared configurations</div>
              </div>
            </div>
            <svg class="w-5 h-5 text-gray-600 group-hover:translate-x-1 transition-transform" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
            </svg>
          </button>
        </div>
      </div>
    </div>
    </div>

    <!-- Documentation Modal -->
    <Teleport to="body">
    <Transition name="modal">
      <div
        v-if="showDocsModal"
        class="fixed inset-0 z-[9999] flex items-center justify-center bg-black bg-opacity-50 p-4"
        @mousedown.self="handleDocsBackdropMouseDown"
        @mouseup.self="handleDocsBackdropMouseUp"
        style="touch-action: none;"
      >
        <div class="relative bg-white rounded-xl shadow-2xl w-full h-full max-w-7xl max-h-[90vh] flex flex-col">
          <!-- Modal Header -->
          <div class="flex items-center justify-between p-4 border-b border-gray-200">
            <h3 class="text-xl font-bold text-gray-900">Technical Documentation</h3>
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
              :src="selectedDocUrl"
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
  </div>
</template>

<script setup lang="ts">
import { computed, ref } from 'vue';
import { 
  MULESOFT_SHIELD,
  MCP_ICON, 
  A2A_ICON, 
  AGENTFORCE_ICON, 
  EINSTEIN_AI_ICON, 
  IDP_ICON, 
  MULESOFT_INFERENCE_ICON, 
  MULESOFT_VECTORS_ICON,
  BEDROCK_ICON,
  OPENAI_ICON,
  GEMINI_ICON
} from '../constants/assets';

// Determine base URL for documentation links
import { API_BASE } from '../config/api';
const baseUrl = computed(() => API_BASE);

// Modal state for documentation viewer
const showDocsModal = ref(false);
const docsBackdropMouseDownPos = ref<{ x: number, y: number } | null>(null);
const selectedDocUrl = ref('');
const selectedDocTitle = ref('');

function openDoc(url: string, title: string) {
  selectedDocUrl.value = url;
  selectedDocTitle.value = title;
  showDocsModal.value = true;
}

function handleDocsBackdropMouseDown(e: MouseEvent) {
  docsBackdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
}

function handleDocsBackdropMouseUp(e: MouseEvent) {
  if (!docsBackdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - docsBackdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - docsBackdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10) {
    closeDocsModal();
  }
  
  docsBackdropMouseDownPos.value = null;
}

function closeDocsModal() {
  showDocsModal.value = false;
  selectedDocUrl.value = '';
  selectedDocTitle.value = '';
}
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

.modal-enter-active .relative,
.modal-leave-active .relative {
  transition: transform 0.3s ease;
}

.modal-enter-from .relative,
.modal-leave-to .relative {
  transform: scale(0.95);
}
</style>

