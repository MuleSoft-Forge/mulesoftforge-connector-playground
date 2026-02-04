/**
 * A2A Protocol JSON Schema Validator
 * 
 * Provides client-side validation for A2A protocol objects
 * using Ajv (Another JSON Schema Validator) with the official
 * A2A 1.0.0 JSON schemas from MuleSoft Connector implementation
 */

import Ajv from 'ajv'
import addFormats from 'ajv-formats'
import type { AgentCard, Task, Message, MessageSendParams, TaskOrMessage, StreamingMessageResponse } from '../types/a2a'

// Initialize Ajv with support for draft-07 and formats (date-time, uri, etc.)
const ajv = new Ajv({
  strict: false, // Allow additional properties
  validateFormats: true,
  allErrors: true, // Return all errors, not just the first one
})

// Add format validators (date-time, uri, email, etc.)
addFormats(ajv)

// ============================================================================
// INLINE SCHEMAS (copied from _deprecated/schemas-a2a-1.0.0/)
// ============================================================================

const commonDefs = {
  TaskState: {
    description: "An enumeration.",
    enum: [
      "submitted",
      "working",
      "input-required",
      "completed",
      "canceled",
      "failed",
      "rejected",
      "auth-required",
      "unknown"
    ],
    title: "TaskState",
    type: "string"
  },
  TaskStatus: {
    title: "TaskStatus",
    type: "object",
    required: ["state"],
    properties: {
      state: { $ref: "#/$defs/TaskState" },
      message: {
        $ref: "#/$defs/Message",
        default: null,
        description: "Message containing task content"
      },
      timestamp: {
        format: "date-time",
        title: "Timestamp",
        type: "string"
      }
    }
  },
  Message: {
    type: "object",
    description: "Message containing task content",
    required: ["role", "parts", "messageId", "kind"],
    properties: {
      role: {
        type: "string",
        enum: ["user", "agent"],
        description: "Indicates the sender: \"user\" (from A2A Client) or \"agent\" (from A2A Server)."
      },
      parts: { $ref: "#/$defs/Parts" },
      messageId: {
        type: "string",
        description: "Unique identifier for the message"
      },
      taskId: {
        type: "string",
        description: "Unique identifier for the task"
      },
      contextId: {
        type: "string",
        description: "Unique context identifier for the task"
      },
      kind: {
        type: "string",
        const: "message",
        description: "Type discriminator, literal value 'message'."
      },
      referenceTaskIds: {
        type: "array",
        items: { type: "string" },
        description: "A list of other task IDs that this message references for additional context.",
        title: "Reference Task Ids"
      },
      metadata: {
        type: "object",
        description: "Additional metadata for the message",
        additionalProperties: true
      },
      extensions: {
        type: "array",
        items: { type: "string" },
        description: "The URIs of extensions that are present or contributed to this Message.",
        title: "Extensions"
      }
    }
  },
  Parts: {
    title: "Parts",
    type: "array",
    items: { $ref: "#/$defs/Part" }
  },
  Part: {
    title: "Part",
    type: "object",
    required: [],
    properties: {
      kind: {
        type: "string",
        enum: ["text", "file", "data"]
      },
      text: { type: "string" },
      metadata: {
        type: "object",
        additionalProperties: true
      },
      file: {
        type: "object",
        description: "Contains the file details and data/reference.",
        required: [],
        properties: {
          bytes: {
            type: "string",
            contentEncoding: "base64",
            description: "Base64 encoded bytes of the file"
          },
          name: { type: "string" },
          mimeType: { type: "string" },
          uri: { type: "string" }
        }
      },
      data: {
        type: "object",
        additionalProperties: true
      }
    }
  },
  Artifact: {
    title: "Artifact",
    type: "object",
    required: ["artifactId", "parts"],
    properties: {
      artifactId: {
        type: "string",
        description: "Unique identifier for the artifact",
        title: "ArtifactId"
      },
      name: {
        type: "string",
        default: null,
        title: "Name"
      },
      description: {
        type: "string",
        default: null,
        title: "Description"
      },
      parts: { $ref: "#/$defs/Parts" },
      metadata: {
        additionalProperties: {},
        type: "object",
        default: null,
        title: "Metadata"
      },
      extensions: {
        type: "array",
        items: { type: "string" },
        description: "The URIs of extensions that are present or contributed to this Artifact.",
        title: "Extensions"
      }
    }
  }
}

