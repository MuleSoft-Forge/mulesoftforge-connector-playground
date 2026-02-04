-- =====================================================
-- MCP CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the MCP (Model Context Protocol) Connector 1.3.1
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - Configuration type (Client only)
-- - Provider (Streamable HTTP Client)
-- - Operations (5 CLIENT operations - executable): Call Tool, List Resources, List Tools, Ping, Read Resource
-- - Parameters for all operations
-- - Runtime configurations: MCPG MCP Server, Deepwiki
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-mcp-connector',
    'MCP',
    '1.3.1',
    'AI',
    '**Model Context Protocol (MCP)** has rapidly emerged as the **industry standard** for agent-to-tool communication, analogous to what REST became for web services. MCP allows AI agents to dynamically discover a system''s capabilities, understand its inputs and outputs, and invoke it to perform actions—all without requiring pre-programmed or hard-coded logic.

The **MuleSoft MCP Connector** allows any API implemented as a Mule application to be published as an MCP server. Since MuleSoft provides hundreds of pre-built connectors to virtually every major enterprise system (SaaS, legacy, databases), this instantly transforms an organization''s APIs and applications into agent-ready tools.',
    'https://docs.mulesoft.com/mcp-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KICAgIDxnIGNsaXAtcGF0aD0idXJsKCNjbGlwMF8xXzg0NzI2KSI+CiAgICAgICAgPHBhdGggZD0iTTkgMThDMTMuOTcwNiAxOCAxOCAxMy45NzA2IDE4IDlDMTggNC4wMjk0NCAxMy45NzA2IDAgOSAwQzQuMDI5NDQgMCAwIDQuMDI5NDQgMCA5QzAgMTMuOTcwNiA0LjAyOTQ0IDE4IDkgMThaIiBmaWxsPSIjQ0ZFOUZFIi8+CiAgICAgICAgPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGQ9Ik0xMS4xNzQ1IDMuOTAwMDFDMTAuNTgzNiAzLjMyODM1IDkuNjM4MTUgMy4zMjgzNSA5LjA0NzI0IDMuOTAwMDFMMy4zNjI3IDkuNDA2NjhDMy4xNjE3OSA5LjU5MzM1IDIuODU0NTIgOS41OTMzNSAyLjY1MzYxIDkuNDA2NjhDMi40NjQ1MiA5LjIyMDAxIDIuNDUyNyA4LjkxNjY4IDIuNjUzNjEgOC43MzAwMUw4LjMzODE1IDMuMjExNjhDOS4zMzA4OCAyLjI2NjY4IDEwLjkwMjcgMi4yNjY2OCAxMS44OTU0IDMuMjExNjhDMTIuNDUwOSAzLjc0ODM1IDEyLjcyMjcgNC41MTgzNSAxMi42MDQ1IDUuMjc2NjhDMTMuMzg0NSA1LjE3MTY4IDE0LjE3NjMgNS40MTY2OCAxNC43MzE4IDUuOTY1MDFMMTQuNzU1NCA2LjAwMDAxQzE1LjcxMjcgNi45MjE2OCAxNS43MzYzIDguNDM4MzUgMTQuODAyNyA5LjM5NTAxQzE0Ljc5MDkgOS40MDY2OCAxNC43NjcyIDkuNDMwMDEgMTQuNzU1NCA5LjQ0MTY4TDkuNjE0NTIgMTQuNDIzM0M5LjU1NTQzIDE0LjQ4MTcgOS41NDM2MSAxNC41ODY3IDkuNjE0NTIgMTQuNjQ1TDEwLjY2NjMgMTUuNjcxN0MxMC44NTU0IDE1Ljg1ODMgMTAuODY3MiAxNi4xNjE3IDEwLjY2NjMgMTYuMzQ4M0MxMC40NjU0IDE2LjUzNSAxMC4xNTgyIDE2LjUzNSA5Ljk1NzI0IDE2LjM0ODNMOC45MDU0MyAxNS4zMjE3QzguNDU2MzQgMTQuODkgOC40NDQ1MiAxNC4xNzgzIDguODgxNzkgMTMuNzM1QzguODgxNzkgMTMuNzM1IDguODkzNjEgMTMuNzIzMyA4LjkwNTQzIDEzLjcxMTdMMTQuMDQ2MyA4LjczMDAxQzE0LjYyNTQgOC4xNzAwMSAxNC42MzcyIDcuMjYwMDEgMTQuMDcgNi42ODgzNUwxNC4wNDYzIDYuNjY1MDFMMTQuMDIyNyA2LjY0MTY4QzEzLjQzMTggNi4wNzAwMSAxMi40ODYzIDYuMDcwMDEgMTEuODk1NCA2LjY0MTY4TDcuNjUyNyAxMC43NDgzTDcuNTkzNjEgMTAuODA2N0M3LjM5MjcgMTAuOTkzMyA3LjA4NTQzIDEwLjk5MzMgNi44ODQ1MiAxMC44MDY3QzYuNjk1NDMgMTAuNjIgNi42ODM2MSAxMC4zMTY3IDYuODg0NTIgMTAuMTNMMTEuMTg2MyA1Ljk2NTAxQzExLjc2NTQgNS40MDUwMSAxMS43NzcyIDQuNDk1MDEgMTEuMjEgMy45MjMzNUMxMS4yMSAzLjkyMzM1IDExLjE5ODIgMy45MTE2OCAxMS4xODYzIDMuOTAwMDFIMTEuMTc0NVoiIGZpbGw9IiMwMTc2RDMiLz4KICAgICAgICA8cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGNsaXAtcnVsZT0iZXZlbm9kZCIgZD0iTTEwLjQ2NTUgNS4yNzY2M0MxMC42NTQ2IDUuMDg5OTYgMTAuNjY2NCA0Ljc4NjYzIDEwLjQ2NTUgNC41OTk5NkMxMC4yNjQ2IDQuNDEzMjkgOS45NTczMiA0LjQxMzI5IDkuNzU2NDEgNC41OTk5Nkw1LjU0OTE0IDguNjcxNjNDNC41OTE4NyA5LjU5MzI5IDQuNTY4MjMgMTEuMTEgNS41MDE4NyAxMi4wNjY2QzUuNTEzNjggMTIuMDc4MyA1LjUzNzMyIDEyLjEwMTYgNS41NDkxNCAxMi4xMTMzQzYuNTQxODcgMTMuMDU4MyA4LjExMzY4IDEzLjA1ODMgOS4xMDY0MSAxMi4xMTMzTDEzLjMxMzcgOC4wNDE2M0MxMy41MDI4IDcuODU0OTYgMTMuNTE0NiA3LjU1MTYzIDEzLjMxMzcgNy4zNjQ5NkMxMy4xMTI4IDcuMTc4MjkgMTIuODA1NSA3LjE3ODI5IDEyLjYwNDYgNy4zNjQ5Nkw4LjM5NzMyIDExLjQzNjZDNy44MDY0MSAxMi4wMDgzIDYuODYwOTYgMTIuMDA4MyA2LjI3MDA1IDExLjQzNjZDNS42OTA5NiAxMC44NzY2IDUuNjc5MTQgOS45NjY2MyA2LjI0NjQxIDkuMzk0OTZMNi4yNzAwNSA5LjM3MTYzTDEwLjQ3NzMgNS4yOTk5NkwxMC40NjU1IDUuMjc2NjNaIiBmaWxsPSIjMDE3NkQzIi8+CiAgICA8L2c+CiAgICA8ZGVmcz4KICAgICAgICA8Y2xpcFBhdGggaWQ9ImNsaXAwXzFfODQ3MjYiPgogICAgICAgICAgICA8cmVjdCB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIGZpbGw9IndoaXRlIi8+CiAgICAgICAgPC9jbGlwUGF0aD4KICAgIDwvZGVmcz4KPC9zdmc+Cg==',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPE
