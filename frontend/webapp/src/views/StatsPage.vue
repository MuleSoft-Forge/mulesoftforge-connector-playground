<template>
  <div class="min-h-screen bg-gradient-to-b from-gray-50 to-white py-12">
    <div class="max-w-7xl mx-auto px-6">
      <!-- Header -->
      <div class="text-center mb-12">
        <div class="inline-flex items-center justify-center w-24 h-24 bg-gradient-to-br from-white via-purple-50 to-indigo-50 rounded-3xl shadow-2xl mb-6 p-4 ring-4 ring-purple-100 ring-opacity-50">
          <svg class="w-full h-full text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/>
          </svg>
        </div>
        <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-4">
          Execution Statistics
        </h1>
        <p class="text-xl text-gray-600 max-w-3xl mx-auto">
          Monitor connector performance, success rates, and identify problematic operations
        </p>
      </div>

      <!-- View Toggle -->
      <div class="flex justify-center mb-8">
        <div class="inline-flex rounded-lg border border-gray-300 bg-white p-1 shadow-sm">
          <button
            @click="activeView = 'overall'"
            :class="[
              'px-6 py-2 rounded-md font-medium transition-colors',
              activeView === 'overall' 
                ? 'bg-purple-600 text-white shadow-md' 
                : 'text-gray-600 hover:text-gray-900'
            ]"
          >
            Overall Stats
          </button>
          <button
            @click="activeView = 'connectors'"
            :class="[
              'px-6 py-2 rounded-md font-medium transition-colors',
              activeView === 'connectors' 
                ? 'bg-purple-600 text-white shadow-md' 
                : 'text-gray-600 hover:text-gray-900'
            ]"
          >
            By Connector
          </button>
          <button
            @click="activeView = 'operations'"
            :class="[
              'px-6 py-2 rounded-md font-medium transition-colors',
              activeView === 'operations' 
                ? 'bg-purple-600 text-white shadow-md' 
                : 'text-gray-600 hover:text-gray-900'
            ]"
          >
            By Operation
          </button>
        </div>
      </div>

      <!-- Loading State -->
      <div v-if="loading" class="flex justify-center items-center py-20">
        <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-purple-600"></div>
      </div>

      <!-- Error State -->
      <div v-else-if="error" class="bg-red-50 border border-red-200 rounded-xl p-6 text-center">
        <p class="text-red-600 font-medium">{{ error }}</p>
        <button @click="loadAllData" class="mt-4 px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition-colors">
          Retry
        </button>
      </div>

      <!-- Overall Stats View -->
      <div v-else-if="activeView === 'overall'" class="space-y-8">
        <!-- KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-600 font-medium">Total Executions</p>
                <p class="text-3xl font-bold text-gray-900 mt-2">{{ overallStats?.totalExecutions || 0 }}</p>
              </div>
              <div class="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                </svg>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-600 font-medium">Success Rate</p>
                <p class="text-3xl font-bold text-green-600 mt-2">{{ overallStats?.successRate.toFixed(1) || 0 }}%</p>
              </div>
              <div class="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
            </div>
          </div>

          <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
            <div class="flex items-center justify-between">
              <div>
                <p class="text-sm text-gray-600 font-medium">Error Count</p>
                <p class="text-3xl font-bold text-red-600 mt-2">{{ overallStats?.errorCount || 0 }}</p>
              </div>
              <div class="w-12 h-12 bg-red-100 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
              </div>
            </div>
          </div>
        </div>

        <!-- Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
          <!-- Execution Status Chart -->
          <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6">Execution Status</h2>
            <div class="h-80">
              <Bar :data="statusChartData" :options="chartOptions" />
            </div>
          </div>

          <!-- Error Breakdown Chart -->
          <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
            <h2 class="text-xl font-bold text-gray-900 mb-6">Error Breakdown</h2>
            <div v-if="overallStats?.errorBreakdown && overallStats.errorBreakdown.length > 0" class="h-80">
              <Bar :data="errorChartData" :options="chartOptions" />
            </div>
            <div v-else class="h-80 flex items-center justify-center text-gray-400">
              <div class="text-center">
                <svg class="w-16 h-16 mx-auto mb-4 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <p class="text-lg font-medium">No Errors</p>
                <p class="text-sm">All executions successful!</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- By Connector View -->
      <div v-else-if="activeView === 'connectors'" class="space-y-8">
        <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
          <h2 class="text-xl font-bold text-gray-900 mb-6">Connector Performance Comparison</h2>
          <div v-if="connectorStats.length > 0" class="space-y-6">
            <div class="h-96">
              <Bar :data="connectorErrorsChartData" :options="connectorChartOptions" />
            </div>
            
            <!-- Connector Details Table -->
            <div class="overflow-x-auto">
              <table class="w-full">
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase">Connector</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Total</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Success</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Errors</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Success Rate</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-for="stat in connectorStats" :key="stat.connectorId" class="hover:bg-gray-50">
                    <td class="px-4 py-3">
                      <div class="flex items-center gap-3">
                        <img 
                          v-if="getConnectorIcon(stat.connectorId)" 
                          :src="getConnectorIcon(stat.connectorId)" 
                          :alt="stat.connectorName"
                          class="w-8 h-8 object-contain"
                        />
                        <span class="font-medium text-gray-900">{{ stat.connectorName }}</span>
                      </div>
                    </td>
                    <td class="px-4 py-3 text-right text-gray-600">{{ stat.totalExecutions }}</td>
                    <td class="px-4 py-3 text-right text-green-600 font-medium">{{ stat.successCount }}</td>
                    <td class="px-4 py-3 text-right">
                      <span :class="stat.errorCount > 0 ? 'text-red-600 font-bold' : 'text-gray-400'">
                        {{ stat.errorCount }}
                      </span>
                    </td>
                    <td class="px-4 py-3 text-right">
                      <span :class="[
                        'px-2 py-1 rounded text-xs font-semibold',
                        stat.successRate >= 95 ? 'bg-green-100 text-green-800' :
                        stat.successRate >= 80 ? 'bg-yellow-100 text-yellow-800' :
                        'bg-red-100 text-red-800'
                      ]">
                        {{ stat.successRate.toFixed(1) }}%
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div v-else class="text-center py-12 text-gray-400">
            <p class="text-lg font-medium">No execution data available</p>
            <p class="text-sm">Execute some operations to see connector statistics</p>
          </div>
        </div>
      </div>

      <!-- By Operation View -->
      <div v-else-if="activeView === 'operations'" class="space-y-8">
        <div class="bg-white rounded-xl shadow-lg border border-gray-200 p-6">
          <h2 class="text-xl font-bold text-gray-900 mb-6">Operation Error Analysis</h2>
          <div v-if="operationStats.length > 0" class="space-y-6">
            <div class="h-96">
              <Bar :data="operationErrorsChartData" :options="operationChartOptions" />
            </div>
            
            <!-- Operation Details Table -->
            <div class="overflow-x-auto">
              <table class="w-full">
                <thead class="bg-gray-50 border-b border-gray-200">
                  <tr>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase">Operation</th>
                    <th class="px-4 py-3 text-left text-xs font-semibold text-gray-600 uppercase">Connector</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Total</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Success</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Errors</th>
                    <th class="px-4 py-3 text-right text-xs font-semibold text-gray-600 uppercase">Success Rate</th>
                  </tr>
                </thead>
                <tbody class="divide-y divide-gray-200">
                  <tr v-for="stat in sortedOperationStats" :key="`${stat.operationId}-${stat.connectorId}`" class="hover:bg-gray-50">
                    <td class="px-4 py-3 font-medium text-gray-900">{{ stat.operationKey }}</td>
                    <td class="px-4 py-3">
                      <div class="flex items-center gap-2">
                        <img 
                          v-if="getConnectorIcon(stat.connectorId)" 
                          :src="getConnectorIcon(stat.connectorId)" 
                          :alt="stat.connectorName"
                          class="w-6 h-6 object-contain"
                        />
                        <span class="text-sm text-gray-600">{{ stat.connectorName }}</span>
                      </div>
                    </td>
                    <td class="px-4 py-3 text-right text-gray-600">{{ stat.totalExecutions }}</td>
                    <td class="px-4 py-3 text-right text-green-600 font-medium">{{ stat.successCount }}</td>
                    <td class="px-4 py-3 text-right">
                      <span :class="stat.errorCount > 0 ? 'text-red-600 font-bold' : 'text-gray-400'">
                        {{ stat.errorCount }}
                      </span>
                    </td>
                    <td class="px-4 py-3 text-right">
                      <span :class="[
                        'px-2 py-1 rounded text-xs font-semibold',
                        stat.successRate >= 95 ? 'bg-green-100 text-green-800' :
                        stat.successRate >= 80 ? 'bg-yellow-100 text-yellow-800' :
                        'bg-red-100 text-red-800'
                      ]">
                        {{ stat.successRate.toFixed(1) }}%
                      </span>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
          <div v-else class="text-center py-12 text-gray-400">
            <p class="text-lg font-medium">No execution data available</p>
            <p class="text-sm">Execute some operations to see operation statistics</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { Bar } from 'vue-chartjs';
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  LinearScale
} from 'chart.js';
import { useApi } from '../composables/useApi';

