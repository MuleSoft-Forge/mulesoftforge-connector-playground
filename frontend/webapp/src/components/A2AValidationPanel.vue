<template>
  <div v-if="validationResult" class="mt-3">
    <div :class="[
      'rounded-lg p-3 border-2',
      validationResult.valid 
        ? 'bg-green-50 border-green-300' 
        : 'bg-red-50 border-red-300'
    ]">
      <div class="flex items-start gap-2">
        <div :class="[
          'text-2xl flex-shrink-0',
          validationResult.valid ? 'text-green-600' : 'text-red-600'
        ]">
          {{ validationResult.valid ? '✅' : '❌' }}
        </div>
        <div class="flex-1">
          <div :class="[
            'text-sm font-bold mb-1',
            validationResult.valid ? 'text-green-900' : 'text-red-900'
          ]">
            {{ validationResult.valid ? 'Valid A2A Object' : 'Validation Failed' }}
          </div>
          <div v-if="!validationResult.valid && validationResult.errors" class="space-y-1">
            <div 
              v-for="(error, idx) in validationResult.errors" 
              :key="idx" 
              class="text-xs text-red-800 bg-red-100 rounded px-2 py-1 font-mono"
            >
              {{ error }}
            </div>
          </div>
          <div v-else class="text-xs text-green-800">
            All fields conform to A2A {{ schemaType }} schema (v1.0.0)
          </div>
        </div>
      </div>
      
      <!-- Details Toggle -->
      <details v-if="!validationResult.valid && validationResult.details" class="mt-2 pt-2 border-t border-red-200">
        <summary class="text-xs text-red-700 cursor-pointer hover:text-red-900 font-semibold">
          Show Technical Details
        </summary>
        <pre class="mt-2 text-[10px] font-mono text-red-700 bg-red-100 rounded p-2 overflow-x-auto">{{ JSON.stringify(validationResult.details, null, 2) }}</pre>
      </details>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { ValidationResult } from '../utils/a2aValidator'

const props = defineProps<{
  validationResult: ValidationResult | null
  schemaType?: string
}>()
</script>

