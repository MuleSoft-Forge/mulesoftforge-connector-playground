<template>
  <component :is="currentComponent" :key="route.params.connectorId" />
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import AgentforceTestLab from './test-labs/AgentforceTestLab.vue'
import EinsteinAITestLab from './test-labs/EinsteinAITestLab.vue'
import MuleSoftInferenceTestLab from './test-labs/MuleSoftInferenceTestLab.vue'
import MCPTestLab from './test-labs/MCPTestLab.vue'
import MuleSoftVectorsTestLab from './test-labs/MuleSoftVectorsTestLab.vue'
import IDPTestLab from './test-labs/IDPTestLab.vue'
import A2ATestLab from './test-labs/A2ATestLab.vue'
import BedrockTestLab from './test-labs/BedrockTestLab.vue'
import OpenAITestLab from './test-labs/OpenAITestLab.vue'
import GeminiTestLab from './test-labs/GeminiTestLab.vue'
import LabConnectorPage from './LabConnectorPage.vue'
import { logger } from '../utils/logger'

const route = useRoute()

// Map connector IDs to their specific test lab components
// Using numeric IDs based on seed data:
// - Agentforce: ID 1 (from seed_agentforce.sql)
// - Einstein AI: ID 2 (from seed_einstein_ai.sql)
// - MuleSoft Inference: ID 3 (from seed_mulesoft_inference.sql)
// - MCP: ID 4 (from seed_mcp.sql)
// - MuleSoft Vectors: ID 5 (from seed_mulesoft_vectors.sql)
// - IDP: ID 6 (from seed_idp.sql)
// - A2A: ID 7 (from seed_a2a.sql)
// - Amazon Bedrock: ID 8 (from seed_bedrock.sql)
// - OpenAI: ID 9 (from seed_openai.sql)
// - Google Gemini: ID 10 (from seed_gemini.sql)
const connectorTestLabs: Record<number, any> = {
  1: AgentforceTestLab, // Agentforce
  2: EinsteinAITestLab, // Einstein AI
  3: MuleSoftInferenceTestLab, // MuleSoft Inference
  4: MCPTestLab, // MCP
  5: MuleSoftVectorsTestLab, // MuleSoft Vectors
  6: IDPTestLab, // IDP
  7: A2ATestLab, // A2A
  8: BedrockTestLab, // Amazon Bedrock
  9: OpenAITestLab, // OpenAI
  10: GeminiTestLab, // Google Gemini
}

// Dynamically select the component based on connectorId
const currentComponent = computed(() => {
  const connectorId = Number(route.params.connectorId)
  
  // Debug logging
  logger.debug('[TestLabRouter] Connector ID:', connectorId)
  logger.debug('[TestLabRouter] Has specific lab?', !!connectorTestLabs[connectorId])
  logger.debug('[TestLabRouter] Component:', connectorTestLabs[connectorId]?.name || 'LabConnectorPage (fallback)')
  
  // If connectorId has a specific test lab, use it
  if (connectorId && connectorTestLabs[connectorId]) {
    return connectorTestLabs[connectorId]
  }
  
  // Otherwise use the generic LabConnectorPage
  return LabConnectorPage
})
</script>

