-- =====================================================
-- AMAZON BEDROCK CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the Amazon Bedrock Connector 0.6.0 (MAC Project)
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - Configuration type and AWS provider
-- - 10 Operations across 6 categories (Agent, Chat, Embedding, Image Generation, Platform, Sentiment Analysis)
-- - Placeholder runtime configuration
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-amazon-bedrock-connector',
    'Amazon Bedrock',
    '0.6.0',
    'AI',
    '**Amazon Bedrock** is AWS''s fully managed service for foundation models from leading AI companies. Build and scale generative AI applications with secure, enterprise-grade access to multiple LLMs through a single API.

**Key capabilities:**
- **Multi-model access** - Anthropic Claude, Amazon Titan, Cohere, Meta Llama, Stability AI, AI21 Labs
- **Chat completions** - Conversational AI with streaming support
- **Embeddings** - Generate vector embeddings for semantic search and RAG
- **Image generation** - Create images using Stable Diffusion and Amazon Titan Image
- **Agent framework** - Pre-built agents with tool integration and function calling
- **Enterprise features** - AWS security, compliance (HIPAA, SOC, GDPR), VPC support, CloudWatch monitoring

**Use cases:** Enterprise chatbots, RAG applications, content generation, code generation, document analysis, image creation, sentiment analysis.',
    'https://mac-project.ai/docs/amazon-bedrock/connector-overview',
    'data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHN2ZyB3aWR0aD0iODBweCIgaGVpZ2h0PSI4MHB4IiB2aWV3Qm94PSIwIDAgODAgODAiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayI+CiAgICA8dGl0bGU+SWNvbi1BcmNoaXRlY3R1cmUvNjQvQXJjaF9BbWF6b24tQmVkcm9ja182NDwvdGl0bGU+CiAgICA8ZyBpZD0iSWNvbi1BcmNoaXRlY3R1cmUvNjQvQXJjaF9BbWF6b24tQmVkcm9ja182NCIgc3Ryb2tlPSJub25lIiBzdHJva2Utd2lkdGg9IjEiIGZpbGw9Im5vbmUiIGZpbGwtcnVsZT0iZXZlbm9kZCI+CiAgICAgICAgPGcgaWQ9Ikljb24tQXJjaGl0ZWN0dXJlLUJHLzY0L01hY2hpbmUtTGVhcm5pbmciIGZpbGw9IiMwMUE4OEQiPgogICAgICAgICAgICA8cmVjdCBpZD0iUmVjdGFuZ2xlIiB4PSIwIiB5PSIwIiB3aWR0aD0iODAiIGhlaWdodD0iODAiPjwvcmVjdD4KICAgICAgICA8L2c+CiAgICAgICAgPGcgaWQ9Ikljb24tU2VydmljZS82NC9BbWF6b24tQmVkcm9ja182NCIgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMTIuMDAwMDAwLCAxMi4wMDAwMDApIiBmaWxsPSIjRkZGRkZGIj4KICAgICAgICAgICAgPHBhdGggZD0iTTUyLDI2Ljk5OTg5MTggQzUwLjg5NywyNi45OTk4OTE4IDUwLDI2LjEwMjg5MTggNTAsMjQuOTk5ODkxOCBDNTAsMjMuODk2ODkxOCA1MC44OTcsMjIuOTk5ODkxOCA1MiwyMi45OTk4OTE4IEM1My4xMDMsMjIuOTk5ODkxOCA1NCwyMy44OTY4OTE4IDU0LDI0Ljk5OTg5MTggQzU0LDI2LjEwMjg5MTggNTMuMTAzLDI2Ljk5OTg5MTggNTIsMjYuOTk5ODkxOCBMNTIsMjYuOTk5ODkxOCBaIE0yMC4xMTMsNTMuOTA3ODkxOCBMMTYuODY1LDUyLjAxMzg5MTggTDIzLjUzLDQ3Ljg0Nzg5MTggTDIyLjQ3LDQ2LjE1MTg5MTggTDE0LjkxMyw1MC44NzQ4OTE4IEw5LDQ3LjQyNTg5MTggTDksMzguNTM0ODkxOCBMMTQuNTU1LDM0LjgzMTg5MTggTDEzLjQ0NSwzMy4xNjc4OTE4IEw3Ljk1OSwzNi44MjQ4OTE4IEwyLDMzLjQxOTg5MTggTDIsMjguNTc5ODkxOCBMOC40OTYsMjQuODY3ODkxOCBMNy41MDQsMjMuMTMxODkxOCBMMiwyNi4yNzY4OTE4IEwyLDIyLjU3OTg5MTggTDgsMTkuMTUxODkxOCBMMTQsMjIuNTc5ODkxOCBMMTQsMjYuNDMzODkxOCBMOS40ODUsMjkuMTQyODkxOCBMMTAuNTE1LDMwLjg1Njg5MTggTDE1LDI4LjE2NTg5MTggTDE5LjQ4NSwzMC44NTY4OTE4IEwyMC41MTUsMjkuMTQyODkxOCBMMTYsMjYuNDMzODkxOCBMMTYsMjIuNTM0ODkxOCBMMjEuNTU1LDE4LjgzMTg5MTggQzIxLjgzMywxOC42NDU4OTE4IDIyLDE4LjMzMzg5MTggMjIsMTcuOTk5ODkxOCBMMjIsMTAuOTk5ODkxOCBMMjAsMTAuOTk5ODkxOCBMMjAsMTcuNDY0ODkxOCBMMTQuOTU5LDIwLjgyNDg5MTggTDksMTcuNDE5ODkxOCBMOSw4LjU3Mzg5MTgxIEwxNCw1LjY1Nzg5MTgxIEwxNCwxMy45OTk4OTE4IEwxNiwxMy45OTk4OTE4IEwxNiw0LjQ5MDg5MTgxIEwyMC4xMTMsMi4wOTE4OTE4MSBMMjgsNC43MjA4OTE4MSBMMjgsMzMuNDMzODkxOCBMMTMuNDg1LDQyLjE0Mjg5MTggTDE0LjUxNSw0My44NTY4OTE4IEwyOCwzNS43NjU4OTE4IEwyOCw1MS4yNzg4OTE4IEwyMC4xMTMsNTMuOTA3ODkxOCBaIE01MCwzNy45OTk4OTE4IEM1MCwzOS4xMDI4OTE4IDQ5LjEwMywzOS45OTk4OTE4IDQ4LDM5Ljk5OTg5MTggQzQ2Ljg5NywzOS45OTk4OTE4IDQ2LDM5LjEwMjg5MTggNDYsMzcuOTk5ODkxOCBDNDYsMzYuODk2ODkxOCA0Ni44OTcsMzUuOTk5ODkxOCA0OCwzNS45OTk4OTE4IEM0OS4xMDMsMzUuOTk5ODkxOCA1MCwzNi44OTY4OTE4IDUwLDM3Ljk5OTg5MTggTDUwLDM3Ljk5OTg5MTggWiBNNDAsNDcuOTk5ODkxOCBDNDAsNDkuMTAyODkxOCAzOS4xMDMsNDkuOTk5ODkxOCAzOCw0OS45OTk4OTE4IEMzNi44OTcsNDkuOTk5ODkxOCAzNiw0OS4xMDI4OTE4IDM2LDQ3Ljk5OTg5MTggQzM2LDQ2Ljg5Njg5MTggMzYuODk3LDQ1Ljk5OTg5MTggMzgsNDUuOTk5ODkxOCBDMzkuMTAzLDQ1Ljk5OTg5MTggNDAsNDYuODk2ODkxOCA0MCw0Ny45OTk4OTE4IEw0MCw0Ny45OTk4OTE4IFogTTM5LDcuOTk5ODkxODEgQzM5LDYuODk2ODkxODEgMzkuODk3LDUuOTk5ODkxODEgNDEsNS45OTk4OTE4MSBDNDIuMTAzLDUuOTk5ODkxODEgNDMsNi44OTY4OTE4MSA0Myw3Ljk5OTg5MTgxIEM0Myw5LjEwMjg5MTgxIDQyLjEwMyw5Ljk5OTg5MTgxIDQxLDkuOTk5ODkxODEgQzM5Ljg5Nyw5Ljk5OTg5MTgxIDM5LDkuMTAyODkxODEgMzksNy45OTk4OTE4MSBMMzksNy45OTk4OTE4MSBaIE01MiwyMC45OTk4OTE4IEM1MC4xNDEsMjAuOTk5ODkxOCA0OC41ODksMjIuMjc5ODkxOCA0OC4xNDIsMjMuOTk5ODkxOCBMMzAsMjMuOTk5ODkxOCBMMzAsMTguOTk5ODkxOCBMNDEsMTguOTk5ODkxOCBDNDEuNTUzLDE4Ljk5OTg5MTggNDIsMTguNTUxODkxOCA0MiwxNy45OTk4OTE4IEw0MiwxMS44NTc4OTE4IEM0My43MiwxMS40MTA4OTE4IDQ1LDkuODU3ODkxODEgNDUsNy45OTk4OTE4MSBDNDUsNS43OTM4OTE4MSA0My4yMDYsMy45OTk4OTE4MSA0MSwzLjk5OTg5MTgxIEMzOC43OTQsMy45OTk4OTE4MSAzNyw1Ljc5Mzg5MTgxIDM3LDcuOTk5ODkxODEgQzM3LDkuODU3ODkxODEgMzguMjgsMTEuNDEwODkxOCA0MCwxMS44NTc4OTE4IEw0MCwxNi45OTk4OTE4IEwzMCwxNi45OTk4OTE4IEwzMCwzLjk5OTg5MTgxIEMzMCwzLjU2ODg5MTgxIDI5LjcyNSwzLjE4Nzg5MTgxIDI5LjMxNiwzLjA1MDg5MTgxIEwyMC4zMTYsMC4wNTA4OTE4MTEgQzIwLjA0MiwtMC4wMzkxMDgxODkgMTkuNzQ0LC0wLjAwOTEwODE4OTA0IDE5LjQ5NiwwLjEzNTg5MTgxMSBMNy40OTYsNy4xMzU4OTE4MSBDNy4xODgsNy4zMTQ4OTE4MSA3LDcuNjQ0ODkxODEgNyw3Ljk5OTg5MTgxIEw3LDE3LjQxOTg5MTggTDAuNTA0LDIxLjEzMTg5MTggQzAuMTkyLDIxLjMwOTg5MTggMCwyMS42NDA4OTE4IDAsMjEuOTk5ODkxOCBMMCwzMy45OTk4OTE4IEMwLDM0LjM1ODg5MTggMC4xOTIsMzQuNjg5ODkxOCAwLjUwNCwzNC44Njc4OTE4IEw3LDM4LjU3OTg5MTggTDcsNDcuOTk5ODkxOCBDNyw0OC4zNTQ4OTE4IDcuMTg4LDQ4LjY4NDg5MTggNy40OTYsNDguODYzODkxOCBMMTkuNDk2LDU1Ljg2Mzg5MTggQzE5LjY1LDU1Ljk1Mzg5MTggMTkuODI1LDU1Ljk5OTg5MTggMjAsNTUuOTk5ODkxOCBDMjAuMTA2LDU1Ljk5OTg5MTggMjAuMjEzLDU1Ljk4Mjg5MTggMjAuMzE2LDU1Ljk0ODg5MTggTDI5LjMxNiw1Mi45NDg4OTE4IEMyOS43MjUsNTIuODExODkxOCAzMCw1Mi40MzA4OTE4IDMwLDUxLjk5OTg5MTggTDMwLDM5Ljk5OTg5MTggTDM3LDM5Ljk5OTg5MTggTDM3LDQ0LjE0MTg5MTggQzM1LjI4LDQ0LjU4ODg5MTggMzQsNDYuMTQxODkxOCAzNCw0Ny45OTk4OTE4IEMzNCw1MC4yMDU4OTE4IDM1Ljc5NCw1MS45OTk4OTE4IDM4LDUxLjk5OTg5MTggQzQwLjIwNiw1MS45OTk4OTE4IDQyLDUwLjIwNTg5MTggNDIsNDcuOTk5ODkxOCBDNDIsNDYuMTQxODkxOCA0MC43Miw0NC41ODg4OTE4IDM5LDQ0LjE0MTg5MTggTDM5LDM4Ljk5OTg5MTggQzM5LDM4LjQ0Nzg5MTggMzguNTUzLDM3Ljk5OTg5MTggMzgsMzcuOTk5ODkxOCBMMzAsMzcuOTk5ODkxOCBMMzAsMzIuOTk5ODkxOCBMNDIuNSwzMi45OTk4OTE4IEw0NC42MzgsMzUuODQ5ODkxOCBDNDQuMjM5LDM2LjQ3MTg5MTggNDQsMzcuMjA2ODkxOCA0NCwzNy45OTk4OTE4IEM0NCw0MC4yMDU4OTE4IDQ1Ljc5NCw0MS45OTk4OTE4IDQ4LDQxLjk5OTg5MTggQzUwLjIwNiw0MS45OTk4OTE4IDUyLDQwLjIwNTg5MTggNTIsMzcuOTk5ODkxOCBDNTIsMzUuNzkzODkxOCA1MC4yMDYsMzMuOTk5ODkxOCA0OCwzMy45OTk4OTE4IEM0Ny4zMTYsMzMuOTk5ODkxOCA0Ni42ODIsMzQuMTg3ODkxOCA0Ni4xMTksMzQuNDkxODkxOCBMNDMuOCwzMS4zOTk4OTE4IEM0My42MTEsMzEuMTQ3ODkxOCA0My4zMTQsMzAuOTk5ODkxOCA0MywzMC45OTk4OTE4IEwzMCwzMC45OTk4OTE4IEwzMCwyNS45OTk4OTE4IEw0OC4xNDIsMjUuOTk5ODkxOCBDNDguNTg5LDI3LjcxOTg5MTggNTAuMTQxLDI4Ljk5OTg5MTggNTIsMjguOTk5ODkxOCBDNTQuMjA2LDI4Ljk5OTg5MTggNTYsMjcuMjA1ODkxOCA1NiwyNC45OTk4OTE4IEM1NiwyMi43OTM4OTE4IDU0LjIwNiwyMC45OTk4OTE4IDUyLDIwLjk5OTg5MTggTDUyLDIwLjk5OTg5MTggWiIgaWQ9IkZpbGwtMSI+PC9wYXRoPgogICAgICAgIDwvZz4KICAgIDwvZz4KPC9zdmc+',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPE
