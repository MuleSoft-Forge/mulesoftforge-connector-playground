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
              ? 'bg-green-500 text-white' 
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
              ? 'bg-green-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          { } JSON
        </button>
      </div>
    </div>

    <!-- Form View -->
    <div v-if="currentView === 'form'" class="p-4 space-y-3 max-h-[600px] overflow-y-auto">
      <!-- REQUIRED: Model -->
      <div class="p-3 bg-blue-50 border border-blue-200 rounded-lg">
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Model <span class="text-red-500">*</span>
        </label>
        <input
          v-model="config.model"
          @input="syncToJson"
          type="text"
          placeholder="gpt-4-turbo"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        />
        <p class="text-[10px] text-gray-600 mt-1">
          ID of the model to use (e.g., gpt-4-turbo, gpt-4, gpt-3.5-turbo)
        </p>
      </div>

      <!-- Name -->
      <div>
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Name (Optional)
        </label>
        <input
          v-model="config.name"
          @input="syncToJson"
          type="text"
          maxlength="256"
          placeholder="Math Tutor"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        />
        <p class="text-[10px] text-gray-600 mt-1">Max 256 characters</p>
      </div>

      <!-- Description -->
      <div>
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Description (Optional)
        </label>
        <textarea
          v-model="config.description"
          @input="syncToJson"
          maxlength="512"
          rows="2"
          placeholder="A helpful assistant that specializes in mathematics..."
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        />
        <p class="text-[10px] text-gray-600 mt-1">Max 512 characters</p>
      </div>

      <!-- Instructions -->
      <div>
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Instructions (Optional)
        </label>
        <textarea
          v-model="config.instructions"
          @input="syncToJson"
          rows="4"
          placeholder="You are a personal math tutor. When asked a question, write and run Python code to answer the question."
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        />
        <p class="text-[10px] text-gray-600 mt-1">Max 256,000 characters</p>
      </div>

      <!-- Tools -->
      <div class="border border-gray-300 rounded-lg p-3">
        <label class="block text-xs font-semibold text-gray-800 mb-2">
          Tools (Optional)
        </label>
        <div class="space-y-2">
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              v-model="config.tools.code_interpreter"
              @change="syncToJson"
              class="w-4 h-4 text-blue-600 border-gray-300 rounded"
            />
            <span class="text-xs">
              <strong>Code Interpreter</strong> - Writes and runs Python code
            </span>
          </label>
          <label class="flex items-center gap-2">
            <input
              type="checkbox"
              v-model="config.tools.file_search"
              @change="syncToJson"
              class="w-4 h-4 text-blue-600 border-gray-300 rounded"
            />
            <span class="text-xs">
              <strong>File Search</strong> - Searches uploaded vector stores
            </span>
          </label>
          
          <!-- Function Tool -->
          <div class="mt-2 p-2 bg-gray-50 rounded border border-gray-200">
            <label class="flex items-center gap-2 mb-2">
              <input
                type="checkbox"
                v-model="config.tools.function_enabled"
                @change="syncToJson"
                class="w-4 h-4 text-blue-600 border-gray-300 rounded"
              />
              <span class="text-xs font-semibold">
                Function Tool - Custom functions
              </span>
            </label>
            
            <div v-if="config.tools.function_enabled">
              <textarea
                v-model="config.tools.function_definitions"
                @input="syncToJson"
                rows="8"
                placeholder='[{"type":"function","function":{"name":"get_weather","description":"Get weather","parameters":{...}}}]'
                class="w-full px-2 py-1.5 text-[10px] border border-gray-300 rounded-md font-mono"
              />
            </div>
          </div>
        </div>
        <p class="text-[10px] text-gray-600 mt-2">Max 128 tools</p>
      </div>

      <!-- Tool Resources -->
      <div class="border border-gray-300 rounded-lg p-3">
        <label class="block text-xs font-semibold text-gray-800 mb-2">
          Tool Resources (Optional)
        </label>
        
        <div class="mb-3">
          <label class="block text-xs font-medium text-gray-700 mb-1">
            Code Interpreter File IDs
          </label>
          <textarea
            v-model="config.tool_resources.code_interpreter_files"
            @input="syncToJson"
            rows="2"
            placeholder='["file-abc123"]'
            class="w-full px-2 py-1.5 text-[10px] border border-gray-300 rounded-md font-mono"
          />
          <p class="text-[10px] text-gray-600 mt-1">JSON array, max 20 files</p>
        </div>

        <div>
          <label class="block text-xs font-medium text-gray-700 mb-1">
            File Search Vector Store IDs
          </label>
          <textarea
            v-model="config.tool_resources.file_search_vector_stores"
            @input="syncToJson"
            rows="2"
            placeholder='["vs_abc123"]'
            class="w-full px-2 py-1.5 text-[10px] border border-gray-300 rounded-md font-mono"
          />
          <p class="text-[10px] text-gray-600 mt-1">JSON array, max 1 vector store</p>
        </div>
      </div>

      <!-- Model Parameters -->
      <div class="grid grid-cols-2 gap-3">
        <div>
          <label class="block text-xs font-semibold text-gray-800 mb-1">
            Temperature
          </label>
          <input
            v-model.number="config.temperature"
            @input="syncToJson"
            type="number"
            min="0"
            max="2"
            step="0.1"
            placeholder="1"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
          />
          <p class="text-[10px] text-gray-600 mt-1">0-2, higher = more random</p>
        </div>

        <div>
          <label class="block text-xs font-semibold text-gray-800 mb-1">
            Top P
          </label>
          <input
            v-model.number="config.top_p"
            @input="syncToJson"
            type="number"
            min="0"
            max="1"
            step="0.01"
            placeholder="1"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
          />
          <p class="text-[10px] text-gray-600 mt-1">0-1, nucleus sampling</p>
        </div>
      </div>

      <!-- Reasoning Effort -->
      <div>
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Reasoning Effort
        </label>
        <select
          v-model="config.reasoning_effort"
          @change="syncToJson"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        >
          <option value="">Auto (default)</option>
          <option value="none">None</option>
          <option value="minimal">Minimal</option>
          <option value="low">Low</option>
          <option value="medium">Medium</option>
          <option value="high">High</option>
          <option value="xhigh">Extra High</option>
        </select>
        <p class="text-[10px] text-gray-600 mt-1">For o1/o3/gpt-5 models</p>
      </div>

      <!-- Response Format -->
      <div>
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Response Format
        </label>
        <select
          v-model="config.response_format"
          @change="syncToJson"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
        >
          <option value="">Auto (default)</option>
          <option value="text">Text</option>
          <option value="json_object">JSON Object</option>
          <option value="json_schema">JSON Schema (custom)</option>
        </select>
        
        <div v-if="config.response_format === 'json_schema'" class="mt-2">
          <textarea
            v-model="config.response_format_schema"
            @input="syncToJson"
            rows="6"
            placeholder='{"type":"json_schema","json_schema":{"name":"response","strict":true,"schema":{...}}}'
            class="w-full px-2 py-1.5 text-[10px] border border-gray-300 rounded-md font-mono"
          />
        </div>
      </div>

      <!-- Metadata -->
      <div>
        <label class="block text-xs font-semibold text-gray-800 mb-1">
          Metadata
        </label>
        <textarea
          v-model="config.metadata"
          @input="syncToJson"
          rows="3"
          placeholder='{"user_id":"user_123","project":"math_tutor"}'
          class="w-full px-2 py-1.5 text-[10px] border border-gray-300 rounded-md font-mono"
        />
        <p class="text-[10px] text-gray-600 mt-1">Max 16 key-value pairs</p>
      </div>
    </div>

    <!-- JSON View -->
    <div v-if="currentView === 'json'" class="p-4">
      <textarea
        v-model="jsonText"
        @input="syncToForm"
        rows="20"
        class="w-full px-3 py-2 text-xs font-mono border border-gray-300 rounded-md resize-y"
        :class="{ 'border-red-500': jsonError }"
        placeholder='{"model":"gpt-4-turbo","name":"Math Tutor",...}'
      />
      <div v-if="jsonError" class="mt-2 text-xs text-red-600">
        {{ jsonError }}
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'

