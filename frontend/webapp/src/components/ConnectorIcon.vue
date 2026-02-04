<template>
  <div class="flex-shrink-0">
    <img 
      v-if="dataUrl" 
      :src="dataUrl" 
      alt="Connector icon" 
      :class="['rounded-full object-cover shadow-md', sizeClass]"
    />
    <div 
      v-else 
      :class="['rounded-full bg-gradient-to-br from-mulesoft-cyan to-mulesoft-cyan-dark flex items-center justify-center shadow-md', sizeClass]"
    >
      <span class="text-white text-2xl">🔌</span>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { computed } from 'vue';
import { useImageWithCorrectMimeType } from '../composables/useImageWithCorrectMimeType';

const props = withDefaults(defineProps<{
  iconUrl?: string;
  size?: 'sm' | 'md' | 'lg';
}>(), {
  size: 'lg'
});

const sizeClass = computed(() => {
  switch (props.size) {
    case 'sm': return 'w-10 h-10';
    case 'md': return 'w-12 h-12';
    case 'lg': return 'w-14 h-14';
    default: return 'w-14 h-14';
  }
});

const iconUrlComputed = computed(() => props.iconUrl);
const { dataUrl } = useImageWithCorrectMimeType(iconUrlComputed);
</script>