// Register Chart.js components
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

const { apiCall } = useApi();

interface ExecutionStats {
  totalExecutions: number;
  successCount: number;
  errorCount: number;
  timeoutCount: number;
  successRate: number;
  avgDurationMs: number;
  minDurationMs: number;
  maxDurationMs: number;
  errorBreakdown: Array<{
    errorType: string;
    count: number;
    percentage: number;
  }>;
}

interface ConnectorSummary {
  id: number;
  name: string;
  mavenArtifactId: string;
  icon?: string;
}

interface ExecutionLogSummary {
  executionId: string;
  operationId: number;
  operationKey: string;
  connectorId: number;
  connectorName: string;
  status: string;
  durationMs: number;
}

const loading = ref(true);
const error = ref<string | null>(null);
const activeView = ref<'overall' | 'connectors' | 'operations'>('overall');
const overallStats = ref<ExecutionStats | null>(null);
const connectors = ref<ConnectorSummary[]>([]);
const executionLogs = ref<ExecutionLogSummary[]>([]);

// Determine base URL for assets
import { MULE_ORIGIN } from '../config/api';

const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: false
    }
  },
  scales: {
    y: {
      beginAtZero: true
    }
  }
};

const connectorChartOptions = {
  ...chartOptions,
  indexAxis: 'y' as const,
  plugins: {
    legend: {
      display: true,
      position: 'bottom' as const
    }
  }
};

