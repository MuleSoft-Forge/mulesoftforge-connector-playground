<template>
  <div class="flex items-center justify-center min-h-[400px] bg-gradient-to-br from-blue-50 to-indigo-50 rounded-xl p-8">
    <div class="max-w-3xl w-full">
      <!-- Race Track -->
      <div class="flex justify-center mb-6">
        <svg viewBox="0 0 800 300" class="w-full max-w-2xl">
          <!-- Track outline -->
          <rect x="50" y="50" width="700" height="200" rx="100" ry="100" 
                fill="none" stroke="#e5e7eb" stroke-width="40" stroke-dasharray="20,10" />
          
          <!-- Progress track (blue gradient bar) -->
          <rect x="50" y="50" width="700" height="200" rx="100" ry="100" 
                fill="none" stroke="url(#progressGradient)" stroke-width="40" 
                :stroke-dasharray="`${progress * 21} 2100`"
                stroke-linecap="round"
                class="transition-all duration-500" />
          
          <!-- Gradient definition -->
          <defs>
            <linearGradient id="progressGradient" x1="0%" y1="0%" x2="100%" y2="0%">
              <stop offset="0%" style="stop-color:#00A3E0;stop-opacity:1" />
              <stop offset="100%" style="stop-color:#0077A3;stop-opacity:1" />
            </linearGradient>
          </defs>
          
          <!-- Checkpoints -->
          <!-- Start/Finish -->
          <g transform="translate(150, 50)">
            <circle cx="0" cy="0" r="20" :fill="steps[0]?.status === 'complete' ? '#10b981' : steps[0]?.status === 'loading' ? '#3b82f6' : '#d1d5db'" />
            <text v-if="steps[0]?.status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
            <text v-else-if="steps[0]?.status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
            <text x="0" y="50" text-anchor="middle" font-size="14" fill="#6b7280" class="font-medium">{{ steps[0]?.label || 'Start' }}</text>
          </g>
          
          <!-- Checkpoint 2 (top-right) -->
          <g transform="translate(750, 150)">
            <circle cx="0" cy="0" r="20" :fill="steps[1]?.status === 'complete' ? '#10b981' : steps[1]?.status === 'loading' ? '#3b82f6' : '#d1d5db'" />
            <text v-if="steps[1]?.status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
            <text v-else-if="steps[1]?.status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
            <text x="60" y="6" text-anchor="start" font-size="14" fill="#6b7280" class="font-medium">{{ steps[1]?.label || 'Step 2' }}</text>
          </g>
          
          <!-- Checkpoint 3 (bottom-right) -->
          <g transform="translate(650, 250)">
            <circle cx="0" cy="0" r="20" :fill="steps[2]?.status === 'complete' ? '#10b981' : steps[2]?.status === 'loading' ? '#3b82f6' : '#d1d5db'" />
            <text v-if="steps[2]?.status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
            <text v-else-if="steps[2]?.status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
            <text x="0" y="-30" text-anchor="middle" font-size="14" fill="#6b7280" class="font-medium">{{ steps[2]?.label || 'Step 3' }}</text>
          </g>
          
          <!-- Checkpoint 4 (bottom-left) -->
          <g transform="translate(150, 250)">
            <circle cx="0" cy="0" r="20" :fill="steps[3]?.status === 'complete' ? '#10b981' : steps[3]?.status === 'loading' ? '#3b82f6' : '#d1d5db'" />
            <text v-if="steps[3]?.status === 'complete'" x="0" y="6" text-anchor="middle" fill="white" font-size="20">✓</text>
            <text v-else-if="steps[3]?.status === 'loading'" x="0" y="8" text-anchor="middle" fill="white" font-size="24">🏁</text>
            <text x="0" y="-30" text-anchor="middle" font-size="14" fill="#6b7280" class="font-medium">{{ steps[3]?.label || 'Step 4' }}</text>
          </g>
          
          <!-- Spinning Mule Shield in Center -->
          <foreignObject x="300" y="75" width="200" height="150">
            <div xmlns="http://www.w3.org/1999/xhtml" class="flex items-center justify-center h-full">
              <LoadingSpinner text="" />
            </div>
          </foreignObject>
          
          <!-- Max the Mule (animated position) -->
          <g :transform="carPosition">
            <image 
              :href="maxTheMule" 
              x="-50" 
              y="-50" 
              width="100" 
              height="100"
              class="transition-transform duration-300"
            />
          </g>
        </svg>
      </div>
      
      <!-- Current Status Text -->
      <div class="text-center mt-6">
        <p class="text-lg font-semibold text-mulesoft-cyan">
          {{ currentLoadingText }}
        </p>
        <p class="text-sm text-gray-500 mt-1">{{ Math.round(progress) }}% complete</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { MAX_THE_MULE } from '../constants/assets'
