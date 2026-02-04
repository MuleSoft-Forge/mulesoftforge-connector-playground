<template>
  <a 
    v-if="url"
    :href="url"
    target="_blank"
    rel="noopener noreferrer"
    :class="linkClasses"
    :title="title || 'View Documentation'"
  >
    <!-- Icon -->
    <svg :class="iconClasses" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
    </svg>
    
    <!-- Text (only for button and text variants) -->
    <span v-if="variant !== 'icon'" :class="textClasses">{{ label || 'Docs' }}</span>
    
    <!-- External link icon (only for button variant) -->
    <svg v-if="variant === 'button'" class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
    </svg>
  </a>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = withDefaults(defineProps<{
  url?: string
  variant?: 'button' | 'icon' | 'text'
  size?: 'sm' | 'md' | 'lg'
  label?: string
  title?: string
}>(), {
  variant: 'text',
  size: 'md',
  label: 'Docs'
})

const linkClasses = computed(() => {
  const base = 'inline-flex items-center gap-2 transition-colors'
  
  if (props.variant === 'button') {
    const sizeClasses = {
      sm: 'px-3 py-1.5 text-sm',
      md: 'px-4 py-2',
      lg: 'px-6 py-3 text-lg'
    }
    return `${base} ${sizeClasses[props.size]} bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark shadow-md`
  }
  
  if (props.variant === 'icon') {
    const sizeClasses = {
      sm: 'p-1',
      md: 'p-2',
      lg: 'p-3'
    }
    return `${base} ${sizeClasses[props.size]} text-gray-400 hover:text-mulesoft-cyan rounded-lg`
  }
  
  // text variant
  const sizeClasses = {
    sm: 'text-xs',
    md: 'text-sm',
    lg: 'text-base'
  }
  return `${base} ${sizeClasses[props.size]} text-mulesoft-cyan hover:text-mulesoft-cyan-dark font-medium`
})

const iconClasses = computed(() => {
  if (props.variant === 'icon') {
    const sizeMap = {
      sm: 'w-4 h-4',
      md: 'w-5 h-5',
      lg: 'w-6 h-6'
    }
    return sizeMap[props.size]
  }
  
  const sizeMap = {
    sm: 'w-3 h-3',
    md: 'w-4 h-4',
    lg: 'w-5 h-5'
  }
  return sizeMap[props.size]
})

const textClasses = computed(() => {
  if (props.variant === 'button') {
    return ''
  }
  return ''
})
</script>