const operationChartOptions = {
  ...chartOptions,
  indexAxis: 'y' as const,
  plugins: {
    legend: {
      display: true,
      position: 'bottom' as const
    }
  }
};

const statusChartData = computed(() => ({
  labels: ['Success', 'Error', 'Timeout'],
  datasets: [{
    label: 'Executions',
    data: [
      overallStats.value?.successCount || 0,
      overallStats.value?.errorCount || 0,
      overallStats.value?.timeoutCount || 0
    ],
    backgroundColor: [
      'rgba(16, 185, 129, 0.8)',
      'rgba(239, 68, 68, 0.8)',
      'rgba(251, 191, 36, 0.8)'
    ],
    borderColor: [
      'rgb(16, 185, 129)',
      'rgb(239, 68, 68)',
      'rgb(251, 191, 36)'
    ],
    borderWidth: 2
  }]
}));

const errorChartData = computed(() => ({
  labels: overallStats.value?.errorBreakdown?.map(e => e.errorType) || [],
  datasets: [{
    label: 'Error Count',
    data: overallStats.value?.errorBreakdown?.map(e => e.count) || [],
    backgroundColor: 'rgba(239, 68, 68, 0.8)',
    borderColor: 'rgb(239, 68, 68)',
    borderWidth: 2
  }]
}));

// Compute per-connector stats
const connectorStats = computed(() => {
  const statsByConnector = new Map<number, {
    connectorId: number;
    connectorName: string;
    totalExecutions: number;
    successCount: number;
    errorCount: number;
    timeoutCount: number;
  }>();

  executionLogs.value.forEach(log => {
    if (!statsByConnector.has(log.connectorId)) {
      statsByConnector.set(log.connectorId, {
        connectorId: log.connectorId,
        connectorName: log.connectorName,
        totalExecutions: 0,
        successCount: 0,
        errorCount: 0,
        timeoutCount: 0
      });
    }

    const stats = statsByConnector.get(log.connectorId)!;
    stats.totalExecutions++;
    if (log.status === 'success') stats.successCount++;
    if (log.status === 'error') stats.errorCount++;
    if (log.status === 'timeout') stats.timeoutCount++;
  });

  return Array.from(statsByConnector.values()).map(stats => ({
    ...stats,
    successRate: stats.totalExecutions > 0 ? (stats.successCount / stats.totalExecutions) * 100 : 0
  })).sort((a, b) => b.errorCount - a.errorCount);
});

