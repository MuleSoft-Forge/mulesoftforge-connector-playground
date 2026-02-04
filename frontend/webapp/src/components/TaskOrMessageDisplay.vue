<template>
  <div v-if="data" class="space-y-4">
    <!-- Main Header -->
    <div :class="[
      'rounded-lg p-5 text-white',
      isTask ? 'bg-gradient-to-r from-purple-600 to-indigo-600' : 'bg-gradient-to-r from-blue-600 to-cyan-600'
    ]">
      <div class="flex items-start justify-between">
        <div class="flex-1">
          <div class="flex items-center gap-3 mb-2">
            <span class="text-3xl">{{ isTask ? '📋' : '💬' }}</span>
            <div>
              <h3 class="text-2xl font-bold">{{ isTask ? 'Task' : 'Message' }}</h3>
              <p v-if="data.status" class="text-sm opacity-90">
                Status: <span :class="statusClass">{{ data.status.state }}</span>
              </p>
            </div>
          </div>
        </div>
        <div class="text-right space-y-1">
          <div v-if="data.id || data.taskId" class="text-xs opacity-75">
            {{ isTask ? 'Task ID' : 'Task ID' }}
          </div>
          <div class="font-mono text-sm bg-white/20 px-3 py-1 rounded">
            {{ data.id || data.taskId }}
          </div>
        </div>
      </div>

      <!-- Context ID -->
      <div v-if="data.contextId" class="mt-3 pt-3 border-t border-white/20">
        <div class="flex items-center gap-2 text-xs">
          <span class="opacity-75">Context ID:</span>
          <code class="font-mono bg-white/20 px-2 py-0.5 rounded">{{ data.contextId }}</code>
        </div>
      </div>

      <!-- Message ID (for messages) -->
      <div v-if="data.messageId" class="mt-2">
        <div class="flex items-center gap-2 text-xs">
          <span class="opacity-75">Message ID:</span>
          <code class="font-mono bg-white/20 px-2 py-0.5 rounded">{{ data.messageId }}</code>
        </div>
      </div>
    </div>

    <!-- Status Details (for Tasks) -->
    <div v-if="data.status" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Task Status
      </h4>
      
      <!-- Status Progress Bar -->
      <div class="mb-4">
        <div class="flex items-center justify-between mb-2">
          <span :class="['px-3 py-1.5 rounded-full text-sm font-bold', getStateColor(data.status.state)]">
            {{ getStateEmoji(data.status.state) }} {{ data.status.state }}
          </span>
          <span v-if="data.status.timestamp" class="text-xs text-gray-500">
            {{ formatTimestamp(data.status.timestamp) }}
          </span>
        </div>
        
        <!-- Visual Progress Indicator -->
        <div class="relative pt-1">
          <div class="flex mb-2 items-center justify-between">
            <div class="flex space-x-1 text-xs">
              <span :class="getProgressStepClass('submitted', data.status.state)">Submitted</span>
              <span class="text-gray-400">→</span>
              <span :class="getProgressStepClass('working', data.status.state)">Working</span>
              <span class="text-gray-400">→</span>
              <span :class="getProgressStepClass('completed', data.status.state)">Done</span>
            </div>
          </div>
          <div class="overflow-hidden h-2 text-xs flex rounded bg-gray-200">
            <div 
              :style="{ width: getProgressPercentage(data.status.state) + '%' }" 
              :class="['shadow-none flex flex-col text-center whitespace-nowrap text-white justify-center transition-all duration-500', getProgressBarColor(data.status.state)]"
            ></div>
          </div>
        </div>
      </div>

      <!-- Status Message (A2A Message Object) -->
      <div v-if="data.status.message" class="mt-3 p-3 bg-purple-50 border-2 border-purple-200 rounded-lg">
        <div class="text-[10px] font-semibold text-purple-700 uppercase mb-2">Status Update Message</div>
        <div class="bg-white rounded p-3 border border-purple-200">
          <div class="flex items-center gap-2 mb-2">
            <span :class="[
              'px-2 py-1 rounded text-xs font-bold',
              data.status.message.role === 'user' ? 'bg-green-200 text-green-900' : 'bg-blue-200 text-blue-900'
            ]">
              {{ data.status.message.role === 'user' ? '👤 User' : '🤖 Agent' }}
            </span>
            <span v-if="data.status.message.messageId" class="text-[10px] font-mono text-gray-400 bg-gray-100 px-2 py-0.5 rounded">
              {{ data.status.message.messageId.substring(0, 8) }}...
            </span>
          </div>
          
          <!-- Message Parts -->
          <div v-if="data.status.message.parts && data.status.message.parts.length > 0" class="space-y-2">
            <div v-for="(part, idx) in data.status.message.parts" :key="idx">
              <div v-if="part.text" class="text-sm text-gray-800">{{ part.text }}</div>
              <div v-if="part.file" class="text-xs text-gray-600 flex items-center gap-1">
                📎 {{ part.file.name || 'Attachment' }}
              </div>
              <div v-if="part.data" class="text-xs">
                <pre class="bg-gray-50 p-2 rounded font-mono text-[10px]">{{ JSON.stringify(part.data, null, 2) }}</pre>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Additional Status Details -->
      <div v-if="data.status.code" class="mt-2 flex items-center gap-2 text-xs">
        <span class="font-semibold text-gray-700">Code:</span>
        <code class="px-2 py-0.5 bg-gray-100 text-gray-800 rounded">{{ data.status.code }}</code>
      </div>
    </div>

    <!-- Message Content (Parts) -->
    <div v-if="data.parts && data.parts.length > 0" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 10h.01M12 10h.01M16 10h.01M9 16H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-5l-5 5v-5z"/>
        </svg>
        Content ({{ data.parts.length }} part{{ data.parts.length > 1 ? 's' : '' }})
      </h4>
      <div class="space-y-3">
        <div v-for="(part, idx) in data.parts" :key="idx" class="border border-gray-200 rounded-lg p-3 hover:border-blue-300 transition-colors">
          <div class="flex items-center gap-2 mb-2">
            <span :class="['px-2 py-0.5 rounded text-xs font-medium', getPartTypeColor(part.kind)]">
              {{ part.kind || 'text' }}
            </span>
          </div>
          
          <!-- Text Content -->
          <div v-if="part.text" class="text-sm text-gray-700 whitespace-pre-wrap">{{ part.text }}</div>
          
          <!-- File Content -->
          <div v-if="part.file" class="bg-gray-50 rounded p-2 text-xs">
            <div class="flex items-center gap-2 mb-1">
              <span class="text-gray-700 font-medium">📎 {{ part.file.name || 'File' }}</span>
              <span v-if="part.file.mimeType" class="text-gray-500">{{ part.file.mimeType }}</span>
            </div>
            <div v-if="part.file.uri" class="text-blue-600 truncate mb-1">
              <a :href="part.file.uri" target="_blank" class="hover:underline">{{ part.file.uri }}</a>
            </div>
            <!-- Base64 File Preview/Download -->
            <div v-if="part.file.bytes" class="mt-2 pt-2 border-t border-gray-200">
              <div v-if="isImageMimeType(part.file.mimeType)" class="mb-2">
                <img :src="getDataUri(part.file.bytes, part.file.mimeType)" :alt="part.file.name || 'File'" class="max-w-full max-h-48 rounded border border-gray-300">
              </div>
              <button 
                @click="downloadFile(part.file.bytes, part.file.name, part.file.mimeType)" 
                class="px-2 py-1 bg-blue-500 text-white rounded text-xs hover:bg-blue-600 transition-colors"
              >
                ⬇️ Download ({{ formatFileSize(part.file.bytes) }})
              </button>
            </div>
          </div>
          
          <!-- Data Content -->
          <div v-if="part.data" class="bg-gray-50 rounded p-2">
            <pre class="text-[11px] font-mono text-gray-700 overflow-x-auto">{{ JSON.stringify(part.data, null, 2) }}</pre>
          </div>

          <!-- Metadata -->
          <div v-if="part.metadata" class="mt-2 pt-2 border-t border-gray-100">
            <details class="text-xs">
              <summary class="cursor-pointer text-gray-600 hover:text-gray-900 font-medium">Metadata</summary>
              <pre class="mt-1 text-[10px] font-mono text-gray-600">{{ JSON.stringify(part.metadata, null, 2) }}</pre>
            </details>
          </div>
        </div>
      </div>
    </div>

    <!-- Role (for Messages) -->
    <div v-if="data.role" class="bg-white border border-gray-200 rounded-lg p-4">
      <div class="flex items-center gap-2">
        <span class="text-sm font-medium text-gray-700">Role:</span>
        <span :class="[
          'px-3 py-1 rounded-full text-xs font-semibold',
          data.role === 'user' ? 'bg-green-100 text-green-800' : 'bg-blue-100 text-blue-800'
        ]">
          {{ data.role === 'user' ? '👤 User' : '🤖 Agent' }}
        </span>
      </div>
    </div>

    <!-- Artifacts -->
    <div v-if="data.artifacts && data.artifacts.length > 0" class="bg-white border-2 border-purple-300 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-purple-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
        </svg>
        Task Artifacts ({{ data.artifacts.length }})
        <span class="ml-2 px-2 py-0.5 bg-purple-100 text-purple-800 rounded text-[10px] font-bold">ATTACHMENTS</span>
      </h4>
      <div class="space-y-4">
        <div v-for="artifact in data.artifacts" :key="artifact.artifactId" class="border-2 border-purple-200 rounded-lg bg-gradient-to-br from-purple-50 to-white shadow-sm hover:shadow-md transition-shadow">
          <!-- Artifact Header -->
          <div class="bg-purple-100 px-4 py-3 rounded-t-lg border-b-2 border-purple-200">
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <div class="flex items-center gap-2 mb-1">
                  <span class="text-lg">📄</span>
                  <h5 class="text-sm font-bold text-purple-900">{{ artifact.name || 'Untitled Artifact' }}</h5>
                </div>
                <p v-if="artifact.description" class="text-xs text-purple-700 ml-7">{{ artifact.description }}</p>
              </div>
              <span class="text-[10px] font-mono text-purple-600 bg-white px-2 py-1 rounded border border-purple-200">
                {{ artifact.artifactId.substring(0, 12) }}...
              </span>
            </div>
          </div>
          
          <!-- Artifact Body -->
          <div class="px-4 py-3">
            <!-- Artifact Parts -->
            <div v-if="artifact.parts && artifact.parts.length > 0" class="space-y-2">
              <div class="text-[10px] font-semibold text-purple-700 uppercase mb-2">
                Content ({{ artifact.parts.length }} part{{ artifact.parts.length > 1 ? 's' : '' }})
              </div>
              <div v-for="(part, idx) in artifact.parts" :key="idx" class="bg-white rounded-lg p-3 border border-purple-200 shadow-sm">
                <div class="flex items-center gap-2 mb-2">
                  <span :class="['px-2 py-1 rounded text-xs font-bold', getPartTypeColor(part.kind)]">
                    {{ part.kind || 'text' }}
                  </span>
                  <span v-if="idx > 0" class="text-[10px] text-gray-400">Part {{ idx + 1 }}</span>
                </div>
                
                <!-- Text Content -->
                <div v-if="part.text" class="text-sm text-gray-800 leading-relaxed">{{ part.text }}</div>
                
                <!-- File Content -->
                <div v-if="part.file" class="bg-purple-50 rounded-lg p-3 border border-purple-200">
                  <div class="flex items-start gap-3">
                    <span class="text-2xl">📎</span>
                    <div class="flex-1">
                      <div class="font-semibold text-purple-900 text-sm">{{ part.file.name || 'Unnamed File' }}</div>
                      <div v-if="part.file.mimeType" class="text-xs text-purple-700 mt-0.5">{{ part.file.mimeType }}</div>
                      <div v-if="part.file.uri" class="text-xs text-blue-600 hover:text-blue-800 mt-1 truncate">
                        <a :href="part.file.uri" target="_blank" class="hover:underline">{{ part.file.uri }}</a>
                      </div>
                      
                      <!-- Base64 File Preview/Download -->
                      <div v-if="part.file.bytes" class="mt-3 pt-3 border-t border-purple-200">
                        <div v-if="isImageMimeType(part.file.mimeType)" class="mb-2">
                          <img :src="getDataUri(part.file.bytes, part.file.mimeType)" :alt="part.file.name || 'File'" class="max-w-full max-h-48 rounded border border-purple-300">
                        </div>
                        <button 
                          @click="downloadFile(part.file.bytes, part.file.name, part.file.mimeType)" 
                          class="px-3 py-1.5 bg-purple-600 text-white rounded text-xs font-semibold hover:bg-purple-700 transition-colors"
                        >
                          ⬇️ Download File ({{ formatFileSize(part.file.bytes) }})
                        </button>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Data Content -->
                <div v-if="part.data" class="bg-gray-900 rounded-lg p-3 border border-gray-700">
                  <div class="text-[10px] text-gray-400 mb-1 font-semibold">JSON DATA</div>
                  <pre class="text-[11px] font-mono text-green-400 overflow-x-auto">{{ JSON.stringify(part.data, null, 2) }}</pre>
                </div>

                <!-- Part Metadata -->
                <div v-if="part.metadata" class="mt-2 pt-2 border-t border-gray-200">
                  <details class="text-xs">
                    <summary class="cursor-pointer text-purple-700 hover:text-purple-900 font-semibold">Part Metadata</summary>
                    <pre class="mt-2 text-[10px] font-mono text-gray-600 bg-gray-50 p-2 rounded">{{ JSON.stringify(part.metadata, null, 2) }}</pre>
                  </details>
                </div>
              </div>
            </div>

            <!-- Artifact Metadata -->
            <div v-if="artifact.metadata" class="mt-3 pt-3 border-t border-purple-200">
              <details class="text-xs">
                <summary class="cursor-pointer text-purple-700 hover:text-purple-900 font-semibold">Artifact Metadata</summary>
                <pre class="mt-2 text-[10px] font-mono text-gray-600 bg-purple-50 p-2 rounded border border-purple-200">{{ JSON.stringify(artifact.metadata, null, 2) }}</pre>
              </details>
            </div>

            <!-- Extensions -->
            <div v-if="artifact.extensions && artifact.extensions.length > 0" class="mt-3 pt-3 border-t border-purple-200">
              <div class="text-[10px] font-semibold text-purple-700 uppercase mb-2">Extensions</div>
              <div class="flex flex-wrap gap-1">
                <span v-for="ext in artifact.extensions" :key="ext" class="px-2 py-1 bg-purple-200 text-purple-900 rounded text-xs font-medium">
                  ⚡ {{ ext }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- History Timeline -->
    <div v-if="data.history && data.history.length > 0" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        Conversation History ({{ data.history.length }} message{{ data.history.length > 1 ? 's' : '' }})
      </h4>
      <div class="relative">
        <!-- Timeline Line -->
        <div class="absolute left-4 top-0 bottom-0 w-0.5 bg-gradient-to-b from-blue-300 via-blue-200 to-transparent"></div>
        
        <div class="space-y-4">
          <div v-for="(msg, idx) in data.history" :key="idx" class="relative pl-10">
            <!-- Timeline Dot -->
            <div :class="[
              'absolute left-2 top-2 w-4 h-4 rounded-full border-2',
              msg.role === 'user' 
                ? 'bg-green-500 border-green-300' 
                : 'bg-blue-500 border-blue-300'
            ]"></div>
            
            <!-- Message Card -->
            <div :class="[
              'rounded-lg p-3 border-2 shadow-sm',
              msg.role === 'user' 
                ? 'bg-green-50 border-green-200' 
                : 'bg-blue-50 border-blue-200'
            ]">
              <div class="flex items-center justify-between mb-2">
                <div class="flex items-center gap-2">
                  <span :class="[
                    'px-2 py-1 rounded text-xs font-bold',
                    msg.role === 'user' 
                      ? 'bg-green-200 text-green-900' 
                      : 'bg-blue-200 text-blue-900'
                  ]">
                    {{ msg.role === 'user' ? '👤 User' : '🤖 Agent' }}
                  </span>
                  <span class="text-[10px] text-gray-500">Message {{ idx + 1 }}</span>
                </div>
                <span v-if="msg.messageId" class="text-[10px] font-mono text-gray-400 bg-white px-2 py-0.5 rounded">
                  {{ msg.messageId.substring(0, 8) }}...
                </span>
              </div>
              
              <!-- Message Content -->
              <div v-if="msg.parts && msg.parts.length > 0" class="space-y-2">
                <div v-for="(part, pIdx) in msg.parts" :key="pIdx" class="text-sm">
                  <div v-if="part.text" class="text-gray-800 bg-white rounded p-2 border border-gray-200">
                    {{ part.text }}
                  </div>
                  <div v-if="part.file" class="text-xs text-gray-600 bg-white rounded p-2 border border-gray-200">
                    📎 {{ part.file.name || 'Attachment' }}
                  </div>
                </div>
              </div>
              
              <!-- Context/Task IDs -->
              <div v-if="msg.contextId || msg.taskId" class="mt-2 pt-2 border-t border-gray-200 flex flex-wrap gap-2 text-[10px]">
                <span v-if="msg.contextId" class="text-gray-500">
                  Context: <code class="font-mono bg-white px-1 rounded">{{ msg.contextId.substring(0, 12) }}...</code>
                </span>
                <span v-if="msg.taskId" class="text-gray-500">
                  Task: <code class="font-mono bg-white px-1 rounded">{{ msg.taskId.substring(0, 12) }}...</code>
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Reference Task IDs -->
    <div v-if="data.referenceTaskIds && data.referenceTaskIds.length > 0" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"/>
        </svg>
        Referenced Tasks
      </h4>
      <div class="flex flex-wrap gap-2">
        <code v-for="taskId in data.referenceTaskIds" :key="taskId" class="px-2 py-1 bg-gray-100 text-gray-800 rounded text-xs font-mono">
          {{ taskId }}
        </code>
      </div>
    </div>

    <!-- Extensions (for Messages) -->
    <div v-if="data.extensions && data.extensions.length > 0" class="bg-white border-2 border-indigo-300 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 4a2 2 0 114 0v1a1 1 0 001 1h3a1 1 0 011 1v3a1 1 0 01-1 1h-1a2 2 0 100 4h1a1 1 0 011 1v3a1 1 0 01-1 1h-3a1 1 0 01-1-1v-1a2 2 0 10-4 0v1a1 1 0 01-1 1H7a1 1 0 01-1-1v-3a1 1 0 00-1-1H4a2 2 0 110-4h1a1 1 0 001-1V7a1 1 0 011-1h3a1 1 0 001-1V4z"/>
        </svg>
        Protocol Extensions
        <span class="ml-2 px-2 py-0.5 bg-indigo-100 text-indigo-800 rounded text-[10px] font-bold">EXTENDED</span>
      </h4>
      <div class="flex flex-wrap gap-2">
        <span v-for="ext in data.extensions" :key="ext" class="px-3 py-1.5 bg-indigo-100 text-indigo-900 rounded-lg text-xs font-semibold border border-indigo-200">
          ⚡ {{ ext }}
        </span>
      </div>
    </div>

    <!-- Metadata -->
    <div v-if="data.metadata" class="bg-white border border-gray-200 rounded-lg p-4">
      <details>
        <summary class="text-sm font-semibold text-gray-900 cursor-pointer hover:text-gray-700 flex items-center">
          <svg class="w-4 h-4 mr-2 text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z"/>
          </svg>
          Metadata
        </summary>
        <pre class="mt-3 bg-gray-50 border border-gray-200 rounded p-3 overflow-x-auto text-[11px] font-mono text-gray-700">{{ JSON.stringify(data.metadata, null, 2) }}</pre>
      </details>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  payload: any
}>()

