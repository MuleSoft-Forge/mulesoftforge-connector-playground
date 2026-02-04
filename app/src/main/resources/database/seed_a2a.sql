-- =====================================================
-- A2A (AGENT-TO-AGENT) CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the Agent-to-Agent (A2A) Connector 1.0.1
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - Configuration types and providers
-- - 10 Active client operations (task management, messaging, push notifications, streaming)
-- - 6 Inactive operations (3 server operations + 3 server listeners/sources)
-- - Runtime configuration with serverUrl
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-a2a-connector',
    'A2A',
    '1.0.1',
    'AI',
    'While **MCP** excels at hierarchical agent-invoking-tool interactions, complex business processes often require collaboration between multiple specialized agents. The **Agent-to-Agent (A2A) protocol** is the emerging open standard designed to facilitate *peer-to-peer communication* that enables sophisticated, multi-agent workflows.

**MuleSoft''s support for A2A** allows enterprises to design and build advanced systems with the same level of governance and reliability they expect for their APIs. The **MuleSoft A2A Connector** enables developers to easily expose any agent as an A2A server, or invoke any A2A-compliant agent from a Mule application.

**Example workflow:** A mortgage application process may be orchestrated across a "Credit Check Agent," a "Document Signature Agent," and a "Regulatory Compliance Agent"—with each agent discovering and invoking the others'' capabilities as needed to move the application forward.