// Agent Card Schema
const agentCardSchema = {
  $schema: "http://json-schema.org/draft-07/schema#",
  title: "AgentCard",
  description: "JSON Schema for an AgentCard representing agent capabilities and configuration.",
  type: "object",
  required: ["name", "description", "url", "version", "capabilities", "defaultInputModes", "defaultOutputModes", "skills"],
  properties: {
    name: { type: "string", title: "Agent Name", description: "Human readable name of the agent" },
    description: { type: "string", title: "Description", description: "A human-readable description of the agent" },
    url: { type: "string", format: "uri", title: "Agent URL", description: "URL where the agent is hosted" },
    version: { type: "string", title: "Version", description: "Version of the agent" },
    iconUrl: { type: "string", format: "uri" },
    protocolVersion: { type: "string" },
    documentationUrl: { type: "string", format: "uri" },
    provider: {
      type: "object",
      required: ["organization", "url"],
      properties: {
        organization: { type: "string" },
        url: { type: "string", format: "uri" }
      }
    },
    capabilities: {
      type: "object",
      properties: {
        streaming: { type: "boolean" },
        pushNotifications: { type: "boolean" },
        stateTransitionHistory: { type: "boolean" },
        extensions: { type: "array", items: { type: "object" } }
      }
    },
    defaultInputModes: { type: "array", items: { type: "string" } },
    defaultOutputModes: { type: "array", items: { type: "string" } },
    skills: {
      type: "array",
      items: {
        type: "object",
        required: ["id", "name", "description", "tags"],
        properties: {
          id: { type: "string" },
          name: { type: "string" },
          description: { type: "string" },
          tags: { type: "array", items: { type: "string" } },
          examples: { type: "array", items: { type: "string" } },
          inputModes: { type: "array", items: { type: "string" } },
          outputModes: { type: "array", items: { type: "string" } }
        }
      }
    },
    securitySchemes: { type: "object", additionalProperties: true },
    security: { type: "array", items: { type: "object" } },
    supportsAuthenticatedExtendedCard: { type: "boolean", default: false },
    supportedInterfaces: { type: "array", items: { type: "object" } },
    signatures: { type: "object", additionalProperties: true }
  }
}

// Task Schema
const taskSchema = {
  $schema: "http://json-schema.org/draft-07/schema#",
  title: "A2A Task",
  description: "Task object in A2A protocol",
  type: "object",
  required: ["id", "contextId", "kind", "status"],
  properties: {
    id: { type: "string", description: "Unique identifier for the task" },
    contextId: { type: "string", description: "Server-generated ID for contextual alignment across interactions" },
    status: { $ref: "#/$defs/TaskStatus" },
    artifacts: { type: "array", items: { $ref: "#/$defs/Artifact" } },
    history: { type: "array", items: { $ref: "#/$defs/Message" } },
    metadata: { type: "object", description: "Additional metadata for the task", additionalProperties: true },
    kind: { type: "string", const: "task", description: "Type discriminator, literal value 'task'." }
  },
  $defs: commonDefs
}

// Message Schema
const messageSchema = {
  $schema: "http://json-schema.org/draft-07/schema#",
  title: "A2A Message",
  type: "object",
  required: ["role", "parts", "messageId", "kind"],
  properties: {
    role: { type: "string", enum: ["user", "agent"] },
    parts: { $ref: "#/$defs/Parts" },
    messageId: { type: "string" },
    taskId: { type: "string" },
    contextId: { type: "string" },
    kind: { type: "string", const: "message" },
    referenceTaskIds: { type: "array", items: { type: "string" } },
    metadata: { type: "object", additionalProperties: true },
    extensions: { type: "array", items: { type: "string" } }
  },
  $defs: commonDefs
}