-- =====================================================

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'mac-bedrock:config',
    'Amazon Bedrock Configuration',
    'AWS configuration for Amazon Bedrock service. Supports all foundation models available in AWS Bedrock.'
FROM connectors 
WHERE maven_artifact_id = 'mule4-amazon-bedrock-connector';

-- =====================================================
-- 3. INSERT PROVIDER
-- =====================================================

INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'aws-connection',
    'AWS',
    'AWS credentials and configuration for Amazon Bedrock service. Requires AWS Access Key, Secret Key, and region.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- =====================================================
-- 4. INSERT CONFIG PARAMETERS
-- =====================================================

INSERT INTO config_parameters (provider_id, api_name, display_name, data_type, is_required, default_value, description, parameter_order)
SELECT 
    cp.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.default_value,
    param.description,
    param.parameter_order
FROM config_providers cp
JOIN connector_config_types ct ON cp.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
CROSS JOIN (
    VALUES
        ('accessKeyId', 'Aws access key id', 'String', true, NULL, 'AWS Access Key ID for authentication (AWS_ACCESS_KEY_ID). Create in AWS IAM console with Bedrock permissions.', 1),
        ('secretAccessKey', 'Aws secret access key', 'String', true, NULL, 'AWS Secret Access Key corresponding to the Access Key ID (AWS_SECRET_ACCESS_KEY). Keep this secure.', 2),
        ('sessionToken', 'Aws session token', 'String', false, NULL, 'Optional AWS session token for temporary credentials (AWS_SESSION_TOKEN). Used when authenticating with AWS STS.', 3),
        ('fipsMode', 'Fips mode enabled', 'Boolean', false, 'false', 'Enable FIPS 140-2 compliant endpoints for government/regulated workloads.', 4),
        ('endpoint', 'Endpoint override', 'String', false, NULL, 'Optional custom endpoint URL to override default AWS Bedrock endpoint (for VPC endpoints or testing).', 5)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND cp.provider_key = 'aws-connection';

-- =====================================================
-- 5. INSERT OPERATIONS
-- =====================================================

-- Operation 1: [Agent] Define Prompt Template
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent define prompt template',
    'mac-bedrock:agent-define-prompt-template',
    '**Defines a prompt template** with instructions and data to drive agent behavior. This operation allows you to compose AI functions using plain text templates.

**What this does:**
1. **Template** - Defines the agent''s persona and output format
2. **Instructions** - Provides specific guidance on how to process the data
3. **Dataset** - The actual data to analyze using the template

**How it works:**
The operation combines your template, instructions, and dataset into a structured prompt sent to Amazon Bedrock. The model processes it according to your specifications and returns formatted results.

**Example use case:** Create a customer satisfaction agent that analyzes feedback and categorizes it as positive/negative with appropriate responses.

**Supported models:** All Bedrock text models (Claude, Titan Text, Cohere, Llama)',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent Define Prompt Template
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('template', 'Template', 'String', false, 'Prompt template defining the agent''s role and output format.', 'You are a customer satisfaction agent who analyzes customer feedback. Answer in JSON format with a "type" field (positive or negative) and a "response" field with the complete answer.', 1, NULL),
        ('instructions', 'Instructions', 'String', true, 'Specific instructions for the LLM outlining the goals of the task.', 'If the customer feedback is negative, acknowledge the issue and apologize professionally. If positive, thank the customer warmly. Be concise and professional.', 2, NULL),
        ('dataset', 'Dataset', 'String', true, 'The data for the LLM to evaluate using the template and instructions.', 'The training last week was amazing! We learned so much and the trainer was very friendly and knowledgeable.', 3, NULL),
        ('modelName', 'Model Name', 'String', false, 'Amazon Bedrock model identifier (overrides config default).', NULL, 4, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the model.', 'us-east-1', 5, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('temperature', 'Temperature', 'Number', false, 'Controls randomness (0-1). Overrides config default if specified.', '0.7', 6, NULL),
        ('topP', 'Top P', 'Number', false, 'Nucleus sampling threshold (0-1). Overrides config default.', '0.9', 7, NULL),
        ('topK', 'Top K', 'Number', false, 'Number of most-likely candidates. Overrides config default.', '250', 8, NULL),
        ('maxTokenCount', 'Max Token Count', 'Number', false, 'Maximum tokens to generate. Overrides config default.', '512', 9, NULL),
        ('guardrailIdentifier', 'Guardrail Identifier', 'String', false, 'ID of the guardrail to apply to the model invocation.', NULL, 10, NULL),
        ('guardrailVersion', 'Guardrail Version', 'String', false, 'Version of the guardrail to use.', NULL, 11, NULL),
        ('awsAccountId', 'AWS Account ID', 'String', false, 'AWS account ID for cross-account guardrail access.', NULL, 12, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-define-prompt-template';

-- Operation 2: [Agent] Chat
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent chat',
    'mac-bedrock:agent-chat',
    '**Interacts with pre-configured Amazon Bedrock Agents**. These are agents you''ve built in the AWS Bedrock console with defined purposes, knowledge bases, and action groups.

**What this does:**
1. Connects to an existing Bedrock Agent using its ID and alias
2. Sends prompts and receives intelligent responses
3. The agent can access knowledge bases, execute actions, and use tools you''ve configured

**Prerequisites:**
- Agent must be created in AWS Bedrock console
- Agent ID and Agent Alias ID required
- Proper IAM permissions to invoke the agent

**Key capabilities:**
- **Knowledge base access** - Agent can query vector databases
- **Action groups** - Execute API calls and Lambda functions
- **Tool use** - Multi-step reasoning and function calling
- **Memory** - Maintains conversation context

**Example:** Chat with a product support agent that can query inventory databases and create support tickets.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent Chat
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent (from AWS console).', 'WFK8E3DFKD', 1, NULL),
        ('agentAliasId', 'Agent Alias ID', 'String', true, 'The alias ID of the agent (e.g., TSTALIASID for test, PROD for production).', 'TSTALIASID', 2, NULL),
        ('prompt', 'Prompt', 'String', true, 'The user''s question or instruction to send to the agent.', 'What is the current status of order #12345?', 3, NULL),
        ('enableTrace', 'Enable Trace', 'Boolean', false, 'Enable detailed tracing for debugging agent responses and actions.', 'true', 4, NULL),
        ('latencyOptimized', 'Latency Optimized', 'Boolean', false, 'Optimize for lower latency responses (may trade off some accuracy).', 'true', 5, NULL),
        ('sessionId', 'Session ID', 'String', false, 'Optional session ID to continue a previous conversation.', NULL, 6, NULL),
        ('excludePreviousThinkingSteps', 'Exclude Previous Thinking Steps', 'Boolean', false, 'Exclude the agent''s internal reasoning steps from previous turns in the response.', 'true', 7, NULL),
        ('previousConversationTurnsToInclude', 'Previous Conversation Turns To Include', 'String', false, 'Number of previous conversation turns to include for context.', NULL, 8, NULL),
        ('knowledgeBaseId', 'Knowledge Base ID', 'String', false, 'ID of the knowledge base to query for additional context.', NULL, 9, NULL),
        ('numberOfResults', 'Number Of Results', 'String', false, 'Number of results to retrieve from knowledge base.', NULL, 10, NULL),
        ('overrideSearchType', 'Override Search Type', 'String', false, 'Knowledge base search type to use.', 'HYBRID', 11, '{"enum":["HYBRID","SEMANTIC"]}'),
        ('retrievalMetadataFilterType', 'Retrieval Metadata Filter Type', 'String', false, 'How to combine metadata filters when querying knowledge base.', 'OR_ALL', 12, '{"enum":["OR_ALL","AND_ALL"]}'),
        ('metadataFilters', 'Metadata Filters', 'String', false, 'JSON metadata filters for knowledge base retrieval.', NULL, 13, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use for the agent.', NULL, 14, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the agent.', 'us-east-1', 15, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-chat';

-- Operation 3: [Chat] Answer Prompt  
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Chat answer prompt',
    'mac-bedrock:chat-answer-prompt',
    '**Sends a single prompt to Amazon Bedrock** and receives a text completion. This is the simplest operation for getting responses from foundation models.

**What this does:**
- Accepts a plain text prompt
- Sends it to the configured Bedrock model
- Returns a plain text response

**How it works:**
The operation wraps your prompt in the appropriate format for the selected model, handles authentication with AWS, and returns the model''s response.

**Best for:**
- Single-turn conversations
- One-off questions or completions
- Simple text generation tasks
- Content creation, summarization, classification

**Supported models:**
- Anthropic Claude (claude-instant-v1, claude-v2, claude-v3-sonnet)
- Amazon Titan (amazon.titan-text-express-v1, amazon.titan-text-lite-v1)
- Cohere Command (cohere.command-text-v14, cohere.command-light-text-v14)
- Meta Llama (meta.llama2-13b-chat-v1, meta.llama2-70b-chat-v1)
- AI21 Jurassic (ai21.j2-mid-v1, ai21.j2-ultra-v1)',
    'Chat'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/chat',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Chat Answer Prompt
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', true, 'The user''s prompt - question, instruction, or text to complete.', 'Explain the key benefits of using Amazon Bedrock for enterprise AI applications.', 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Model identifier. Overrides config default if specified.', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the model.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('temperature', 'Temperature', 'Number', false, 'Controls randomness (0-1). Lower = more deterministic.', '0.7', 4, NULL),
        ('topP', 'Top P', 'Number', false, 'Nucleus sampling threshold (0-1).', '0.9', 5, NULL),
        ('topK', 'Top K', 'Number', false, 'Number of most-likely candidates.', '250', 6, NULL),
        ('maxTokenCount', 'Max Token Count', 'Number', false, 'Maximum tokens to generate in response.', '512', 7, NULL),
        ('guardrailIdentifier', 'Guardrail Identifier', 'String', false, 'ID of the guardrail to apply to the model invocation.', NULL, 8, NULL),
        ('guardrailVersion', 'Guardrail Version', 'String', false, 'Version of the guardrail to use.', NULL, 9, NULL),
        ('awsAccountId', 'AWS Account ID', 'String', false, 'AWS account ID for cross-account guardrail access.', NULL, 10, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:chat-answer-prompt';

-- Operation 4: [Embedding] Generate from Text
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Embedding generate from text',
    'mac-bedrock:embedding-generate-from-text',
    '**Generates vector embeddings from text** for semantic search, similarity matching, and RAG (Retrieval Augmented Generation) applications.

**What this does:**
- Converts text into high-dimensional vector representations
- Captures semantic meaning (not just keywords)
- Enables similarity comparisons between texts

**How embeddings work:**
Text is transformed into a numerical vector (array of floats) where semantically similar texts have vectors close together in vector space. This enables:
- **Semantic search** - Find documents by meaning, not just keywords
- **Similarity matching** - Compare documents for relevance
- **RAG** - Retrieve relevant context for LLM prompts
- **Clustering** - Group similar content
- **Recommendation** - Find related items

**Supported models:**
- Amazon Titan Embeddings (amazon.titan-embed-text-v1) - 1536 dimensions
- Cohere Embed (cohere.embed-english-v3, cohere.embed-multilingual-v3) - 1024 dimensions

**Output:** Array of floating-point numbers (the embedding vector)

**Storage:** Store in vector databases (Pinecone, Weaviate, OpenSearch, pgvector) for similarity search.',
    'Embedding'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/embedding',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Embedding Generate from Text
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', true, 'The text to convert into an embedding vector.', 'Amazon Bedrock is a fully managed service that offers a choice of high-performing foundation models from leading AI companies.', 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Embedding model identifier (e.g., amazon.titan-embed-text-v1).', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the embedding model.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('dimension', 'Dimension', 'Number', false, 'Output dimension size for embeddings (model-dependent).', '1024', 4, NULL),
        ('normalize', 'Normalize', 'Boolean', false, 'Whether to normalize the embedding vectors to unit length.', 'true', 5, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:embedding-generate-from-text';

-- Operation 5: [Image] Generate
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Image generate',
    'mac-bedrock:image-generate',
    '**Generates images from text descriptions** using AI-powered image generation models available on Amazon Bedrock.

**What this does:**
- Converts text prompts into high-quality images
- Supports various styles, subjects, and compositions
- Returns Base64-encoded image data

**Supported models:**
- **Stability AI Stable Diffusion** (stability.stable-diffusion-xl-v1)
  - Photorealistic and artistic images
  - 1024x1024 resolution
  - Multiple style presets
- **Amazon Titan Image Generator** (amazon.titan-image-generator-v1)
  - Enterprise-grade image generation
  - Content filtering and safety features
  - 512x512 to 1024x1024 resolution

**Prompt engineering tips:**
- Be specific about subject, style, lighting, composition
- Include artistic styles: "digital art", "photorealistic", "watercolor"
- Specify quality: "high detail", "4K", "professional photography"
- Mention lighting: "golden hour", "studio lighting", "dramatic shadows"
- Add modifiers: "trending on artstation", "unreal engine"

**Example prompts:**
- "A futuristic cityscape at sunset with flying cars, cyberpunk style, neon lights, high detail"
- "Professional product photography of a smartwatch on a marble surface, studio lighting, 4K"
- "Mountain landscape with snow peaks, dramatic clouds, golden hour lighting, photorealistic"

**Output:** Base64-encoded PNG or JPEG image data',
    'Image'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/image-generation',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Image Generate
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('TextToImage', 'Text To Image', 'String', true, 'Text description of the image to generate. Be specific about subject, style, and quality.', 'A serene Japanese garden with cherry blossoms, koi pond, and traditional architecture. Photorealistic style, soft natural lighting, high detail, 4K quality.', 1, NULL),
        ('AvoidInImage', 'Avoid In Image', 'String', false, 'Negative prompt describing what to exclude from the generated image.', NULL, 2, NULL),
        ('fullPathOutput', 'Full Path Output', 'String', false, '⚠️ MANAGED BY MCPG: File path where the generated image will be saved. This field is automatically set by the system and cannot be modified.', NULL, 3, '{"readonly":true}'),
        ('modelName', 'Model Name', 'String', false, 'Image generation model identifier (e.g., stability.stable-diffusion-xl-v1).', NULL, 4, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for image generation.', 'us-east-1', 5, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('numOfImages', 'Number Of Images', 'Number', false, 'Number of images to generate (typically 1-4).', '1', 6, NULL),
        ('height', 'Height', 'Number', false, 'Image height in pixels (model-dependent constraints apply).', '512', 7, NULL),
        ('width', 'Width', 'Number', false, 'Image width in pixels (model-dependent constraints apply).', '512', 8, NULL),
        ('cfgScale', 'Cfg Scale', 'Number', false, 'Classifier-free guidance scale controlling adherence to prompt (1-20).', '8.0', 9, NULL),
        ('seed', 'Seed', 'Number', false, 'Random seed for reproducible image generation.', '0', 10, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:image-generate';

-- Operation 6: Foundational model details
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Foundational model details',
    'mac-bedrock:foundational-model-details',
    '**Retrieves detailed information about a specific Amazon Bedrock model**. Use this to discover model capabilities, pricing, and requirements.

**What this does:**
- Queries AWS Bedrock for model metadata
- Returns model specifications and capabilities
- Shows availability in your configured region

**Information returned:**
- **Model ID** - Unique identifier
- **Model name** - Human-readable name
- **Provider** - AI company (Anthropic, Amazon, Cohere, etc.)
- **Input modalities** - TEXT, IMAGE, EMBEDDING
- **Output modalities** - TEXT, IMAGE, EMBEDDING
- **Supported inference parameters** - temperature, topP, topK, maxTokens
- **Max input tokens** - Context window size
- **Max output tokens** - Generation limits
- **Pricing information** - Per-token costs
- **Lifecycle status** - ACTIVE, LEGACY

**Use cases:**
- Discover model capabilities before implementation
- Validate model availability in your region
- Compare specifications across models
- Dynamically select models based on requirements
- Display model options to end users

**Example model IDs:**
- anthropic.claude-3-sonnet-20240229-v1:0
- amazon.titan-text-express-v1
- cohere.command-text-v14
- meta.llama2-70b-chat-v1
- stability.stable-diffusion-xl-v1',
    'Platform'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/platform',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Foundational model details
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('modelName', 'Model Name', 'String', true, 'The unique model identifier to retrieve information for (e.g., anthropic.claude-instant-v1).', 'anthropic.claude-instant-v1', 1, NULL),
        ('region', 'Region', 'String', false, 'AWS region to query for model details.', 'us-east-1', 2, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:foundational-model-details';

-- Operation 7: Foundational models list
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Foundational models list',
    'mac-bedrock:foundational-models-list',
    '**Lists all Amazon Bedrock models available in your configured region**. Discover what models you can use and their capabilities.

**What this does:**
- Queries AWS Bedrock for all available foundation models
- Returns a list with model IDs, names, and providers
- Shows models you have access to based on your AWS account permissions

**Information returned for each model:**
- **Model ID** - Full identifier for API calls
- **Model name** - Human-readable name
- **Provider name** - AI company (Anthropic, Amazon, Cohere, Meta, AI21, Stability AI)
- **Model type** - TEXT, IMAGE, EMBEDDING
- **Status** - ACTIVE or LEGACY

**Model categories:**
- **Text Generation** - Claude, Titan Text, Command, Llama, Jurassic
- **Embeddings** - Titan Embeddings, Cohere Embed
- **Image Generation** - Stable Diffusion, Titan Image

**Use cases:**
- Build dynamic model selection UIs
- Discover newly released models
- Verify model availability in your region
- Create model comparison tools
- Validate model access for your AWS account

**Response format:** JSON array of model objects

**No parameters required** - uses configured AWS credentials and region

**Note:** Available models vary by AWS region. Some models require explicit access request through AWS console.',
    'Platform'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/platform',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Foundational models list
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('region', 'Region', 'String', false, 'AWS region to query for available models. Defaults to config region if not specified.', 'us-east-1', 1, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:foundational-models-list';

-- Operation 8: Sentiment analyze
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Sentiment analyze',
    'mac-bedrock:sentiment-analyze',
    '**Analyzes sentiment and emotional tone of text** using foundation models. Identifies whether text is positive, negative, or neutral, along with confidence scores.

**What this does:**
- Analyzes text for emotional sentiment
- Returns sentiment classification (positive/negative/neutral)
- Provides confidence scores for each sentiment category
- Identifies emotional intensity and nuance

**How it works:**
The operation sends your text to a Bedrock model with sentiment analysis instructions. The model classifies the overall sentiment and provides detailed scores.

**Output includes:**
- **Sentiment** - POSITIVE, NEGATIVE, NEUTRAL, or MIXED
- **Confidence scores** - Percentage confidence for each category
- **Overall score** - Numeric sentiment score (-1 to +1)
- **Key phrases** - Words contributing to sentiment

**Use cases:**
- **Customer feedback analysis** - Categorize reviews and support tickets
- **Social media monitoring** - Track brand sentiment in real-time
- **Survey analysis** - Analyze open-ended survey responses
- **Content moderation** - Identify negative or toxic content
- **Market research** - Gauge public opinion on products/topics
- **Employee feedback** - Analyze internal feedback and surveys

**Supported models:**
All Bedrock text models can perform sentiment analysis, with Claude models particularly effective for nuanced emotional understanding.

**Example analysis:**
Input: "This product exceeded my expectations! Great quality."
Output: POSITIVE (confidence: 95%, score: 0.92)

Input: "Disappointed with the service. Long wait times."
Output: NEGATIVE (confidence: 87%, score: -0.78)',
    'Moderation'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/sentiment-analysis',
    8,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Sentiment analyze
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('TextToAnalyze', 'Text To Analyze', 'String', true, 'The text to analyze for sentiment. Can be reviews, feedback, social media posts, etc.', 'The product quality is excellent and delivery was faster than expected. Very satisfied with my purchase!', 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Model identifier for sentiment analysis. Claude models recommended for nuanced understanding.', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the model.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('temperature', 'Temperature', 'Number', false, 'Controls randomness (0-1). Lower = more deterministic.', '0.7', 4, NULL),
        ('topP', 'Top P', 'Number', false, 'Nucleus sampling threshold (0-1).', '0.9', 5, NULL),
        ('topK', 'Top K', 'Number', false, 'Number of most-likely candidates.', '250', 6, NULL),
        ('maxTokenCount', 'Max Token Count', 'Number', false, 'Maximum tokens to generate in response.', '512', 7, NULL),
        ('guardrailIdentifier', 'Guardrail Identifier', 'String', false, 'ID of the guardrail to apply to the model invocation.', NULL, 8, NULL),
        ('guardrailVersion', 'Guardrail Version', 'String', false, 'Version of the guardrail to use.', NULL, 9, NULL),
        ('awsAccountId', 'AWS Account ID', 'String', false, 'AWS account ID for cross-account guardrail access.', NULL, 10, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:sentiment-analyze';

-- Operation 9: Agent chat streaming (SSE)
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent chat streaming (SSE)',
    'mac-bedrock:agent-chat-streaming-sse',
    'Streams agent responses in real-time using Server-Sent Events (SSE) for interactive conversational experiences.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    9,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent chat streaming (SSE)
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent.', NULL, 1, NULL),
        ('agentAliasId', 'Agent Alias ID', 'String', true, 'The alias ID of the agent.', NULL, 2, NULL),
        ('prompt', 'Prompt', 'String', true, 'The user''s question or instruction to send to the agent.', NULL, 3, NULL),
        ('enableTrace', 'Enable Trace', 'Boolean', false, 'Enable detailed tracing for debugging agent responses and actions.', 'true', 4, NULL),
        ('latencyOptimized', 'Latency Optimized', 'Boolean', false, 'Optimize for lower latency responses.', 'true', 5, NULL),
        ('sessionId', 'Session ID', 'String', false, 'Optional session ID to continue a previous conversation.', NULL, 6, NULL),
        ('excludePreviousThinkingSteps', 'Exclude Previous Thinking Steps', 'Boolean', false, 'Exclude the agent''s internal reasoning steps from previous turns.', 'true', 7, NULL),
        ('previousConversationTurnsToInclude', 'Previous Conversation Turns To Include', 'String', false, 'Number of previous conversation turns to include for context.', NULL, 8, NULL),
        ('knowledgeBaseId', 'Knowledge Base ID', 'String', false, 'ID of the knowledge base to query for additional context.', NULL, 9, NULL),
        ('numberOfResults', 'Number Of Results', 'String', false, 'Number of results to retrieve from knowledge base.', NULL, 10, NULL),
        ('overrideSearchType', 'Override Search Type', 'String', false, 'Knowledge base search type to use.', 'SEMANTIC', 11, '{"enum":["HYBRID","SEMANTIC"]}'),
        ('retrievalMetadataFilterType', 'Retrieval Metadata Filter Type', 'String', false, 'How to combine metadata filters when querying knowledge base.', 'AND_ALL', 12, '{"enum":["OR_ALL","AND_ALL"]}'),
        ('metadataFilters', 'Metadata Filters', 'String', false, 'JSON metadata filters for knowledge base retrieval.', NULL, 13, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use for the agent.', NULL, 14, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the agent.', 'us-east-1', 15, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-chat-streaming-sse';

-- Operation 10: Agent create
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent create',
    'mac-bedrock:agent-create',
    'Creates a new Bedrock Agent with specified configurations, foundation model, and instructions.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    10,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent create
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentName', 'Agent Name', 'String', true, 'Name for the new Bedrock Agent.', NULL, 1, NULL),
        ('instructions', 'Instructions', 'String', true, 'Instructions that define the agent''s behavior and capabilities.', NULL, 2, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use for the agent (e.g., anthropic.claude-v2).', NULL, 3, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent will be created.', 'us-east-1', 4, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-create';

-- Operation 11: Agent create alias
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent create alias',
    'mac-bedrock:agent-create-alias',
    'Creates an alias for a Bedrock Agent, allowing version management and deployment control.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    11,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent create alias
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentAlias', 'Agent Alias', 'String', true, 'The alias name for the agent (e.g., PROD, STAGING, DEV).', NULL, 1, NULL),
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent.', NULL, 2, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use for the agent alias.', NULL, 3, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent alias will be created.', 'us-east-1', 4, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-create-alias';

-- Operation 12: Agent delete agent aliases
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent delete agent aliases',
    'mac-bedrock:agent-delete-agent-aliases',
    'Deletes one or more agent aliases for a Bedrock Agent.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    12,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent delete agent aliases
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent.', NULL, 1, NULL),
        ('agentAliasName', 'Agent Alias Name', 'String', true, 'The name of the agent alias to delete.', NULL, 2, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use.', NULL, 3, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent alias exists.', 'us-east-1', 4, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-delete-agent-aliases';

-- Operation 13: Agent delete by id
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent delete by id',
    'mac-bedrock:agent-delete-by-id',
    'Deletes a Bedrock Agent by its unique agent ID.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    13,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent delete by id
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent to delete.', NULL, 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use.', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent exists.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-delete-by-id';

-- Operation 14: Agent get alias by agent id
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent get alias by agent id',
    'mac-bedrock:agent-get-alias-by-agent-id',
    'Retrieves agent alias information for a specific agent ID.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    14,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent get alias by agent id
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent.', NULL, 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use.', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent exists.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-get-alias-by-agent-id';

-- Operation 15: Agent get by id
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent get by id',
    'mac-bedrock:agent-get-by-id',
    'Retrieves detailed information about a Bedrock Agent by its unique ID.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    15,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent get by id
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentId', 'Agent ID', 'String', true, 'The unique identifier of the Bedrock Agent to retrieve.', NULL, 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use.', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent exists.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-get-by-id';

-- Operation 16: Agent get by name
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent get by name',
    'mac-bedrock:agent-get-by-name',
    'Retrieves agent information by searching for the agent name.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    16,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent get by name
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentName', 'Agent Name', 'String', true, 'The name of the Bedrock Agent to retrieve.', NULL, 1, NULL),
        ('modelName', 'Model Name', 'String', false, 'Foundation model to use.', NULL, 2, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the agent exists.', 'us-east-1', 3, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-get-by-name';

-- Operation 17: Agent list
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Agent list',
    'mac-bedrock:agent-list',
    'Lists all Bedrock Agents available in your AWS account and region.',
    'Agent'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/agent',
    17,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Agent list
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('modelName', 'Model Name', 'String', false, 'Foundation model to filter agents by (optional).', NULL, 1, NULL),
        ('region', 'Region', 'String', true, 'AWS region to list agents from (required).', 'us-east-1', 2, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:agent-list';

-- Operation 18: Chat answer prompt memory
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Chat answer prompt memory',
    'mac-bedrock:chat-answer-prompt-memory',
    'Chat operation with conversation memory to maintain context across multiple interactions.',
    'Chat'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/chat',
    18,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Chat answer prompt memory
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', true, 'The user''s prompt - question, instruction, or text to complete.', NULL, 1, NULL),
        ('memoryPath', 'Memory Path', 'String', false, 'File path to store conversation memory/history.', NULL, 2, NULL),
        ('memoryName', 'Memory Name', 'String', false, 'Name/identifier for the conversation memory session.', NULL, 3, NULL),
        ('keepLastMessages', 'Keep Last Messages', 'String', false, 'Number of previous messages to retain in memory.', NULL, 4, NULL),
        ('modelName', 'Model Name', 'String', false, 'Model identifier. Overrides config default if specified.', NULL, 5, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the model.', 'us-east-1', 6, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('temperature', 'Temperature', 'Number', false, 'Controls randomness (0-1). Lower = more deterministic.', '0.7', 7, NULL),
        ('topP', 'Top P', 'Number', false, 'Nucleus sampling threshold (0-1).', '0.9', 8, NULL),
        ('topK', 'Top K', 'Number', false, 'Number of most-likely candidates.', '250', 9, NULL),
        ('maxTokenCount', 'Max Token Count', 'Number', false, 'Maximum tokens to generate in response.', '512', 10, NULL),
        ('guardrailIdentifier', 'Guardrail Identifier', 'String', false, 'ID of the guardrail to apply to the model invocation.', NULL, 11, NULL),
        ('guardrailVersion', 'Guardrail Version', 'String', false, 'Version of the guardrail to use.', NULL, 12, NULL),
        ('awsAccountId', 'AWS Account ID', 'String', false, 'AWS account ID for cross-account guardrail access.', NULL, 13, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:chat-answer-prompt-memory';

-- Operation 19: Custom model details
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Custom model details',
    'mac-bedrock:custom-model-details',
    'Retrieves detailed information about a custom fine-tuned model in your AWS account.',
    'Platform'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/platform',
    19,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Custom model details
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('modelName', 'Model Name', 'String', true, 'The identifier of the custom fine-tuned model.', NULL, 1, NULL),
        ('region', 'Region', 'String', false, 'AWS region where the custom model exists.', 'us-east-1', 2, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:custom-model-details';

-- Operation 20: Custom models list
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Custom models list',
    'mac-bedrock:custom-models-list',
    'Lists all custom fine-tuned models available in your AWS account.',
    'Platform'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/platform',
    20,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Custom models list
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('region', 'Region', 'String', false, 'AWS region to list custom models from.', 'us-east-1', 1, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:custom-models-list';

-- Operation 21: Embedding adhoc query
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Embedding adhoc query',
    'mac-bedrock:embedding-adhoc-query',
    'Performs ad-hoc embedding queries for quick semantic search and similarity matching.',
    'Embedding'::operation_category,
    ct.id,
    'https://mac-project.ai/docs/amazon-bedrock/supported-operations/embedding',
    21,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config';

-- Parameters for Embedding adhoc query
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('prompt', 'Prompt', 'String', true, 'The text query to generate embeddings for semantic search.', NULL, 1, NULL),
        ('filePath', 'File Path', 'Base64', false, 'File path containing queries or documents for batch embedding generation. Browse to select a file - it will be automatically encoded as base64.', NULL, 2, NULL),
        ('modelName', 'Model Name', 'String', false, 'Embedding model identifier (e.g., amazon.titan-embed-text-v1).', NULL, 3, NULL),
        ('region', 'Region', 'String', false, 'AWS region to use for the embedding model.', 'us-east-1', 4, '{"enum":["af-south-1","ap-northeast-1","ap-northeast-2","ap-northeast-3","ap-south-1","ap-south-2","ap-southeast-1","ap-southeast-2","ap-southeast-3","ap-southeast-4","ap-southeast-5","ap-southeast-7","ca-central-1","ca-west-1","eu-central-1","eu-central-2","eu-north-1","eu-south-1","eu-south-2","eu-west-1","eu-west-2","eu-west-3","il-central-1","me-central-1","me-south-1","mx-central-1","sa-east-1","us-east-1","us-east-2","us-gov-east-1","us-gov-west-1","us-west-1","us-west-2"]}'),
        ('dimension', 'Dimension', 'Number', false, 'Output dimension size for embeddings (model-dependent).', '1024', 5, NULL),
        ('normalize', 'Normalize', 'Boolean', false, 'Whether to normalize the embedding vectors to unit length.', 'true', 6, NULL),
        ('optionType', 'Option Type', 'String', false, 'Type of content to embed.', 'FULL', 7, '{"enum":["FULL","PARAGRAPH","SENTENCES"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND o.operation_key = 'mac-bedrock:embedding-adhoc-query';

-- =====================================================
-- 6. CREATE RUNTIME CONFIGURATION
-- =====================================================

-- Create runtime configuration for AWS Bedrock
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'AWS Bedrock Connection (Default)',
    'Default AWS Bedrock configuration using property placeholders. Configure AWS credentials in your properties file.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND ct.config_type_key = 'mac-bedrock:config'
  AND cp.provider_key = 'aws-connection';

-- Insert runtime config values (using placeholder property syntax)
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp.id,
    CASE cp.api_name
        WHEN 'accessKeyId' THEN '#[p('aws.bedrock.accessKeyId')]'
        WHEN 'secretAccessKey' THEN '#[p('aws.bedrock.secretAccessKey')]'
        WHEN 'sessionToken' THEN '#[p('aws.bedrock.sessionToken')]'
        WHEN 'fipsMode' THEN 'false'
        WHEN 'endpoint' THEN NULL
    END,
    CASE cp.api_name
        WHEN 'secretAccessKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN connector_config_types ct ON rc.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers prov ON prov.config_type_id = ct.id
JOIN config_parameters cp ON cp.provider_id = prov.id
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
  AND rc.name = 'AWS Bedrock Connection (Default)';

-- =====================================================
-- SEED COMPLETE - Summary Query
-- =====================================================

SELECT 
    '✅ Amazon Bedrock connector seed data inserted successfully!' AS status;

SELECT 
    c.name as connector,
    COUNT(DISTINCT o.id) as operations,
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
WHERE c.maven_artifact_id = 'mule4-amazon-bedrock-connector'
GROUP BY c.name;

