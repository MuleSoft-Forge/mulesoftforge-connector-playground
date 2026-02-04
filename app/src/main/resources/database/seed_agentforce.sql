-- =====================================================
-- AGENTFORCE CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the Agentforce Connector 1.2
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - Configuration types and providers
-- - Operations and parameters
-- - Placeholder runtime configuration
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-agentforce-connector',
    'Agentforce',
    '1.2.0',
    'AI',
    '**Salesforce Agentforce** enables autonomous AI agents that understand natural language, access Salesforce data, and take actions on behalf of users.

**Key capabilities:**
- **Authenticate** with Salesforce using OAuth
- **Create and manage** conversational AI agent sessions
- **Send messages** to agents and receive intelligent responses
- **Access Salesforce data** - Query and update CRM records (leads, accounts, opportunities)
- **Execute actions** - Create cases, update records, trigger workflows

**Use cases:** Customer service automation, sales assistance, data enrichment, process orchestration.',
    'https://docs.mulesoft.com/agentforce-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMzIiIGhlaWdodD0iMzIiIHZpZXdCb3g9IjAgMCAzMiAzMiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTAgMTZDMCA3LjE2MzQ0IDcuMTYzNDQgMCAxNiAwQzI0LjgzNjYgMCAzMiA3LjE2MzQ0IDMyIDE2QzMyIDI0LjgzNjYgMjQuODM2NiAzMiAxNiAzMkM3LjE2MzQ0IDMyIDAgMjQuODM2NiAwIDE2WiIgZmlsbD0iI0Q2RTZGRiIvPgo8cGF0aCBkPSJNMTguMTExNiAxNi42MjNIMTguMTE5M0MxNy44MDM5IDE2LjY0OTkgMTcuNTIzMSAxNi43MDM3IDE3LjI4MDggMTYuNzgwN0MxNy4yODA4IDE2Ljc4MDcgMTYuOTI3IDE2Ljg5MjIgMTYuMzg0NyAxNi45NjkxQzE2LjI1NzcgMTYuOTg4MyAxNi4wOTYyIDE2Ljk4ODMgMTYuMDA3NyAxNi45ODgzSDE1Ljk0MjRDMTUuODUzOSAxNi45ODgzIDE1LjY4ODUgMTYuOTgwNyAxNS41NjU0IDE2Ljk2MTRDMTUuMDIzMSAxNi44NzMgMTQuNjczMSAxNi43NDk5IDE0LjY3MzEgMTYuNzQ5OUMxNC40MzA4IDE2LjY3MyAxNC4xNSAxNi42MTUzIDEzLjgzNDcgMTYuNTgwN0MxMi4xMDc3IDE2LjQwMzcgMTEuMzYxNiAxNy4wNjE0IDExLjMxOTMgMTcuMTg0NUMxMS4yNzcgMTcuMzA3NiAxMS40NjU0IDE4LjkwNzYgMTEuNjAzOSAxOS4xNjE0QzExLjczODUgMTkuNDExNCAxMS45NDYyIDE5LjU1NzYgMTIuMTM0NyAxOS42MzgzQzEyLjMyNyAxOS43MTkxIDEzLjkwNzcgMTkuODc2OCAxNC40MzQ3IDE5LjgwMzdDMTQuOTYxNiAxOS43MzA3IDE1LjA0MjQgMTkuNTUzNyAxNS4xODQ3IDE5LjI4NDVDMTUuMjg0NyAxOS4wOTIyIDE1LjU0MjQgMTguMjIzIDE1LjY4NDcgMTcuNzExNEMxNS43MTkzIDE3LjYxMTQgMTUuNzIzMSAxNy40MTE0IDE1Ljk2NTQgMTcuMzk2QzE2LjIwNzcgMTcuNDE1MyAxNi4yMTE2IDE3LjYxOTEgMTYuMjQyNCAxNy43MTkxQzE2LjM4MDggMTguMjMwNyAxNi42MjMxIDE5LjEwNzYgMTYuNzE5MyAxOS4yOTk5QzE2Ljg1MzkgMTkuNTczIDE2LjkzNDcgMTkuNzQ5OSAxNy40NjE2IDE5LjgzNDVDMTcuOTg0NyAxOS45MTUzIDE5LjU2OTMgMTkuNzg4NCAxOS43NjE2IDE5LjcxMTRDMTkuOTUzOSAxOS42MzQ1IDIwLjE2MTYgMTkuNDkyMiAyMC4zIDE5LjI0MjJDMjAuNDM4NSAxOC45OTIyIDIwLjY1MzkgMTcuMzk2IDIwLjYxNTQgMTcuMjczQzIwLjU3NyAxNy4xNDYgMTkuODQyNCAxNi40NzY4IDE4LjExMTYgMTYuNjIzWiIgZmlsbD0iIzAyNTBEOSIvPgo8cGF0aCBkPSJNMjMuNTA3NyAxMS41OTZIMjMuNTExNkMyMy4wMzA4IDEwLjk4NDUgMjIuNDYxNiAxMC40NDIyIDIxLjgzMDggOS45NzY4MUMyMi40ODQ3IDkuODYxNDMgMjIuOTgwOCA5LjI5MjIgMjIuOTgwOCA4LjYwNzU4QzIyLjk4MDggNy44MzgzNSAyMi4zNTc3IDcuMjExNDMgMjEuNTg0NyA3LjIxMTQzQzIwLjgxMTYgNy4yMTE0MyAyMC4xODg1IDcuODM0NSAyMC4xODg1IDguNjA3NThDMjAuMTg4NSA4Ljc2MTQzIDIwLjIxOTMgOC45MDc1OCAyMC4yNjU0IDkuMDQ2MDRDMTkuMjczMSA4LjU3NjgxIDE4LjE4ODUgOC4yNjkxMiAxNy4wNTM5IDguMTQ5ODlDMTUuMTUzOSA3Ljk0OTg5IDEzLjMxOTMgOC4yODgzNSAxMS43Mzg1IDkuMDM0NUMxMS43ODA4IDguODk5ODkgMTEuODExNiA4Ljc1NzU4IDExLjgxMTYgOC42MDc1OEMxMS44MTE2IDcuODM4MzUgMTEuMTg4NSA3LjIxMTQzIDEwLjQxNTQgNy4yMTE0M0M5LjY0MjM1IDcuMjExNDMgOS4wMTkyNyA3LjgzNDUgOS4wMTkyNyA4LjYwNzU4QzkuMDE5MjcgOS4yOTIyIDkuNTExNTggOS44NTc1OCAxMC4xNTc3IDkuOTc2ODFDOC4zNjU0MyAxMS4yOTk5IDcuMTE1NDMgMTMuMjI2OCA2LjgzMDgxIDE1LjQ2MTRDNi41NjU0MyAxNy41MjY4IDcuMTUzODkgMTkuNTk2IDguNDkyMzUgMjEuMjg4M0MxMC4wMDc3IDIzLjIwMzcgMTIuMzYxNiAyNC40NjE0IDE0Ljk0NjIgMjQuNzM0NUMxNS4zMDc3IDI0Ljc3MyAxNS42NjU0IDI0Ljc5MjIgMTYuMDE5MyAyNC43OTIyQzIwLjYzMDggMjQuNzkyMiAyNC42MjMxIDIxLjY2MTQgMjUuMTY5MyAxNy40MjNDMjUuNDM0NyAxNS4zNTc2IDI0Ljg0NjIgMTMuMjg4MyAyMy41MDc3IDExLjU5NlpNMTYuMDA3NyAyMi40MDc2SDE2LjAwMzlDMTIuNTM0NyAyMi40MDM3IDkuNzExNTggMjAuMDg4MyA5LjcxMTU4IDE3LjI0MjJDOS43MTE1OCAxNi4zODQ1IDkuOTczMTIgMTUuNTYxNCAxMC40NDYyIDE0LjgzMDdDMTAuNDg4NSAxNS4wOTIyIDEwLjU2NTQgMTUuMzE5MSAxMC42NSAxNS40ODgzQzEwLjc2NTQgMTUuNzE5MSAxMC45OTYyIDE1Ljg1MzcgMTEuMjM4NSAxNS44NTM3QzExLjMzNDcgMTUuODUzNyAxMS40MzQ3IDE1LjgzNDUgMTEuNTI3IDE1Ljc4ODNDMTEuODUzOSAxNS42MzA3IDExLjk4ODUgMTUuMjM4MyAxMS44Mzg1IDE0LjkxMTRDMTEuNzU3NyAxNC43MzgzIDExLjU1IDE0LjE2NTMgMTIuMDUzOSAxMy43MjY4QzEyLjU0MjQgMTQuMTY5MSAxMy4yNDI0IDE0LjY4ODMgMTQuMDMwOCAxNC45NDIyQzE1LjUgMTUuNDA3NiAxNi42MTE2IDE1LjEzNDUgMTYuNjU3NyAxNS4xMjNDMTYuODgwOCAxNS4wNjUzIDE3LjA1MzkgMTQuODk5OSAxNy4xMjMxIDE0LjY4MDdDMTcuMTkyNCAxNC40NjE0IDE3LjE0MjQgMTQuMjIzIDE2Ljk5MjQgMTQuMDUzN0MxNi4yNSAxMy4xOTk5IDE1Ljg5NjIgMTIuNTc2OCAxNS43NDI0IDEyLjE5OTlDMTguNzUgMTIuNjA3NiAxOS4zMjcgMTUuMDAzNyAxOS4zNSAxNS4xMTE0QzE5LjQxNTQgMTUuNDE5MSAxOS42ODg1IDE1LjYzMDcgMTkuOTkyNCAxNS42MzA3QzIwLjAzODUgMTUuNjMwNyAyMC4wODA4IDE1LjYyNjggMjAuMTI3IDE1LjYxNTNDMjAuNDg0NyAxNS41NDIyIDIwLjcxMTYgMTUuMTkyMiAyMC42Mzg1IDE0LjgzNDVDMjAuNTQ2MiAxNC4zODgzIDIwLjMwMzkgMTMuNzg0NSAxOS44NzMxIDEzLjE4MDdDMjEuMzQ2MiAxNC4xMjY4IDIyLjMgMTUuNTk2IDIyLjMgMTcuMjQ2QzIyLjMgMjAuMDkyMiAxOS40NzcgMjIuNDA3NiAxNi4wMDc3IDIyLjQwNzZaIiBmaWxsPSIjMDI1MEQ5Ii8+Cjwvc3ZnPgo=',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPE
