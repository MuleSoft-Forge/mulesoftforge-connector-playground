<template>
  <div class="border border-gray-300 rounded-md bg-white">
    <!-- Header -->
    <div class="flex items-center justify-between bg-gray-50 px-3 py-2 border-b border-gray-300">
      <div class="flex items-center gap-2">
        <button
          @click="loadTemplate"
          class="px-2 py-1 text-xs bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors"
        >
          📋 Load Template
        </button>
      </div>
      
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
    <div v-if="currentView === 'form'" class="p-4 space-y-4 max-h-96 overflow-y-auto">
      <!-- Blocking Mode - Only show for send-message, hide for send-stream-message -->
      <div 
        v-if="props.operationKey !== 'a2a:send-stream-message'"
        class="bg-blue-50 border-2 border-blue-200 rounded-md p-3">
        <div class="flex items-start gap-3">
          <input
            v-model="formData.configuration.blocking"
            @change="syncToJson"
            type="checkbox"
            id="blocking-checkbox"
            class="mt-0.5 w-5 h-5 text-blue-600 border-gray-300 rounded"
          />
          <div class="flex-1">
            <label for="blocking-checkbox" class="block text-sm font-semibold text-gray-900 cursor-pointer">
              Blocking Request
            </label>
            <p class="text-xs text-gray-600 mt-1">
              <span class="font-medium">Checked (blocking=true):</span> Wait for completion, returns Message.<br>
              <span class="font-medium">Unchecked (blocking=false):</span> Returns Task immediately, process async.
            </p>
          </div>
        </div>
      </div>

      <!-- Info message for streaming -->
      <div 
        v-else
        class="bg-yellow-50 border-2 border-yellow-200 rounded-md p-3">
        <div class="flex items-start gap-2">
          <span class="text-lg">⚡</span>
          <div class="flex-1">
            <p class="text-xs font-medium text-gray-900">Streaming Mode Active</p>
            <p class="text-xs text-gray-600 mt-1">
              This operation always streams events in real-time. The blocking flag is ignored.
            </p>
          </div>
        </div>
      </div>

      <!-- Message Section -->
      <div class="space-y-3">
        <h3 class="text-sm font-semibold text-gray-900 border-b pb-1">Message</h3>
        
        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">Role *</label>
            <select
              v-model="formData.message.role"
              @change="syncToJson"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            >
              <option value="user">User</option>
              <option value="agent">Agent</option>
            </select>
          </div>
          
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">Message ID *</label>
            <div class="flex gap-1">
              <input
                v-model="formData.message.messageId"
                @input="syncToJson"
                type="text"
                placeholder="msg-xyz123"
                class="flex-1 px-2 py-1.5 text-xs border border-gray-300 rounded-md"
              />
              <button
                @click="generateMessageId"
                class="px-2 py-1.5 text-xs bg-gray-100 border border-gray-300 rounded hover:bg-gray-200"
                title="Generate UUID"
              >
                🔄
              </button>
            </div>
          </div>
        </div>

        <div class="grid grid-cols-2 gap-3">
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">Task ID</label>
            <input
              v-model="formData.message.taskId"
              @input="syncToJson"
              type="text"
              placeholder="task-123"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
          </div>
          
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">Context ID</label>
            <input
              v-model="formData.message.contextId"
              @input="syncToJson"
              type="text"
              placeholder="context-123"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
          </div>
        </div>

        <!-- Parts Array -->
        <div>
          <div class="flex items-center justify-between mb-2">
            <label class="block text-xs font-medium text-gray-700">Parts *</label>
            <button
              @click="addPart"
              class="px-2 py-1 text-xs bg-green-500 text-white rounded hover:bg-green-600"
            >
              + Add Part
            </button>
          </div>
          
          <div v-for="(part, index) in formData.message.parts" :key="index" class="mb-2 p-2 bg-gray-50 border border-gray-200 rounded">
            <div class="flex items-start gap-2">
              <div class="flex-1 space-y-2">
                <select
                  v-model="part.kind"
                  @change="syncToJson"
                  class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
                >
                  <option value="text">Text</option>
                  <option value="file">File</option>
                  <option value="data">Data</option>
                </select>
                
                <textarea
                  v-if="part.kind === 'text'"
                  v-model="part.text"
                  @input="syncToJson"
                  placeholder="Enter your message text..."
                  rows="2"
                  class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md resize-y"
                />
                
                <div v-if="part.kind === 'file'" class="text-xs text-gray-600 italic">
                  File uploads not yet implemented
                </div>
                
                <textarea
                  v-if="part.kind === 'data'"
                  v-model="part.dataJson"
                  @input="updatePartData(index)"
                  placeholder='{"key": "value"}'
                  rows="2"
                  class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono resize-y"
                />
              </div>
              
              <button
                @click="removePart(index)"
                class="px-2 py-1 text-xs bg-red-500 text-white rounded hover:bg-red-600"
                title="Remove part"
              >
                ✕
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Configuration Section -->
      <div class="space-y-3">
        <div class="flex items-center justify-between">
          <h3 class="text-sm font-semibold text-gray-900 border-b pb-1">Configuration</h3>
          <button
            @click="showConfiguration = !showConfiguration"
            class="text-xs text-blue-600 hover:text-blue-800"
          >
            {{ showConfiguration ? '▼ Hide' : '▶ Show' }}
          </button>
        </div>
        
        <div v-show="showConfiguration" class="space-y-3 pl-2">
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">Accepted Output Modes *</label>
            <input
              v-model="outputModesInput"
              @input="updateOutputModes"
              type="text"
              placeholder="text, stream (comma-separated)"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
            <p class="text-xs text-gray-500 mt-1">Comma-separated values</p>
          </div>
          
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">History Length</label>
            <input
              v-model.number="formData.configuration.historyLength"
              @input="syncToJson"
              type="number"
              min="0"
              placeholder="10"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
          </div>
        </div>
      </div>

      <!-- Metadata Section -->
      <div class="space-y-3">
        <div class="flex items-center justify-between">
          <h3 class="text-sm font-semibold text-gray-900 border-b pb-1">Metadata (Optional)</h3>
          <button
            @click="showMetadata = !showMetadata"
            class="text-xs text-blue-600 hover:text-blue-800"
          >
            {{ showMetadata ? '▼ Hide' : '▶ Show' }}
          </button>
        </div>
        
        <div v-show="showMetadata" class="space-y-2 pl-2">
          <div v-for="(value, key, index) in formData.metadata" :key="index" class="flex gap-2">
            <input
              :value="key"
              @input="updateMetadataKey(key, $event.target.value)"
              type="text"
              placeholder="key"
              class="flex-1 px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
            <input
              v-model="formData.metadata[key]"
              @input="syncToJson"
              type="text"
              placeholder="value"
              class="flex-1 px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            />
            <button
              @click="removeMetadata(key)"
              class="px-2 py-1 text-xs bg-red-500 text-white rounded hover:bg-red-600"
            >
              ✕
            </button>
          </div>
          
          <button
            @click="addMetadata"
            class="px-2 py-1 text-xs bg-green-500 text-white rounded hover:bg-green-600"
          >
            + Add Metadata
          </button>
        </div>
      </div>
    </div>

    <!-- JSON View -->
    <div v-if="currentView === 'json'" class="p-4">
      <textarea
        v-model="jsonText"
        @input="syncToForm"
        rows="12"
        class="w-full px-3 py-2 text-xs font-mono border border-gray-300 rounded-md resize-y"
        :class="{ 'border-red-500': jsonError }"
        placeholder='{"message": {...}, "configuration": {...}}'
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

