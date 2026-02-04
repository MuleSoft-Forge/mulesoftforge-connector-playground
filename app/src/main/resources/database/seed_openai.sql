-- ============================================================================
-- OpenAI Connector Seed Data
-- ============================================================================
-- Connector: OpenAI Connector 0.1.0
-- Description: The OpenAI API provides developers with programmatic access 
--              to OpenAI's advanced AI models, including GPT-4, embeddings,
--              assistants, and moderation.
-- Documentation: https://platform.openai.com/docs/api-reference
-- Exchange: com.mulesoft.connectivity.openai:openai-anypoint-connector-model
-- ============================================================================

-- ============================================================================
-- 1. CONNECTOR
-- ============================================================================
INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'openai-anypoint-connector-model',
    'OpenAI',
    '0.1.0',
    'AI',
    'The OpenAI API provides developers with programmatic access to OpenAI''s advanced AI models, including large language models like GPT-4, vision models, embeddings, assistants, and content moderation.',
    'https://docs.mulesoft.com/openai-connector/0.1/',
    'data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMjQgMjQiPgogICAgPHBhdGggZmlsbD0iIzAwMDAwMCIgZD0iTTIzLjE1IDExLjQxYy4yNi41OC40MiAxLjIuNDkgMS44My4wNy42My4wMyAxLjI3LS4xIDEuOS0uMTMuNjItLjM2IDEuMjItLjY4IDEuNzctLjIxLjM3LS40Ni43MS0uNzQgMS4wMy0uMjguMzEtLjYuNi0uOTQuODUtLjM1LjI1LS43MS40Ni0xLjEuNjMtLjM5LjE3LS43OS4zLTEuMjEuMzktLjIuNi0uNDkgMS4xOC0uODYgMS42OS0uMzcuNTEtLjgzLjk3LTEuMzQgMS4zNC0uNTIuMzctMS4wOS42Ni0xLjY5Ljg2LS42MS4yLTEuMjQuMjktMS44OC4yOS0uNDIgMC0uODUtLjA0LTEuMjYtLjEzLS40MS0uMDktLjgyLS4yMi0xLjIxLS4zOS0uMzktLjE3LS43NS0uMzktMS4xLS42NC0uMzQtLjI1LS42NS0uNTQtLjkzLS44NS0uNjMuMTMtMS4yNy4xNy0xLjkuMS0uNjMtLjA3LTEuMjUtLjIzLTEuODQtLjQ5LS41OC0uMjYtMS4xMi0uNjEtMS41OS0xLjA0LS40Ny0uNDMtLjg4LS45My0xLjE5LTEuNDgtLjIxLS4zNy0uMzktLjc1LS41Mi0xLjE2LS4xMy0uNDEtLjIyLS44Mi0uMjctMS4yNC0uMDQtLjQyLS4wNC0uODQgMC0xLjI3LjA1LS40Mi4xNC0uODMuMjctMS4yNC0uNDItLjQ3LS43Ny0xLjAxLTEuMDMtMS41OS0uMjYtLjU4LS40My0xLjItLjQ5LTEuODMtLjA3LS42My0uMDMtMS4yNy4xLTEuOS4xMy0uNjIuMzYtMS4yMi42OC0xLjc3LjIxLS4zNy40Ni0uNzEuNzQtMS4wMy4yOC0uMzEuNi0uNi45NC0uODUuMzUtLjI1LjcxLS40NiAxLjEtLjYzLjM5LS4xNy44LS4zIDEuMjEtLjM4LjItLjYxLjQ5LTEuMTguODYtMS42OS4zNy0uNTIuODMtLjk3IDEuMzQtMS4zNC41Mi0uMzcgMS4wOS0uNjYgMS42OS0uODYuNjEtLjIgMS4yNC0uMyAxLjg4LS4yOS40MiAwIC44NS4wNCAxLjI2LjEzLjQxLjA5LjgyLjIyIDEuMjEuMzkuMzkuMTcuNzUuMzkgMS4xLjY0LjM0LjI1LjY2LjU0Ljk0Ljg1LjYyLS4xMyAxLjI2LS4xNiAxLjg5LS4xLjYzLjA3IDEuMjUuMjMgMS44My40OS41OC4yNiAxLjEyLjYxIDEuNTkgMS4wNC40Ny40Mi44OC45MiAxLjE5IDEuNDcuMjEuMzcuMzkuNzUuNTIgMS4xNi4xMy40LjIyLjgyLjI3IDEuMjQuMDQuNDIuMDQuODUgMCAxLjI3LS4wNS40Mi0uMTQuODQtLjI3IDEuMjQuNDMuNDcuNzggMS4wMSAxLjA0IDEuNTl6bS04LjMzIDEwLjY3Yy41NC0uMjIgMS4wNC0uNTYgMS40Ni0uOTcuNDItLjQyLjc1LS45MS45Ny0xLjQ2LjIzLS41NS4zNC0xLjEzLjM0LTEuNzJ2LTUuNThsLTIuMDItMS4xNnY2LjczYzAgLjA3LS4wMS4xNC0uMDMuMi0uMDIuMDctLjA0LjEzLS4wOC4xOS0uMDMuMDYtLjA3LjEyLS4xMi4xNi0uMDUuMDUtLjEuMDktLjE2LjEzbC00Ljc4IDIuNzZjLjIuMTcuNDEuMzEuNjQuNDQuMjMuMTMuNDYuMjQuNzEuMzMuMjQuMDkuNS4xNS43NS4yLjI2LjA0LjUyLjA3Ljc4LjA3LjU5IDAgMS4xNy0uMTIgMS43Mi0uMzV6bS0xMS4zOC0zLjc5Yy4zLjUxLjY5Ljk2IDEuMTYgMS4zMi40Ny4zNiAxIC42MiAxLjU3Ljc3LjU3LjE2IDEuMTcuMTkgMS43NS4xMi41OC0uMDggMS4xNS0uMjcgMS42Ni0uNTZsNC44My0yLjc5di0yLjM1bC01LjgzIDMuMzdjLS4wNi4wNC0uMTIuMDYtLjE5LjA4LS4wNy4wMi0uMTMuMDMtLjIuMDMtLjA3IDAtLjE0LS4wMS0uMi0uMDMtLjA3LS4wMi0uMTMtLjA0LS4xOS0uMDhsLTQuNzgtMi43NmMtLjA0LjI2LS4wNy41Mi0uMDcuNzhzLjAzLjUyLjA3Ljc4Yy4wNS4yNS4xMi41MS4yLjc1LjA5LjI0LjIuNDguMzMuN3ptLTEuMjYtMTAuNDJjLS4yOS41MS0uNDggMS4wOC0uNTYgMS42Ni0uMDguNTgtLjA0IDEuMTguMTIgMS43NS4xNS41Ny40MSAxLjEuNzcgMS41Ny4zNi40Ny44MS44NiAxLjMyIDEuMTZsNC44MyAyLjc5LjAyLS4wMmguMDRsMi4wMi0xLjE3LTUuODMtMy4zN2MtLjA2LS4wMy0uMTEtLjA4LS4xNi0uMTItLjA1LS4wNS0uMDktLjEtLjEzLS4xNi0uMDMtLjA2LS4wNi0uMTItLjA4LS4xOS0uMDItLjA2LS4wMi0uMTMtLjAyLS4ydi01LjY4Yy0uMjQuMDktLjQ4LjItLjcxLjMzLS4yMi4xMy0uNDQuMjgtLjY0LjQ1LS4yLjE3LS4zOC4zNS0uNTUuNTUtLjE3LjItLjMxLjQxLS40NC42NHptMTYuNTggMy44NmMuMDYuMDMuMTIuMDcuMTcuMTIuMDUuMDUuMDkuMS4xMi4xNi4wMy4wNi4wNi4xMy4wOC4xOS4wMS4wNy4wMi4xNC4wMi4yMXY1LjY4Yy44LS4zIDEuNS0uODEgMi4wMi0xLjQ5LjUyLS42OC44My0xLjQ5LjkxLTIuMzQuMDctLjg1LS4xLTEuNzEtLjQ5LTIuNDYtLjQtLjc2LTEtMS4zOS0xLjc0LTEuODFsLTQuODMtMi43OS0uMDIuMDJoLS4wNGwtMi4wMSAxLjE3em0yLjAxLTMuMDNoLS4wMXptMCAwYy4xNC0uODQuMDUtMS43MS0uMjgtMi40OS0uMzMtLjc5LS44OC0xLjQ3LTEuNTgtMS45Ni0uNy0uNDktMS41Mi0uNzctMi4zOC0uOC0uODUtLjA0LTEuNy4xNy0yLjQ0LjZsLTQuODMgMi43OXYyLjMzbDUuODMtMy4zN2MuMDYtLjAzLjEzLS4wNi4xOS0uMDguMDctLjAyLjEzLS4wMi4yLS4wMi4wNyAwIC4xNC4wMS4yMS4wMi4wNi4wMi4xMy4wNS4xOS4wOGw0Ljc4IDIuNzZ6bS0xMi42My0yLjU4YzAtLjA3LjAxLS4xNC4wMy0uMi4wMi0uMDcuMDQtLjEzLjA4LS4xOS4wMy0uMDYuMDctLjExLjEyLS4xNi4wNS0uMDUuMS0uMDkuMTYtLjEybDQuNzgtMi43NmMtLjY2LS41NS0xLjQ2LS45LTIuMy0xLjAxLS44NS0uMTEtMS43MS4wMy0yLjQ4LjM5LS43Ny4zNi0xLjQzLjk0LTEuODkgMS42Ni0uNDYuNzItLjcgMS41Ni0uNyAyLjQxdjUuNThsMi4wMiAxLjE3em0xLjA5IDcuMzcgMi42IDEuNSAyLjYtMS41di0zIGwtMi42LTEuNS0yLjYgMS41eiIvPgo8L3N2Zz4=',
    true
);