// Determine if this is a Task or Message
const isTask = computed(() => {
  if (!props.payload) return false
  return props.payload.kind === 'task' || (props.payload.status && !props.payload.kind)
})

const data = computed(() => {
  if (!props.payload) return null
  return props.payload
})

const statusClass = computed(() => {
  if (!data.value?.status?.state) return ''
  const state = data.value.status.state.toLowerCase()
  
  const classes: Record<string, string> = {
    'completed': 'text-green-200 font-semibold',
    'working': 'text-yellow-200 font-semibold',
    'submitted': 'text-blue-200 font-semibold',
    'failed': 'text-red-200 font-semibold',
    'canceled': 'text-gray-200 font-semibold',
    'rejected': 'text-red-200 font-semibold',
    'input-required': 'text-orange-200 font-semibold',
    'auth-required': 'text-orange-200 font-semibold',
    'unknown': 'text-gray-200 font-semibold'
  }
  
  return classes[state] || 'text-white'
})

function getStateColor(state: string): string {
  const stateMap: Record<string, string> = {
    'completed': 'bg-green-100 text-green-800',
    'working': 'bg-yellow-100 text-yellow-800',
    'submitted': 'bg-blue-100 text-blue-800',
    'failed': 'bg-red-100 text-red-800',
    'canceled': 'bg-gray-100 text-gray-800',
    'rejected': 'bg-red-100 text-red-800',
    'input-required': 'bg-orange-100 text-orange-800',
    'auth-required': 'bg-orange-100 text-orange-800',
    'unknown': 'bg-gray-100 text-gray-800'
  }
  return stateMap[state.toLowerCase()] || 'bg-gray-100 text-gray-800'
}