const modelValue = defineModel<string>({ default: '' })

const currentView = ref<'form' | 'json'>('form')
const jsonError = ref('')

// Form data structure
const config = ref({
  model: 'gpt-4-turbo',
  name: '',
  description: '',
  instructions: '',
  tools: {
    code_interpreter: false,
    file_search: false,
    function_enabled: false,
    function_definitions: ''
  },
  tool_resources: {
    code_interpreter_files: '',
    file_search_vector_stores: ''
  },
  temperature: null as number | null,
  top_p: null as number | null,
  reasoning_effort: '',
  response_format: '',
  response_format_schema: '',
  metadata: ''
})

const jsonText = ref('')

// Initialize from modelValue
watch(() => modelValue.value, (newValue) => {
  if (newValue) {
    try {
      const parsed = JSON.parse(newValue)
      updateConfigFromJson(parsed)
      // Also update jsonText so JSON view is in sync
      jsonText.value = JSON.stringify(parsed, null, 2)
    } catch (e) {
      // Invalid JSON, keep current config
      if (currentView.value === 'json') {
        jsonText.value = newValue
      }
    }
  }
}, { immediate: true })

function syncToJson() {
  try {
    const body: any = {
      model: config.value.model
    }

    if (config.value.name) body.name = config.value.name
    if (config.value.description) body.description = config.value.description
    if (config.value.instructions) body.instructions = config.value.instructions

    // Tools
    const tools = []
    if (config.value.tools.code_interpreter) {
      tools.push({ type: 'code_interpreter' })
    }
    if (config.value.tools.file_search) {
      tools.push({ type: 'file_search' })
    }
    if (config.value.tools.function_enabled && config.value.tools.function_definitions) {
      try {
        const functionDefs = JSON.parse(config.value.tools.function_definitions)
        if (Array.isArray(functionDefs)) {
          tools.push(...functionDefs)
        }
      } catch (e) {
        // Invalid function definitions JSON
      }
    }
    if (tools.length > 0) body.tools = tools

    // Tool Resources
    const toolResources: any = {}
    if (config.value.tool_resources.code_interpreter_files) {
      try {
        const files = JSON.parse(config.value.tool_resources.code_interpreter_files)
        if (Array.isArray(files) && files.length > 0) {
          toolResources.code_interpreter = { file_ids: files }
        }
      } catch (e) {
        // Invalid JSON
      }
    }
    if (config.value.tool_resources.file_search_vector_stores) {
      try {
        const stores = JSON.parse(config.value.tool_resources.file_search_vector_stores)
        if (Array.isArray(stores) && stores.length > 0) {
          toolResources.file_search = { vector_store_ids: stores }
        }
      } catch (e) {
        // Invalid JSON
      }
    }
    if (Object.keys(toolResources).length > 0) body.tool_resources = toolResources

    // Model parameters
    if (config.value.temperature !== null && config.value.temperature !== undefined && config.value.temperature !== '') {
      body.temperature = config.value.temperature
    }
    if (config.value.top_p !== null && config.value.top_p !== undefined && config.value.top_p !== '') {
      body.top_p = config.value.top_p
    }
    if (config.value.reasoning_effort) {
      body.reasoning_effort = config.value.reasoning_effort
    }

    // Response format
    if (config.value.response_format) {
      if (config.value.response_format === 'json_schema' && config.value.response_format_schema) {
        try {
          body.response_format = JSON.parse(config.value.response_format_schema)
        } catch (e) {
          // Invalid schema JSON
        }
      } else if (config.value.response_format === 'text') {
        body.response_format = { type: 'text' }
      } else if (config.value.response_format === 'json_object') {
        body.response_format = { type: 'json_object' }
      }
    }

    // Metadata
    if (config.value.metadata) {
      try {
        body.metadata = JSON.parse(config.value.metadata)
      } catch (e) {
        // Invalid metadata JSON
      }
    }

    const jsonString = JSON.stringify(body, null, 2)
    jsonText.value = jsonString
    modelValue.value = jsonString
    jsonError.value = ''
  } catch (err) {
    jsonError.value = 'Error building JSON'
  }
}