-- ============================================================================
-- 2. CONFIG TYPE
-- ============================================================================
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'openai:config',
    'OpenAI Configuration',
    'Default configuration for OpenAI Connector with API key authentication.'
FROM connectors 
WHERE maven_artifact_id = 'openai-anypoint-connector-model';

-- ============================================================================
-- 3. CONFIG PROVIDER (Connection Type)
-- ============================================================================
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'openai:api-key',
    'Api Key',
    'API Key authentication for OpenAI API access.'
FROM connector_config_types 
WHERE config_type_key = 'openai:config';

-- ============================================================================
-- 4. CONFIG PARAMETERS
-- ============================================================================

-- Base URI
INSERT INTO config_parameters (provider_id, api_name, display_name, data_type, is_required, default_value, description, parameter_order)
SELECT 
    id,
    'baseUri',
    'Base URI',
    'String',
    true,
    'https://api.openai.com/v1',
    'The base URI for the OpenAI API endpoint.',
    1
FROM config_providers 
WHERE provider_key = 'openai:api-key';

-- API Token
INSERT INTO config_parameters (provider_id, api_name, display_name, data_type, is_required, default_value, description, parameter_order)
SELECT 
    id,
    'token',
    'API Key',
    'String',
    true,
    NULL,
    'Your OpenAI API key. Get yours at https://platform.openai.com/api-keys',
    2