// Props and emits
const props = defineProps<{
  modelValue: string
  operationKey?: string
}>()

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void
}>()

// State
const currentView = ref<'form' | 'json'>('form')
const jsonText = ref('')
const jsonError = ref('')
const showConfiguration = ref(false)
const showMetadata = ref(false)
const outputModesInput = ref('text')

// Form data structure
const formData = ref({
  message: {
    role: 'user',
    parts: [{ kind: 'text', text: '', dataJson: '' }],
    messageId: '',
    taskId: '',
    contextId: '',
    kind: 'message'
  },
  configuration: {
    acceptedOutputModes: ['text'],
    historyLength: null as number | null,
    blocking: true
  },
  metadata: {} as Record<string, string>
})

// Generate UUID-like ID
function generateMessageId() {
  formData.value.message.messageId = 'msg-' + Math.random().toString(36).substr(2, 9) + '-' + Date.now().toString(36)
  syncToJson()
}

// Load template
function loadTemplate() {
  formData.value = {
    message: {
      role: 'user',
      parts: [{ kind: 'text', text: 'What is the weather in San Francisco?', dataJson: '' }],
      messageId: 'msg-' + Math.random().toString(36).substr(2, 9) + '-' + Date.now().toString(36),
      taskId: '',
      contextId: '',
      kind: 'message'
    },
    configuration: {
      acceptedOutputModes: ['text'],
      historyLength: null,
      blocking: true
    },
    metadata: {}
  }
  outputModesInput.value = 'text'
  syncToJson()
}

