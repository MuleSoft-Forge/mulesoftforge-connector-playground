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
      <!-- Task ID -->
      <div>
        <label class="block text-xs font-medium text-gray-700 mb-1">
          Task ID *
        </label>
        <input
          v-model="formData.taskId"
          type="text"
          placeholder="e.g., task-12345"
          class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
          @input="syncFormToJson"
        />
      </div>

      <!-- Push Notification Config Section -->
      <div class="space-y-3">
        <h3 class="text-sm font-semibold text-gray-900 border-b pb-1">Push Notification Configuration</h3>

        <!-- Notification ID -->
        <div>
          <label class="block text-xs font-medium text-gray-700 mb-1">
            Notification ID
          </label>
          <input
            v-model="formData.pushNotificationConfig.id"
            type="text"
            placeholder="e.g., notif-001"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            @input="syncFormToJson"
          />
        </div>

        <!-- URL -->
        <div>
          <label class="block text-xs font-medium text-gray-700 mb-1">
            Webhook URL *
          </label>
          <input
            v-model="formData.pushNotificationConfig.url"
            type="url"
            placeholder="https://your-webhook-endpoint.com/notifications"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            @input="syncFormToJson"
          />
        </div>

        <!-- Token -->
        <div>
          <label class="block text-xs font-medium text-gray-700 mb-1">
            Validation Token
          </label>
          <input
            v-model="formData.pushNotificationConfig.token"
            type="text"
            placeholder="Optional client token for webhook validation"
            class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
            @input="syncFormToJson"
          />
        </div>

        <!-- Authentication Section -->
        <div class="pl-2 space-y-3 border-l-2 border-gray-200">
          <h4 class="text-xs font-semibold text-gray-700">
            Authentication
          </h4>

          <!-- Auth Schemes -->
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">
              Authentication Schemes
            </label>
            <div class="flex gap-2 mb-2">
              <input
                v-model="newScheme"
                type="text"
                placeholder="e.g., Bearer, Basic"
                class="flex-1 px-2 py-1.5 text-xs border border-gray-300 rounded-md"
                @keyup.enter="addScheme"
              />
              <button
                @click="addScheme"
                class="px-2 py-1 text-xs bg-blue-500 text-white rounded hover:bg-blue-600"
              >
                Add
              </button>
            </div>
            <div v-if="formData.pushNotificationConfig.authentication.schemes.length > 0" class="flex flex-wrap gap-1">
              <span
                v-for="(scheme, index) in formData.pushNotificationConfig.authentication.schemes"
                :key="index"
                class="inline-flex items-center gap-1 px-2 py-0.5 bg-blue-100 text-blue-800 rounded text-xs"
              >
                {{ scheme }}
                <button
                  @click="removeScheme(index)"
                  class="hover:text-red-600 transition-colors"
                >
                  ×
                </button>
              </span>
            </div>
          </div>

          <!-- Credentials -->
          <div>
            <label class="block text-xs font-medium text-gray-700 mb-1">
              Credentials
            </label>
            <input
              v-model="formData.pushNotificationConfig.authentication.credentials"
              type="text"
              placeholder="Authentication credentials"
              class="w-full px-2 py-1.5 text-xs border border-gray-300 rounded-md"
              @input="syncFormToJson"
            />
          </div>
        </div>
      </div>
    </div>

    <!-- JSON View -->
    <div v-if="currentView === 'json'" class="p-4">
      <textarea
        v-model="jsonValue"
        @input="syncJsonToForm"
        rows="12"
        class="w-full px-3 py-2 text-xs font-mono border border-gray-300 rounded-md resize-y"
        :class="{ 'border-red-500': jsonError }"
        placeholder='{"taskId": "task-12345", "pushNotificationConfig": {...}}'
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
  taskId: string;
  pushNotificationConfig: {
    id: string;
    url: string;
    token: string;
    authentication: {
      schemes: string[];
      credentials: string;
    };
  };
};

const currentView = ref<'form' | 'json'>('form');
const jsonValue = ref('');
const jsonError = ref('');
const newScheme = ref('');