FROM config_providers 
WHERE provider_key = 'openai:api-key';

-- ============================================================================
-- 5. OPERATIONS - CHAT (1 operation)
-- ============================================================================

-- Create Chat Completion
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-chat-completion',
    '[Chat] Create Chat Completion',
    'Creates a model response for the given chat conversation. Supports GPT-4, GPT-3.5, and other chat models.',
    'Chat'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/chat/create',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The chat completion request body containing model, messages array, and optional parameters like temperature, max_tokens, etc.',
    'JSON',
    true,
    NULL,
    '{}',
    '{"model": "gpt-4", "messages": [{"role": "user", "content": "Hello!"}]}',
    1
FROM operations 
WHERE operation_key = 'openai:create-chat-completion';

-- ============================================================================
-- 6. OPERATIONS - EMBEDDINGS (1 operation)
-- ============================================================================

-- Create Embedding
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-embedding',
    '[Embedding] Create Embedding',
    'Creates an embedding vector representing the input text. Use for semantic search, clustering, and recommendations.',
    'Embedding'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/embeddings/create',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The embedding request body containing model (e.g., text-embedding-3-small) and input text or array of texts.',
    'JSON',
    true,
    NULL,
    '{}',
    '{"model": "text-embedding-3-small", "input": "Your text to embed"}',
    1
FROM operations 
WHERE operation_key = 'openai:create-embedding';

-- ============================================================================
-- 7. OPERATIONS - ASSISTANTS API (11 operations)
-- ============================================================================

