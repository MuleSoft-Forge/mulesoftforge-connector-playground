<template>
  <div class="max-w-7xl mx-auto px-6 py-6">
    <!-- Breadcrumbs -->
    <nav class="flex items-center text-sm text-mulesoft-gray mb-6">
      <router-link to="/lab" class="hover:text-mulesoft-cyan transition-colors">Lab</router-link>
      <svg class="w-4 h-4 mx-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
      </svg>
      <span class="text-mulesoft-dark font-medium">{{ connector?.name || 'Loading...' }}</span>
    </nav>

    <!-- Header -->
    <div class="flex items-center justify-between mb-6">
      <div class="flex items-center gap-3">
        <ConnectorIcon :icon-url="connector?.icon" size="lg" />
        <div>
          <div class="text-xl font-semibold text-mulesoft-dark">{{ connector?.name || 'Loading…' }}</div>
          <div class="text-xs text-gray-500">v{{ connector?.version }}</div>
        </div>
      </div>
      <div class="flex items-center gap-3">
        <select
          v-model="selectedRuntimeConfigId"
          class="px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
        >
          <option value="">Choose runtime config…</option>
          <optgroup v-for="ct in configTypes" :key="ct.id" :label="ct.displayName">
            <template v-for="prov in ct.providers">
              <option
                v-for="rc in getProviderConfigs(ct.id, prov.id)"
                :key="rc.id"
                :value="rc.id"
              >
                {{ prov.displayName }} → {{ rc.name }}
              </option>
            </template>
          </optgroup>
        </select>
        <DocLink :url="connector?.docUrl" variant="text" size="sm" />
      </div>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
      <!-- Operations list -->
      <aside class="lg:col-span-3 bg-white border border-gray-200 rounded-xl p-4">
        <div class="flex items-center gap-2 mb-3">
          <input v-model="opQuery" placeholder="Search operations…" class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent" />
        </div>
        <div class="space-y-2 max-h-[65vh] overflow-auto pr-1">
          <button
            v-for="op in filteredOperations"
            :key="op.id"
            @click="selectOperation(op)"
            class="w-full text-left px-3 py-2 rounded-lg border"
            :class="selectedOperation?.id === op.id ? 'border-mulesoft-cyan bg-blue-50' : 'border-gray-200 hover:bg-gray-50'"
          >
            <div class="font-medium text-sm">{{ op.displayName }}</div>
            <div class="text-[11px] text-gray-500">{{ op.operationKey }}</div>
          </button>
        </div>
      </aside>

      <!-- Workbench -->
      <section class="lg:col-span-6">
        <div v-if="selectedOperation" class="bg-white border border-gray-200 rounded-xl p-5">
          <div class="flex items-start justify-between mb-4">
            <div>
              <div class="text-lg font-semibold text-mulesoft-dark">{{ selectedOperation.displayName }}</div>
              <div class="text-xs text-gray-500">{{ selectedOperation.operationKey }}</div>
            </div>
            <DocLink :url="selectedOperation.helpUrl" variant="text" size="sm" />
          </div>
          <div class="text-sm text-gray-600 mb-4">{{ selectedOperation.description }}</div>

          <!-- Parameters form (simple scaffold) -->
          <form class="space-y-4">
            <div v-for="(param, idx) in selectedOperation.parameters" :key="idx" class="">
              <label class="block text-sm font-medium text-mulesoft-dark mb-1">
                {{ param.displayName }}
                <span v-if="param.isRequired" class="text-red-600">*</span>
              </label>
              <input
                v-model="parameters[param.apiName]"
                :placeholder="param.description || param.apiName"
                class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-mulesoft-cyan focus:border-transparent"
              />
              <div class="text-[11px] text-gray-500 mt-1">{{ param.dataType }}</div>
            </div>
          </form>
        </div>
        <div v-else class="text-gray-500">Choose an operation</div>
      </section>

      <!-- Execute Panel -->
      <aside class="lg:col-span-3 bg-gray-50 border border-gray-200 rounded-xl p-5 overflow-y-auto" style="max-height: calc(100vh - 200px)">
        <button
          @click="run"
          :disabled="!canRun || running"
          :class="[
            'w-full px-4 py-3 rounded-lg font-medium flex items-center justify-center transition-all mb-4',
            running || !canRun
              ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
              : 'bg-mulesoft-cyan text-white hover:bg-mulesoft-cyan-dark shadow-md hover:shadow-lg'
          ]"
        >
          <svg v-if="running" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <svg v-else class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14.752 11.168l-3.197-2.132A1 1 0 0010 9.87v4.263a1 1 0 001.555.832l3.197-2.132a1 1 0 000-1.664z"/>
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
          </svg>
          <span v-if="running">Running…</span>
          <span v-else>Execute</span>
        </button>

        <!-- Empty State -->
        <div v-if="!result && !running" class="text-center py-8">
          <svg class="w-16 h-16 mx-auto text-gray-400 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
          </svg>
          <p class="text-sm text-gray-600">Select an operation and click Execute to see results</p>
        </div>

        <!-- Loading State -->
        <div v-else-if="running" class="text-center py-8">
          <svg class="animate-spin h-12 w-12 mx-auto text-mulesoft-cyan mb-3" fill="none" viewBox="0 0 24 24">
            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
          </svg>
          <p class="text-sm text-gray-600 font-medium">Executing operation...</p>
        </div>

        <!-- Results -->
        <div v-else-if="result" class="bg-white rounded-lg border border-gray-200 p-4">
          <div class="flex items-center justify-between mb-3">
            <div class="flex items-center">
              <svg v-if="result.status === 'success'" class="w-5 h-5 text-green-600 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
              </svg>
              <svg v-else class="w-5 h-5 text-red-600 mr-2" fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"/>
              </svg>
              <span :class="[
                'text-sm font-semibold',
                result.status === 'success' ? 'text-green-900' : 'text-red-900'
              ]">
                {{ result.status === 'success' ? 'Success' : 'Failed' }}
              </span>
            </div>
            <button @click="result = null" class="text-gray-500 hover:text-gray-700">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
              </svg>
            </button>
          </div>
          <pre class="text-xs bg-gray-50 border border-gray-200 rounded p-3 overflow-auto max-h-[50vh] font-mono">{{ pretty(result) }}</pre>
        </div>
      </aside>
    </div>
  </div>
