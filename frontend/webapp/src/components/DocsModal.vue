<template>
  <Teleport to="body">
    <div v-if="isOpen" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black bg-opacity-50" @mousedown.self="handleBackdropMouseDown" @mouseup.self="handleBackdropMouseUp" style="touch-action: none;">
        <div class="bg-white rounded-xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-hidden flex flex-col">
          <!-- Header -->
          <div class="flex items-center justify-between p-6 border-b border-gray-200 bg-gradient-to-r from-mulesoft-cyan to-blue-600">
            <h2 class="text-2xl font-bold text-white flex items-center gap-2">
              📚 {{ title }}
            </h2>
            <button
              @click="close"
              class="text-white hover:text-gray-200 transition-colors p-2 rounded-lg hover:bg-white/10"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>

          <!-- Content -->
          <div class="flex-1 overflow-y-auto p-6">
            <div class="prose prose-sm max-w-none">
              <slot>
                <!-- Default slot for custom content -->
              </slot>
            </div>
          </div>

          <!-- Footer -->
          <div class="p-4 border-t border-gray-200 bg-gray-50 flex justify-end">
            <button
              @click="close"
              class="px-6 py-2 bg-mulesoft-cyan text-white font-semibold rounded-lg hover:bg-mulesoft-cyan-dark transition-colors"
            >
              Close
            </button>
          </div>
        </div>
    </div>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, onUnmounted } from 'vue'

const props = withDefaults(defineProps<{
  title?: string
}>(), {
  title: 'Documentation'
})

const isOpen = ref(false)
const backdropMouseDownPos = ref<{ x: number, y: number } | null>(null)

function open() {
  isOpen.value = true
  document.body.style.overflow = 'hidden'
}

function close() {
  isOpen.value = false
  document.body.style.overflow = ''
}

function handleBackdropMouseDown(e: MouseEvent) {
  backdropMouseDownPos.value = { x: e.clientX, y: e.clientY }
}

function handleBackdropMouseUp(e: MouseEvent) {
  if (!backdropMouseDownPos.value) return
  
  // Only close if mouse didn't move significantly (not a swipe/drag)
  const deltaX = Math.abs(e.clientX - backdropMouseDownPos.value.x)
  const deltaY = Math.abs(e.clientY - backdropMouseDownPos.value.y)
  
  if (deltaX < 10 && deltaY < 10) {
    close()
  }
  
  backdropMouseDownPos.value = null
}

// Ensure body overflow is restored on unmount
onUnmounted(() => {
  document.body.style.overflow = ''
})

defineExpose({
  open,
  close
})
</script>

<style scoped>
/* Prose styling for markdown-like content */
.prose {
  color: #374151;
}

.prose h1 {
  font-size: 1.875rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 1rem;
  margin-top: 1.5rem;
}

.prose h2 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 0.75rem;
  margin-top: 1.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid #e5e7eb;
}

.prose h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 0.5rem;
  margin-top: 1rem;
}

.prose h4 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 0.5rem;
  margin-top: 0.75rem;
}

.prose p {
  margin-bottom: 0.75rem;
  line-height: 1.625;
}

.prose ul {
  list-style-type: disc;
  list-style-position: inside;
  margin-bottom: 0.75rem;
}

.prose ul li {
  margin-top: 0.25rem;
}

.prose ol {
  list-style-type: decimal;
  list-style-position: inside;
  margin-bottom: 0.75rem;
}

.prose ol li {
  margin-top: 0.25rem;
}

.prose li {
  margin-left: 1rem;
}

.prose code {
  background-color: #f3f4f6;
  padding: 0.125rem 0.5rem;
  border-radius: 0.25rem;
  font-size: 0.875rem;
  font-family: ui-monospace, monospace;
  color: #db2777;
}

.prose pre {
  background-color: #111827;
  color: #f3f4f6;
  padding: 1rem;
  border-radius: 0.5rem;
  overflow-x: auto;
  margin-bottom: 0.75rem;
}

.prose pre code {
  background-color: transparent;
  color: #f3f4f6;
  padding: 0;
}

.prose blockquote {
  border-left: 4px solid #00a3e0;
  padding-left: 1rem;
  font-style: italic;
  color: #374151;
  margin: 0.75rem 0;
}

.prose a {
  color: #00a3e0;
  text-decoration: underline;
}

.prose a:hover {
  color: #0077a3;
}

.prose strong {
  font-weight: 600;
  color: #111827;
}

.prose hr {
  border-color: #d1d5db;
  margin: 1.5rem 0;
}

.prose table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 1rem;
}

.prose th {
  background-color: #f3f4f6;
  border: 1px solid #d1d5db;
  padding: 0.5rem 1rem;
  text-align: left;
  font-weight: 600;
}

.prose td {
  border: 1px solid #d1d5db;
  padding: 0.5rem 1rem;
}
</style>