-- Create Assistant
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-assistant',
    '[Assistants] Create Assistant',
    'Create an AI assistant with custom instructions, tools, and knowledge. Assistants can call functions, retrieve information, and run code.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/assistants/createAssistant',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The assistant configuration including model, name, instructions, and tools (code_interpreter, file_search, function).',
    'JSON',
    true,
    NULL,
    '{}',
    '{"model": "gpt-4-turbo", "name": "Math Tutor", "instructions": "You are a helpful math tutor."}',
    1
FROM operations 
WHERE operation_key = 'openai:create-assistant';

-- List Assistants
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:list-assistants',
    '[Assistants] List Assistants',
    'Returns a paginated list of assistants. Supports ordering and cursor-based pagination.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/assistants/listAssistants',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'limit',
    'Limit',
    'Maximum number of assistants to return (1-100).',
    'Number',
    false,
    '20',
    '{"min": 1, "max": 100}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:list-assistants';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'order',
    'Order',
    'Sort order by creation time: asc (ascending) or desc (descending).',
    'String',
    false,
    'desc',
    '{}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'openai:list-assistants';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'after',
    'After',
    'Cursor for pagination. Fetches assistants created after this ID.',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    3
FROM operations 
WHERE operation_key = 'openai:list-assistants';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'before',
    'Before',
    'Cursor for pagination. Fetches assistants created before this ID.',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    4
FROM operations 
WHERE operation_key = 'openai:list-assistants';

-- Retrieve Assistants
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:retrieve-assistants',
    '[Assistants] Retrieve Assistant',
    'Retrieves an assistant by ID. Returns the assistant object with its configuration and metadata.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/assistants/getAssistant',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'assistant_id',
    'Assistant ID',
    'The ID of the assistant to retrieve.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:retrieve-assistants';

-- Modify Assistant
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:modify-assistant',
    '[Assistants] Modify Assistant',
    'Modifies an existing assistant. Update the name, instructions, tools, or model.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/assistants/modifyAssistant',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'assistant_id',
    'Assistant ID',
    'The ID of the assistant to modify.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:modify-assistant';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The fields to update (name, instructions, tools, model, etc.).',
    'JSON',
    true,
    NULL,
    '{}',
    '{"instructions": "Updated instructions for the assistant"}',
    2
FROM operations 
WHERE operation_key = 'openai:modify-assistant';

-- Create Thread
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-thread',
    '[Assistants] Create Thread',
    'Create a conversation thread for the Assistants API. Threads store messages and maintain conversation state.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/threads/createThread',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'Optional thread configuration including initial messages and metadata.',
    'JSON',
    false,
    '{}',
    '{}',
    '{"messages": [{"role": "user", "content": "Hello"}]}',
    1
FROM operations 
WHERE operation_key = 'openai:create-thread';

-- Retrieve Thread
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:retrieve-thread',
    '[Assistants] Retrieve Thread',
    'Retrieves a thread by ID. Returns the thread object with metadata.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/threads/getThread',
    8,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread to retrieve.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:retrieve-thread';

-- Modify Thread
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:modify-thread',
    '[Assistants] Modify Thread',
    'Modifies a thread. Currently only supports updating metadata.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/threads/modifyThread',
    9,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread to modify.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:modify-thread';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The fields to update (currently only metadata).',
    'JSON',
    true,
    NULL,
    '{}',
    '{"metadata": {"user_id": "user_123"}}',
    2
FROM operations 
WHERE operation_key = 'openai:modify-thread';

-- Delete Thread
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:delete-thread',
    '[Assistants] Delete Thread',
    'Deletes a thread permanently. This cannot be undone.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/threads/deleteThread',
    10,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread to delete.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:delete-thread';

-- Create Thread And Run
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-thread-and-run',
    '[Assistants] Create Thread And Run',
    'Create a thread and run it in one request. Efficient way to start a conversation and get an assistant response.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/runs/createThreadAndRun',
    11,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The request containing assistant_id, thread configuration, and optional run parameters.',
    'JSON',
    true,
    NULL,
    '{}',
    '{"assistant_id": "asst_abc123", "thread": {"messages": [{"role": "user", "content": "Hello"}]}}',
    1
FROM operations 
WHERE operation_key = 'openai:create-thread-and-run';

