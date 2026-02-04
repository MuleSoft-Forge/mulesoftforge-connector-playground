<template>
  <div class="border border-gray-300 rounded-md bg-white">
    <!-- Header -->
    <div class="flex items-center justify-between bg-gray-50 px-3 py-2 border-b border-gray-300">
      <button
        @click="loadTemplate"
        class="px-2 py-1 text-xs bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors"
      >
        📋 Load Template
      </button>
      
      <!-- View Toggle -->
      <div class="flex bg-white border border-gray-300 rounded overflow-hidden">
        <button
          @click="currentView = 'form'"
          :class="[
            'px-3 py-1 text-xs font-medium transition-colors',
            currentView === 'form' 
              ? 'bg-blue-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          📝 Form
        </button>
        <button
          @click="currentView = 'json'"
          :class="[
            'px-3 py-1 text-xs font-medium transition-colors border-l border-gray-300',
            currentView === 'json' 
              ? 'bg-blue-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          { } JSON
        </button>
      </div>
    </div>

    <!-- Form View -->
    <div v-if="currentView === 'form'" class="p-4 space-y-3 max-h-96 overflow-y-auto">
      <div class="flex items-center justify-between mb-2">
        <label class="block text-xs font-medium text-gray-700">Conversation Messages</label>
        <button
          @click="addMessage"
          class="px-2 py-1 text-xs bg-green-500 text-white rounded hover:bg-green-600"
        >
          + Add Message
        </button>
      </div>
      
      <div v-for="(message, index) in messages" :key="index" class="p-3 bg-gray-50 border border-gray-200 rounded">
        <div class="flex items-start gap-2">
          <div class="flex-1 space-y-2">
            <div class="flex items-center gap-2">
              <span class="text-xs font-semibold text-gray-600">Message {{ index + 1 }}</span>
              <select
                v-model="message.role"
                @change="syncToJson"
                class="flex-1 px-2 py-1.5 text-xs border border-gray-300 rounded-md"
              >
                <option value="user">👤 User</option>
                <option value="assistant">🤖 Assistant</option>
              </select>
            </div>
            
            <textarea
              v-model="message.content"
              @input="syncToJson"
              :placeholder="`Enter ${message.role} message...`"
              rows="3"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y"
            />
          </div>
          
          <button
            @click="removeMessage(index)"
            class="px-2 py-1 text-xs bg-red-500 text-white rounded hover:bg-red-600"
            title="Remove message"
          >
            ✕
          </button>
        </div>
      </div>
      
      <p v-if="messages.length === 0" class="text-xs text-gray-500 text-center py-4">
        No messages. Click "Add Message" or "Load Template" to start.
      </p>
    </div>

    <!-- JSON View -->
    <div v-if="currentView === 'json'" class="p-4">
      <textarea
        v-model="jsonText"
        @input="syncToForm"
        rows="12"
        class="w-full px-3 py-2 text-xs font-mono border border-gray-300 rounded-md resize-y"
        :class="{ 'border-red-500': jsonError }"
        placeholder='[{"role":"user","content":"..."},{"role":"assistant","content":"..."}]'
      />
      <div v-if="jsonError" class="mt-2 text-xs text-red-600">
        ❌ {{ jsonError }}
      </div>
      <button
        @click="formatJson"
        class="mt-2 px-3 py-1.5 text-xs bg-gray-100 border border-gray-300 rounded hover:bg-gray-200"
      >
        ✨ Format JSON
      </button>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue'

interface Message {
  role: 'user' | 'assistant'
  content: string
}

// Props and emits
const props = defineProps<{
  modelValue: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

// State
const currentView = ref<'form' | 'json'>('form')
const jsonText = ref('')
const jsonError = ref('')
const messages = ref<Message[]>([])

// Load cherry pie template
function loadTemplate() {
  messages.value = [
    { role: 'user', content: 'Can you give me a recipe for cherry pie?' },
    { role: 'assistant', content: 'Certainly! I have a great recipe for a classic cherry pie. Are you planning on using fresh, frozen, or canned cherries?' },
    { role: 'user', content: "I'd prefer to use fresh cherries if possible." },
    { role: 'assistant', content: 'Fresh cherries are perfect! This recipe also includes instructions for a homemade flaky crust. Would you like the full recipe now?' },
    { role: 'user', content: 'Yes, please. Also, any tips for making a lattice top?' }
  ]
  syncToJson()
}

// Add/remove messages
function addMessage() {
  messages.value.push({ role: 'user', content: '' })
  syncToJson()
}

function removeMessage(index: number) {
  messages.value.splice(index, 1)
  syncToJson()
}

// Sync from form to JSON
function syncToJson() {
  try {
    const output = messages.value.map(m => ({
      role: m.role,
      content: m.content
    }))
    
    jsonText.value = JSON.stringify(output, null, 2)
    jsonError.value = ''
    emit('update:modelValue', JSON.stringify(output))
  } catch (e) {
    jsonError.value = 'Error generating JSON: ' + (e as Error).message
  }
}

// Sync from JSON to form
function syncToForm() {
  try {
    const parsed = JSON.parse(jsonText.value)
    
    if (!Array.isArray(parsed)) {
      jsonError.value = 'Messages must be an array'
      return
    }
    
    messages.value = parsed.map((m: any) => ({
      role: m.role === 'assistant' ? 'assistant' : 'user',
      content: m.content || ''
    }))
    
    jsonError.value = ''
    emit('update:modelValue', jsonText.value)
  } catch (e) {
    jsonError.value = 'Invalid JSON: ' + (e as Error).message
  }
}

// Format JSON
function formatJson() {
  try {
    const parsed = JSON.parse(jsonText.value)
    jsonText.value = JSON.stringify(parsed, null, 2)
    jsonError.value = ''
  } catch (e) {
    jsonError.value = 'Cannot format invalid JSON'
  }
}

// Initialize from prop
onMounted(() => {
  if (props.modelValue) {
    jsonText.value = props.modelValue
    syncToForm()
  } else {
    loadTemplate()
  }
})

// Watch for external changes
watch(() => props.modelValue, (newValue) => {
  if (newValue && newValue !== jsonText.value) {
    jsonText.value = newValue
    syncToForm()
  }
})
</script>