-- =====================================================

-- Client Configuration Type (Server config type removed - users cannot create MCP Server configs)
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'mcp:client-config',
    'MCP_Client',
    'Configuration element that acts as a client and connects to an MCP server. Enables Mule to interact with remote MCP servers to call tools, list resources, and read resource content.'
FROM connectors 
WHERE maven_artifact_id = 'mule4-mcp-connector';

-- =====================================================
-- 3. INSERT PROVIDER
-- =====================================================

-- Provider: Streamable HTTP Client
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'streamable-http-client-connection',
    'Streamable HTTP Client',
    'Recommended connection type. Allows deployment of multiple instances behind a load balancer. Clients connect to a single endpoint (/mcp) and the load balancer distributes requests. Ideal for scalability in cloud environments.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config';

-- =====================================================
-- 4. INSERT CONFIG PARAMETERS
-- =====================================================

-- Streamable HTTP Client Parameters
-- Only include runtime-configurable parameters for MCPG
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
        ('serverUrl', 'Server URL', 'String', true, NULL, 'The base URL for the target MCP server (e.g., https://mulesoft-connector-playground-app-9sqczt.m3jzw3-2.deu-c1.cloudhub.io).', 1),
        ('requestTimeout', 'Request Timeout', 'Number', false, '30', 'Duration to wait for server responses before timing out requests.', 2),
        ('requestTimeoutUnit', 'Request Timeout Unit', 'String', false, 'SECONDS', 'Time unit for Request Timeout. Defaults to SECONDS. Options: NANOSECONDS, MICROSECONDS, MILLISECONDS, SECONDS, MINUTES, HOURS, DAYS.', 3),
        
        -- Authentication
        ('authType', 'Authentication Type', 'String', true, 'none', 'Authentication method for connecting to the MCP server. Options: none (default), basic, oauth2-client-credentials', 4),
        
        -- Basic Auth
        ('basicUsername', 'Username', 'String', false, NULL, 'Username for HTTP Basic Authentication. Required when authType is "basic".', 5),
        ('basicPassword', 'Password', 'String', false, NULL, 'Password for HTTP Basic Authentication. Required when authType is "basic". This value will be encrypted.', 6),
        
        -- OAuth 2.0 Client Credentials
        ('oauthClientId', 'OAuth Client ID', 'String', false, NULL, 'OAuth 2.0 Client ID for Client Credentials grant flow. Required when authType is "oauth2-client-credentials".', 7),
        ('oauthClientSecret', 'OAuth Client Secret', 'String', false, NULL, 'OAuth 2.0 Client Secret for Client Credentials grant flow. Required when authType is "oauth2-client-credentials". This value will be encrypted.', 8),
        ('oauthTokenUrl', 'OAuth Token URL', 'String', false, NULL, 'OAuth 2.0 token endpoint URL for obtaining access tokens. Required when authType is "oauth2-client-credentials".', 9),
        ('oauthScopes', 'OAuth Scopes', 'String', false, NULL, 'Space-separated list of OAuth scopes to request. Optional for OAuth authentication.', 10)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND cp.provider_key = 'streamable-http-client-connection';