function syncToForm() {
  try {
    const parsed = JSON.parse(jsonText.value)
    updateConfigFromJson(parsed)
    modelValue.value = jsonText.value
    jsonError.value = ''
  } catch (err) {
    jsonError.value = 'Invalid JSON syntax'
  }
}

function updateConfigFromJson(parsed: any) {
  config.value.model = parsed.model || 'gpt-4-turbo'
  config.value.name = parsed.name || ''
  config.value.description = parsed.description || ''
  config.value.instructions = parsed.instructions || ''

  // Reset tools
  config.value.tools.code_interpreter = false
  config.value.tools.file_search = false
  config.value.tools.function_enabled = false
  config.value.tools.function_definitions = ''

  // Parse tools
  if (Array.isArray(parsed.tools)) {
    const functionTools = []
    for (const tool of parsed.tools) {
      if (tool.type === 'code_interpreter') {
        config.value.tools.code_interpreter = true
      } else if (tool.type === 'file_search') {
        config.value.tools.file_search = true
      } else if (tool.type === 'function') {
        functionTools.push(tool)
      }
    }
    if (functionTools.length > 0) {
      config.value.tools.function_enabled = true
      config.value.tools.function_definitions = JSON.stringify(functionTools, null, 2)
    }
  }

  // Tool resources
  config.value.tool_resources.code_interpreter_files = parsed.tool_resources?.code_interpreter?.file_ids 
    ? JSON.stringify(parsed.tool_resources.code_interpreter.file_ids) 
    : ''
  config.value.tool_resources.file_search_vector_stores = parsed.tool_resources?.file_search?.vector_store_ids
    ? JSON.stringify(parsed.tool_resources.file_search.vector_store_ids)
    : ''

  config.value.temperature = parsed.temperature ?? null
  config.value.top_p = parsed.top_p ?? null
  config.value.reasoning_effort = parsed.reasoning_effort || ''

  // Response format
  if (parsed.response_format) {
    if (typeof parsed.response_format === 'object') {
      if (parsed.response_format.type === 'json_schema') {
        config.value.response_format = 'json_schema'
        config.value.response_format_schema = JSON.stringify(parsed.response_format, null, 2)
      } else {
        config.value.response_format = parsed.response_format.type || ''
      }
    }
  } else {
    config.value.response_format = ''
    config.value.response_format_schema = ''
  }

  config.value.metadata = parsed.metadata ? JSON.stringify(parsed.metadata, null, 2) : ''
}

function loadTemplate() {
  const template = {
    model: 'gpt-4-turbo',
    name: 'Math Tutor',
    instructions: 'You are a personal math tutor. When asked a question, write and run Python code to answer the question.',
    tools: [
      { type: 'code_interpreter' }
    ]
  }
  
  jsonText.value = JSON.stringify(template, null, 2)
  updateConfigFromJson(template)
  modelValue.value = jsonText.value
}
</script>

