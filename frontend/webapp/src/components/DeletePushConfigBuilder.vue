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
    <div v-if="currentView === 'form'" class="p-4 space-y-4">
      <!-- Task ID -->
      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          Task ID *
        </label>
        <input
          v-model="formData.id"
          type="text"
          placeholder="e.g., task-12345"
          :class="[
            'w-full px-2 py-1.5 text-xs border rounded-md',
            formData.id && formData.id.trim() 
              ? 'border-green-500 focus:ring-2 focus:ring-green-200' 
              : 'border-gray-300'
          ]"
          @input="syncFormToJson"
        />
        <p class="text-[10px] mt-1" :class="formData.id && formData.id.trim() ? 'text-green-600' : 'text-gray-500'">
          <span v-if="formData.id && formData.id.trim()">✓ Required field filled</span>
          <span v-else>Unique identifier of the task</span>
        </p>
      </div>

      <!-- Push Notification Config ID -->
      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          Push Notification Config ID *
        </label>
        <input
          v-model="formData.pushNotificationConfigId"
          type="text"
          placeholder="e.g., config-456"
          :class="[
            'w-full px-2 py-1.5 text-xs border rounded-md',
            formData.pushNotificationConfigId && formData.pushNotificationConfigId.trim() 
              ? 'border-green-500 focus:ring-2 focus:ring-green-200' 
              : 'border-gray-300'
          ]"
          @input="syncFormToJson"
        />
        <p class="text-[10px] mt-1" :class="formData.pushNotificationConfigId && formData.pushNotificationConfigId.trim() ? 'text-green-600' : 'text-red-600'">
          <span v-if="formData.pushNotificationConfigId && formData.pushNotificationConfigId.trim()">✓ Required field filled</span>
          <span v-else>⚠️ REQUIRED: Specific configuration ID to delete</span>
        </p>
      </div>

      <!-- Metadata -->
      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          Metadata
          <span class="text-gray-400 text-[10px] font-normal">(optional JSON)</span>
        </label>
        <textarea
          v-model="formData.metadata"
          rows="3"
          placeholder='{"key": "value"}'
          :class="[
            'w-full px-2 py-1.5 text-xs border rounded-md font-mono',
            jsonError && jsonError.includes('Metadata') ? 'border-red-500' : 'border-gray-300'
          ]"
          @input="syncFormToJson"
        />
        <p class="text-[10px] mt-1" :class="jsonError && jsonError.includes('Metadata') ? 'text-red-600' : 'text-gray-500'">
          <span v-if="jsonError && jsonError.includes('Metadata')">❌ {{ jsonError }}</span>
          <span v-else>Additional metadata for the deletion request (JSON object)</span>
        </p>
      </div>

      <!-- Warning Box -->
      <div class="bg-red-50 border border-red-200 rounded p-3 text-xs">
        <p class="font-semibold text-red-900 mb-1">⚠️ Delete Operation Requirements</p>
        <p class="text-red-800 text-[11px]">
          <strong>BOTH</strong> <code class="bg-red-100 px-1 rounded">id</code> and 
          <code class="bg-red-100 px-1 rounded">pushNotificationConfigId</code> are <strong>mandatory</strong> for delete operations.
          Use <code class="bg-red-100 px-1 rounded">List Push Notification Configs</code> to find the specific config ID to delete.
        </p>
      </div>
    </div>

    <!-- JSON View -->
    <div v-if="currentView === 'json'" class="p-4">
      <textarea
        v-model="jsonValue"
        @input="syncJsonToForm"
        rows="8"
        class="w-full px-3 py-2 text-xs font-mono border border-gray-300 rounded-md resize-y"
        :class="{ 'border-red-500': jsonError }"
        placeholder='{"id": "task-12345", "pushNotificationConfigId": "config-456", "metadata": {}}'
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
import { ref, watch, onMounted } from 'vue';

const props = defineProps<{
  modelValue: string;
}>();

const emit = defineEmits<{
  (e: 'update:modelValue', value: string): void;
}>();

type FormDataType = {
  id: string;
  pushNotificationConfigId: string;
  metadata: string;
};