const formData = ref<FormDataType>({
  taskId: '',
  pushNotificationConfig: {
    id: '',
    url: '',
    token: '',
    authentication: {
      schemes: [],
      credentials: ''
    }
  }
});

// Initialize from props
onMounted(() => {
  if (props.modelValue) {
    try {
      const parsed = JSON.parse(props.modelValue);
      formData.value = {
        taskId: parsed.taskId || '',
        pushNotificationConfig: {
          id: parsed.pushNotificationConfig?.id || '',
          url: parsed.pushNotificationConfig?.url || '',
          token: parsed.pushNotificationConfig?.token || '',
          authentication: {
            schemes: parsed.pushNotificationConfig?.authentication?.schemes || [],
            credentials: parsed.pushNotificationConfig?.authentication?.credentials || ''
          }
        }
      };
      jsonValue.value = props.modelValue;
    } catch (e) {
      jsonValue.value = props.modelValue;
    }
  }
});

// Watch for external changes
watch(() => props.modelValue, (newVal) => {
  if (newVal !== jsonValue.value) {
    try {
      const parsed = JSON.parse(newVal);
      formData.value = {
        taskId: parsed.taskId || '',
        pushNotificationConfig: {
          id: parsed.pushNotificationConfig?.id || '',
          url: parsed.pushNotificationConfig?.url || '',
          token: parsed.pushNotificationConfig?.token || '',
          authentication: {
            schemes: parsed.pushNotificationConfig?.authentication?.schemes || [],
            credentials: parsed.pushNotificationConfig?.authentication?.credentials || ''
          }
        }
      };
      jsonValue.value = newVal;
    } catch (e) {
      jsonValue.value = newVal;
    }
  }
});

function syncFormToJson() {
  try {
    // Build clean object (omit empty optional fields)
    const config: any = {
      taskId: formData.value.taskId,
      pushNotificationConfig: {
        url: formData.value.pushNotificationConfig.url
      }
    };

    // Add optional fields only if they have values
    if (formData.value.pushNotificationConfig.id) {
      config.pushNotificationConfig.id = formData.value.pushNotificationConfig.id;
    }
    if (formData.value.pushNotificationConfig.token) {
      config.pushNotificationConfig.token = formData.value.pushNotificationConfig.token;
    }
    
    // Add authentication if schemes exist
    if (formData.value.pushNotificationConfig.authentication.schemes.length > 0) {
      config.pushNotificationConfig.authentication = {
        schemes: formData.value.pushNotificationConfig.authentication.schemes
      };
      if (formData.value.pushNotificationConfig.authentication.credentials) {
        config.pushNotificationConfig.authentication.credentials = 
          formData.value.pushNotificationConfig.authentication.credentials;
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
      taskId: parsed.taskId || '',
      pushNotificationConfig: {
        id: parsed.pushNotificationConfig?.id || '',
        url: parsed.pushNotificationConfig?.url || '',
        token: parsed.pushNotificationConfig?.token || '',
        authentication: {
          schemes: parsed.pushNotificationConfig?.authentication?.schemes || [],
          credentials: parsed.pushNotificationConfig?.authentication?.credentials || ''
        }
      }
    };
    jsonError.value = '';
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

function addScheme() {
  if (newScheme.value.trim()) {
    formData.value.pushNotificationConfig.authentication.schemes.push(newScheme.value.trim());
    newScheme.value = '';
    syncFormToJson();
  }
}

function removeScheme(index: number) {
  formData.value.pushNotificationConfig.authentication.schemes.splice(index, 1);
  syncFormToJson();
}

function loadTemplate() {
  const template = {
    taskId: "task-12345",
    pushNotificationConfig: {
      id: "notif-001",
      url: "https://your-webhook-endpoint.com/notifications",
      token: "your-validation-token",
      authentication: {
        schemes: ["Bearer"],
        credentials: "your-auth-credentials"
      }
    }
  };
  
  formData.value = JSON.parse(JSON.stringify(template));
  syncFormToJson();
  currentView.value = 'form';
}
</script>

