<template>
  <div class="min-h-screen bg-gray-50">
    <header class="bg-white border-b border-gray-200 shadow-sm sticky top-0 z-50">
      <div class="max-w-7xl mx-auto px-6 py-4">
        <div class="flex items-center justify-between">
          <div class="flex items-center space-x-8">
            <!-- Logo -->
            <router-link to="/" class="flex items-center space-x-3 hover:opacity-80 transition-opacity">
              <img 
                v-if="logoDataUrl" 
                :src="logoDataUrl" 
                alt="MuleSoft" 
                class="h-8"
              />
              <div 
                v-else 
                class="w-10 h-10 bg-gradient-to-br from-mulesoft-cyan to-mulesoft-cyan-dark rounded-full flex items-center justify-center"
              >
                <span class="text-white font-bold text-lg">M</span>
              </div>
              <span class="text-xl font-bold text-mulesoft-dark hidden sm:inline">Connector Playground</span>
            </router-link>
            
            <!-- Desktop Navigation -->
            <nav class="hidden md:flex space-x-1">
              <router-link 
                to="/" 
                class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent"
                active-class="!text-mulesoft-cyan !border-mulesoft-cyan"
                exact
              >
                Home
              </router-link>
              <router-link 
                to="/browse" 
                class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent"
                active-class="!text-mulesoft-cyan !border-mulesoft-cyan"
              >
                Browse
              </router-link>
              <router-link 
                to="/lab" 
                class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent"
                active-class="!text-mulesoft-cyan !border-mulesoft-cyan"
              >
                Lab
              </router-link>
              <router-link 
                to="/flows" 
                class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent"
                active-class="!text-mulesoft-cyan !border-mulesoft-cyan"
              >
                Mule Flows
              </router-link>
              <router-link 
                to="/stats" 
                class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent"
                active-class="!text-mulesoft-cyan !border-mulesoft-cyan"
              >
                Stats
              </router-link>
              
              <!-- Admin Dropdown -->
              <div class="relative" @mouseenter="showAdmin = true" @mouseleave="showAdmin = false">
                <button 
                  class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent flex items-center"
                  :class="{ '!text-mulesoft-cyan !border-mulesoft-cyan': $route.path.startsWith('/admin') }"
                >
                  Admin
                  <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
                  </svg>
                </button>
                <div 
                  v-show="showAdmin"
                  class="absolute top-full left-0 w-56 bg-white rounded-lg shadow-lg border border-gray-200 pt-2 pb-2"
                >
                  <router-link 
                    to="/admin/connectors" 
                    class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
                  >
                    Connectors
                  </router-link>
                  <router-link 
                    to="/admin/runtime-configs" 
                    class="block px-4 py-2 text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
                  >
                    Runtime Configs
                  </router-link>
                  <div class="border-t border-gray-100 my-1"></div>
                  <button
                    @click="showResetModal = true; showAdmin = false"
                    class="w-full text-left px-4 py-2 text-red-600 hover:bg-red-50 transition-colors font-medium flex items-center gap-2"
                  >
                    <span>💣</span>
                    <span>Reset Database</span>
                    <span class="text-xs">🚀</span>
                  </button>
                </div>
              </div>
              
              <router-link 
                to="/help" 
                class="px-4 py-2 text-gray-600 hover:text-mulesoft-cyan transition-colors border-b-2 border-transparent"
                active-class="!text-mulesoft-cyan !border-mulesoft-cyan"
              >
                Help
              </router-link>
            </nav>
          </div>
          
          <div class="flex items-center gap-3">
            <!-- User Indicator (when authenticated) -->
            <div v-if="isAuthenticated" class="hidden md:flex items-center gap-2 px-3 py-1.5 bg-green-50 border border-green-200 rounded-lg">
              <div class="w-2 h-2 bg-green-500 rounded-full"></div>
              <span class="text-xs font-medium text-green-700">Authenticated</span>
              <button 
                @click="handleLogout"
                class="ml-2 text-xs text-green-600 hover:text-green-800 font-medium"
                title="Sign Out"
              >
                Logout
              </button>
            </div>
            
            <!-- Login Button (when not authenticated) -->
            <button 
              v-else
              @click="showLoginModal = true"
              class="hidden md:inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-mulesoft-cyan to-blue-600 text-white text-sm font-semibold rounded-lg hover:shadow-lg transition-all"
            >
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
              </svg>
              Sign In
            </button>
            
            <!-- Mobile Menu Button -->
            <button 
              @click="mobileMenuOpen = !mobileMenuOpen"
              class="md:hidden p-2 rounded-lg hover:bg-gray-100 transition-colors"
            >
              <svg v-if="!mobileMenuOpen" class="w-6 h-6 text-mulesoft-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path>
              </svg>
              <svg v-else class="w-6 h-6 text-mulesoft-dark" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
          </div>
        </div>
      </div>
      
      <!-- Mobile Navigation Drawer -->
      <transition name="slide-down">
        <div v-if="mobileMenuOpen" class="md:hidden border-t border-gray-200 bg-white">
          <nav class="px-6 py-4 space-y-2">
            <router-link 
              to="/" 
              @click="mobileMenuOpen = false"
              class="block px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
              active-class="bg-blue-50 !text-mulesoft-cyan font-medium"
              exact
            >
              Home
            </router-link>
            <router-link 
              to="/browse" 
              @click="mobileMenuOpen = false"
              class="block px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
              active-class="bg-blue-50 !text-mulesoft-cyan font-medium"
            >
              Browse
            </router-link>
            <router-link 
              to="/lab" 
              @click="mobileMenuOpen = false"
              class="block px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
              active-class="bg-blue-50 !text-mulesoft-cyan font-medium"
            >
              Lab
            </router-link>
            <router-link 
              to="/flows" 
              @click="mobileMenuOpen = false"
              class="block px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
              active-class="bg-blue-50 !text-mulesoft-cyan font-medium"
            >
              Mule Flows
            </router-link>
            <router-link 
              to="/stats" 
              @click="mobileMenuOpen = false"
              class="block px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
              active-class="bg-blue-50 !text-mulesoft-cyan font-medium"
            >
              Stats
            </router-link>
            
            <!-- Mobile Admin Submenu -->
            <div class="border-t border-gray-100 pt-2 mt-2">
              <div class="px-4 py-2 text-xs font-semibold text-gray-500 uppercase">Admin</div>
              <router-link 
                to="/admin/connectors" 
                @click="mobileMenuOpen = false"
                class="block px-4 py-2 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors text-sm"
              >
                Connectors
              </router-link>
              <router-link 
                to="/admin/runtime-configs" 
                @click="mobileMenuOpen = false"
                class="block px-4 py-2 rounded-lg text-gray-600 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors text-sm"
              >
                Runtime Configs
              </router-link>
              <button
                @click="showResetModal = true; mobileMenuOpen = false"
                class="w-full text-left px-4 py-2 rounded-lg text-red-600 hover:bg-red-50 transition-colors text-sm font-medium flex items-center gap-2"
              >
                <span>💣</span>
                <span>Reset Database</span>
                <span class="text-xs">🚀</span>
              </button>
            </div>
            
            <!-- Help Link -->
            <div class="border-t border-gray-100 pt-2 mt-2">
              <router-link 
                to="/help" 
                @click="mobileMenuOpen = false"
                class="block px-4 py-3 rounded-lg text-gray-700 hover:bg-gray-50 hover:text-mulesoft-cyan transition-colors"
                active-class="bg-blue-50 !text-mulesoft-cyan font-medium"
              >
                Help
              </router-link>
            </div>
            
            <!-- Auth Section -->
            <div class="border-t border-gray-100 pt-2 mt-2">
              <div v-if="isAuthenticated" class="px-4 py-3">
                <div class="flex items-center gap-2 mb-2">
                  <div class="w-2 h-2 bg-green-500 rounded-full"></div>
                  <span class="text-xs font-medium text-green-700">Authenticated</span>
                </div>
                <button 
                  @click="handleLogout(); mobileMenuOpen = false"
                  class="w-full px-4 py-2 bg-red-50 text-red-600 rounded-lg text-sm font-medium hover:bg-red-100 transition-colors"
                >
                  Sign Out
                </button>
              </div>
              <button 
                v-else
                @click="showLoginModal = true; mobileMenuOpen = false"
                class="w-full mx-4 px-4 py-3 bg-gradient-to-r from-mulesoft-cyan to-blue-600 text-white rounded-lg font-semibold hover:shadow-lg transition-all flex items-center justify-center gap-2"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                </svg>
                Sign In
              </button>
            </div>
          </nav>
        </div>
      </transition>
    </header>
    
    <main>
      <router-view v-slot="{ Component, route }">
        <transition name="fade" mode="out-in">
          <component :is="Component" :key="route.path" />
        </transition>
      </router-view>
    </main>
    
    <!-- Global API Error Modal -->
    <ApiErrorModal />
    
    <!-- Global Reset Database Modal -->
    <ResetDatabaseModal 
      :show="showResetModal" 
      @close="showResetModal = false"
    />
    
    <!-- Global Login Modal -->
    <LoginModal 
      :show="showLoginModal" 
      @authenticated="handleAuthenticated"
      @close="showLoginModal = false"
    />
  </div>