const currentView = ref<'form' | 'json'>('form');
const jsonValue = ref('');
const jsonError = ref('');

const formData = ref<FormDataType>({
  id: '',
  pushNotificationConfigId: '',
  metadata: ''
});

// Initialize from props
onMounted(() => {
  if (props.modelValue) {
    try {
      const parsed = JSON.parse(props.modelValue);
      formData.value = {
        id: parsed.id || '',
        pushNotificationConfigId: parsed.pushNotificationConfigId || '',
        metadata: parsed.metadata ? JSON.stringify(parsed.metadata, null, 2) : ''
      };
      jsonValue.value = props.modelValue;
    } catch (e) {
      jsonValue.value = props.modelValue;
    }
  } else {
    // Initialize with empty structure
    jsonValue.value = '';
  }
});

// Watch for external changes
watch(() => props.modelValue, (newVal) => {
  if (newVal !== jsonValue.value) {
    try {
      const parsed = JSON.parse(newVal);
      formData.value = {
        id: parsed.id || '',
        pushNotificationConfigId: parsed.pushNotificationConfigId || '',
        metadata: parsed.metadata ? JSON.stringify(parsed.metadata, null, 2) : ''
      };
      jsonValue.value = newVal;
    } catch (e) {
      jsonValue.value = newVal;
    }
  }
});

function syncFormToJson() {
  try {
    // Require BOTH id AND pushNotificationConfigId for delete operations
    if (!formData.value.id || !formData.value.id.trim()) {
      jsonValue.value = '';
      jsonError.value = '';
      emit('update:modelValue', '');
      return;
    }

    if (!formData.value.pushNotificationConfigId || !formData.value.pushNotificationConfigId.trim()) {
      jsonValue.value = '';
      jsonError.value = 'pushNotificationConfigId is required for delete operations';
      emit('update:modelValue', '');
      return;
    }

    // Build clean object with both required fields
    const config: any = {
      id: formData.value.id.trim(),
      pushNotificationConfigId: formData.value.pushNotificationConfigId.trim()
    };

    // Add metadata only if it has a value (parse it as JSON)
    if (formData.value.metadata && formData.value.metadata.trim()) {
      try {
        config.metadata = JSON.parse(formData.value.metadata);
      } catch (e) {
        throw new Error('Metadata must be valid JSON');
      }
    }

    jsonValue.value = JSON.stringify(config, null, 2);
    jsonError.value = '';
    emit('update:modelValue', jsonValue.value);
  } catch (e: any) {
    jsonError.value = `Error: ${e.message}`;
  }
}

function syncJsonToForm() {
  try {
    const parsed = JSON.parse(jsonValue.value);
    formData.value = {
      id: parsed.id || '',
      pushNotificationConfigId: parsed.pushNotificationConfigId || '',
      metadata: parsed.metadata ? JSON.stringify(parsed.metadata, null, 2) : ''
    };
    
    // Validate required fields
    if (!parsed.id || !parsed.pushNotificationConfigId) {
      jsonError.value = 'Both id and pushNotificationConfigId are required';
    } else {
      jsonError.value = '';
    }
    
    emit('update:modelValue', jsonValue.value);
  } catch (e: any) {
    jsonError.value = `Invalid JSON: ${e.message}`;
  }
}

function formatJson() {
  try {
    const parsed = JSON.parse(jsonValue.value);
    jsonValue.value = JSON.stringify(parsed, null, 2);
    jsonError.value = '';
    emit('update:modelValue', jsonValue.value);
  } catch (e: any) {
    jsonError.value = `Invalid JSON: ${e.message}`;
  }
}

function loadTemplate() {
  const template = {
    id: "task-12345",
    pushNotificationConfigId: "config-456",
    metadata: {
      reason: "Endpoint decommissioned",
      deletedBy: "admin",
      timestamp: new Date().toISOString()
    }
  };
  
  formData.value = {
    id: template.id,
    pushNotificationConfigId: template.pushNotificationConfigId,
    metadata: JSON.stringify(template.metadata, null, 2)
  };
  syncFormToJson();
  currentView.value = 'form';
}
</script>

