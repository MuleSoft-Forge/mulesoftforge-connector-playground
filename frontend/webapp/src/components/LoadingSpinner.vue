<template>
  <div class="flex flex-col items-center justify-center py-20">
    <!-- Spinning MuleSoft Shield -->
    <div class="w-24 h-24 mb-4 animate-spin-slow">
      <img 
        v-if="logoDataUrl"
        :src="logoDataUrl" 
        alt="MuleSoft" 
        class="w-full h-full object-contain"
      />
      <div v-else class="w-full h-full bg-gradient-to-br from-mulesoft-cyan to-mulesoft-cyan-dark rounded-full flex items-center justify-center">
        <span class="text-white text-3xl font-bold">M</span>
      </div>
    </div>
    
    <!-- Loading text -->
    <p v-if="text" class="text-mulesoft-gray font-medium animate-pulse">{{ text }}</p>
  </div>
</template>

<script lang="ts" setup>
import { MULESOFT_SHIELD } from '../constants/assets';

defineProps<{
  text?: string;
}>();

const logoDataUrl = MULESOFT_SHIELD;
</script>

<style scoped>
@keyframes spin-slow {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin-slow {
  animation: spin-slow 2s linear infinite;
}
</style>

