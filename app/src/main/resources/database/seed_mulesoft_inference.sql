-- =====================================================
-- MULESOFT INFERENCE CONNECTOR - SEED DATA
-- =====================================================
-- Aligned with inference.xml
--
-- This seed includes:
-- - 1 Connector: MuleSoft Inference 1.2
-- - 4 Config Types: Text Generation, Vision, Image Generation, Moderation
-- - 6 Providers: OpenAI Text, Anthropic Text, OpenAI Vision, Anthropic Vision, OpenAI Image, OpenAI Moderation
-- - 8 Operations: Chat Answer Prompt, Chat Completions, Agent Define Prompt Template, 
--                 Tools Native Template, MCP Tooling, Image Read, Image Generate, Toxicity Detection
-- - 6 Runtime Configs (1 active, 5 inactive placeholders)
-- - Complete config parameters for all providers
--
-- NOTE: schema.sql drops all tables first, so this inserts into empty tables
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-mulesoft-inference-connector',
    'MuleSoft Inference',
    '1.2.0',
    'AI',
    '**MuleSoft Inference Connector** provides direct access to multiple LLM providers (OpenAI, Anthropic, Cohere, Google, Amazon) *without* the Trust Layer. Ideal for development, testing, or scenarios where data governance is handled externally.

**Key capabilities:**
- **Multi-model access** - Call OpenAI GPT, Anthropic Claude, Cohere, Google Gemini, Amazon Bedrock
- **Text generation** - Chat completions, summarization, classification, translation
- **Vision** - Image analysis and description
- **Image generation** - Create images from text prompts (DALL-E, Stable Diffusion)
- **Content moderation** - Detect harmful content

**When to use:** Development/testing, external governance, POCs, demos, or when you need direct model access without Trust Layer overhead.

**Use cases:** Prototyping, internal tools, specialized workflows, multi-model comparison.',
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHdpZHRoPSI1MTIiIGhlaWdodD0iNTEyIiB4PSIwIiB5PSIwIiB2aWV3Qm94PSIwIDAgNTEyIDUxMiIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgNTEyIDUxMiIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgY2xhc3M9IiI+PGNpcmNsZSByPSIyNTYiIGN4PSIyNTYiIGN5PSIyNTYiIGZpbGw9IiNjZmU5ZmUiIHNoYXBlPSJjaXJjbGUiPjwvY2lyY2xlPjxnIHRyYW5zZm9ybT0ibWF0cml4KDAuOTY5OTk5OTk5OTk5OTk5MywwLDAsMC45Njk5OTk5OTk5OTk5OTkzLDcuNjgwMzc1MTM3MzI5MzQ5LDIyLjY3OTk5OTU0MjIzNjgzKSI+PHBhdGggZD0iTTMzNS4yIDI3OS45YzIxLjItMjEuMiAzMi44LTQ5LjMgMzIuOC03OS4zIDAtMjkuOS0xMS43LTU4LjEtMzIuOC03OS4zbC0yNi40IDI2LjRjMTQuMSAxNC4xIDIxLjkgMzIuOSAyMS45IDUyLjggMCAyMC03LjggMzguNy0yMS45IDUyLjl6TTE3Ni43IDI3OS45bDI2LjQtMjYuNGMtMjkuMS0yOS4xLTI5LjEtNzYuNiAwLTEwNS43bC0yNi40LTI2LjRjLTQzLjcgNDMuNi00My43IDExNC44IDAgMTU4LjV6IiBmaWxsPSIjMDE3NmQzIiBvcGFjaXR5PSIxIiBkYXRhLW9yaWdpbmFsPSIjMDAwMDAwIiBjbGFzcz0iIj48L3BhdGg+PHBhdGggZD0ibTM4OC4xIDY4LjUtMjYuNCAyNi40YzI4LjIgMjguMiA0My44IDY1LjggNDMuOCAxMDUuN3MtMTUuNSA3Ny41LTQzLjggMTA1LjdsMjYuNCAyNi40YzM1LjMtMzUuMyA1NC43LTgyLjIgNTQuNy0xMzIuMXMtMTkuNC05Ni44LTU0LjctMTMyLjF6TTE1MC4zIDk0LjlsLTI2LjQtMjYuNGMtNzIuOSA3Mi44LTcyLjkgMTkxLjQgMCAyNjQuMmwyNi40LTI2LjRDOTIgMjQ4IDkyIDE1My4yIDE1MC4zIDk0Ljl6TTI3NC42IDIzMi44YzIuOC0xLjYgNS40LTMuNSA3LjctNS44IDcuMS03LjEgMTAuOS0xNi40IDEwLjktMjYuNHMtMy45LTE5LjQtMTAuOS0yNi40Yy0xNC4xLTE0LjEtMzguNy0xNC4xLTUyLjggMC03LjEgNy4xLTEwLjkgMTYuNC0xMC45IDI2LjRzMy45IDE5LjQgMTAuOSAyNi40YzIuMyAyLjMgNSA0LjIgNy43IDUuOHYxNzMuM2gtNzQuN3YzNy40aDE4Ni44di0zNy40aC03NC43eiIgZmlsbD0iIzAxNzZkMyIgb3BhY2l0eT0iMSIgZGF0YS1vcmlnaW5hbD0iIzAwMDAwMCIgY2xhc3M9IiI+PC9wYXRoPjwvZz48L3N2Zz4=',
    true
);

