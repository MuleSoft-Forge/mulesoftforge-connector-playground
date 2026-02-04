/**
 * Application-wide constants
 * 
 * Centralized location for magic values used throughout the application.
 */

/**
 * Port numbers
 */
export const PORTS = {
  DEV: '5173',
  MULE_API: '8081',
} as const;

/**
 * LocalStorage and SessionStorage keys
 */
export const STORAGE_KEYS = {
  RUNTIME_CONFIG: 'mule-playground-runtime-config-id',
  ENABLE_LOGGING: 'mule-playground-enable-logging',
  ENABLE_VALIDATION: 'mule-playground-enable-validation',
} as const;

/**
 * Connector IDs (from database seed files)
 * These IDs must match the values in the database seed scripts
 */
export const CONNECTOR_IDS = {
  AGENTFORCE: 1,      // seed_agentforce.sql
  EINSTEIN_AI: 2,     // seed_einstein_ai.sql
  INFERENCE: 3,       // seed_mulesoft_inference.sql
  MCP: 4,             // seed_mcp.sql
  VECTORS: 5,         // seed_mulesoft_vectors.sql
  IDP: 6,             // seed_idp.sql
  A2A: 7,             // seed_a2a.sql
} as const;