-- Create Message
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-message',
    '[Assistants] Create Message',
    'Add a message to a thread. Messages are the core of conversations in the Assistants API.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/messages/createMessage',
    12,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread to add the message to.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:create-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The message content including role (user/assistant) and content text or array.',
    'JSON',
    true,
    NULL,
    '{}',
    '{"role": "user", "content": "How can I help you today?"}',
    2
FROM operations 
WHERE operation_key = 'openai:create-message';

-- List Message
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:list-message',
    '[Assistants] List Messages',
    'Returns a paginated list of messages in a thread. Supports ordering and filtering by run.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/messages/listMessages',
    13,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread to retrieve messages from.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:list-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'limit',
    'Limit',
    'Maximum number of messages to return (1-100).',
    'Number',
    false,
    '20',
    '{"min": 1, "max": 100}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'openai:list-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'order',
    'Order',
    'Sort order by creation time: asc (ascending) or desc (descending).',
    'String',
    false,
    'desc',
    '{}',
    NULL,
    3
FROM operations 
WHERE operation_key = 'openai:list-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'after',
    'After',
    'Cursor for pagination. Fetches messages created after this ID.',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    4
FROM operations 
WHERE operation_key = 'openai:list-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'before',
    'Before',
    'Cursor for pagination. Fetches messages created before this ID.',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    5
FROM operations 
WHERE operation_key = 'openai:list-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'run_id',
    'Run ID',
    'Optional filter to only show messages associated with a specific run.',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    6
FROM operations 
WHERE operation_key = 'openai:list-message';

-- Retrieve Message
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:retrieve-message',
    '[Assistants] Retrieve Message',
    'Retrieves a specific message from a thread by ID.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/messages/getMessage',
    14,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread containing the message.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:retrieve-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'message_id',
    'Message ID',
    'The ID of the message to retrieve.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'openai:retrieve-message';

-- Modify Message
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:modify-message',
    '[Assistants] Modify Message',
    'Modifies a message in a thread. Currently only supports updating metadata.',
    'Agent'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/messages/modifyMessage',
    15,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'thread_id',
    'Thread ID',
    'The ID of the thread containing the message.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'openai:modify-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'message_id',
    'Message ID',
    'The ID of the message to modify.',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'openai:modify-message';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The fields to update (currently only metadata).',
    'JSON',
    true,
    NULL,
    '{}',
    '{"metadata": {"important": "true"}}',
    3
FROM operations 
WHERE operation_key = 'openai:modify-message';

-- ============================================================================
-- 8. OPERATIONS - MODERATIONS (1 operation)
-- ============================================================================

-- Create Moderation
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:create-moderation',
    '[Moderation] Create Moderation',
    'Classifies if text violates OpenAI''s usage policies. Checks for hate, harassment, self-harm, sexual content, and violence.',
    'Moderation'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/moderations/create',
    16,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'body',
    'Request Body',
    'The moderation request body containing input text and optional model (text-moderation-latest or text-moderation-stable).',
    'JSON',
    true,
    NULL,
    '{}',
    '{"input": "Text to check for policy violations"}',
    1
FROM operations 
WHERE operation_key = 'openai:create-moderation';

-- ============================================================================
-- 9. OPERATIONS - MODELS (1 operation)
-- ============================================================================

-- List Models
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'openai:list-models',
    '[Models] List Models',
    'Lists all available models including GPT-4, GPT-3.5, embeddings, and other models accessible with your API key.',
    'Platform'::operation_category,
    ct.id,
    'https://platform.openai.com/docs/api-reference/models/list',
    17,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config';

-- No parameters needed for List Models

-- ============================================================================
-- 10. RUNTIME CONFIGS (Default configuration)
-- ============================================================================

-- Default OpenAI Config
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'OpenAI Connection (Default)',
    'Default OpenAI API configuration. Provides access to GPT-4, embeddings, assistants, and all OpenAI services.',
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND ct.config_type_key = 'openai:config'
  AND cp.provider_key = 'openai:api-key';

INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp.id,
    CASE cp.api_name
        WHEN 'baseUri' THEN '${openai.baseUri}'
        WHEN 'token' THEN '${openai.apiKey}'
    END,
    CASE cp.api_name
        WHEN 'token' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN connector_config_types ct ON rc.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers prov ON prov.config_type_id = ct.id
JOIN config_parameters cp ON cp.provider_id = prov.id
WHERE c.maven_artifact_id = 'openai-anypoint-connector-model'
  AND rc.name = 'OpenAI Connection (Default)';