-- =====================================================
-- 5. INSERT CLIENT OPERATIONS (EXECUTABLE)
-- =====================================================
-- These operations can be executed from the lab UI to interact
-- with remote MCP servers.
-- Order: Ping, List Tools, Call Tool, List Resources, Read Resource
-- Categories: General, Tools, Resources
-- =====================================================

-- Operation 1: MCP Client - Ping
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'MCP Client - Ping',
    'mcp:ping',
    '**Verifies connectivity** to a remote MCP server by sending a ping request. This operation is essential for:

- **Health checks** - Validate that the MCP server is reachable and responding
- **Connection testing** - Confirm proper network configuration before executing operations
- **Monitoring** - Implement periodic connectivity checks in production environments

*No parameters required* - simply execute to test the connection.',
    CAST('General' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mcp-connector/latest/mcp-connector-reference#Ping',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config';

-- No parameters for Ping operation

-- Operation 2: MCP Client - List Tools
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'MCP Client - List Tools',
    'mcp:list-tools',
    '**Discovers all available tools** exposed by the remote MCP server. This operation returns comprehensive tool metadata that enables dynamic tool invocation.

**Returns for each tool:**
- `name` - The tool identifier used in **Call Tool** operations
- `description` - Detailed explanation of what the tool does
- `inputSchema` - `JSON` schema defining required and optional parameters

**Use cases:**
- **Tool discovery** - Explore capabilities before building integrations
- **Dynamic routing** - Select tools programmatically based on business logic
- **Documentation** - Generate runtime API catalogs from live servers',
    CAST('Tools' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mcp-connector/latest/mcp-connector-reference#ListTools',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config';

-- No parameters for List Tools operation

-- Operation 3: MCP Client - Call Tool
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'MCP Client - Call Tool',
    'mcp:call-tool',
    '**Executes a specific tool** on the remote MCP server with provided arguments. This is the primary operation for invoking server-side functionality and receiving structured responses.

**How it works:**
1. Specify the `toolName` to invoke (discovered via **List Tools**)
2. Provide input `arguments` as a `JSON` object matching the tool''s schema
3. Receive structured results with text, images, or data payloads

**Use cases:**
- **API orchestration** - Call backend services wrapped as MCP tools
- **AI agent integration** - Enable LLMs to invoke enterprise systems
- **Workflow automation** - Chain tool calls for complex business processes

*Tip: Always validate argument structure against the tool''s input schema.*',
    CAST('Tools' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mcp-connector/latest/mcp-connector-reference#CallTool',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('toolName', 'Tool Name', 'String', true, 'Name of the tool to invoke in the remote MCP server.', NULL, 1),
        ('arguments', 'Arguments', 'JSON', false, 'The tool''s input arguments as a JSON object. Structure must match the tool''s input schema.', NULL, 2),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Additional properties to include with the request (e.g., custom headers, API keys).', NULL, 3)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND o.operation_key = 'mcp:call-tool';

-- Operation 4: MCP Client - List Resources
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'MCP Client - List Resources',
    'mcp:list-resources',
    '**Discovers all available resources** exposed by the remote MCP server. Resources represent accessible content that can be read, including files, data sources, and generated content.

**Returns for each resource:**
- `uri` - Unique identifier used in **Read Resource** operations
- `name` - Human-readable resource name
- `description` - What the resource contains and when to use it
- `mimeType` - Content type (e.g., `text/csv`, `application/json`)

**Common resource types:**
- **Static files** - Configuration files, documents, cached data
- **Dynamic content** - Live database queries, API responses, computed results
- **Streaming data** - Real-time feeds, logs, monitoring data

*Use **Read Resource** to fetch the actual content after discovering available resources.*',
    CAST('Resources' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mcp-connector/latest/mcp-connector-reference#ListResources',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config';

-- No parameters for List Resources operation

-- Operation 5: MCP Client - Read Resource
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'MCP Client - Read Resource',
    'mcp:read-resource',
    '**Retrieves the actual content** of a resource from the remote MCP server using its `URI`. Resources can contain text or binary data depending on their `mimeType`.

**Content types supported:**
- **Text resources** - `JSON`, `CSV`, `XML`, plain text, markdown
- **Binary resources** (blobs) - Images, PDFs, compressed files
- **Structured data** - Database exports, API responses, generated reports

**Workflow:**
1. Use **List Resources** to discover available `URI` values
2. Call **Read Resource** with the target `URI`
3. Process the returned content based on its `mimeType`

**Use cases:**
- **RAG systems** - Fetch knowledge base content for AI context
- **Data integration** - Pull files or datasets from remote systems
- **Content delivery** - Retrieve generated documents or reports

*Always check the resource''s mimeType to handle content appropriately.*',
    CAST('Resources' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/mcp-connector/latest/mcp-connector-reference#ReadResource',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, parameter_order)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.description,
    param.default_value,
    param.parameter_order
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('uri', 'URI', 'String', true, 'The URI of the resource to read. Use the List Resources operation to discover available URIs.', NULL, 1),
        ('additionalProperties', 'Additional Properties', 'JSON', false, 'Additional properties to include with the request.', NULL, 2)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order)
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND o.operation_key = 'mcp:read-resource';

-- =====================================================
-- 6. CREATE RUNTIME CONFIGURATIONS
-- =====================================================

-- Create runtime configuration for Streamable HTTP Client - MCPG MCP Server
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'MCPG MCP Server',
    'MuleSoftForge Connector Playground''s own MCP Server',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config'
  AND cp.provider_key = 'streamable-http-client-connection';

-- Insert runtime config values for MCPG MCP Server
-- Only include runtime-configurable parameters: serverUrl, requestTimeout, requestTimeoutUnit, authType
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp.id,
    CASE cp.api_name
        WHEN 'serverUrl' THEN '#[p('mcpg.mcp.serverUrl')]'
        WHEN 'requestTimeout' THEN '30'
        WHEN 'requestTimeoutUnit' THEN 'SECONDS'
        WHEN 'authType' THEN 'none'
    END,
    false
FROM runtime_configurations rc
JOIN connector_config_types ct ON rc.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers prov ON prov.config_type_id = ct.id
JOIN config_parameters cp ON cp.provider_id = prov.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND rc.name = 'MCPG MCP Server'
  AND cp.api_name IN ('serverUrl', 'requestTimeout', 'requestTimeoutUnit', 'authType');

-- Create runtime configuration for Streamable HTTP Client - Deepwiki
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Deepwiki',
    'Index your code with Devin',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND ct.config_type_key = 'mcp:client-config'
  AND cp.provider_key = 'streamable-http-client-connection';

-- Insert runtime config values for Deepwiki
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp.id,
    CASE cp.api_name
        WHEN 'serverUrl' THEN 'https://mcp.deepwiki.com'
        WHEN 'requestTimeout' THEN '30'
        WHEN 'requestTimeoutUnit' THEN 'SECONDS'
        WHEN 'authType' THEN 'none'
    END,
    false
FROM runtime_configurations rc
JOIN connector_config_types ct ON rc.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers prov ON prov.config_type_id = ct.id
JOIN config_parameters cp ON cp.provider_id = prov.id
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
  AND rc.name = 'Deepwiki'
  AND cp.api_name IN ('serverUrl', 'requestTimeout', 'requestTimeoutUnit', 'authType');

-- =====================================================
-- SEED COMPLETE - Summary Query
-- =====================================================

SELECT 
    '✅ MCP connector seed data inserted successfully!' AS status;

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
WHERE c.maven_artifact_id = 'mule4-mcp-connector'
GROUP BY c.name;

