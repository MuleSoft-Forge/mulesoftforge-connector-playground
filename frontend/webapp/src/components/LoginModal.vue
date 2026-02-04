<template>
  <Teleport to="body">
    <Transition name="modal">
      <div v-if="show" class="fixed inset-0 z-50 flex items-center justify-center p-4" @mousedown.self="handleBackdropMouseDown" @mouseup.self="handleBackdropMouseUp" style="touch-action: none;">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-black/50 backdrop-blur-sm"></div>
        
        <!-- Modal -->
        <div class="relative bg-white rounded-2xl shadow-2xl w-full max-w-md p-8 transform transition-all">
          <!-- Header -->
          <div class="text-center mb-6">
            <div class="w-16 h-16 mx-auto mb-4 bg-gradient-to-br from-mulesoft-cyan to-blue-600 rounded-xl flex items-center justify-center">
              <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
              </svg>
            </div>
            <h2 class="text-2xl font-bold text-mulesoft-dark mb-2">Authentication Required</h2>
            <p class="text-sm text-mulesoft-gray">Enter your API credentials to continue</p>
          </div>

          <!-- Form -->
          <form @submit.prevent="handleLogin" class="space-y-4">
            <!-- Client ID -->
            <div>
              <label for="clientId" class="block text-sm font-medium text-mulesoft-dark mb-1">
                Client ID
              </label>
              <input
                id="clientId"
                v-model="clientId"
                type="text"
                required
                autocomplete="username"
                placeholder="Enter your client ID"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent transition-all"
                :disabled="loading"
              />
            </div>

            <!-- Client Secret -->
            <div>
              <label for="clientSecret" class="block text-sm font-medium text-mulesoft-dark mb-1">
                Client Secret
              </label>
              <input
                id="clientSecret"
                v-model="clientSecret"
                type="password"
                required
                autocomplete="current-password"
                placeholder="Enter your client secret"
                class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent transition-all"
                :disabled="loading"
              />
            </div>

            <!-- Error Message -->
            <div v-if="error" class="p-3 bg-red-50 border border-red-200 rounded-lg text-sm text-red-700">
              {{ error }}
            </div>

            <!-- Submit Button -->
            <button
              type="submit"
              :disabled="loading"
              class="w-full py-3 bg-gradient-to-r from-mulesoft-cyan to-blue-600 text-white font-semibold rounded-lg shadow-md hover:shadow-lg transform hover:-translate-y-0.5 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed disabled:transform-none"
            >
              <span v-if="!loading">Sign In</span>
              <span v-else class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-2 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Authenticating...
              </span>
            </button>
          </form>

          <!-- Footer -->
          <div class="mt-6 text-center text-xs text-mulesoft-gray">
            <p>Need credentials? Contact your MuleSoft administrator.</p>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref } from 'vue';
import { authService } from '../services/authService';
import { API_BASE } from '../config/api';

// Props
defineProps<{
  show: boolean;
}>();

// Emits
const emit = defineEmits<{
  (e: 'authenticated'): void;
  (e: 'close'): void;
}>();

// State
const clientId = ref('');
const clientSecret = ref('');
const error = ref('');
const loading = ref(false);
const backdropMouseDownPos = ref<{ x: number, y: number } | null>(null);

// Methods
const handleLogin = async () => {
  if (loading.value) return; // Prevent double-click
  
  error.value = '';
  loading.value = true;

  try {
    // Set credentials
    authService.setCredentials(clientId.value, clientSecret.value);

    // Test credentials with a simple API call
    const authHeader = authService.getAuthHeader();
    const response = await fetch(`${API_BASE}/connectors`, {
      headers: {
        'Authorization': authHeader
      }
    });

    if (response.ok) {
      // Success! Emit authenticated event
      emit('authenticated');
      resetForm();
    } else if (response.status === 401) {
      error.value = 'Invalid credentials. Please check your Client ID and Secret.';
      authService.logout(); // Clear invalid credentials
    } else {
      error.value = `Authentication failed: ${response.statusText}`;
      authService.logout();
    }
  } catch (e) {
    error.value = 'Connection error. Please check your network and try again.';
    authService.logout();
  } finally {
    loading.value = false;
  }
};

const handleBackdropMouseDown = (e: MouseEvent) => {
  backdropMouseDownPos.value = { x: e.clientX, y: e.clientY };
};

const handleBackdropMouseUp = (e: MouseEvent) => {
  if (!backdropMouseDownPos.value) return;
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - backdropMouseDownPos.value.x);
  const deltaY = Math.abs(e.clientY - backdropMouseDownPos.value.y);
  
  if (deltaX < 10 && deltaY < 10 && !loading.value) {
    emit('close');
  }
  
  backdropMouseDownPos.value = null;
};

const resetForm = () => {
  clientId.value = '';
  clientSecret.value = '';
  error.value = '';
  loading.value = false;
};
</script>

<style scoped>
/* Modal transitions */
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
  transform: scale(0.9);
}
</style>