-- =====================================================

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'ms-agentforce:config',
    'Agentforce_Configuration',
    'Only supported configuration using OAuth Client Credentials for Salesforce'
FROM connectors 
WHERE maven_artifact_id = 'mule4-agentforce-connector';

-- =====================================================
-- 3. INSERT PROVIDER
-- =====================================================

INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'Config_OauthClientCredentials',
    'Salesforce',
    'OAuth Client Credentials connection to Salesforce for Agentforce services.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND ct.config_type_key = 'ms-agentforce:config';

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
        ('clientId', 'Client ID', 'String', true, NULL, 'OAuth client ID as registered with the service provider.', 1),
        ('clientSecret', 'Client Secret', 'String', true, NULL, 'OAuth client secret as registered with the service provider.', 2),
        ('tokenUrl', 'Token URL', 'String', false, 'https://{salesforceorg}/services/oauth2/token', 'The service provider''s token endpoint URL.', 3),
        ('scopes', 'Scopes', 'String', false, NULL, 'OAuth scopes to request during the OAuth dance. This value defaults to the scopes in the annotation.', 4),
        ('salesforceOrg', 'Salesforce Org', 'String', true, NULL, 'Salesforce org hostname (e.g., storm-bc10ebcc1814e0.my.salesforce.com)', 5)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND cp.provider_key = 'Config_OauthClientCredentials';