// Add/remove parts
function addPart() {
  formData.value.message.parts.push({ kind: 'text', text: '', dataJson: '' })
  syncToJson()
}

function removePart(index: number) {
  formData.value.message.parts.splice(index, 1)
  syncToJson()
}

function updatePartData(index: number) {
  const part = formData.value.message.parts[index]
  try {
    part.data = JSON.parse(part.dataJson || '{}')
    syncToJson()
  } catch (e) {
    // Invalid JSON, don't sync yet
  }
}

// Add/remove/update metadata
function addMetadata() {
  const newKey = `key${Object.keys(formData.value.metadata).length + 1}`
  formData.value.metadata[newKey] = ''
  syncToJson()
}

function removeMetadata(key: string) {
  delete formData.value.metadata[key]
  syncToJson()
}

function updateMetadataKey(oldKey: string, newKey: string) {
  if (oldKey === newKey) return
  const value = formData.value.metadata[oldKey]
  delete formData.value.metadata[oldKey]
  formData.value.metadata[newKey] = value
  syncToJson()
}

// Update output modes
function updateOutputModes() {
  formData.value.configuration.acceptedOutputModes = outputModesInput.value
    .split(',')
    .map(s => s.trim())
    .filter(s => s.length > 0)
  syncToJson()
}

// Sync from form to JSON
function syncToJson() {
  try {
    const output: any = {
      message: {
        role: formData.value.message.role,
        parts: formData.value.message.parts.map(part => {
          const p: any = { kind: part.kind }
          if (part.kind === 'text' && part.text) {
            p.text = part.text
          } else if (part.kind === 'data' && part.dataJson) {
            try {
              p.data = JSON.parse(part.dataJson)
            } catch (e) {
              p.data = {}
            }
          }
          return p
        }),
        messageId: formData.value.message.messageId,
        kind: 'message'
      },
      configuration: {
        acceptedOutputModes: formData.value.configuration.acceptedOutputModes
      }
    }

    // Add optional fields
    if (formData.value.message.taskId) {
      output.message.taskId = formData.value.message.taskId
    }
    if (formData.value.message.contextId) {
      output.message.contextId = formData.value.message.contextId
    }
    if (formData.value.configuration.historyLength !== null && formData.value.configuration.historyLength !== undefined) {
      output.configuration.historyLength = formData.value.configuration.historyLength
    }
    // Always include blocking field (true or false)
    output.configuration.blocking = formData.value.configuration.blocking
    if (Object.keys(formData.value.metadata).length > 0) {
      output.metadata = formData.value.metadata
    }

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
    
    // Update form data
    if (parsed.message) {
      formData.value.message.role = parsed.message.role || 'user'
      formData.value.message.messageId = parsed.message.messageId || ''
      formData.value.message.taskId = parsed.message.taskId || ''
      formData.value.message.contextId = parsed.message.contextId || ''
      
      if (parsed.message.parts && Array.isArray(parsed.message.parts)) {
        formData.value.message.parts = parsed.message.parts.map((p: any) => ({
          kind: p.kind || 'text',
          text: p.text || '',
          dataJson: p.data ? JSON.stringify(p.data, null, 2) : '',
          data: p.data
        }))
      }
    }
    
    if (parsed.configuration) {
      formData.value.configuration.acceptedOutputModes = parsed.configuration.acceptedOutputModes || ['text']
      outputModesInput.value = formData.value.configuration.acceptedOutputModes.join(', ')
      formData.value.configuration.historyLength = parsed.configuration.historyLength || null
      formData.value.configuration.blocking = parsed.configuration.blocking !== undefined ? parsed.configuration.blocking : true
    }
    
    if (parsed.metadata && typeof parsed.metadata === 'object') {
      formData.value.metadata = { ...parsed.metadata }
    } else {
      formData.value.metadata = {}
    }
    
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
  
  // Auto-generate message ID for streaming operations on mount if not already set
  if (props.operationKey === 'a2a:send-stream-message' && !formData.value.message.messageId) {
    generateMessageId()
  }
})

// Watch for operation changes - regenerate message ID when switching to streaming operations
watch(() => props.operationKey, (newOperationKey) => {
  if (newOperationKey === 'a2a:send-stream-message' && !formData.value.message.messageId) {
    generateMessageId()
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