By providing robust, enterprise-grade tooling for both **MCP** and **A2A**, MuleSoft supports building a flexible ecosystem consisting of direct agent-to-system interactions (via MCP tools) and agent-to-agent (A2A) interactions. Regardless of how the AI landscape evolves, this approach positions MuleSoft as the underlying foundation that connects all forms of agentic communication.',
    'https://docs.mulesoft.com/a2a-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTkgMThDMTMuOTcwNiAxOCAxOCAxMy45NzA2IDE4IDlDMTggNC4wMjk0NCAxMy45NzA2IDAgOSAwQzQuMDI5NDQgMCAwIDQuMDI5NDQgMCA5QzAgMTMuOTcwNiA0LjAyOTQ0IDE4IDkgMThaIiBmaWxsPSIjQ0ZFOUZFIi8+CjxwYXRoIGQ9Ik00LjQzOTcgMTIuMDMxNEMyLjk4MTE0IDEyLjAzMTEgMS43NDQ5MSAxMC44NDM5IDEuNjg1NjkgOS4zODY1OEMxLjYyNjQ2IDcuOTI5MjUgMi43NjYyMSA2Ljc0MjQ5IDQuMjI0NzcgNi43NDI3N0w3LjQ1OTQ0IDYuNzQzNEM4LjkxOCA2Ljc0MzY4IDEwLjE1NDIgNy45MzA5IDEwLjIxMzUgOS4zODgyM0MxMC4yMTY2IDkuNDQ2NjIgMTAuMjA4MiA5LjUwNDU4IDEwLjE4ODYgOS41NTg3NUMxMC4xNjkgOS42MTI5MiAxMC4xMzg2IDkuNjYyMjIgMTAuMDk5MyA5LjcwMzc5QzEwLjA1OTkgOS43NDUzNSAxMC4wMTI0IDkuNzc4MzYgOS45NTkzNiA5LjgwMDg4QzkuOTA2MzYgOS44MjM0IDkuODQ4OTcgOS44MzQ5OSA5Ljc5MDUzIDkuODM0OThDOS43MzIwOSA5LjgzNDk3IDkuNjczNzYgOS44MjMzNSA5LjYxODkzIDkuODAwODFDOS41NjQwOSA5Ljc3ODI3IDkuNTEzODUgOS43NDUyNSA5LjQ3MTEyIDkuNzAzNjdDOS40MjgzOSA5LjY2MjA5IDkuMzk0MDMgOS42MTI3OCA5LjM3MDAyIDkuNTU4NkM5LjM0NjAxIDkuNTA0NDIgOS4zMzI4NCA5LjQ0NjQ1IDkuMzMxMjcgOS4zODgwN0M5LjI5MTI4IDguNDAzOCA4LjQ4MDM1IDcuNjI1MDMgNy40OTUyNyA3LjYyNDg0TDQuMjYwNTkgNy42MjQyMkMzLjI3NTUgNy42MjQwMiAyLjUyNzg3IDguNDAyNDkgMi41Njc4NyA5LjM4Njc2QzIuNjA3ODYgMTAuMzcxIDMuNDE4NzkgMTEuMTQ5OCA0LjQwMzg4IDExLjE1TDcuNjM4NTUgMTEuMTUwNkM3LjY5Njk2IDExLjE0OTggNy43NTU0MiAxMS4xNjA2IDcuODEwNTQgMTEuMTgyNEM3Ljg2NTY1IDExLjIwNDIgNy45MTYzMyAxMS4yMzY1IDcuOTU5NjEgMTEuMjc3NkM4LjAwMjg5IDExLjMxODYgOC4wMzc5MiAxMS4zNjc0IDguMDYyNjcgMTEuNDIxM0M4LjA4NzQxIDExLjQ3NTIgOC4xMDEzOCAxMS41MzMgOC4xMDM3NSAxMS41OTE0QzguMTA2MTIgMTEuNjQ5OCA4LjA5Njg2IDExLjcwNzYgOC4wNzY0OSAxMS43NjE1QzguMDU2MTMgMTEuODE1NCA4LjAyNTA2IDExLjg2NDIgNy45ODUxMSAxMS45MDUyQzcuOTQ1MTYgMTEuOTQ2MiA3Ljg5NzEyIDExLjk3ODUgNy44NDM3NyAxMi4wMDAzQzcuNzkwNDMgMTIuMDIyMSA3LjczMjg0IDEyLjAzMjkgNy42NzQzNyAxMi4wMzJMNC40Mzk3IDEyLjAzMTRaTTEwLjMyMDkgMTIuMDMyNkM4Ljg2MjM2IDEyLjAzMjMgNy42MjYxMyAxMC44NDUxIDcuNTY2OTEgOS4zODc3M0M3LjU2Mzc0IDkuMzI5MzUgNy41NzIyMSA5LjI3MTM5IDcuNTkxODIgOS4yMTcyMkM3LjYxMTQyIDkuMTYzMDYgNy42NDE3OCA5LjExMzc3IDcuNjgxMTMgOS4wNzIyMUM3LjcyMDQ4IDkuMDMwNjUgNy43NjgwMyA4Ljk5NzY2IDcuODIxMDMgOC45NzUxNEM3Ljg3NDAyIDguOTUyNjMgNy45MzE0MSA4Ljk0MTAzIDcuOTg5ODQgOC45NDEwNEM4LjA0ODI4IDguOTQxMDUgOC4xMDY2IDguOTUyNjcgOC4xNjE0MyA4Ljk3NTIxQzguMjE2MjYgOC45OTc3NCA4LjI2NjUgOS4wMzA3NSA4LjMwOTIyIDkuMDcyMzNDOC4zNTE5NSA5LjExMzkgOC4zODYzMiA5LjE2MzIxIDguNDEwMzMgOS4yMTczOEM4LjQzNDM0IDkuMjcxNTUgOC40NDc1MiA5LjMyOTUxIDguNDQ5MDkgOS4zODc4OUM4LjQ4OTA5IDEwLjM3MjIgOS4zMDAwMiAxMS4xNTA5IDEwLjI4NTEgMTEuMTUxMUwxMy41MTk4IDExLjE1MTdDMTQuNTA0OSAxMS4xNTE5IDE1LjI1MjUgMTAuMzczNSAxNS4yMTI1IDkuMzg5MkMxNS4xNzI1IDguNDA0OTQgMTQuMzYxNiA3LjYyNjE2IDEzLjM3NjUgNy42MjU5OEwxMC4xNDE4IDcuNjI1MzVDMTAuMDgzNCA3LjYyNjE2IDEwLjAyNDkgNy42MTUzNiA5Ljk2OTgxIDcuNTkzNTdDOS45MTQ2OCA3LjU3MTc5IDkuODY0IDcuNTM5NDUgOS44MjA3MSA3LjQ5ODQzQzkuNzc3NDIgNy40NTc0MiA5Ljc0MjM4IDcuNDA4NTUgOS43MTc2MyA3LjM1NDY2QzkuNjkyODggNy4zMDA3OCA5LjY3ODkxIDcuMjQyOTUgOS42NzY1NCA3LjE4NDU0QzkuNjc0MTYgNy4xMjYxNCA5LjY4MzQzIDcuMDY4MzIgOS43MDM4IDcuMDE0NDRDOS43MjQxNyA2Ljk2MDU2IDkuNzU1MjQgNi45MTE3MSA5Ljc5NTIgNi44NzA3MUM5LjgzNTE2IDYuODI5NzEgOS44ODMyMSA2Ljc5NzM4IDkuOTM2NTcgNi43NzU2MkM5Ljk4OTkyIDYuNzUzODUgMTAuMDQ3NSA2Ljc0MzA3IDEwLjEwNiA2Ljc0MzkxTDEzLjM0MDcgNi43NDQ1NEMxNC43OTkyIDYuNzQ0ODIgMTYuMDM1NSA3LjkzMjA0IDE2LjA5NDcgOS4zODkzOEMxNi4xNTM5IDEwLjg0NjcgMTUuMDE0MiAxMi4wMzM1IDEzLjU1NTYgMTIuMDMzMkwxMC4zMjA5IDEyLjAzMjZaIiBmaWxsPSIjMDE3NkQzIi8+CjxjaXJjbGUgY3g9IjQuNSIgY3k9IjkuNSIgcj0iMC41IiBmaWxsPSIjMDE3NkQzIi8+CjxjaXJjbGUgY3g9IjYuNSIgY3k9IjkuNSIgcj0iMC41IiBmaWxsPSIjMDE3NkQzIi8+CjxjaXJjbGUgY3g9IjExLjUiIGN5PSI5LjUiIHI9IjAuNSIgZmlsbD0iIzAxNzZEMyIvPgo8Y2lyY2xlIGN4PSIxMy41IiBjeT0iOS41IiByPSIwLjUiIGZpbGw9IiMwMTc2RDMiLz4KPC9zdmc+Cg==',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPE
