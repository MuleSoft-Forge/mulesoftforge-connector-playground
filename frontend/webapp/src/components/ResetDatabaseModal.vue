<template>
  <Teleport to="body">
    <div v-if="show" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[99999] p-4">
      <div class="bg-white rounded-2xl shadow-2xl max-w-md w-full overflow-hidden border-4 border-red-500 animate-pulse-border">
        <!-- Header with dramatic warning -->
        <div class="bg-gradient-to-r from-red-600 to-orange-600 p-6 text-white">
          <div class="flex items-center justify-center gap-3 mb-2">
            <span class="text-5xl animate-bounce">💣</span>
            <h2 class="text-2xl font-bold">NUCLEAR OPTION</h2>
            <span class="text-5xl animate-bounce animation-delay-150">🚀</span>
          </div>
          <p class="text-center text-sm opacity-90">Database Reset Protocol</p>
        </div>

        <!-- Content -->
        <div class="p-6">
          <div v-if="!confirmed" class="space-y-4">
            <!-- Warning message -->
            <div class="bg-red-50 border-2 border-red-200 rounded-lg p-4">
              <p class="text-red-900 font-semibold mb-2">⚠️ This action will:</p>
              <ul class="text-red-800 text-sm space-y-1 ml-4">
                <li>💥 Obliterate all data (CASCADE style!)</li>
                <li>🔥 Burn the schema to the ground</li>
                <li>🏗️ Rebuild everything from scratch</li>
                <li>🌱 Reseed with fresh connector data</li>
              </ul>
            </div>

            <div class="bg-yellow-50 border-2 border-yellow-200 rounded-lg p-4">
              <p class="text-yellow-900 text-sm">
                <strong>🎯 Pro Tip:</strong> This is great for development, terrible for production. 
                Please tell me you're not running this in prod... 🙈
              </p>
            </div>

            <!-- Token input -->
            <div>
              <label for="reset-token" class="block text-sm font-semibold text-gray-700 mb-2">
                🔑 Enter Reset Token (If you have it, you know what you're doing)
              </label>
              <input
                id="reset-token"
                v-model="resetToken"
                type="password"
                placeholder="super-secret-token-here"
                class="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-red-500 focus:outline-none transition-colors"
                @keyup.enter="confirmReset"
              />
            </div>

            <!-- Action buttons -->
            <div class="flex gap-3 pt-2">
              <button
                @click="emit('close')"
                class="flex-1 px-4 py-3 bg-gray-100 text-gray-700 rounded-lg font-semibold hover:bg-gray-200 transition-colors"
              >
                🏃 Nevermind, I'm Out
              </button>
              <button
                @click="confirmReset"
                :disabled="!resetToken"
                class="flex-1 px-4 py-3 bg-gradient-to-r from-red-600 to-orange-600 text-white rounded-lg font-semibold hover:from-red-700 hover:to-orange-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all transform hover:scale-105"
              >
                💣 Launch Reset
              </button>
            </div>
          </div>

          <!-- Loading state -->
          <div v-else-if="loading" class="text-center py-8">
            <div class="text-6xl mb-4 animate-spin">🌀</div>
            <p class="text-lg font-semibold text-gray-700">Destroying and rebuilding...</p>
            <p class="text-sm text-gray-500 mt-2">{{ loadingMessage }}</p>
          </div>

          <!-- Success state -->
          <div v-else-if="success" class="text-center py-8">
            <div class="text-6xl mb-4 animate-bounce">🎉</div>
            <h3 class="text-2xl font-bold text-green-600 mb-2">Mission Accomplished!</h3>
            <div class="bg-green-50 border-2 border-green-200 rounded-lg p-4 mb-4 text-left">
              <p class="text-sm text-gray-700 mb-2">
                <strong>Status:</strong> <span class="text-green-600">{{ result?.status }}</span>
              </p>
              <p class="text-sm text-gray-700 mb-2">
                <strong>Message:</strong> {{ result?.message }}
              </p>
              <p class="text-sm text-gray-700 mb-2">
                <strong>Version:</strong> {{ result?.version }}
              </p>
              <p class="text-sm text-gray-600">
                <strong>Timestamp:</strong> {{ formatTimestamp(result?.timestamp) }}
              </p>
            </div>
            <p class="text-sm text-gray-600 mb-4">
              Your database is now fresh, clean, and ready to party! 🚀
            </p>
            <button
              @click="closeAndReload"
              class="px-6 py-3 bg-gradient-to-r from-green-600 to-blue-600 text-white rounded-lg font-semibold hover:from-green-700 hover:to-blue-700 transition-all transform hover:scale-105"
            >
              🎊 Awesome, Close This
            </button>
          </div>

          <!-- Error state -->
          <div v-else-if="error" class="text-center py-8">
            <div class="text-6xl mb-4">😱</div>
            <h3 class="text-2xl font-bold text-red-600 mb-2">Houston, We Have a Problem</h3>
            <div class="bg-red-50 border-2 border-red-200 rounded-lg p-4 mb-4">
              <p class="text-sm text-red-800">{{ error }}</p>
            </div>
            <div class="flex gap-3">
              <button
                @click="emit('close')"
                class="flex-1 px-4 py-3 bg-gray-100 text-gray-700 rounded-lg font-semibold hover:bg-gray-200 transition-colors"
              >
                Close
              </button>
              <button
                @click="retryReset"
                class="flex-1 px-4 py-3 bg-red-600 text-white rounded-lg font-semibold hover:bg-red-700 transition-colors"
              >
                🔄 Try Again
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { API_BASE } from '../config/api';

interface Props {
  show: boolean;
}

interface ResetDatabaseResponse {
  status: string;
  message: string;
  version: string;
  timestamp: string;
}

defineProps<Props>();

const emit = defineEmits<{
  (e: 'close'): void;
}>();

const resetToken = ref('');
const confirmed = ref(false);
const loading = ref(false);
const loadingMessage = ref('Dropping tables...');
const success = ref(false);
const error = ref('');
const result = ref<ResetDatabaseResponse | null>(null);

const loadingMessages = [
  'Dropping tables... 💥',
  'Nuking the schema... 🔥',
  'Rebuilding from scratch... 🏗️',
  'Seeding fresh data... 🌱',
  'Almost there... 🚀'
];

async function confirmReset() {
  if (!resetToken.value || loading.value) return;

  confirmed.value = true;
  loading.value = true;
  error.value = '';
  
  // Cycle through loading messages
  let messageIndex = 0;
  const messageInterval = setInterval(() => {
    messageIndex = (messageIndex + 1) % loadingMessages.length;
    loadingMessage.value = loadingMessages[messageIndex];
  }, 800);

  try {
    const response = await fetch(`${API_BASE}/_ops/reset-db`, {
      method: 'POST',
      headers: {
        'X-Reset-Token': resetToken.value,
        'Accept': 'application/json'
      }
    });

    clearInterval(messageInterval);

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({ detail: response.statusText }));
      throw new Error(errorData.detail || errorData.title || `Reset failed: ${response.status}`);
    }

    result.value = await response.json();
    success.value = true;
  } catch (err: any) {
    clearInterval(messageInterval);
    error.value = err.message || 'Failed to reset database. Check your token and try again!';
  } finally {
    loading.value = false;
  }
}

function retryReset() {
  confirmed.value = false;
  success.value = false;
  error.value = '';
  result.value = null;
}

function formatTimestamp(timestamp: string | undefined): string {
  if (!timestamp) return '';
  return new Date(timestamp).toLocaleString();
}

function closeAndReload() {
  emit('close');
  // Reload the page to fetch fresh data after database reset
  window.location.reload();
}
</script>

<style scoped>
@keyframes pulse-border {
  0%, 100% {
    border-color: rgb(239, 68, 68);
  }
  50% {
    border-color: rgb(251, 146, 60);
  }
}

.animate-pulse-border {
  animation: pulse-border 2s ease-in-out infinite;
}

.animation-delay-150 {
  animation-delay: 0.15s;
}
</style>

