<template>
  <div class="max-w-7xl mx-auto px-6 py-8">
    <div class="mb-8">
      <h1 class="text-3xl font-bold text-mulesoft-dark mb-2">Admin Dashboard</h1>
      <p class="text-mulesoft-gray">Manage connectors and operations</p>
    </div>

    <!-- Admin Cards -->
    <div class="grid grid-cols-1 md:grid-cols-1 gap-6 max-w-2xl">
      <!-- Connectors -->
      <router-link 
        to="/admin/connectors"
        class="group bg-white rounded-xl p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:border-mulesoft-cyan transition-all"
      >
        <div class="flex items-center gap-6">
          <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-cyan-500 rounded-lg flex items-center justify-center group-hover:scale-110 transition-transform flex-shrink-0">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"></path>
            </svg>
          </div>
          <div>
            <h3 class="text-xl font-semibold text-mulesoft-dark mb-2 group-hover:text-mulesoft-cyan transition-colors">
              Connectors
            </h3>
            <p class="text-mulesoft-gray">Add, edit, and manage connectors and their operations</p>
          </div>
        </div>
      </router-link>

      <!-- Runtime Configs -->
      <router-link 
        to="/admin/runtime-configs"
        class="group bg-white rounded-xl p-8 shadow-sm border border-gray-100 hover:shadow-xl hover:border-mulesoft-cyan transition-all"
      >
        <div class="flex items-center gap-6">
          <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-indigo-500 rounded-lg flex items-center justify-center group-hover:scale-110 transition-transform flex-shrink-0">
            <svg class="w-8 h-8 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path>
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path>
            </svg>
          </div>
          <div>
            <h3 class="text-xl font-semibold text-mulesoft-dark mb-2 group-hover:text-mulesoft-cyan transition-colors">
              Runtime Configs
            </h3>
            <p class="text-mulesoft-gray">Manage runtime configuration instances for executing connector operations</p>
          </div>
        </div>
      </router-link>

      <!-- Danger Zone: Reset Database -->
      <div class="border-4 border-red-200 rounded-xl overflow-hidden">
        <div class="bg-red-50 px-4 py-2 border-b-2 border-red-200">
          <p class="text-red-800 font-semibold text-sm">⚠️ DANGER ZONE</p>
        </div>
        <button 
          @click="showResetModal = true"
          class="w-full group bg-white p-8 hover:bg-red-50 transition-all text-left"
        >
          <div class="flex items-center gap-6">
            <div class="w-16 h-16 bg-gradient-to-br from-red-600 to-orange-600 rounded-lg flex items-center justify-center group-hover:scale-110 transition-transform flex-shrink-0">
              <span class="text-3xl">💣</span>
            </div>
            <div>
              <h3 class="text-xl font-semibold text-red-700 mb-2 group-hover:text-red-800 transition-colors">
                Reset Database 🚀
              </h3>
              <p class="text-red-600 text-sm">
                Nuclear option: Drop everything, rebuild schema, and reseed data
              </p>
              <p class="text-red-500 text-xs mt-1 font-medium">
                Development & Testing Only!
              </p>
            </div>
          </div>
        </button>
      </div>
    </div>

    <!-- Reset Database Modal -->
    <ResetDatabaseModal 
      :show="showResetModal" 
      @close="showResetModal = false"
    />
  </div>
</template>

<script lang="ts" setup>
import { ref } from 'vue';
import ResetDatabaseModal from '../components/ResetDatabaseModal.vue';

// Admin dashboard with navigation to CRUD pages
const showResetModal = ref(false);
</script>