-- =====================================================
-- 2. INSERT TEXT GENERATION CONFIG TYPE
-- =====================================================

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'text-generation-config',
    'Text Generation',
    'Configuration for text generation operations including chat, completions, and agent prompts. Supports OpenAI, Anthropic, and Azure OpenAI.'
FROM connectors 
WHERE maven_artifact_id = 'mule4-mulesoft-inference-connector';

-- Additional config types aligned with inference.xml
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'vision-config',
    'Vision',
    'Configuration for vision operations that analyze images (OpenAI and Anthropic).'
FROM connectors 
WHERE maven_artifact_id = 'mule4-mulesoft-inference-connector';

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'image-generation-config',
    'Image Generation',
    'Configuration for image generation operations (OpenAI DALL-E).'
FROM connectors 
WHERE maven_artifact_id = 'mule4-mulesoft-inference-connector';

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'moderation-config',
    'Moderation',
    'Configuration for content moderation and toxicity detection (OpenAI).'
FROM connectors 
WHERE maven_artifact_id = 'mule4-mulesoft-inference-connector';

-- =====================================================
-- 3. INSERT PROVIDERS (OpenAI, Anthropic, Azure OpenAI)
-- =====================================================

-- Provider: OpenAI
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'openai-connection',
    'OpenAI',
    'OpenAI''s GPT models (gpt-4o, gpt-4o-mini, gpt-3.5-turbo). Market leader with ChatGPT.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

-- Provider: OpenAI Vision
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'openai-connection',
    'OpenAI',
    'OpenAI vision-capable models (gpt-4o, gpt-4o-mini) for image analysis.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config';

-- Provider: Anthropic Vision
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'anthropic-connection',
    'Anthropic',
    'Anthropic Claude with vision capabilities for multimodal analysis.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config';

-- Provider: OpenAI Image Generation
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'openai-connection',
    'OpenAI',
    'OpenAI DALL-E image generation.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'image-generation-config';

-- Provider: OpenAI Moderation
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'openai-connection',
    'OpenAI',
    'OpenAI content moderation and toxicity detection.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'moderation-config';

-- Provider: Anthropic
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'anthropic-connection',
    'Anthropic',
    'Anthropic''s Claude models (claude-3-opus, claude-3-sonnet, claude-3-haiku). Strong enterprise adoption.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

-- Provider: Azure OpenAI
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'azureopenai-connection',
    'Azure OpenAI',
    'Microsoft Azure OpenAI Service. Enterprise-grade OpenAI models with Azure integration, security, and compliance.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

-- =====================================================
-- 4. INSERT CONFIG PARAMETERS
-- =====================================================