const connectorErrorsChartData = computed(() => ({
  labels: connectorStats.value.map(s => s.connectorName),
  datasets: [
    {
      label: 'Errors',
      data: connectorStats.value.map(s => s.errorCount),
      backgroundColor: 'rgba(239, 68, 68, 0.8)',
      borderColor: 'rgb(239, 68, 68)',
      borderWidth: 2
    },
    {
      label: 'Success',
      data: connectorStats.value.map(s => s.successCount),
      backgroundColor: 'rgba(16, 185, 129, 0.8)',
      borderColor: 'rgb(16, 185, 129)',
      borderWidth: 2
    }
  ]
}));

// Compute per-operation stats
const operationStats = computed(() => {
  const statsByOperation = new Map<string, {
    operationId: number;
    operationKey: string;
    connectorId: number;
    connectorName: string;
    totalExecutions: number;
    successCount: number;
    errorCount: number;
    timeoutCount: number;
  }>();

  executionLogs.value.forEach(log => {
    const key = `${log.operationId}-${log.connectorId}`;
    if (!statsByOperation.has(key)) {
      statsByOperation.set(key, {
        operationId: log.operationId,
        operationKey: log.operationKey,
        connectorId: log.connectorId,
        connectorName: log.connectorName,
        totalExecutions: 0,
        successCount: 0,
        errorCount: 0,
        timeoutCount: 0
      });
    }

    const stats = statsByOperation.get(key)!;
    stats.totalExecutions++;
    if (log.status === 'success') stats.successCount++;
    if (log.status === 'error') stats.errorCount++;
    if (log.status === 'timeout') stats.timeoutCount++;
  });

  return Array.from(statsByOperation.values()).map(stats => ({
    ...stats,
    successRate: stats.totalExecutions > 0 ? (stats.successCount / stats.totalExecutions) * 100 : 0
  }));
});

const sortedOperationStats = computed(() => {
  return [...operationStats.value].sort((a, b) => b.errorCount - a.errorCount);
});

const operationErrorsChartData = computed(() => {
  // Show top 10 operations with most errors
  const topErrorOps = sortedOperationStats.value.slice(0, 10);
  
  return {
    labels: topErrorOps.map(s => `${s.operationKey} (${s.connectorName})`),
    datasets: [
      {
        label: 'Errors',
        data: topErrorOps.map(s => s.errorCount),
        backgroundColor: 'rgba(239, 68, 68, 0.8)',
        borderColor: 'rgb(239, 68, 68)',
        borderWidth: 2
      },
      {
        label: 'Success',
        data: topErrorOps.map(s => s.successCount),
        backgroundColor: 'rgba(16, 185, 129, 0.8)',
        borderColor: 'rgb(16, 185, 129)',
        borderWidth: 2
      }
    ]
  };
});

function getConnectorIcon(connectorId: number): string {
  const connector = connectors.value.find(c => c.id === connectorId);
  if (!connector?.icon) return '';
  
  // Handle absolute URLs
  if (connector.icon.startsWith('http://') || connector.icon.startsWith('https://') || connector.icon.startsWith('data:')) {
    return connector.icon;
  }
  
  // Handle relative paths with /webapp/ prefix
  return `${MULE_ORIGIN}${connector.icon.startsWith('/') ? '' : '/'}${connector.icon}`;
}

async function loadAllData() {
  loading.value = true;
  error.value = null;
  
  try {
    // Load overall stats
    overallStats.value = await apiCall('/execution-stats', 'GET');
    
    // Load all connectors
    connectors.value = await apiCall('/connectors?filter=all', 'GET');
    
    // Load execution logs for detailed breakdown
    executionLogs.value = await apiCall('/execution-logs?limit=500', 'GET');
    
  } catch (e: any) {
    error.value = e.message || 'Failed to load execution statistics';
  } finally {
    loading.value = false;
  }
}

onMounted(() => {
  loadAllData();
});
</script>

