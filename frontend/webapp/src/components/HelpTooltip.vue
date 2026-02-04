<template>
  <div class="inline-block" @mouseenter="handleMouseEnter" @mouseleave="handleMouseLeave" ref="buttonRef">
    <!-- Animated Help Button -->
    <button
      type="button"
      :class="[
        'inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full',
        'bg-gradient-to-r from-blue-500 to-mulesoft-cyan',
        'text-white font-semibold text-xs',
        'shadow-lg hover:shadow-xl',
        'transform hover:scale-105',
        'transition-all duration-300',
        'cursor-help',
        'animate-gentle-pulse',
        'border-2 border-white'
      ]"
    >
      <!-- Sparkle Icon (more exciting than ?) -->
      <svg class="w-4 h-4 animate-spin-slow" fill="currentColor" viewBox="0 0 20 20">
        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
      </svg>
      <span class="font-bold">Need Help?</span>
      <!-- Badge -->
      <span class="relative flex h-2 w-2">
        <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-yellow-400 opacity-75"></span>
        <span class="relative inline-flex rounded-full h-2 w-2 bg-yellow-300"></span>
      </span>
    </button>
  </div>
  
  <!-- Tooltip Popover (Teleported to body to avoid any layout issues) -->
  <Teleport to="body">
    <div 
      v-show="showTooltip"
      ref="tooltipRef"
      :style="tooltipStyle"
      class="fixed z-30 bg-white border border-gray-200 rounded-lg shadow-xl p-4 transition-opacity duration-200"
      @mouseenter="showTooltip = true"
      @mouseleave="showTooltip = false"
    >
      <slot>
        <!-- Default slot for custom content -->
        <div class="text-xs text-gray-700">
          {{ content }}
        </div>
      </slot>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const props = withDefaults(defineProps<{
  content?: string
  position?: 'top' | 'bottom' | 'left' | 'right'
  width?: 'sm' | 'md' | 'lg' | 'xl'
}>(), {
  content: '',
  position: 'bottom',
  width: 'md'
})

const showTooltip = ref(false)
const buttonRef = ref<HTMLElement | null>(null)
const tooltipRef = ref<HTMLElement | null>(null)

const tooltipStyle = computed(() => {
  if (!buttonRef.value) return {}
  
  const rect = buttonRef.value.getBoundingClientRect()
  const widths = { sm: 192, md: 256, lg: 320, xl: 384 }
  const width = widths[props.width]
  
  let top = rect.bottom + 8 // Default: below button
  let left = rect.left
  
  if (props.position === 'top') {
    top = rect.top - 8
  } else if (props.position === 'left') {
    top = rect.top
    left = rect.left - width - 8
  } else if (props.position === 'right') {
    top = rect.top
    left = rect.right + 8
  }
  
  return {
    top: `${top}px`,
    left: `${left}px`,
    width: `${width}px`
  }
})

function handleMouseEnter() {
  showTooltip.value = true
}

function handleMouseLeave() {
  showTooltip.value = false
}
</script>

<style scoped>
@keyframes gentle-pulse {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.05);
  }
}

@keyframes spin-slow {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

.animate-gentle-pulse {
  animation: gentle-pulse 3s ease-in-out infinite;
}

.animate-spin-slow {
  animation: spin-slow 8s linear infinite;
}
</style>