-- OpenAI Parameters (Complete Essential Set from Documentation)
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('modelName', 'Model Name', 'String', false, 'gpt-4o-mini', 'OpenAI model identifier (gpt-4o, gpt-4o-mini, gpt-3.5-turbo)', 1),
        ('apiKey', 'API Key', 'String', true, NULL, 'OpenAI API key for authentication', 2),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers to include with each request (JSON array). For existing headers, custom values take precedence.', 3),
        ('maxTokens', 'Max Tokens', 'Number', false, '500', 'Defines the number of LLM tokens to use when generating a response. Controls usage and costs.', 4),
        ('temperature', 'Temperature', 'Number', false, '0.9', 'Number between 0 and 2. Controls randomness: higher = more random, lower (towards 0) = more deterministic.', 5),
        ('topP', 'Top P', 'Number', false, '0.9', 'Controls diversity via nucleus sampling. Specifies cumulative probability score threshold for token selection.', 6)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config'
  AND cp.provider_key = 'openai-connection';

-- Anthropic Parameters (Complete Essential Set from Documentation)
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('apiKey', 'API Key', 'String', true, NULL, 'Anthropic API key for authentication', 1),
        ('modelName', 'Model Name', 'String', true, NULL, 'Claude model identifier (claude-3-opus, claude-3-sonnet, claude-3-haiku). Required field.', 2),
        ('timeout', 'Timeout', 'Number', false, '60', 'Response timeout value set for each inference HTTP request', 3),
        ('timeoutUnit', 'Timeout Unit', 'String', false, 'SECONDS', 'Response timeout unit for the Timeout field. Options: NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS', 4),
        ('maxTokens', 'Max Tokens', 'Number', false, '500', 'Defines the number of LLM tokens to use when generating a response. Controls usage and costs.', 5),
        ('temperature', 'Temperature', 'Number', false, '0.9', 'Number between 0 and 2. Controls randomness: higher = more random, lower (towards 0) = more deterministic.', 6),
        ('topP', 'Top P', 'Number', false, '0.9', 'Controls diversity via nucleus sampling. Specifies cumulative probability score threshold for token selection.', 7),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers to include with each request (JSON array). For existing headers, custom values take precedence.', 8)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config'
  AND cp.provider_key = 'anthropic-connection';

-- Azure OpenAI Parameters (Complete Set for Azure OpenAI Service)
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('apiKey', 'API Key', 'String', true, NULL, 'Azure OpenAI API key for authentication', 1),
        ('modelName', 'Model Name', 'String', false, 'gpt-4o-mini', 'Azure OpenAI model name (gpt-4o, gpt-4o-mini, gpt-35-turbo)', 2),
        ('apiVersion', 'API Version', 'String', false, '2024-10-21', 'Azure OpenAI API version (e.g., 2024-10-21)', 3),
        ('endpoint', 'Endpoint', 'String', true, NULL, 'Azure OpenAI endpoint URL (e.g., https://lowcoders.openai.azure.com)', 4),
        ('resourceName', 'Resource Name', 'String', false, NULL, 'Azure OpenAI resource name', 5),
        ('deploymentId', 'Deployment ID', 'String', true, NULL, 'Azure OpenAI deployment ID/name', 6),
        ('user', 'User', 'String', false, NULL, 'Optional user identifier for Azure OpenAI requests', 7),
        ('maxTokens', 'Max Tokens', 'Number', false, '500', 'Maximum number of tokens to generate in the response', 8),
        ('temperature', 'Temperature', 'Number', false, '0.9', 'Controls randomness: 0-2, higher = more random, lower = more deterministic', 9),
        ('topP', 'Top P', 'Number', false, '0.9', 'Controls diversity via nucleus sampling', 10),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers (JSON array)', 11)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config'
  AND cp.provider_key = 'azureopenai-connection';

-- OpenAI Vision Parameters
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('modelName', 'Model Name', 'String', true, 'gpt-4o', 'Vision-capable model (e.g., gpt-4o, gpt-4o-mini)', 1),
        ('apiKey', 'API Key', 'String', true, NULL, 'OpenAI API key', 2),
        ('maxTokens', 'Max Tokens', 'Number', false, '500', 'Max tokens for response generation.', 3),
        ('temperature', 'Temperature', 'Number', false, '0.9', 'Controls randomness.', 4),
        ('topP', 'Top P', 'Number', false, '0.9', 'Nucleus sampling threshold.', 5),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers (JSON array).', 6)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config'
  AND cp.provider_key = 'openai-connection';