-- =====================================================
-- 5. INSERT OPERATIONS
-- =====================================================

-- Operation 1: Start Agent Conversation
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Start Agent Conversation',
    'ms-agentforce:start-agent-conversation',
    '**Initiates a new conversational session** with a Salesforce Agentforce AI agent. This is the **first required step** before sending messages to the agent.

**What this does:**
1. **Authenticates** with Salesforce using OAuth
2. **Creates a session** with the specified agent
3. **Returns a session ID** for subsequent messages

**Key parameters:**
- **Agent ID** - Identifier of the Salesforce AI agent to connect to
- **Bypass User** (optional) - Bypasses permissions for Data Cloud access

Sessions maintain conversation history and context. Always call this before sending messages.',
    'Agent'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/agentforce-connector/1.2/configuring-agent-operations#start-agent',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND ct.config_type_key = 'ms-agentforce:config';

-- Parameters for Start Agent Conversation
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, validation_rules, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.validation_rules::jsonb,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('agentList', 'Agent List', 'String', true, 'Select the Agentforce agent to interact with. Agents are dynamically loaded from your Salesforce org based on the selected runtime configuration.', NULL, NULL, 1),
        ('bypassUser', 'Bypass User', 'Boolean', false, 'Bypasses current user''s permissions when the agent needs to access Data Cloud assets.', 'false', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, validation_rules, parameter_order)
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND o.operation_key = 'ms-agentforce:start-agent-conversation';