function getPartTypeColor(kind: string): string {
  const typeMap: Record<string, string> = {
    'text': 'bg-blue-100 text-blue-800',
    'file': 'bg-purple-100 text-purple-800',
    'data': 'bg-green-100 text-green-800'
  }
  return typeMap[kind] || 'bg-gray-100 text-gray-800'
}

function formatTimestamp(timestamp: string): string {
  try {
    const date = new Date(timestamp)
    return date.toLocaleString()
  } catch {
    return timestamp
  }
}

function getStateEmoji(state: string): string {
  const emojiMap: Record<string, string> = {
    'completed': '✅',
    'working': '⚙️',
    'submitted': '📤',
    'failed': '❌',
    'canceled': '🚫',
    'rejected': '⛔',
    'input-required': '⚠️',
    'auth-required': '🔐',
    'unknown': '❓'
  }
  return emojiMap[state.toLowerCase()] || '❓'
}

function getProgressPercentage(state: string): number {
  const progressMap: Record<string, number> = {
    'submitted': 25,
    'working': 60,
    'completed': 100,
    'failed': 100,
    'canceled': 50,
    'rejected': 25,
    'input-required': 75,
    'auth-required': 10,
    'unknown': 0
  }
  return progressMap[state.toLowerCase()] || 0
}