import LoadingSpinner from './LoadingSpinner.vue'

const maxTheMule = MAX_THE_MULE

export interface LoadingStep {
  label: string
  status: 'pending' | 'loading' | 'complete'
}

const props = withDefaults(defineProps<{
  steps: LoadingStep[]
  progress: number
}>(), {
  progress: 0
})

const carPosition = computed(() => {
  const progressValue = props.progress / 100
  
  // Track dimensions (matching the SVG)
  const trackWidth = 700
  const trackHeight = 200
  const cornerRadius = 100
  const startX = 50
  const startY = 50
  
  // Calculate the perimeter of the rounded rectangle
  const straightWidth = trackWidth - 2 * cornerRadius
  const straightHeight = trackHeight - 2 * cornerRadius
  const perimeter = 2 * straightWidth + 2 * straightHeight + 2 * Math.PI * cornerRadius
  
  // Distance traveled
  const distance = progressValue * perimeter
  
  let x = 0, y = 0
  
  // Top straight (left to right)
  if (distance < straightWidth) {
    x = startX + cornerRadius + distance
    y = startY
  }
  // Top-right corner
  else if (distance < straightWidth + Math.PI * cornerRadius / 2) {
    const angle = (distance - straightWidth) / cornerRadius
    x = startX + trackWidth - cornerRadius + cornerRadius * Math.sin(angle)
    y = startY + cornerRadius - cornerRadius * Math.cos(angle)
  }
  // Right straight (top to bottom)
  else if (distance < straightWidth + Math.PI * cornerRadius / 2 + straightHeight) {
    const straightDist = distance - (straightWidth + Math.PI * cornerRadius / 2)
    x = startX + trackWidth
    y = startY + cornerRadius + straightDist
  }
  // Bottom-right corner
  else if (distance < straightWidth + Math.PI * cornerRadius + straightHeight) {
    const angle = (distance - (straightWidth + Math.PI * cornerRadius / 2 + straightHeight)) / cornerRadius
    x = startX + trackWidth - cornerRadius + cornerRadius * Math.cos(angle)
    y = startY + trackHeight - cornerRadius + cornerRadius * Math.sin(angle)
  }
  // Bottom straight (right to left)
  else if (distance < 2 * straightWidth + Math.PI * cornerRadius + straightHeight) {
    const straightDist = distance - (straightWidth + Math.PI * cornerRadius + straightHeight)
    x = startX + trackWidth - cornerRadius - straightDist
    y = startY + trackHeight
  }
  // Bottom-left corner
  else if (distance < 2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + straightHeight) {
    const angle = (distance - (2 * straightWidth + Math.PI * cornerRadius + straightHeight)) / cornerRadius
    x = startX + cornerRadius - cornerRadius * Math.sin(angle)
    y = startY + trackHeight - cornerRadius + cornerRadius * Math.cos(angle)
  }
  // Left straight (bottom to top)
  else if (distance < 2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + 2 * straightHeight) {
    const straightDist = distance - (2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + straightHeight)
    x = startX
    y = startY + trackHeight - cornerRadius - straightDist
  }
  // Top-left corner
  else {
    const angle = (distance - (2 * straightWidth + 3 * Math.PI * cornerRadius / 2 + 2 * straightHeight)) / cornerRadius
    x = startX + cornerRadius - cornerRadius * Math.cos(angle)
    y = startY + cornerRadius - cornerRadius * Math.sin(angle)
  }
  
  return `translate(${x}, ${y})`
})

const currentLoadingText = computed(() => {
  const activeStep = props.steps.find(s => s.status === 'loading')
  return activeStep ? activeStep.label : 'Almost there...'
})
</script>

