<template>
  <div class="border border-gray-300 rounded-md bg-white">
    <!-- Header -->
    <div class="flex items-center justify-between bg-gray-50 px-3 py-2 border-b border-gray-300">
      <button
        @click="loadTemplate"
        class="px-2 py-1 text-xs bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors"
      >
        📋 Load Default
      </button>
      
      <!-- View Toggle -->
      <div class="flex bg-white border border-gray-300 rounded overflow-hidden">
        <button
          @click="currentView = 'json'"
          :class="[
            'px-3 py-1 text-xs font-medium transition-colors',
            currentView === 'json' 
              ? 'bg-blue-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          { } JSON
        </button>
        <button
          @click="currentView = 'file'"
          :class="[
            'px-3 py-1 text-xs font-medium transition-colors border-l border-gray-300',
            currentView === 'file' 
              ? 'bg-blue-500 text-white' 
              : 'bg-white text-gray-700 hover:bg-gray-50'
          ]"
        >
          📁 File
        </button>
      </div>
    </div>

    <!-- JSON View -->
    <div v-if="currentView === 'json'" class="p-3">
      <label class="block text-xs font-medium text-gray-700 mb-1">Tools Configuration (JSON Array)</label>
      <textarea
        :value="modelValue"
        @input="$emit('update:modelValue', ($event.target as HTMLTextAreaElement).value)"
        rows="12"
        placeholder='[{"type": "function", "function": {"name": "...", "description": "...", "parameters": {...}}}]'
        class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md font-mono bg-gray-50"
      />
      <p class="text-[10px] text-gray-500 mt-1">
        💡 OpenAI function calling format: Each tool must have "type": "function" with nested "function" object containing "name", "description", and "parameters" (JSON Schema)
      </p>
    </div>

    <!-- File Upload View -->
    <div v-if="currentView === 'file'" class="p-3">
      <label class="block text-xs font-medium text-gray-700 mb-2">Upload Tools Configuration File</label>
      <input
        type="file"
        accept=".json"
        @change="handleFileUpload"
        class="w-full text-[11px] file:mr-2 file:py-1.5 file:px-3 file:rounded file:border-0 file:text-xs file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100"
      />
      <div v-if="uploadedFileName" class="mt-2 text-[10px] text-green-600">
        ✓ File loaded: {{ uploadedFileName }}
      </div>
      <p class="text-[10px] text-gray-500 mt-2">
        💡 Upload a .json file containing your tools configuration array
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

interface Props {
  modelValue: string
  defaultConfig?: string
}

const props = defineProps<Props>()
const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const currentView = ref<'json' | 'file'>('json')
const uploadedFileName = ref('')

const defaultToolsConfig = props.defaultConfig || `[
  {
    "type": "function",
    "function": {
      "name": "transform_salesforce_data",
      "description": "Transform Salesforce record to canonical format. Use when data contains 'Id', 'attributes', '__c' custom field suffixes.",
      "parameters": {
        "type": "object",
        "properties": {
          "record": {
            "type": "object",
            "description": "The Salesforce record"
          },
          "objectType": {
            "type": "string",
            "description": "Salesforce object type",
            "enum": ["Account", "Contact", "Opportunity"]
          },
          "targetFormat": {
            "type": "string",
            "enum": ["canonical", "json", "xml"],
            "default": "canonical"
          }
        },
        "required": ["record", "objectType"]
      }
    }
  },
  {
    "type": "function",
    "function": {
      "name": "transform_sap_data",
      "description": "Transform SAP data to canonical format. Use when data contains 'MANDT', 'BUKRS', 'VBELN' or uppercase field names.",
      "parameters": {
        "type": "object",
        "properties": {
          "record": {
            "type": "object",
            "description": "The SAP record"
          },
          "tableType": {
            "type": "string",
            "description": "SAP table type (KNA1, VBAK, etc.)"
          },
          "client": {
            "type": "string",
            "default": "100"
          },
          "targetFormat": {
            "type": "string",
            "enum": ["canonical", "json", "xml"],
            "default": "canonical"
          }
        },
        "required": ["record", "tableType"]
      }
    }
  }
]`

function loadTemplate() {
  emit('update:modelValue', defaultToolsConfig)
  currentView.value = 'json'
}

function handleFileUpload(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  uploadedFileName.value = file.name
  
  const reader = new FileReader()
  reader.onload = (e) => {
    const content = e.target?.result as string
    try {
      // Validate it's valid JSON
      JSON.parse(content)
      // Emit raw JSON
      emit('update:modelValue', content)
    } catch (error) {
      alert('Invalid JSON file. Please upload a valid tools configuration file.')
      uploadedFileName.value = ''
    }
  }
  reader.readAsText(file)
}
</script>