function getProgressBarColor(state: string): string {
  const colorMap: Record<string, string> = {
    'completed': 'bg-green-500',
    'working': 'bg-yellow-500',
    'submitted': 'bg-blue-500',
    'failed': 'bg-red-500',
    'canceled': 'bg-gray-500',
    'rejected': 'bg-red-500',
    'input-required': 'bg-orange-500',
    'auth-required': 'bg-orange-500',
    'unknown': 'bg-gray-400'
  }
  return colorMap[state.toLowerCase()] || 'bg-gray-400'
}

function getProgressStepClass(step: string, currentState: string): string {
  const currentLower = currentState.toLowerCase()
  const stepLower = step.toLowerCase()
  
  const stateOrder = ['submitted', 'working', 'completed']
  const currentIndex = stateOrder.indexOf(currentLower)
  const stepIndex = stateOrder.indexOf(stepLower)
  
  if (currentIndex >= stepIndex) {
    return 'font-bold text-blue-700'
  }
  return 'text-gray-400'
}

// File utilities
function isImageMimeType(mimeType?: string): boolean {
  if (!mimeType) return false
  return mimeType.startsWith('image/')
}

function getDataUri(base64: string, mimeType?: string): string {
  const mime = mimeType || 'application/octet-stream'
  // Remove any existing data URI prefix if present
  const cleanBase64 = base64.replace(/^data:.*?;base64,/, '')
  return `data:${mime};base64,${cleanBase64}`
}

function downloadFile(base64: string, filename?: string, mimeType?: string): void {
  const dataUri = getDataUri(base64, mimeType)
  const link = document.createElement('a')
  link.href = dataUri
  link.download = filename || 'download'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

function formatFileSize(base64: string): string {
  // Base64 encoding increases size by ~33%, so decode to get actual size
  const cleanBase64 = base64.replace(/^data:.*?;base64,/, '').replace(/[^A-Za-z0-9+/=]/g, '')
  const bytes = (cleanBase64.length * 3) / 4
  
  if (bytes < 1024) return bytes.toFixed(0) + ' B'
  if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB'
  return (bytes / (1024 * 1024)).toFixed(1) + ' MB'
}
</script>










