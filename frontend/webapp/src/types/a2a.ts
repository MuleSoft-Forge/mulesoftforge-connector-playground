/**
 * TypeScript types for A2A Protocol 1.0.0
 * Generated from JSON Schemas in _deprecated/schemas-a2a-1.0.0/
 * 
 * These types match the MuleSoft A2A Connector 1.0.0 implementation
 * @see https://a2a-protocol.org/latest/definitions/
 */

// ============================================================================
// COMMON TYPES
// ============================================================================

export type TaskState = 
  | 'submitted'
  | 'working'
  | 'input-required'
  | 'completed'
  | 'canceled'
  | 'failed'
  | 'rejected'
  | 'auth-required'
  | 'unknown'

export type PartKind = 'text' | 'file' | 'data'

export type MessageRole = 'user' | 'agent'

export type StreamingEventKind = 'task' | 'task-status-update' | 'task-artifact-update' | 'message'

// ============================================================================
// PART TYPES
// ============================================================================

export interface TextPart {
  kind: 'text'
  text: string
  metadata?: Record<string, any>
}

export interface FilePart {
  kind: 'file'
  file: {
    bytes?: string // Base64 encoded
    name?: string
    mimeType?: string
    uri?: string
  }
  metadata?: Record<string, any>
}

export interface DataPart {
  kind: 'data'
  data: Record<string, any>
  metadata?: Record<string, any>
}

export type Part = TextPart | FilePart | DataPart

export type Parts = Part[]

// ============================================================================
// MESSAGE TYPES
// ============================================================================

export interface Message {
  role: MessageRole
  parts: Parts
  messageId: string
  kind: 'message'
  taskId?: string
  contextId?: string
  referenceTaskIds?: string[]
  metadata?: Record<string, any>
  extensions?: string[]
}

// ============================================================================
// ARTIFACT TYPES
// ============================================================================

export interface Artifact {
  artifactId: string
  name?: string
  description?: string
  parts: Parts
  metadata?: Record<string, any>
  extensions?: string[]
}

// ============================================================================
// TASK STATUS TYPES
// ============================================================================

export interface TaskStatus {
  state: TaskState
  message?: Message
  timestamp?: string // ISO 8601 date-time
}

// ============================================================================
// TASK TYPES
// ============================================================================

export interface Task {
  id: string
  contextId: string
  kind: 'task'
  status: TaskStatus
  artifacts?: Artifact[]
  history?: Message[]
  metadata?: Record<string, any>
}

// ============================================================================
// TASK OR MESSAGE UNION TYPE
// ============================================================================

export type TaskOrMessage = Task | Message

// ============================================================================
// MESSAGE SEND PARAMS
// ============================================================================

export interface PushNotificationAuthenticationInfo {
  schemes: string[]
  credentials?: string
}

export interface PushNotificationConfig {
  id?: string
  url: string
  token?: string
  authentication?: PushNotificationAuthenticationInfo
}

export interface MessageSendConfiguration {
  acceptedOutputModes: string[]
  historyLength?: number
  pushNotificationConfig?: PushNotificationConfig
  blocking?: boolean
}

export interface MessageSendParams {
  message: Message
  configuration?: MessageSendConfiguration
  metadata?: Record<string, any>
}

// ============================================================================
// STREAMING TYPES
// ============================================================================

export interface TaskStatusUpdateEvent {
  taskId: string
  contextId: string
  kind: 'task-status-update'
  status: TaskStatus
  final?: boolean
  metadata?: Record<string, any>
}

export interface TaskArtifactUpdateEvent {
  taskId: string
  contextId: string
  kind: 'task-artifact-update'
  artifact: Artifact
  append?: boolean
  lastChunk?: boolean
  final?: boolean
  metadata?: Record<string, any>
}

export type StreamingMessageResponse = Task | TaskStatusUpdateEvent | TaskArtifactUpdateEvent

// ============================================================================
// TASK ID PARAMS
// ============================================================================

export interface TaskIdParams {
  taskId: string
  lastEventId?: string
  metadata?: Record<string, any>
}