// Message Send Params Schema
const messageSendParamsSchema = {
  $schema: "http://json-schema.org/draft-07/schema#",
  title: "MessageSendParams",
  description: "Parameters for sending a task in A2A protocol",
  required: ["message"],
  type: "object",
  properties: {
    message: { $ref: "#/$defs/Message" },
    configuration: {
      type: "object",
      required: ["acceptedOutputModes"],
      properties: {
        acceptedOutputModes: { type: "array", items: { type: "string" } },
        historyLength: { type: "integer" },
        pushNotificationConfig: { type: "object" },
        blocking: { type: "boolean" }
      }
    },
    metadata: { type: "object", additionalProperties: true }
  },
  $defs: commonDefs
}

// Compile schemas
const validateAgentCard = ajv.compile(agentCardSchema)
const validateTask = ajv.compile(taskSchema)
const validateMessage = ajv.compile(messageSchema)
const validateMessageSendParams = ajv.compile(messageSendParamsSchema)

// ============================================================================
// VALIDATION FUNCTIONS
// ============================================================================

export interface ValidationResult {
  valid: boolean
  errors?: string[]
  details?: any[]
}

export function validateA2AAgentCard(data: any): ValidationResult {
  const valid = validateAgentCard(data)
  return {
    valid,
    errors: valid ? undefined : validateAgentCard.errors?.map(e => `${e.instancePath} ${e.message}`) || ['Unknown validation error'],
    details: valid ? undefined : validateAgentCard.errors
  }
}

export function validateA2ATask(data: any): ValidationResult {
  const valid = validateTask(data)
  return {
    valid,
    errors: valid ? undefined : validateTask.errors?.map(e => `${e.instancePath} ${e.message}`) || ['Unknown validation error'],
    details: valid ? undefined : validateTask.errors
  }
}

export function validateA2AMessage(data: any): ValidationResult {
  const valid = validateMessage(data)
  return {
    valid,
    errors: valid ? undefined : validateMessage.errors?.map(e => `${e.instancePath} ${e.message}`) || ['Unknown validation error'],
    details: valid ? undefined : validateMessage.errors
  }
}

export function validateA2AMessageSendParams(data: any): ValidationResult {
  const valid = validateMessageSendParams(data)
  return {
    valid,
    errors: valid ? undefined : validateMessageSendParams.errors?.map(e => `${e.instancePath} ${e.message}`) || ['Unknown validation error'],
    details: valid ? undefined : validateMessageSendParams.errors
  }
}

// Auto-detect type and validate
export function validateA2AObject(data: any): ValidationResult {
  if (!data || typeof data !== 'object') {
    return { valid: false, errors: ['Data must be an object'] }
  }

  // Detect type by discriminator field
  if (data.kind === 'task') {
    return validateA2ATask(data)
  } else if (data.kind === 'message') {
    return validateA2AMessage(data)
  } else if (data.name && data.version && data.capabilities) {
    return validateA2AAgentCard(data)
  } else if (data.message && data.message.kind === 'message') {
    return validateA2AMessageSendParams(data)
  }

  return { valid: false, errors: ['Unknown A2A object type - no valid discriminator found'] }
}

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

export function formatValidationErrors(result: ValidationResult): string {
  if (result.valid) return 'Valid'
  return result.errors?.join('\n') || 'Unknown validation error'
}

export function getValidationSummary(result: ValidationResult): string {
  if (result.valid) return '✅ Valid A2A Object'
  const count = result.errors?.length || 0
  return `❌ ${count} Validation Error${count !== 1 ? 's' : ''}`
}