-- Anthropic Vision Parameters
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('modelName', 'Model Name', 'String', true, NULL, 'Anthropic Claude model for vision.', 1),
        ('apiKey', 'API Key', 'String', true, NULL, 'Anthropic API key', 2),
        ('maxTokens', 'Max Tokens', 'Number', false, '500', 'Max tokens for response generation.', 3),
        ('temperature', 'Temperature', 'Number', false, '0.9', 'Controls randomness.', 4),
        ('topP', 'Top P', 'Number', false, '0.9', 'Nucleus sampling threshold.', 5),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers (JSON array).', 6)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config'
  AND cp.provider_key = 'anthropic-connection';

-- OpenAI Image Generation Parameters
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('apiKey', 'API Key', 'String', true, NULL, 'OpenAI API key', 1),
        ('modelName', 'Model Name', 'String', true, 'dall-e-3', 'DALL-E model (dall-e-2 or dall-e-3)', 2),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers (JSON array).', 3)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'image-generation-config'
  AND cp.provider_key = 'openai-connection';

-- OpenAI Moderation Parameters
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
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('apiKey', 'API Key', 'String', true, NULL, 'OpenAI API key', 1),
        ('modelName', 'Model Name', 'String', false, 'omni-moderation-latest', 'Moderation model identifier', 2),
        ('customHeaders', 'Custom Headers', 'JSON', false, NULL, 'Custom HTTP headers (JSON array).', 3)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'moderation-config'
  AND cp.provider_key = 'openai-connection';

-- =====================================================
-- 5. INSERT OPERATIONS
-- =====================================================