</template>

<style>
/* Page transition animations */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.fade-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* Mobile menu slide down animation */
.slide-down-enter-active,
.slide-down-leave-active {
  transition: all 0.3s ease;
}

.slide-down-enter-from {
  opacity: 0;
  transform: translateY(-10px);
}

.slide-down-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>

<script lang="ts" setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { MULESOFT_SHIELD } from './constants/assets';
import ApiErrorModal from './components/ApiErrorModal.vue';
import ResetDatabaseModal from './components/ResetDatabaseModal.vue';
import LoginModal from './components/LoginModal.vue';
import { showLoginModal as globalShowLoginModal } from './composables/useApi';
import { authService, isAuthenticated } from './services/authService';

const router = useRouter();
const logoDataUrl = MULESOFT_SHIELD;
const showAdmin = ref(false);
const mobileMenuOpen = ref(false);
const showResetModal = ref(false);

// Use the global login modal state from useApi
const showLoginModal = globalShowLoginModal;

// Store the route user was trying to access
let pendingRoute: string | null = null;

// Handle successful authentication
const handleAuthenticated = () => {
  showLoginModal.value = false;
  
  // If user was trying to navigate somewhere, complete that navigation
  if (pendingRoute) {
    router.push(pendingRoute);
    pendingRoute = null;
  }
  // No else needed - components will reactively update now that auth is available
};

// Handle logout
const handleLogout = () => {
  if (confirm('Are you sure you want to sign out?')) {
    authService.logout();
    // Navigate to landing page
    router.push('/');
  }
};

// Listen for navigation attempts (set by router guard)
router.beforeEach((to, from) => {
  if (!to.meta.public && showLoginModal.value) {
    pendingRoute = to.path;
  }
});
</script>