-- Operation 2: Continue Agent Conversation
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'Continue Agent Conversation',
    'ms-agentforce:continue-agent-conversation',
    '**Sends a message** to an existing Agentforce agent session and receives an intelligent response. Use this after `Start Agent Conversation` to interact with the AI agent.

**How it works:**
1. Message is sent to the agent with conversation context
2. Agent processes input using NLU, Salesforce data, and configured skills
3. Agent returns response (text, data, actions taken)

**What the agent can do:**
- **Answer questions** - Query Salesforce records
- **Take actions** - Create/update records
- **Provide insights** - Analyze data
- **Multi-turn conversations** - Reference previous messages in the session

**Example:** Send "What''s the status of order #12345?" → Agent queries Salesforce and returns order details with shipping info.',
    'Agent'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/agentforce-connector/1.2/configuring-agent-operations#continue-agent',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND ct.config_type_key = 'ms-agentforce:config';

-- Parameters for Continue Agent Conversation
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('message', 'Message', 'String', true, 'Enter plain text instructions to help the agent make decisions for different use cases.', 1),
        ('sessionId', 'Session ID', 'String', true, 'Session ID returned with the Start agent conversation operation.', 2),
        ('messageSequenceNumber', 'Message Sequence Number', 'Number', true, 'Increase this number for each subsequent message in a session.', 3)
) AS param(api_name, display_name, data_type, is_required, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND o.operation_key = 'ms-agentforce:continue-agent-conversation';

-- Operation 3: End Agent Conversation
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'End Agent Conversation',
    'ms-agentforce:end-agent-conversation',
    'Closes the session after the agent responds. Sessions are closed automatically after three days of inactivity.',
    'Agent'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/agentforce-connector/1.2/configuring-agent-operations#end-agent',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND ct.config_type_key = 'ms-agentforce:config';

-- Parameters for End Agent Conversation
INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, parameter_order)
SELECT 
    o.id,
    'sessionId',
    'Session ID',
    'String',
    true,
    'Session ID returned with the Start agent conversation operation.',
    1
FROM operations o
JOIN connectors c ON o.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND o.operation_key = 'ms-agentforce:end-agent-conversation';

-- =====================================================
-- 6. CREATE RUNTIME CONFIGURATION
-- =====================================================

-- Create runtime configuration for Salesforce Connected App
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Salesforce Connection (Default)',
    'Production Salesforce Connected App for Agentforce integration.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND ct.config_type_key = 'ms-agentforce:config'
  AND cp.provider_key = 'Config_OauthClientCredentials';

-- Insert runtime config values (using real working credentials from agentforce.xml)
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp.id,
    CASE cp.api_name
        WHEN 'clientId' THEN '#[p('salesforce.einstein.clientId')]'
        WHEN 'clientSecret' THEN '#[p('salesforce.einstein.clientSecret')]'
        WHEN 'tokenUrl' THEN '#[p('salesforce.einstein.tokenUrl')]'
        WHEN 'scopes' THEN '#[p('salesforce.einstein.scopes')]'
        WHEN 'salesforceOrg' THEN '#[p('salesforce.einstein.salesforceOrg')]'
    END,
    CASE cp.api_name
        WHEN 'clientSecret' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN connector_config_types ct ON rc.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers prov ON prov.config_type_id = ct.id
JOIN config_parameters cp ON cp.provider_id = prov.id
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
  AND rc.name = 'Salesforce Connection (Default)';

-- =====================================================
-- SEED COMPLETE - Summary Query
-- =====================================================

SELECT 
    '✅ Agentforce connector seed data inserted successfully!' AS status;

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
WHERE c.maven_artifact_id = 'mule4-agentforce-connector'
GROUP BY c.name;