-- =====================================================

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'a2a:client-config',
    'A2A Client Configuration',
    'Client configuration for connecting to A2A servers and initiating agent-to-agent communication.'
FROM connectors 
WHERE maven_artifact_id = 'mule4-a2a-connector';

-- =====================================================
-- 3. INSERT PROVIDER
-- =====================================================

INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'client-connection',
    'A2A Server',
    'Connection to an A2A server endpoint for agent-to-agent task delegation and communication.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

-- =====================================================
-- 4. INSERT CONFIG PARAMETERS
-- =====================================================

INSERT INTO config_parameters (provider_id, api_name, display_name, data_type, is_required, default_value, description, parameter_order)
SELECT 
    cp.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.default_value,
    param.description,
    param.parameter_order
FROM config_providers cp
CROSS JOIN (
    VALUES
        ('serverUrl', 'Server URL', 'String', true, NULL, 'The URL of the A2A server endpoint to connect to. This is the base URL where the target agent is hosted.', 1),
        ('agentPath', 'Agent Path', 'String', true, NULL, 'The path to the agent endpoint (e.g., /mcpg, /agent). This is appended to the server URL to form the complete agent endpoint.', 2),
        
        -- Authentication
        ('authType', 'Authentication Type', 'String', true, 'none', 'Authentication method for connecting to the A2A server. Options: none (default), basic, oauth2-client-credentials', 3),
        
        -- Basic Auth
        ('basicUsername', 'Username', 'String', false, NULL, 'Username for HTTP Basic Authentication. Required when authType is "basic".', 4),
        ('basicPassword', 'Password', 'String', false, NULL, 'Password for HTTP Basic Authentication. Required when authType is "basic". This value will be encrypted.', 5),
        
        -- OAuth 2.0 Client Credentials
        ('oauthClientId', 'OAuth Client ID', 'String', false, NULL, 'OAuth 2.0 Client ID for Client Credentials grant flow. Required when authType is "oauth2-client-credentials".', 6),
        ('oauthClientSecret', 'OAuth Client Secret', 'String', false, NULL, 'OAuth 2.0 Client Secret for Client Credentials grant flow. Required when authType is "oauth2-client-credentials". This value will be encrypted.', 7),
        ('oauthTokenUrl', 'OAuth Token URL', 'String', false, NULL, 'OAuth 2.0 token endpoint URL for obtaining access tokens. Required when authType is "oauth2-client-credentials".', 8),
        ('oauthScopes', 'OAuth Scopes', 'String', false, NULL, 'Space-separated list of OAuth scopes to request. Optional for OAuth authentication.', 9)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND cp.provider_key = 'client-connection';

-- =====================================================
-- 5. INSERT OPERATIONS
-- =====================================================

-- Operation 1: Get Card
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Get Card',
    'a2a:get-card',
    '**Retrieves the Agent Card** from the target A2A server. The Agent Card is a self-describing document that advertises an agent''s capabilities, skills, and available services.

**What''s in an Agent Card:**
- **Agent identity** - Name, description, and metadata
- **Capabilities** - Skills and services the agent can perform
- **Interaction protocols** - Supported message types and workflows
- **Authentication requirements** - Security and access control info

**Use cases:**
- **Agent discovery** - Learn what a remote agent can do before delegating tasks
- **Dynamic routing** - Select the right agent based on advertised capabilities
- **Integration planning** - Understand requirements for agent-to-agent workflows

**Card types:**
- *Standard Card* - Public capabilities (default)
- *Extended Card* - Authenticated, detailed capabilities (set `useExtendedCard=true`)

*Essential first step for any A2A interaction - always fetch the card before sending messages.*',
    'Core Operations'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#GetCard',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('useExtendedCard', 'Extended Card (Advanced)', 'Boolean', false, 'When true, fetches the authenticated extended agent card instead of the normal agent card.', 'false', 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:get-card';

-- Operation 2: Send Message
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Send Message',
    'a2a:send-message',
    '**Sends a message** to another A2A agent for peer-to-peer communication. This is the **core operation** for agent-to-agent task delegation and information exchange.

**Message workflow:**
1. Compose a message with `content`, `role`, and optional `context`
2. Send to the target agent via the A2A protocol
3. Receive a response with the agent''s output or next action

**Message components:**
- **Role** - Message type (`user`, `assistant`, `system`)
- **Content** - The actual message text or task description
- **Context** - Additional data, conversation history, or metadata (`JSON`)
- **Additional properties** - Custom headers, auth tokens, or routing info

**Use cases:**
- **Task delegation** - "Process this invoice" → Accounting Agent
- **Data exchange** - Share context between Credit Check Agent and Loan Agent
- **Workflow orchestration** - Chain agent actions in complex business processes
- **Collaborative problem-solving** - Multi-agent systems working together

**Example:** Send "Verify customer credit score for loan #12345" to Credit Check Agent, receive credit decision.',
    'Core Operations'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#SendMessage',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.example_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('message', 'Message', 'JSON', false, 'Message parameters following the MessageSendParams schema. Includes message content (role, parts, messageId), configuration (acceptedOutputModes, blocking), and optional metadata.', NULL, NULL, 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:send-message';

-- Operation 3: Get Task
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Get Task',
    'a2a:get-task',
    '**Retrieves information about a task** from another A2A agent based on a query parameter (typically the task ID).

**Task tracking workflow:**
1. Initiate a task on a remote agent (e.g., via `Send Message`)
2. Use `Get Task` to check status: *pending*, *in-progress*, *completed*, or *failed*
3. Poll periodically or trigger based on events

**What you get:**
- **Task ID** - Unique identifier
- **Status** - Current state of the task
- **Progress** - Completion percentage or stage info
- **Results** - Output data (if completed)
- **Error details** - Failure reason (if failed)

**Use cases:**
- **Async monitoring** - Track long-running agent tasks
- **Error handling** - Detect and respond to task failures
- **Progress reporting** - Show task completion to users
- **Orchestration logic** - Conditional workflows based on task state

**Example:** Check if "Document Signature Agent" completed signing the contract for loan #12345.',
    'Task Management'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#GetTask',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('taskQuery', 'Task Query', 'JSON', false, 'Parameters for querying a task in A2A protocol. **id** (required) - Unique identifier of the task to query; **historyLength** (optional) - Number of history entries to include in the response; **pushNotificationConfigId** (optional) - Server generated id of the push notification config; **metadata** (optional) - Additional metadata for the query. See: https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#GetTask', '{"id": "task-123"}', 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:get-task';

-- Operation 4: Cancel Task
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Cancel Task',
    'a2a:cancel-task',
    '**Cancels a task** by its unique identifier, stopping a previously initiated operation on a remote A2A agent.

**Cancellation workflow:**
1. Identify the task to cancel (using its `taskId`)
2. Send cancellation request to the agent
3. Agent attempts to halt execution and cleanup resources
4. Receive confirmation or error response

**When to cancel:**
- **User request** - User decides to abort the operation
- **Timeout** - Task exceeded maximum allowed duration
- **Business logic** - Conditions changed (e.g., loan denied, so cancel document prep)
- **Error recovery** - Task is stuck or misbehaving
- **Resource management** - Free up agent capacity for higher-priority work

**Important notes:**
- *Not all tasks can be cancelled* - depends on agent implementation
- *Cancellation is best-effort* - task may complete before cancellation takes effect
- *Cleanup may vary* - some agents rollback changes, others leave partial results

**Example:** Cancel credit check task if customer withdraws loan application mid-process.',
    'Task Management'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#CancelTask',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.example_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('taskId', 'Task ID', 'JSON', false, 'Parameters for canceling a task in A2A protocol. **id** (required) - Unique identifier of the task to cancel; **lastEventId** (optional) - Last event ID for reconnection scenarios; **metadata** (optional) - Additional metadata for the cancellation request. See: https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#CancelTask', NULL, '{"id": "task-123"}', 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:cancel-task';

-- Operation 5: Set Push Notification Config
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Set Push Notification Config',
    'a2a:set-push-notification-config',
    '**Configures push notifications** for a specific task, enabling real-time event-driven updates instead of polling.

**Push notification benefits:**
- **Real-time updates** - Immediate notification when task status changes
- **Reduced overhead** - No need to poll continuously
- **Event-driven architecture** - React to task completion, errors, or progress updates
- **Better resource utilization** - Agent notifies you instead of you asking repeatedly

**Configuration workflow:**
1. Create a task on a remote agent
2. Configure push notification endpoint (webhook URL)
3. Specify event types to monitor (*completed*, *failed*, *progress*)
4. Receive HTTP callbacks when events occur

**Use cases:**
- **Long-running tasks** - Get notified when multi-hour processing completes
- **Async orchestration** - Trigger next workflow step when task finishes
- **Error alerting** - Immediate notification of task failures
- **Progress tracking** - Real-time updates for multi-stage processes

**Example:** Configure webhook to receive notification when "Document Signature Agent" completes contract signing.',
    'Push Notifications'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#SetPushNotificationConfig',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('taskPushNotificationConfig', 'Task Push Notification Config', 'JSON', true, 'Associates a push notification configuration with a specific task.', NULL, 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:set-push-notification-config';

-- Operation 6: Get Push Notification Config
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Get Push Notification Config',
    'a2a:get-push-notification-config',
    '**Retrieves push notification configuration** for a specific task. Requires **two IDs** because a single task can have multiple webhook endpoints.

**Why two IDs?**
- **Task ID** - Identifies *which task* you''re querying
- **Push Config ID** - Specifies *which webhook configuration* for that task

**Multi-endpoint use case:**
A single task may need to notify multiple systems:
- *Monitoring system* - Track operational metrics
- *User dashboard* - Show progress to end users
- *Audit logging* - Compliance and record-keeping
- *Error handling* - Alert on-call teams

**How to get Config IDs:**
1. **After creation** - `Set Push Notification Config` returns config ID in response
2. **Default ID** - If not specified during creation, config ID defaults to task ID
3. **Discovery** - Use `List Push Notification Configs` to find all configs for a task

**Typical workflow:**
1. Create task on remote agent
2. Set push notification config → receive config ID
3. Later, use this operation to verify or inspect config settings

**What you get back:**
- Webhook URL, event types, headers, retry policy, current status',
    'Push Notifications'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#GetPushNotificationConfig',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('getPushConfigParams', 'Get Push Config Params', 'JSON', true, 'Object for fetching the push notification configuration for a task. Contains id (required - task identifier), pushNotificationConfigId (optional - defaults to task ID if not provided), and metadata (optional - additional query metadata).', NULL, 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:get-push-notification-config';

-- Operation 7: List Push Notification Configs
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'List Push Notification Configs',
    'a2a:list-push-notification-configs',
    '**Lists all push notification configurations** associated with a specific task. Essential for discovery and management of multiple webhooks.

**What you get:**
- Array of all push notification configs for the task
- Each config includes: *config ID*, *webhook URL*, *event types*, *status*
- Use config IDs for subsequent `Get`, `Set`, or `Delete` operations

**Discovery workflow:**
1. You know the **task ID** but not the config IDs
2. Call `List Push Notification Configs` with task ID
3. Receive list of all webhook endpoints configured for that task
4. Select config ID to inspect, update, or delete

**Use cases:**
- **Audit** - See all systems receiving task notifications
- **Cleanup** - Find and remove unused webhook configs
- **Troubleshooting** - Identify which endpoints are active/failing
- **Multi-system coordination** - Understand full notification architecture

**Example result:**
```
[
  {id: "config-1", url: "https://monitoring.acme/webhook", events: ["completed", "failed"]},
  {id: "config-2", url: "https://dashboard.acme/updates", events: ["progress"]},
  {id: "config-3", url: "https://audit.acme/log", events: ["*"]}
]
```

*Often the first step when managing webhooks for existing tasks.*',
    'Push Notifications'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#ListPushNotificationConfigs',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('getPushConfigParams', 'Get Push Config Params', 'JSON', true, 'Object for fetching the push notification configuration for a task.', NULL, 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:list-push-notification-configs';

-- Operation 8: Delete Push Notification Config
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Delete Push Notification Config',
    'a2a:delete-push-notification-config',
    '**Removes a push notification configuration** for a task. Permanently stops webhook notifications to that endpoint.

**Deletion workflow:**
1. Identify the config to delete (task ID + config ID)
2. Call `Delete Push Notification Config`
3. Webhook endpoint immediately stops receiving notifications
4. Config is permanently removed (cannot be undone)

**When to delete:**
- **Cleanup** - Remove configs for completed or cancelled tasks
- **Security** - Revoke access when system or credential changes
- **Endpoint changes** - Delete old config before creating new one with updated URL
- **Decommissioning** - Remove webhooks when shutting down monitoring systems
- **Error resolution** - Delete misbehaving or failing webhook configs

**Important notes:**
- *Deletion is immediate* - no more events sent to that webhook
- *Cannot be undone* - must recreate config if needed later
- *Task continues* - only notification stops, task execution unaffected
- *Other configs unaffected* - only deletes specified config, not all webhooks for task

**Best practice:**
Use `List Push Notification Configs` first to confirm which config ID to delete.

**Example:** Delete webhook for decommissioned monitoring dashboard while keeping audit logging webhook active.',
    'Push Notifications'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#DeletePushNotificationConfig',
    8,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('deletePushConfigParams', 'Delete Push Config Params', 'JSON', true, 'Object for deleting a push notification configuration. **id** (required) - Task identifier; **pushNotificationConfigId** (required) - Specific configuration ID to delete; **metadata** (optional) - Additional metadata. BOTH id and pushNotificationConfigId are MANDATORY.', NULL, '{"id": "task-123", "pushNotificationConfigId": "config-456"}', 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:delete-push-notification-config';

-- Operation 9: Send Stream Message
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Send Stream Message',
    'a2a:send-stream-message',
    '**Sends a message** to the A2A agent and establishes an **SSE streaming connection** to receive real-time status updates, artifacts, and error notifications as the agent processes the request.

**Streaming workflow:**
1. Send message to target agent via A2A protocol
2. Establish Server-Sent Events (SSE) connection
3. Receive real-time updates as events stream back
4. Process status changes, artifacts, and notifications in real-time

**What you receive:**
- **Status updates** - Task state changes (pending → in-progress → completed)
- **Artifacts** - Intermediate and final outputs produced by the agent
- **Error notifications** - Real-time error reporting if task fails
- **Progress events** - Detailed progress information during execution

**Use cases:**
- **Long-running tasks** - Monitor multi-minute or multi-hour agent operations
- **Real-time dashboards** - Display live progress to end users
- **Event-driven workflows** - React immediately to agent state changes
- **Debugging** - Observe detailed agent execution in real-time

**Streaming vs. polling:**
- *Streaming (this operation)* - Instant updates, lower overhead, real-time visibility
- *Polling (Send Message + Get Task)* - Delayed updates, higher overhead, periodic checks

**Example:** Send "Generate quarterly financial report" to Reporting Agent, receive real-time progress as each section completes.',
    'Core Operations'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#SendStreamMessage',
    9,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('streamMessage', 'Stream Message', 'JSON', false, 'Message to send (MessageSendParams schema). Includes message content (role, parts, messageId), configuration (acceptedOutputModes, blocking), and optional metadata.', '#[payload]', 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:send-stream-message';

-- Operation 10: Task Resubscribe
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Task Resubscribe',
    'a2a:task-resubscribe',
    '**Reconnects to an existing SSE streaming session** for an ongoing task to receive buffered events and continue receiving real-time updates from where the connection was lost.

**Reconnection workflow:**
1. Identify the task ID for the streaming session
2. Call `Task Resubscribe` with the task ID
3. Receive any buffered events that occurred during disconnection
4. Resume real-time streaming of new events

**When to resubscribe:**
- **Network interruption** - Connection dropped due to network issues
- **Timeout** - SSE connection timed out but task is still running
- **Client restart** - Application restarted but task continues on agent
- **Load balancing** - Connection switched to different server instance
- **Intentional disconnect** - Temporarily closed connection, now want updates again

**Buffered events:**
The A2A agent buffers events during disconnection, so you won''t miss critical updates. Upon reconnection, you receive:
1. All buffered events since disconnection (in order)
2. Current task status
3. Continued real-time streaming of new events

**Use cases:**
- **Resilient monitoring** - Maintain task visibility despite connection issues
- **Fault tolerance** - Recover from transient network failures
- **Multi-client scenarios** - Different systems monitoring same long-running task
- **Connection management** - Optimize resource usage by connecting/disconnecting as needed

**Important notes:**
- Task must still be active (not completed or cancelled)
- Buffering duration depends on agent implementation
- Some agents may have buffer size limits

**Example:** Reconnect to "Document Processing Agent" task after network outage, receive buffered progress events showing pages 10-15 were processed during disconnection.',
    'Task Management'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#TaskResubscribe',
    10,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('taskIdParams', 'Task ID Params', 'JSON', false, 'Task ID to resubscribe to (TaskIdParams schema). Contains the unique identifier of the task whose streaming session you want to reconnect to.', '#[payload]', 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Optional arbitrary metadata sent with the A2A request. **SDK Internals:** Populates the metadata field in MessageSendParams/TaskIdParams; accessible via ClientCallContext (https://github.com/a2aproject/a2a-java/blob/main/client/transport/spi/src/main/java/io/a2a/client/transport/spi/interceptors/ClientCallContext.java) for interceptors; the receiving agent can use it for routing/processing decisions; not validated by the A2A protocol. **Common Uses:** Request tracking (correlation_id, originating_system), Agent Fabric context (client_type: agent/user/system), business context (tenant_id, region, cost_center), debug/telemetry (trace_id, test_mode). **Example:** {"correlation_id": "req-123", "client_type": "agent", "priority": "high"}', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:task-resubscribe';

-- =====================================================
-- 6. INSERT INACTIVE SERVER OPERATIONS
-- =====================================================

-- Server Operation 1: Send Push Notification
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[SERVER] Send Push Notification',
    'a2a:send-push-notification',
    '**Sends a push notification** with the provided task or message payload. This operation allows sending async updates at various stages or steps of a task, not just at the end. The notification message is automatically wrapped in JSON-RPC format. This is a non-blocking operation that uses CompletionCallback for async result handling.

**Server-side operation** - Used when building A2A server agents to send notifications to clients who have configured push notification endpoints.

**Notification workflow:**
1. Task progresses through various stages on the server
2. At key milestones, call `Send Push Notification` with task/message data
3. Connector wraps payload in JSON-RPC format automatically
4. HTTP POST sent to client''s configured webhook endpoint
5. Operation completes asynchronously (non-blocking)

**When to send notifications:**
- **Task state changes** - Started, in-progress, completed, failed
- **Progress milestones** - 25%, 50%, 75%, 100% completion
- **Intermediate results** - Partial outputs available for consumption
- **Errors or warnings** - Issues encountered during processing
- **Custom events** - Application-specific notifications

**Use cases:**
- **Long-running tasks** - Notify clients when multi-hour processing completes
- **Multi-stage workflows** - Update clients as each stage finishes
- **Error alerting** - Immediate notification when task fails
- **Progress tracking** - Real-time updates for complex operations

**Important notes:**
- Requires client to have configured push notification endpoint via `Set Push Notification Config`
- Non-blocking operation (fire-and-forget with callback)
- Automatic JSON-RPC wrapping (don''t manually wrap payload)
- Used in A2A server implementations only

**Example:** Send notification when "Invoice Processing Agent" completes validation stage, before starting payment processing stage.',
    'Push Notifications'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#SendPushNotification',
    11,
    false
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('notificationMessage', 'Notification Message', 'JSON', false, 'The JSON notification message (task or message object). This value is automatically wrapped in JSON-RPC format.', '#[payload]', 1)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:send-push-notification';

-- Server Operation 2: Update Task Artifact
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[SERVER] Update Task Artifact',
    'a2a:update-task-artifact',
    '**Updates a task artifact** and broadcasts the update to all connected SSE clients. Used by A2A server implementations to publish intermediate or final task outputs to streaming clients.

**Server-side operation** - Used when building A2A server agents to push artifact updates to clients connected via SSE streaming.

**Artifact workflow:**
1. Task generates output (intermediate or final result)
2. Call `Update Task Artifact` with artifact data
3. Artifact stored in task state
4. Update broadcast to all SSE clients monitoring this task
5. Clients receive artifact in real-time via streaming connection

**Artifact types:**
- **Final outputs** - Completed task results
- **Intermediate outputs** - Partial results during multi-stage processing
- **Generated files** - Documents, reports, images created by agent
- **Data transformations** - Processed data ready for consumption
- **Status artifacts** - Metadata about task execution

**Use cases:**
- **Progressive results** - Publish results as they become available
- **Multi-output tasks** - Tasks that produce multiple artifacts
- **Large file handling** - Stream large outputs incrementally
- **Real-time collaboration** - Multiple clients monitoring same task

**SSE broadcasting:**
All clients with active SSE connections to this task receive the artifact update immediately. This enables real-time monitoring and progressive result consumption.

**Example:** "Report Generation Agent" publishes each completed section as an artifact - executive summary, financial data, charts - allowing clients to display results progressively rather than waiting for entire report.',
    'Service'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#UpdateTaskArtifact',
    12,
    false
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('artifactUpdateContent', 'Artifact Update Content', 'JSON', false, 'TaskArtifactUpdateEvent content following A2A specification. Includes task ID, artifact data, and metadata.', '#[payload]', 1)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:update-task-artifact';

-- Server Operation 3: Update Task Status
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[SERVER] Update Task Status',
    'a2a:update-task-status',
    '**Updates a task status** and broadcasts the update to all connected SSE clients. Used by A2A server implementations to communicate task state changes to streaming clients.

**Server-side operation** - Used when building A2A server agents to push status updates to clients connected via SSE streaming.

**Status workflow:**
1. Task state changes (e.g., pending → in-progress → completed)
2. Call `Update Task Status` with new status and metadata
3. Status stored in task state
4. Update broadcast to all SSE clients monitoring this task
5. Clients receive status change in real-time via streaming connection

**Task statuses:**
- **Pending** - Task queued, waiting to start
- **In-progress** - Task actively executing
- **Completed** - Task finished successfully
- **Failed** - Task encountered error and stopped
- **Cancelled** - Task cancelled by client request
- **Custom statuses** - Application-specific states

**Status metadata:**
- **Progress percentage** - Completion estimate (0-100%)
- **Current stage** - Which step of multi-stage process
- **Error details** - Failure reason and diagnostic info
- **Estimated completion** - Time remaining prediction
- **Resource usage** - CPU, memory, or other metrics

**Use cases:**
- **Progress tracking** - Show real-time completion percentage to users
- **State machine workflows** - Complex multi-stage task orchestration
- **Error handling** - Immediate notification of failures
- **SLA monitoring** - Track task duration and completion times

**SSE broadcasting:**
All clients with active SSE connections to this task receive the status update immediately. This enables real-time dashboards and responsive UIs.

**Example:** "Data Migration Agent" updates status as it progresses: pending (0%) → in-progress (25% - validating) → in-progress (50% - transforming) → in-progress (75% - loading) → completed (100%).',
    'Service'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#UpdateTaskStatus',
    13,
    false
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('statusUpdateContent', 'Status Update Content', 'JSON', false, 'TaskStatusUpdateEvent content following A2A specification. Includes task ID, status, progress, and metadata.', '#[payload]', 1)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND o.operation_key = 'a2a:update-task-status';

-- =====================================================
-- 7. INSERT INACTIVE SERVER SOURCES (LISTENERS)
-- =====================================================

-- Inactive Source 1: Task Stream Listener
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[SERVER] On Task Stream Listener',
    'a2a:task-stream-listener',
    '**Server-side listener for streaming task requests.** Activated when clients send streaming requests (`messages/stream`) to trigger server-side flows and enable real-time SSE event delivery.

**Prerequisite for streaming support** - This source is required for applications to support streaming. This source is to be used in conjunction with Task Listener.

**Listener workflow:**
1. Client sends streaming request to A2A server
2. `Task Stream Listener` intercepts the streaming request
3. Triggers server-side flow to process the task
4. Enables SSE connection for real-time event broadcasting
5. Works with `Update Task Status` and `Update Task Artifact` operations

**Architecture:**
- **Task Listener** - Handles standard (non-streaming) task requests
- **Task Stream Listener** - Handles streaming task requests (this source)
- Both listeners can coexist in same application
- Routing based on client request type (standard vs. streaming)

**Use cases:**
- **Building A2A server agents** - Implement streaming support for your agent
- **Real-time task execution** - Process tasks with live status updates
- **Progressive results** - Publish outputs as they''re generated
- **Long-running operations** - Keep clients informed during extended processing

**Important notes:**
- Server-side source (not used in client applications)
- Requires A2A Server configuration (not Client configuration)
- Used with `Update Task Status` and `Update Task Artifact` operations
- Complements standard `Task Listener` for non-streaming requests

**Example:** "Document Processing Agent" uses Task Stream Listener to accept streaming requests, then broadcasts status updates (page 1 processed, page 2 processed, etc.) and artifacts (extracted text, images) as processing progresses.',
    'Service'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#TaskStreamListener',
    14,
    false
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

-- Inactive Source 2: Task Listener
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[SERVER] Task Listener',
    'a2a:task-listener',
    'Allows a Mule application to listen for and receive incoming A2A protocol-compliant requests from other AI agents, enabling the Mule-based agent to act as an A2A server and respond to tasks. Used when building A2A server agents.',
    'Service'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#TaskListener',
    15,
    false
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

-- Inactive Source 3: Push Notification Config Listener
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[SERVER] On Push Notification Set Listener',
    'a2a:push-notification-config-listener',
    'Validates the push notification configuration before routing the request to the Task Listener source. Server-side listener used when building A2A server agents.',
    'Push Notifications'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/a2a-connector/latest/a2a-connector-reference#PushNotificationConfigListener',
    16,
    false
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config';

-- =====================================================
-- 8. CREATE RUNTIME CONFIGURATION
-- =====================================================

-- Create runtime configuration for A2A Client
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'MCPG A2A Server',
    'MuleSoftForge Connector Playground''s own A2A Server',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
  AND ct.config_type_key = 'a2a:client-config'
  AND cp.provider_key = 'client-connection';

-- Insert runtime config values
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'serverUrl' THEN '#[p('mcpg.a2a.serverUrl')]'
        WHEN 'agentPath' THEN '#[p('mcpg.a2a.agentPath')]'
        WHEN 'authType' THEN 'none'
    END,
    false
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'MCPG A2A Server'
  AND cfp.api_name IN ('serverUrl', 'agentPath', 'authType');

-- =====================================================
-- SEED COMPLETE - Summary Query
-- =====================================================

SELECT 
    '✅ A2A (Agent-to-Agent) connector seed data inserted successfully!' AS status;

SELECT 
    c.name as connector,
    COUNT(DISTINCT o.id) as operations,
    COUNT(DISTINCT CASE WHEN o.is_active = true THEN o.id END) as active_operations,
    COUNT(DISTINCT CASE WHEN o.is_active = false THEN o.id END) as inactive_operations,
    COUNT(DISTINCT op.id) as parameters,
    COUNT(DISTINCT cct.id) as config_types,
    COUNT(DISTINCT cp.id) as providers,
    COUNT(DISTINCT cfp.id) as config_params,
    COUNT(DISTINCT rc.id) as runtime_configs,
    COUNT(DISTINCT rcv.id) as runtime_config_values
FROM connectors c
LEFT JOIN operations o ON o.connector_id = c.id
LEFT JOIN operation_parameters op ON op.operation_id = o.id
LEFT JOIN connector_config_types cct ON cct.connector_id = c.id
LEFT JOIN config_providers cp ON cp.config_type_id = cct.id
LEFT JOIN config_parameters cfp ON cfp.provider_id = cp.id
LEFT JOIN runtime_configurations rc ON rc.config_type_id = cct.id
LEFT JOIN runtime_config_values rcv ON rcv.runtime_config_id = rc.id
WHERE c.maven_artifact_id = 'mule4-a2a-connector'
GROUP BY c.name;