// ============================================================================
// TASK QUERY PARAMS
// ============================================================================

export interface TaskQueryParams {
  taskIds?: string[]
  contextId?: string
  metadata?: Record<string, any>
}

// ============================================================================
// PUSH NOTIFICATION TYPES
// ============================================================================

export interface TaskPushNotificationConfig {
  id: string
  url: string
  token?: string
  authentication?: PushNotificationAuthenticationInfo
}

export interface GetTaskPushNotificationConfigParams {
  id: string
  metadata?: Record<string, any>
}

export interface ListTaskPushNotificationConfigParams {
  taskId?: string
  contextId?: string
  metadata?: Record<string, any>
}

// ============================================================================
// AGENT CARD TYPES
// ============================================================================

export interface AgentProvider {
  organization: string
  url: string
}

export interface AgentExtension {
  uri: string
  description?: string
  required?: boolean
  params?: Record<string, any>
}

export interface AgentCapabilities {
  streaming?: boolean
  pushNotifications?: boolean
  stateTransitionHistory?: boolean
  extensions?: AgentExtension[]
}

export interface AgentSkill {
  id: string
  name: string
  description: string
  tags: string[]
  examples?: string[]
  inputModes?: string[]
  outputModes?: string[]
}

export interface SecurityScheme {
  type: 'apiKey' | 'http' | 'oauth2' | 'openIdConnect'
  description?: string
  [key: string]: any // Additional scheme-specific properties
}

export interface APIKeySecurityScheme extends SecurityScheme {
  type: 'apiKey'
  name: string
  in: 'query' | 'header' | 'cookie'
}

export interface HTTPAuthSecurityScheme extends SecurityScheme {
  type: 'http'
  scheme: string // e.g., 'basic', 'bearer', 'digest'
  bearerFormat?: string
}

export interface OAuth2Flow {
  authorizationUrl?: string
  tokenUrl?: string
  refreshUrl?: string
  scopes: Record<string, string>
}

export interface OAuth2SecurityScheme extends SecurityScheme {
  type: 'oauth2'
  flows: {
    implicit?: OAuth2Flow
    password?: OAuth2Flow
    clientCredentials?: OAuth2Flow
    authorizationCode?: OAuth2Flow
  }
}

export interface OpenIDConnectSecurityScheme extends SecurityScheme {
  type: 'openIdConnect'
  openIdConnectUrl: string
}

export type SecurityRequirement = Record<string, string[]>

export interface SupportedInterface {
  protocolBinding: string
  url: string
  tenant?: string
}

export interface CardSignature {
  publicKey?: string
  signature?: string
  keyId?: string
  timestamp?: string
  [key: string]: any
}

export interface AgentCard {
  name: string
  description: string
  url: string
  version: string
  capabilities: AgentCapabilities
  defaultInputModes: string[]
  defaultOutputModes: string[]
  skills: AgentSkill[]
  iconUrl?: string
  provider?: AgentProvider
  protocolVersion?: string
  documentationUrl?: string
  securitySchemes?: Record<string, SecurityScheme>
  security?: SecurityRequirement[]
  supportsAuthenticatedExtendedCard?: boolean
  supportedInterfaces?: SupportedInterface[]
  signatures?: Record<string, CardSignature>
}

// ============================================================================
// TYPE GUARDS
// ============================================================================

export function isTask(obj: any): obj is Task {
  return obj && obj.kind === 'task' && 'status' in obj
}

export function isMessage(obj: any): obj is Message {
  return obj && obj.kind === 'message' && 'role' in obj
}

export function isTaskStatusUpdateEvent(obj: any): obj is TaskStatusUpdateEvent {
  return obj && obj.kind === 'task-status-update'
}

export function isTaskArtifactUpdateEvent(obj: any): obj is TaskArtifactUpdateEvent {
  return obj && obj.kind === 'task-artifact-update'
}

export function isTextPart(part: Part): part is TextPart {
  return part.kind === 'text'
}

export function isFilePart(part: Part): part is FilePart {
  return part.kind === 'file'
}

export function isDataPart(part: Part): part is DataPart {
  return part.kind === 'data'
}