</template>

<script lang="ts" setup>
import { ref, computed, onMounted, nextTick } from 'vue';
import { useRoute } from 'vue-router';
import ConnectorIcon from '../components/ConnectorIcon.vue';
import DocLink from '../components/DocLink.vue';
import { apiCall } from '../composables/useApi';
import { logger } from '../utils/logger';

const route = useRoute();
const connectorId = Number(route.params.connectorId);

const connector = ref<any>(null);
const configTypes = ref<any[]>([]);
const runtimeConfigs = ref<any[]>([]);
const operations = ref<any[]>([]);
const selectedRuntimeConfigId = ref<string | number | ''>('');
const selectedOperation = ref<any>(null);
const parameters = ref<Record<string, any>>({});
const result = ref<any>(null);
const running = ref(false);
const opQuery = ref('');

const filteredOperations = computed(() => {
  const q = opQuery.value.trim().toLowerCase();
  if (!q) return operations.value;
  return operations.value.filter((o: any) =>
    o.displayName.toLowerCase().includes(q) || o.operationKey.toLowerCase().includes(q)
  );
});

function getProviderConfigs(configTypeId: number, providerId: number) {
  return runtimeConfigs.value.filter(
    (config: any) => config.configType?.id === configTypeId && config.provider?.id === providerId
  );
}

function selectOperation(op: any) {
  selectedOperation.value = op;
  parameters.value = {};
  for (const p of op.parameters || []) {
    if (p.defaultValue != null) parameters.value[p.apiName] = p.defaultValue;
  }
}

const canRun = computed(() => !!selectedOperation.value && !!selectedRuntimeConfigId.value);

function pretty(obj: any) {
  try { return JSON.stringify(obj, null, 2); } catch { return String(obj); }
}

async function run() {
  if (!canRun.value) return;
  running.value = true;
  result.value = null;
  try {
    const payload: any = {
      operationId: selectedOperation.value.id,
      runtimeConfigId: Number(selectedRuntimeConfigId.value),
      parameters: { ...parameters.value }
    };
    result.value = await apiCall('/execute', 'POST', payload);
  } catch (e) {
    logger.error('Execute failed', e);
  } finally {
    running.value = false;
  }
}

onMounted(async () => {
  // Connector details
  connector.value = await apiCall(`/connectors/${connectorId}`, 'GET');

  // Config types with providers
  configTypes.value = await apiCall(`/connectors/${connectorId}/config-types`, 'GET');

  // Runtime configs across config types
  runtimeConfigs.value = [];
  for (const ct of configTypes.value) {
    const configs = await apiCall(`/runtime-configs?configTypeId=${ct.id}`, 'GET');
    // Attach providers to ct for optgroup labels
    if (!ct.providers) {
      const providersDetail = await apiCall(`/config-types/${ct.id}`, 'GET');
      ct.providers = providersDetail.providers || [];
    }
    runtimeConfigs.value.push(...configs);
  }

  // Operations + parameters (filter to only show active operations)
  const ops = await apiCall(`/connectors/${connectorId}/operations`, 'GET');
  const activeOps = ops.filter((op: any) => op.isActive);
  operations.value = [];
  for (const op of activeOps) {
    const params = await apiCall(`/connectors/${connectorId}/operations/${op.id}/parameters`, 'GET');
    operations.value.push({ ...op, parameters: params });
  }

  // Auto-select operation from query param if provided
  const operationIdFromQuery = route.query.operation;
  if (operationIdFromQuery) {
    const targetOp = operations.value.find(op => op.id === Number(operationIdFromQuery));
    if (targetOp) {
      selectOperation(targetOp);
      
      // Scroll to the selected operation in the sidebar
      nextTick(() => {
        const selectedButton = document.querySelector('.border-mulesoft-cyan');
        selectedButton?.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      });
    }
  }
});
</script>


