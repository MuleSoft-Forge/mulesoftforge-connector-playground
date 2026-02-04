<template>
  <div v-if="card" class="space-y-4">
    <!-- Agent Header -->
    <div class="bg-gradient-to-r from-blue-600 to-cyan-600 rounded-lg p-5 text-white">
      <div class="flex items-start gap-4">
        <!-- Agent Icon -->
        <div v-if="card.iconUrl" class="flex-shrink-0">
          <img :src="card.iconUrl" alt="Agent Icon" class="w-16 h-16 rounded-lg bg-white/20 p-2">
        </div>
        <div v-else class="flex-shrink-0">
          <div class="w-16 h-16 rounded-lg bg-white/20 flex items-center justify-center text-2xl">
            🤖
          </div>
        </div>
        
        <!-- Agent Info -->
        <div class="flex-1">
          <h3 class="text-2xl font-bold mb-1">{{ card.name }}</h3>
          <p class="text-blue-100 text-sm mb-2">{{ card.description }}</p>
          <div class="flex flex-wrap gap-2 text-xs">
            <span class="px-2 py-1 bg-white/20 rounded">v{{ card.version }}</span>
            <span v-if="card.protocolVersion" class="px-2 py-1 bg-white/20 rounded">
              A2A Protocol {{ card.protocolVersion }}
            </span>
            <a v-if="card.url" :href="card.url" target="_blank" class="px-2 py-1 bg-white/20 rounded hover:bg-white/30 transition-colors">
              🔗 Agent URL
            </a>
            <a v-if="card.documentationUrl" :href="card.documentationUrl" target="_blank" class="px-2 py-1 bg-white/20 rounded hover:bg-white/30 transition-colors">
              📚 Documentation
            </a>
          </div>
        </div>
      </div>

      <!-- Provider -->
      <div v-if="card.provider" class="mt-4 pt-4 border-t border-white/20">
        <p class="text-xs text-blue-100 mb-1">Provided by</p>
        <div class="flex items-center gap-2">
          <span class="font-semibold">{{ card.provider.organization }}</span>
          <a v-if="card.provider.url" :href="card.provider.url" target="_blank" class="text-xs hover:underline">
            {{ card.provider.url }}
          </a>
        </div>
      </div>
    </div>

    <!-- Supported Interfaces (REQUIRED) -->
    <div v-if="card.supportedInterfaces && card.supportedInterfaces.length > 0" class="bg-white border-2 border-blue-300 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/>
        </svg>
        Supported Interfaces
        <span class="ml-2 px-2 py-0.5 bg-blue-100 text-blue-800 rounded text-[10px] font-bold">REQUIRED</span>
      </h4>
      <div class="space-y-3">
        <div v-for="(iface, idx) in card.supportedInterfaces" :key="idx" class="bg-blue-50 border border-blue-200 rounded-lg p-3">
          <div class="flex items-start justify-between mb-2">
            <div class="flex-1">
              <div class="flex items-center gap-2 mb-1">
                <span class="px-2 py-1 bg-blue-200 text-blue-900 rounded text-xs font-bold">
                  {{ iface.protocolBinding }}
                </span>
                <span v-if="iface.tenant" class="px-2 py-1 bg-gray-200 text-gray-800 rounded text-[10px]">
                  Tenant: {{ iface.tenant }}
                </span>
              </div>
              <a :href="iface.url" target="_blank" class="text-xs text-blue-700 hover:text-blue-900 hover:underline font-mono break-all">
                {{ iface.url }}
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Capabilities -->
    <div v-if="card.capabilities" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
        </svg>
        Capabilities
      </h4>
      <div class="flex flex-wrap gap-2">
        <span v-if="card.capabilities.streaming" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
          <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          Streaming
        </span>
        <span v-if="card.capabilities.pushNotifications" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
          <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          Push Notifications
        </span>
        <span v-if="card.capabilities.stateTransitionHistory" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
          <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
          </svg>
          State Transition History
        </span>
        <span v-if="card.capabilities.extensions && card.capabilities.extensions.length > 0" class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
          ⚡ {{ card.capabilities.extensions.length }} Extension(s)
        </span>
      </div>

      <!-- Extensions Details -->
      <div v-if="card.capabilities.extensions && card.capabilities.extensions.length > 0" class="mt-3 space-y-2">
        <div v-for="(ext, idx) in card.capabilities.extensions" :key="idx" class="text-xs bg-purple-50 border border-purple-200 rounded p-2">
          <div class="font-medium text-purple-900">{{ ext.uri }}</div>
          <div v-if="ext.description" class="text-purple-700 mt-0.5">{{ ext.description }}</div>
          <span v-if="ext.required" class="inline-block mt-1 px-2 py-0.5 bg-purple-200 text-purple-900 rounded text-[10px] font-semibold">
            REQUIRED
          </span>
        </div>
      </div>
    </div>

    <!-- Skills -->
    <div v-if="card.skills && card.skills.length > 0" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
        </svg>
        Skills ({{ card.skills.length }})
      </h4>
      <div class="space-y-3">
        <div v-for="skill in card.skills" :key="skill.id" class="border border-gray-200 rounded-lg p-3 hover:border-blue-300 transition-colors">
          <div class="flex items-start justify-between mb-2">
            <div class="flex-1">
              <h5 class="text-sm font-semibold text-gray-900">{{ skill.name }}</h5>
              <p class="text-xs text-gray-600 mt-1">{{ skill.description }}</p>
            </div>
            <span class="text-[10px] font-mono text-gray-400 ml-2">{{ skill.id }}</span>
          </div>
          
          <!-- Tags -->
          <div v-if="skill.tags && skill.tags.length > 0" class="flex flex-wrap gap-1 mb-2">
            <span v-for="tag in skill.tags" :key="tag" class="px-2 py-0.5 bg-blue-100 text-blue-800 rounded text-[10px] font-medium">
              {{ tag }}
            </span>
          </div>

          <!-- Examples -->
          <div v-if="skill.examples && skill.examples.length > 0" class="mt-2">
            <p class="text-[10px] font-semibold text-gray-700 mb-1">Examples:</p>
            <ul class="space-y-1">
              <li v-for="(example, idx) in skill.examples" :key="idx" class="text-xs text-gray-600 pl-4 relative">
                <span class="absolute left-0 top-1">💬</span>
                {{ example }}
              </li>
            </ul>
          </div>

          <!-- Input/Output Modes -->
          <div class="mt-2 flex gap-4 text-[10px]">
            <div v-if="skill.inputModes && skill.inputModes.length > 0">
              <span class="font-semibold text-gray-700">Input:</span>
              <span class="text-gray-600 ml-1">{{ skill.inputModes.join(', ') }}</span>
            </div>
            <div v-if="skill.outputModes && skill.outputModes.length > 0">
              <span class="font-semibold text-gray-700">Output:</span>
              <span class="text-gray-600 ml-1">{{ skill.outputModes.join(', ') }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Input/Output Modes -->
    <div class="grid grid-cols-2 gap-4">
      <div v-if="card.defaultInputModes && card.defaultInputModes.length > 0" class="bg-white border border-gray-200 rounded-lg p-4">
        <h4 class="text-sm font-semibold text-gray-900 mb-2 flex items-center">
          <span class="mr-2">📥</span>
          Default Input Modes
        </h4>
        <div class="flex flex-wrap gap-1">
          <span v-for="mode in card.defaultInputModes" :key="mode" class="px-2 py-1 bg-gray-100 text-gray-800 rounded text-xs">
            {{ mode }}
          </span>
        </div>
      </div>

      <div v-if="card.defaultOutputModes && card.defaultOutputModes.length > 0" class="bg-white border border-gray-200 rounded-lg p-4">
        <h4 class="text-sm font-semibold text-gray-900 mb-2 flex items-center">
          <span class="mr-2">📤</span>
          Default Output Modes
        </h4>
        <div class="flex flex-wrap gap-1">
          <span v-for="mode in card.defaultOutputModes" :key="mode" class="px-2 py-1 bg-gray-100 text-gray-800 rounded text-xs">
            {{ mode }}
          </span>
        </div>
      </div>
    </div>

    <!-- Security Schemes -->
    <div v-if="card.securitySchemes" class="bg-white border border-gray-200 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
        </svg>
        Security Schemes
      </h4>
      <div class="space-y-2">
        <div v-for="(scheme, name) in card.securitySchemes" :key="name" class="text-xs bg-gray-50 border border-gray-200 rounded p-2">
          <div class="flex items-center justify-between mb-1">
            <span class="font-semibold text-gray-900">{{ name }}</span>
            <span class="px-2 py-0.5 bg-blue-100 text-blue-800 rounded text-[10px] font-medium">
              {{ scheme.type }}
            </span>
          </div>
          <div v-if="scheme.description" class="text-gray-600 mb-1">{{ scheme.description }}</div>
          <div v-if="scheme.scheme" class="text-gray-500">
            <span class="font-medium">Scheme:</span> {{ scheme.scheme }}
          </div>
          <div v-if="scheme.bearerFormat" class="text-gray-500">
            <span class="font-medium">Format:</span> {{ scheme.bearerFormat }}
          </div>
        </div>
      </div>
    </div>

    <!-- Security Requirements -->
    <div v-if="card.security && card.security.length > 0" class="bg-white border-2 border-red-300 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
        </svg>
        Security Requirements
        <span class="ml-2 px-2 py-0.5 bg-red-100 text-red-800 rounded text-[10px] font-bold">ENFORCED</span>
      </h4>
      <div class="space-y-2">
        <div v-for="(requirement, idx) in card.security" :key="idx" class="bg-red-50 border border-red-200 rounded p-3">
          <div v-if="typeof requirement === 'object'" class="space-y-1">
            <div v-for="(scopes, schemeName) in requirement" :key="schemeName" class="flex items-start gap-2">
              <span class="px-2 py-1 bg-red-200 text-red-900 rounded text-xs font-bold">
                {{ schemeName }}
              </span>
              <div v-if="Array.isArray(scopes) && scopes.length > 0" class="flex flex-wrap gap-1">
                <span v-for="scope in scopes" :key="scope" class="px-2 py-0.5 bg-red-100 text-red-800 rounded text-[10px]">
                  {{ scope }}
                </span>
              </div>
              <span v-else class="text-xs text-red-700 italic">No specific scopes</span>
            </div>
          </div>
          <div v-else class="text-xs text-red-700">{{ requirement }}</div>
        </div>
      </div>
    </div>

    <!-- Signatures -->
    <div v-if="card.signatures && Object.keys(card.signatures).length > 0" class="bg-white border-2 border-green-300 rounded-lg p-4">
      <h4 class="text-sm font-semibold text-gray-900 mb-3 flex items-center">
        <svg class="w-4 h-4 mr-2 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
        </svg>
        Cryptographic Signatures
        <span class="ml-2 px-2 py-0.5 bg-green-100 text-green-800 rounded text-[10px] font-bold">VERIFIED</span>
      </h4>
      <div class="space-y-3">
        <div v-for="(signature, algorithm) in card.signatures" :key="algorithm" class="bg-green-50 border border-green-200 rounded p-3">
          <div class="mb-2">
            <span class="px-2 py-1 bg-green-200 text-green-900 rounded text-xs font-bold">
              {{ algorithm }}
            </span>
          </div>
          <div class="space-y-2 text-xs">
            <div v-if="signature.publicKey" class="bg-white rounded p-2 border border-green-200">
              <div class="font-semibold text-green-900 mb-1">Public Key</div>
              <code class="text-[10px] font-mono text-gray-700 break-all">{{ signature.publicKey }}</code>
            </div>
            <div v-if="signature.signature" class="bg-white rounded p-2 border border-green-200">
              <div class="font-semibold text-green-900 mb-1">Signature</div>
              <code class="text-[10px] font-mono text-gray-700 break-all">{{ signature.signature }}</code>
            </div>
            <div v-if="signature.keyId" class="text-gray-600">
              <span class="font-semibold">Key ID:</span> {{ signature.keyId }}
            </div>
            <div v-if="signature.timestamp" class="text-gray-600">
              <span class="font-semibold">Signed:</span> {{ formatTimestamp(signature.timestamp) }}
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Extended Card Support -->
    <div v-if="card.supportsAuthenticatedExtendedCard" class="bg-yellow-50 border border-yellow-200 rounded-lg p-3">
      <div class="flex items-start gap-2">
        <svg class="w-5 h-5 text-yellow-600 mt-0.5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
        </svg>
        <div>
          <p class="text-sm font-semibold text-yellow-900">Authenticated Extended Card Available</p>
          <p class="text-xs text-yellow-800 mt-0.5">
            This agent supports an extended agent card with additional information available through authenticated requests.
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  payload: any
}>()

// Extract the agent card from various possible payload structures
const card = computed(() => {
  if (!props.payload) return null
  
  // Direct card object
  if (props.payload.name && props.payload.version) {
    return props.payload
  }
  
  // Nested in card property
  if (props.payload.card) {
    return props.payload.card
  }
  
  // Nested in data property
  if (props.payload.data) {
    return props.payload.data
  }
  
  return null
})

function formatTimestamp(timestamp: string): string {
  try {
    const date = new Date(timestamp)
    return date.toLocaleString()
  } catch {
    return timestamp
  }
}
</script>