-- Operation 1: [Agent] Define Prompt Template
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Agent] Define Prompt Template',
    'ms-inference:agent-define-prompt-template',
    'Defines a prompt template with instructions and data to drive agent behavior.',
    CAST('Agent' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-text-generation-operations#configure-the-agent-define-prompt-template-operation',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('template', 'Template', 'String', false, 'Prompt template for the operation.', 'You are a customer satisfaction agent, who analyses the customer feedback in the dataset. Answer via json output and add a type for the result only with positive or negative as well as the complete answer', 1, NULL),
        ('instructions', 'Instructions', 'String', true, 'Instructions for the LLM, outlining the goals of the task.', 'If the customer feedback in the dataset is negative, open a service satisfaction case and apologize to the customer. If the customer feedback in the dataset is positive, thank the customer and wish them a nice day. Don''t repeat the feedback and be more direct starting the conversation with formal greetings', 2, NULL),
        ('data', 'Data', 'String', true, 'Dataset for the LLM to evaluate using the provided template and instructions.', 'The training last week was amazing, we learned so much and the trainer was very friendly.', 3, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 4, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:agent-define-prompt-template';

-- Operation 2: [Chat] Answer Prompt
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Chat] Answer Prompt',
    'ms-inference:chat-answer-prompt',
    'Provides a simple chat answer for a single prompt. Uses plain text prompt as input and responds with plain text answer.',
    CAST('Chat' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-text-generation-operations#configure-the-chat-answer-prompt-operation',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

-- Parameters for Chat Answer Prompt
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', true, 'User''s prompt. Plain text question or instruction.', 'What are the key benefits of using MuleSoft for enterprise integration?', 1, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional additional request attributes in the request payload to generate more relevant and precise LLM outputs. Provider-specific attributes for fine-tuning the inference request.', NULL, 2, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:chat-answer-prompt';

-- Operation 3: [Chat] Completions
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Chat] Completions',
    'ms-inference:chat-completions',
    'Provides chat completions by a messages array, including system or user messages (conversation history).',
    CAST('Chat' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-text-generation-operations#configure-the-chat-completions-operation',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('messages', 'Messages', 'JSON', true, 'Conversation messages array with assistant and user messages.', '[{"role": "assistant", "content": "You are a helpful AI assistant specialized in enterprise integration and APIs."}, {"role": "user", "content": "Explain the benefits of API-led connectivity."}]', 1, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 2, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:chat-completions';

-- Operation 4: [Tools] Native Template (Reasoning only)

INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Tools] Native Template (Reasoning only)',
    'ms-inference:tools-native-template',
    'Defines a tools template with instructions and data for autonomous reasoning.',
    CAST('Tools' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-text-generation-operations#configure-the-tools-native-template-reasoning-only-operation',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('template', 'Template', 'String', true, 'Template defining agent behavior.', 'You are an enterprise integration specialist. Analyze incoming data structures and determine if they originate from Salesforce or SAP systems. Use the appropriate transformation function based on the data source.', 1, NULL),
        ('instructions', 'Instructions', 'String', true, 'Instructions for the LLM on how to use tools.', 'Examine the data structure carefully: Salesforce data contains fields like "Id", "attributes", "__c" suffixes for custom fields. SAP data contains fields like "MANDT", "BUKRS", "VBELN", uppercase field names. Call transform_salesforce_data for Salesforce records. Call transform_sap_data for SAP records.', 2, NULL),
        ('data', 'Data', 'String', false, 'Primary user input.', '{"MANDT": "100", "VBELN": "0000123456", "KUNNR": "0000100001", "NAME1": "Acme Corporation", "LAND1": "US", "ORT01": "San Francisco", "NETWR": "5000000.00", "WAERK": "USD", "VKORG": "1000", "VTWEG": "10", "SPART": "00"}

NOTE: This is SAP data. For Salesforce example, replace with: {"Id": "001xx000003DGbXXXX", "attributes": {"type": "Account"}, "Name": "Acme Corporation", "BillingCity": "San Francisco", "Industry": "Technology", "Custom_Field__c": "Enterprise"}', 3, NULL),
        ('tools', 'Tools', 'JSON', true, 'Tools configuration as a JSON array.', '[{"type":"function","function":{"name":"transform_salesforce_data","description":"Transform Salesforce record to canonical format. Use when data contains ''Id'', ''attributes'', ''__c'' custom field suffixes.","parameters":{"type":"object","properties":{"record":{"type":"object","description":"The Salesforce record"},"objectType":{"type":"string","description":"Salesforce object type","enum":["Account","Contact","Opportunity"]},"targetFormat":{"type":"string","enum":["canonical","json","xml"],"default":"canonical"}},"required":["record","objectType"]}}},{"type":"function","function":{"name":"transform_sap_data","description":"Transform SAP data to canonical format. Use when data contains ''MANDT'', ''BUKRS'', ''VBELN'' or uppercase field names.","parameters":{"type":"object","properties":{"record":{"type":"object","description":"The SAP record"},"tableType":{"type":"string","description":"SAP table type (KNA1, VBAK, etc.)"},"client":{"type":"string","default":"100"},"targetFormat":{"type":"string","enum":["canonical","json","xml"],"default":"canonical"}},"required":["record","tableType"]}}}]', 4, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 5, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:tools-native-template';

-- Operation 5: [MCP] Tooling

INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[MCP] Tooling',
    'ms-inference:mcp-tools-native-template',
    'Executes MCP tools using a defined template and optional attributes.',
    CAST('Tools' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-text-generation-operations#configure-the-mcp-tooling-operation',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('template', 'Template', 'String', true, 'Prompt template.', 'You are an intelligent assistant with access to MCP (Model Context Protocol) tools. Use these tools to help answer user questions and complete tasks efficiently.', 1, NULL),
        ('instructions', 'Instructions', 'String', true, 'Execution instructions.', 'Analyze the user''s request and determine which MCP tools are most appropriate. Execute the tools in the correct sequence to provide a comprehensive answer.', 2, NULL),
        ('data', 'Data', 'String', false, 'User input for tool execution.', 'List all available resources and explain what they contain.', 3, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 4, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:mcp-tools-native-template';

-- Operation 6: [Image] Read by (Url or Base64)

INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Image] Read by (Url or Base64)',
    'ms-inference:read-image',
    'Reads and interprets an image based on a prompt. Accepts image URL or Base64.',
    CAST('Vision' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-vision-operations',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', true, 'Question or instruction about the image.', 'Please list the pdf doc files in json format:\n\nLike: \n\n[\n  "MYFILE.pdf",\n  "myfileAlso.pdf"\n]', 1, NULL),
        ('image', 'Image', 'String', false, 'Image URL or Base64 string.', 'https://www.capturebites.com/wp-content/uploads/2018/06/MetaServer-Tutorial-PDF-Viewer-Thumbnail-Phenomenon-3.png', 2, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 3, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:read-image';

-- Operation 7: [Image] Generate (only Base64)

INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Image] Generate (only Base64)',
    'ms-inference:generate-image',
    'Generates images from text descriptions using AI-powered image generation models.',
    CAST('Image' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-image-generation-operations',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'image-generation-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', false, 'Text description of the image to generate.', 'A futuristic cityscape at sunset with flying cars, neon lights, and towering skyscrapers. Digital art style, vibrant colors, high detail.', 1, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 2, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:generate-image';

-- Operation 8: [Toxicity] Detection by Text

INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    '[Toxicity] Detection by Text',
    'ms-inference:toxicity-detection-text',
    'Classifies and scores harmful content in text.',
    CAST('Moderation' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mulesoft-inference-connector/latest/configuring-moderation-operations',
    8,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'moderation-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    CAST(param.validation_rules AS jsonb)
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('text', 'Text', 'String', false, 'Text content to analyze for toxicity.', 'This is a sample text to check for content moderation. The service analyzes whether the text contains harmful, hateful, violent, or inappropriate content.', 1, NULL),
        ('additionalRequestAttributes', 'Additional Request Attributes', 'JSON', false, 'Optional request attributes to fine-tune the inference request.', NULL, 2, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND o.operation_key = 'ms-inference:toxicity-detection-text';

-- =====================================================
-- 6. CREATE PLACEHOLDER RUNTIME CONFIGURATIONS
-- =====================================================

-- Default: OpenAI
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'OpenAI Connection (Default)',
    'Default OpenAI configuration for text generation. Uses gpt-4o-mini model.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config'
  AND cp.provider_key = 'openai-connection';

-- OpenAI Runtime Config Values
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p('openai.apiKey')]'
        WHEN 'modelName' THEN '#[p('openai.text.default.modelName')]'
        WHEN 'maxTokens' THEN '500'
        WHEN 'temperature' THEN '0.9'
        WHEN 'topP' THEN '0.9'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'OpenAI Connection (Default)'
  AND cp.provider_key = 'openai-connection';

-- Default: Anthropic
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Anthropic Connection (Default)',
    'Default Anthropic configuration for text generation. Replace with your Anthropic API key to activate.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config'
  AND cp.provider_key = 'anthropic-connection';

-- Anthropic Runtime Config Values
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p('anthropic.apiKey')]'
        WHEN 'modelName' THEN '#[p('anthropic.text.default.modelName')]'
        WHEN 'timeout' THEN '60'
        WHEN 'timeoutUnit' THEN 'SECONDS'
        WHEN 'maxTokens' THEN '500'
        WHEN 'temperature' THEN '0.9'
        WHEN 'topP' THEN '0.9'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'Anthropic Connection (Default)'
  AND cp.provider_key = 'anthropic-connection';

-- Default: Azure OpenAI
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Azure OpenAI Connection (Default)',
    'Default Azure OpenAI configuration for text generation. Enterprise-grade OpenAI with Azure integration.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'text-generation-config'
  AND cp.provider_key = 'azureopenai-connection';

-- Azure OpenAI Runtime Config Values
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p("azure.openai.default.apiKey")]'
        WHEN 'modelName' THEN '#[p("azure.openai.text.default.modelName")]'
        WHEN 'apiVersion' THEN '#[p("azure.openai.text.default.apiVersion")]'
        WHEN 'endpoint' THEN '#[p("azure.openai.text.default.endpoint")]'
        WHEN 'resourceName' THEN '#[p("azure.openai.text.default.resourceName")]'
        WHEN 'deploymentId' THEN '#[p("azure.openai.text.default.deploymentId")]'
        WHEN 'user' THEN '#[p("azure.openai.default.user")]'
        WHEN 'maxTokens' THEN '500'
        WHEN 'temperature' THEN '0.9'
        WHEN 'topP' THEN '0.9'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'Azure OpenAI Connection (Default)'
  AND cp.provider_key = 'azureopenai-connection';

-- Default: OpenAI Vision
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'OpenAI Vision Connection (Default)',
    'Default OpenAI Vision configuration. Uses gpt-4o-mini vision model for image analysis.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config'
  AND cp.provider_key = 'openai-connection';

INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p('openai.apiKey')]'
        WHEN 'modelName' THEN '#[p('openai.vision.default.modelName')]'
        WHEN 'maxTokens' THEN '500'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'OpenAI Vision Connection (Default)'
  AND cp.provider_key = 'openai-connection';

-- Default: Anthropic Vision
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Anthropic Vision Connection (Default)',
    'Default Anthropic Vision configuration. Uses Claude 3.5 Sonnet for image analysis.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'vision-config'
  AND cp.provider_key = 'anthropic-connection';

INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p('anthropic.apiKey')]'
        WHEN 'modelName' THEN '#[p('anthropic.vision.default.modelName')]'
        WHEN 'maxTokens' THEN '500'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'Anthropic Vision Connection (Default)'
  AND cp.provider_key = 'anthropic-connection';

-- Default: OpenAI Image Generation
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'OpenAI Image Generation Connection (Default)',
    'Default OpenAI DALL-E configuration for image generation. Uses dall-e-3 model.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'image-generation-config'
  AND cp.provider_key = 'openai-connection';

INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p('openai.apiKey')]'
        WHEN 'modelName' THEN '#[p('openai.image.default.modelName')]'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'OpenAI Image Generation Connection (Default)'
  AND cp.provider_key = 'openai-connection';

-- Default: OpenAI Moderation
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'OpenAI Moderation Connection (Default)',
    'Default OpenAI Moderation configuration for toxicity detection. Uses omni-moderation-latest model (supports text and image inputs).',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
  AND ct.config_type_key = 'moderation-config'
  AND cp.provider_key = 'openai-connection';

INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cfp.id,
    CASE cfp.api_name
        WHEN 'apiKey' THEN '#[p('openai.apiKey')]'
        WHEN 'modelName' THEN 'omni-moderation-latest'
        WHEN 'customHeaders' THEN NULL
    END,
    CASE cfp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cfp ON cfp.provider_id = cp.id
WHERE rc.name = 'OpenAI Moderation Connection (Default)'
  AND cp.provider_key = 'openai-connection';

-- =====================================================
-- SUMMARY - What Was Created
-- =====================================================

SELECT '✅ MuleSoft Inference SIMPLIFIED seed data inserted!' AS status;

SELECT 
    c.name as connector,
    COUNT(DISTINCT ct.id) as config_types,
    COUNT(DISTINCT cp.id) as providers,
    COUNT(DISTINCT cfp.id) as config_params,
    COUNT(DISTINCT o.id) as operations,
    COUNT(DISTINCT op.id) as operation_params,
    COUNT(DISTINCT rc.id) as runtime_configs
FROM connectors c
LEFT JOIN connector_config_types ct ON ct.connector_id = c.id
LEFT JOIN config_providers cp ON cp.config_type_id = ct.id
LEFT JOIN config_parameters cfp ON cfp.provider_id = cp.id
LEFT JOIN operations o ON o.connector_id = c.id
LEFT JOIN operation_parameters op ON op.operation_id = o.id
LEFT JOIN runtime_configurations rc ON rc.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'
GROUP BY c.name;

-- Show what was created
SELECT 
    'Config Type' as type,
    ct.display_name as name,
    ct.description as details
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'

UNION ALL

SELECT 
    'Provider' as type,
    cp.display_name as name,
    cp.description as details
FROM config_providers cp
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector'

UNION ALL

SELECT 
    'Operation' as type,
    o.display_name as name,
    o.description as details
FROM operations o
JOIN connectors c ON o.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mulesoft-inference-connector';

