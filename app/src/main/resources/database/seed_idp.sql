-- =====================================================
-- IDP CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the MuleSoft IDP Universal REST Smart Connector v1
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - 1 Unified Configuration (OAuth + Basic Auth combined)
-- - 1 Connection Provider with 8 parameters
-- - 12 Operations (6 Runtime Services, 6 Platform Services)
-- - Parameters for all operations
-- - 1 Unified Runtime Configuration
--
-- IMPORTANT: This matches the actual idp.xml configuration
-- where ONE config contains both OAuth credentials (for Runtime Services)
-- and Basic Auth credentials (for Platform Services)
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule-idp-connector',
    'IDP',
    '1.0.6',
    'AI',
    '**MuleSoft Intelligent Document Processing (IDP)** extracts structured data from unstructured documents using AI. The **IDP Connector** provides a unified interface to all IDP actions.

**What IDP does:**
- **Document classification** - Identify document types (invoice, contract, W-2, etc.)
- **Data extraction** - Pull structured data from forms, tables, and text
- **Entity recognition** - Find names, dates, amounts, addresses
- **Multi-format support** - Process PDFs, images, scanned documents

**Use cases:** Invoice processing, loan applications, contract analysis, claims processing.',
    'https://docs.mulesoftforge.com/connectors/mule-idp-connector',
    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNDgiIGhlaWdodD0iNDgiIHZpZXdCb3g9IjAgMCA0OCA0OCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTYgNEM0Ljg5NTQzIDQgNCA0Ljg5NTQzIDQgNlYxNS41ODU4QzQgMTYuNDc2NyA1LjA3NzE0IDE2LjkyMjkgNS43MDcxMSAxNi4yOTI5TDcuNTYwNjYgMTQuNDM5M0M3Ljg0MTk2IDE0LjE1OCA4IDEzLjc3NjUgOCAxMy4zNzg3VjlDOCA4LjQ0NzcyIDguNDQ3NzIgOCA5IDhIMTMuMzc4N0MxMy43NzY1IDggMTQuMTU4IDcuODQxOTcgMTQuNDM5MyA3LjU2MDY2TDE2LjI5MjkgNS43MDcxMUMxNi45MjI5IDUuMDc3MTQgMTYuNDc2NyA0IDE1LjU4NTggNEg2WiIgZmlsbD0iIzFCOTZGRiIvPgo8cGF0aCBkPSJNNiA0NEM0Ljg5NTQzIDQ0IDQgNDMuMTA0NiA0IDQyVjMyLjQxNDJDNCAzMS41MjMzIDUuMDc3MTQgMzEuMDc3MSA1LjcwNzExIDMxLjcwNzFMNy41NjA2NiAzMy41NjA3QzcuODQxOTYgMzMuODQyIDggMzQuMjIzNSA4IDM0LjYyMTNWMzlDOCAzOS41NTIzIDguNDQ3NzIgNDAgOSA0MEgxMy4zNzg3QzEzLjc3NjUgNDAgMTQuMTU4IDQwLjE1OCAxNC40MzkzIDQwLjQzOTNMMTYuMjkyOSA0Mi4yOTI5QzE2LjkyMjkgNDIuOTIyOSAxNi40NzY3IDQ0IDE1LjU4NTggNDRINloiIGZpbGw9IiMxQjk2RkYiLz4KPHBhdGggZD0iTTQyIDRDNDMuMTA0NiA0IDQ0IDQuODk1NDMgNDQgNlYxNS41ODU4QzQ0IDE2LjQ3NjcgNDIuOTIyOSAxNi45MjI5IDQyLjI5MjkgMTYuMjkyOUw0MC40MzkzIDE0LjQzOTNDNDAuMTU4IDE0LjE1OCA0MCAxMy43NzY1IDQwIDEzLjM3ODdWOUM0MCA4LjQ0NzcyIDM5LjU1MjMgOCAzOSA4SDM0LjYyMTNDMzQuMjIzNSA4IDMzLjg0MiA3Ljg0MTk3IDMzLjU2MDcgNy41NjA2NkwzMS43MDcxIDUuNzA3MTFDMzEuMDc3MSA1LjA3NzE0IDMxLjUyMzMgNCAzMi40MTQyIDRINDJaIiBmaWxsPSIjMUI5NkZGIi8+CjxwYXRoIGQ9Ik00MiA0NEM0My4xMDQ2IDQ0IDQ0IDQzLjEwNDYgNDQgNDJWMzIuNDE0MkM0NCAzMS41MjMzIDQyLjkyMjkgMzEuMDc3MSA0Mi4yOTI5IDMxLjcwNzFMNDAuNDM5MyAzMy41NjA3QzQwLjE1OCAzMy44NDIgNDAgMzQuMjIzNSA0MCAzNC42MjEzVjM5QzQwIDM5LjU1MjMgMzkuNTUyMyA0MCAzOSA0MEgzNC42MjEzQzM0LjIyMzUgNDAgMzMuODQyIDQwLjE1OCAzMy41NjA3IDQwLjQzOTNMMzEuNzA3MSA0Mi4yOTI5QzMxLjA3NzEgNDIuOTIyOSAzMS41MjMzIDQ0IDMyLjQxNDIgNDRINDJaIiBmaWxsPSIjMUI5NkZGIi8+CjxwYXRoIGQ9Ik0xMiAyOS43ODQ2QzEyIDI5LjE3MDMgMTIuNjAxOCAyOC43MzY1IDEzLjE4NDYgMjguOTMwOEwyMy42ODM4IDMyLjQzMDVDMjMuODg5IDMyLjQ5ODkgMjQuMTExIDMyLjQ5ODkgMjQuMzE2MiAzMi40MzA1TDM0LjgxNTQgMjguOTMwOEMzNS4zOTgyIDI4LjczNjUgMzYgMjkuMTcwMyAzNiAyOS43ODQ2VjMxLjA2MTlDMzYgMzEuNzA5NCAzNS41ODQ0IDMyLjI4MzkgMzQuOTY5MyAzMi40ODY1TDI0LjYyNTggMzUuODk0QzI0LjIxOTMgMzYuMDI3OSAyMy43ODA3IDM2LjAyNzkgMjMuMzc0MiAzNS44OTRMMTMuMDMwNyAzMi40ODY1QzEyLjQxNTYgMzIuMjgzOSAxMiAzMS43MDk0IDEyIDMxLjA2MThWMjkuNzg0NloiIGZpbGw9IiMwQjVDQUIiLz4KPHBhdGggZD0iTTM2IDE3Ljc5MTJDMzYgMTguNDM4OCAzNS41ODQ0IDE5LjAxMzMgMzQuOTY5MyAxOS4yMTU5TDI0LjYyNTggMjIuNjIzNEMyNC4yMTkzIDIyLjc1NzMgMjMuNzgwNyAyMi43NTczIDIzLjM3NDIgMjIuNjIzNEwxMy4wMzA3IDE5LjIxNTlDMTIuNDE1NiAxOS4wMTMzIDEyIDE4LjQzODggMTIgMTcuNzkxMlYxNi41MDI0QzEyIDE2LjExMzggMTIuMjQ5NCAxNS43NjkyIDEyLjYxODQgMTUuNjQ3NkwyMy4zNzQyIDEyLjEwNDNDMjMuNzgwNyAxMS45NzA0IDI0LjIxOTMgMTEuOTcwNCAyNC42MjU4IDEyLjEwNDNMMzUuMzgxNiAxNS42NDc2QzM1Ljc1MDYgMTUuNzY5MiAzNiAxNi4xMTM4IDM2IDE2LjUwMjRWMTcuNzkxMloiIGZpbGw9IiMwQjVDQUIiLz4KPHBhdGggZD0iTTEyIDIzLjE4NDZDMTIgMjIuNTcwMyAxMi42MDE4IDIyLjEzNjYgMTMuMTg0NiAyMi4zMzA4TDIzLjY4MzggMjUuODMwNUMyMy44ODkgMjUuODk5IDI0LjExMSAyNS44OTkgMjQuMzE2MiAyNS44MzA1TDM0LjgxNTQgMjIuMzMwOEMzNS4zOTgyIDIyLjEzNjYgMzYgMjIuNTcwMyAzNiAyMy4xODQ2VjI0LjQ2MTlDMzYgMjUuMTA5NSAzNS41ODQ0IDI1LjY4MzkgMzQuOTY5MyAyNS44ODY2TDI0LjYyNTggMjkuMjk0QzI0LjIxOTMgMjkuNDI3OSAyMy43ODA3IDI5LjQyNzkgMjMuMzc0MiAyOS4yOTRMMTMuMDMwNyAyNS44ODY2QzEyLjQxNTYgMjUuNjgzOSAxMiAyNS4xMDk1IDEyIDI0LjQ2MTlWMjMuMTg0NloiIGZpbGw9IiMwMzJENjAiLz4KPC9zdmc+Cg==',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPE (Single Unified Config)
-- =====================================================

-- Unified IDP Configuration (combines OAuth + Basic Auth + Platform URLs)
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'idp:config',
    'IDP Connection',
    'Unified IDP connection configuration supporting both Runtime Services (OAuth) and Platform Services (Basic Auth)'
FROM connectors 
WHERE maven_artifact_id = 'mule-idp-connector';

-- =====================================================
-- 3. INSERT PROVIDER (Single Unified Provider)
-- =====================================================

-- Unified IDP Connection Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'idp-connection',
    'IDP Universal Connection',
    'Unified connection supporting OAuth (Runtime Services) and Basic Auth (Platform Services)'
FROM connector_config_types 
WHERE config_type_key = 'idp:config';

-- =====================================================
-- 4. INSERT CONFIG PARAMETERS (All-in-One Connection)
-- =====================================================

-- Unified IDP Connection Parameters (matching idp.xml structure)
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    param.api_name,
    param.display_name,
    param.description,
    CAST(param.data_type AS parameter_data_type),
    param.is_required,
    param.default_value,
    CAST(param.validation_rules AS jsonb),
    param.parameter_order
FROM config_providers cp
CROSS JOIN (
    VALUES
        ('organisationId', 'Organisation ID', 'Anypoint Platform Organization ID', 'String', true, NULL, '{}', 1),
        ('username', 'Username', 'Anypoint Platform username (for Platform Services)', 'String', true, NULL, '{}', 2),
        ('password', 'Password', 'Anypoint Platform password (for Platform Services)', 'String', true, NULL, '{"sensitive": true}', 3),
        ('serviceBaseUrl', 'Service Base URL', 'IDP Runtime Service base URL', 'String', true, 'https://idp-rt.us-east-1.anypoint.mulesoft.com', '{"enum": ["https://idp-rt.us-east-1.anypoint.mulesoft.com", "https://idp-rt.eu-central-1.anypoint.mulesoft.com"]}', 4),
        ('platformBaseUrl', 'Platform Base URL', 'Anypoint Platform base URL', 'String', true, 'https://anypoint.mulesoft.com', '{"enum": ["https://anypoint.mulesoft.com", "https://eu1.anypoint.mulesoft.com"]}', 5),
        ('clientId', 'OAuth Client ID', 'Connected App Client ID (for Runtime Services)', 'String', true, NULL, '{}', 6),
        ('clientSecret', 'OAuth Client Secret', 'Connected App Client Secret (for Runtime Services)', 'String', true, NULL, '{"sensitive": true}', 7),
        ('tokenUrl', 'OAuth Token URL', 'OAuth token URL for Connected App authentication', 'String', true, NULL, '{}', 8),
        ('scopes', 'OAuth Scopes', 'OAuth token URL/scopes for Connected App', 'String', false, NULL, '{}', 9)
) AS param(api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
WHERE cp.provider_key = 'idp-connection';

-- =====================================================
-- 5. INSERT OPERATIONS (RUNTIME SERVICES)
-- =====================================================

-- Operation 1: Submit Document for Processing
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:submit-execution',
    'Submit Document',
    'Submits a file for IDP processing using a specific document action and version. Supports both multipart/form-data and Base64 encoded files.',
    CAST('Execution' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api#submit-a-document-to-a-published-document-action',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 2: Retrieve Execution Results
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:retrieve-execution-result',
    'Get Execution Results',
    'Retrieves the state and result data of a specific document action execution. After a document action successfully processes a document, the results are available for consumption.',
    CAST('Execution' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api#retrieve-the-results-of-the-execution',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 3: List Review Tasks
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:list-review-tasks',
    'List Review Tasks',
    'Get a list of all executions requiring manual review, across actions, that the requesting user has permission to review.',
    CAST('Review' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 4: Get Review Task Details
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:retrieve-review-task',
    'Get Review Task',
    'Get a list of low-confidence fields by Execution ID. Use this to retrieve details of documents requiring manual review.',
    CAST('Review' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 5: Update Review Task
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:update-review-task',
    'Update Review Task',
    'Patch a list of low-confidence fields by Execution ID. Update review tasks without requiring a human in the loop (daemon process).',
    CAST('Review' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 6: Delete Review Task
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:delete-review-task',
    'Delete Review Task',
    'Delete a review task (Execution Status is updated as SUCCEEDED without changing the execution result). Useful for notifying reviewers or cleaning up completed reviews.',
    CAST('Review' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- =====================================================
-- 6. INSERT OPERATIONS (PLATFORM SERVICES)
-- =====================================================

-- Operation 7: List Actions
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:list-actions',
    'List Actions',
    'Retrieves a list of published IDP Actions within the specified organization from the Anypoint Platform. Useful for documentation and third-party integrations.',
    CAST('Platform' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 8: Get Action Details
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:get-action-details',
    'Get Action Details',
    'Retrieves high-level details for a specific IDP Action from the Anypoint Platform.',
    CAST('Platform' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    8,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 9: List Action Reviewers
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:list-action-reviewers',
    'List Action Reviewers',
    'Retrieves a list of users or teams assigned as reviewers for a specific IDP Action from the Anypoint Platform.',
    CAST('Platform' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    9,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 10: Update Action Reviewers
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:update-action-reviewers',
    'Update Action Reviewers',
    'Updates the list of users or teams assigned as reviewers for a specific IDP Action.',
    CAST('Platform' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    10,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 11: Get Action Version
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:get-action-version',
    'Get Action Version',
    'Retrieves detailed information for a specific version of an IDP Action from the Anypoint Platform.',
    CAST('Platform' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    11,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- Operation 12: List Action Versions
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'mule-idp:list-action-versions',
    'List Action Versions',
    'Retrieves a list of available versions for a specific IDP Action from the Anypoint Platform.',
    CAST('Platform' AS operation_category),
    ct.id,
    'https://docs.mulesoft.com/idp/automate-document-processing-with-the-idp-api',
    12,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND ct.config_type_key = 'idp:config';

-- =====================================================
-- 7. INSERT OPERATION PARAMETERS
-- =====================================================

-- Parameters for: Submit Document
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:submit-execution';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'versionSemantic',
    'Version',
    'The semantic version of the action (e.g., 1.2.0)',
    'String',
    true,
    NULL,
    '{"inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:submit-execution';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'fileContent',
    'File (Base64)',
    'Base64-encoded file content to process',
    'Base64',
    true,
    NULL,
    '{}',
    NULL,
    3
FROM operations 
WHERE operation_key = 'mule-idp:submit-execution';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'fileName',
    'File Name',
    'Name of the file being submitted, including extension (e.g., invoice.pdf)',
    'String',
    true,
    NULL,
    '{}',
    NULL,
    4
FROM operations 
WHERE operation_key = 'mule-idp:submit-execution';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'callbackUrl',
    'Callback URL',
    'Optional callback configuration to notify upon completion',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    5
FROM operations 
WHERE operation_key = 'mule-idp:submit-execution';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'headerXSfdcCoreTenantId',
    'Tenant ID (x-sfdc-core-tenant-id)',
    'Optional: Use a different Salesforce Org to execute your document actions',
    'String',
    false,
    NULL,
    '{}',
    NULL,
    6
FROM operations 
WHERE operation_key = 'mule-idp:submit-execution';

-- Parameters for: Retrieve Execution Results
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:retrieve-execution-result';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'versionSemantic',
    'Version',
    'The semantic version of the action (e.g., 1.2.0)',
    'String',
    true,
    NULL,
    '{"inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:retrieve-execution-result';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'executionId',
    'Execution ID',
    'The unique identifier (UUID) for a document processing execution',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    3
FROM operations 
WHERE operation_key = 'mule-idp:retrieve-execution-result';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'valueOnly',
    'Value Only',
    'Only keep the extracted value of the given field, remove confidenceScore and geometry from the response body',
    'Boolean',
    false,
    'true',
    '{}',
    4
FROM operations 
WHERE operation_key = 'mule-idp:retrieve-execution-result';

-- Parameters for: List Review Tasks
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'page',
    'Page',
    'Zero-based page index',
    'Number',
    false,
    '0',
    '{"min": 0}',
    1
FROM operations 
WHERE operation_key = 'mule-idp:list-review-tasks';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'size',
    'Size',
    'Number of items per page',
    'Number',
    false,
    '20',
    '{"min": 1}',
    2
FROM operations 
WHERE operation_key = 'mule-idp:list-review-tasks';

-- Parameters for: Get Review Task
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:retrieve-review-task';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'executionId',
    'Execution ID',
    'The unique identifier (UUID) for a document processing execution',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:retrieve-review-task';

-- Parameters for: Update Review Task
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:update-review-task';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'executionId',
    'Execution ID',
    'The unique identifier (UUID) for a document processing execution',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:update-review-task';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'contents',
    'Review Data',
    'Updated low-confidence fields data (DocumentActionLowConfidenceExecution JSON)',
    'JSON',
    true,
    NULL,
    '{}',
    3
FROM operations 
WHERE operation_key = 'mule-idp:update-review-task';

-- Parameters for: Delete Review Task
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:delete-review-task';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'executionId',
    'Execution ID',
    'The unique identifier (UUID) for a document processing execution',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:delete-review-task';

-- Parameters for: List Actions
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'page',
    'Page',
    'Zero-based page index',
    'Number',
    false,
    '0',
    '{"min": 0}',
    1
FROM operations 
WHERE operation_key = 'mule-idp:list-actions';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'size',
    'Size',
    'Number of items per page (max 100)',
    'Number',
    false,
    '20',
    '{"min": 1, "max": 100}',
    2
FROM operations 
WHERE operation_key = 'mule-idp:list-actions';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'sort',
    'Sort',
    'Sorting criteria (field,direction)',
    'String',
    false,
    'UPDATED_AT_DESC',
    '{"enum": ["UPDATED_AT_DESC", "UPDATED_AT_ASC", "NAME_DESC", "NAME_ASC", "TYPE_DESC", "TYPE_ASC"]}',
    3
FROM operations 
WHERE operation_key = 'mule-idp:list-actions';

-- Parameters for: Get Action Details
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:get-action-details';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'versionSemantic',
    'Version',
    'The semantic version of the action (optional)',
    'String',
    false,
    NULL,
    '{"inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:get-action-details';

-- Parameters for: List Action Reviewers
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:list-action-reviewers';

-- Parameters for: Update Action Reviewers
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:update-action-reviewers';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'contents',
    'Reviewers Data',
    'Updated reviewers list data (JSON array)',
    'JSON',
    true,
    NULL,
    '{}',
    2
FROM operations 
WHERE operation_key = 'mule-idp:update-action-reviewers';

-- Parameters for: Get Action Version
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:get-action-version';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'versionSemantic',
    'Version',
    'The specific semantic version of the action (e.g., 1.2.0)',
    'String',
    true,
    NULL,
    '{"inputType": "text"}',
    NULL,
    2
FROM operations 
WHERE operation_key = 'mule-idp:get-action-version';

-- Parameters for: List Action Versions
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'actionId',
    'Action ID',
    'The unique identifier (UUID) of the published Document Action',
    'String',
    true,
    NULL,
    '{"format": "uuid", "inputType": "text"}',
    NULL,
    1
FROM operations 
WHERE operation_key = 'mule-idp:list-action-versions';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'page',
    'Page',
    'Zero-based page index',
    'Number',
    false,
    '0',
    '{"min": 0}',
    2
FROM operations 
WHERE operation_key = 'mule-idp:list-action-versions';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'size',
    'Size',
    'Number of items per page (max 100)',
    'Number',
    false,
    '20',
    '{"min": 1, "max": 100}',
    3
FROM operations 
WHERE operation_key = 'mule-idp:list-action-versions';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'sort',
    'Sort',
    'Sorting criteria',
    'String',
    false,
    'VERSION_DESC',
    '{}',
    4
FROM operations 
WHERE operation_key = 'mule-idp:list-action-versions';


-- =====================================================
-- 8. INSERT RUNTIME CONFIGURATION (Single Unified Config)
-- =====================================================

-- Unified IDP Runtime Configuration
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    cct.id,
    cp.id,
    'IDP_Universal_Connection',
    'Unified IDP configuration supporting both Runtime Services (OAuth) and Platform Services (Basic Auth)',
    true
FROM config_providers cp
JOIN connector_config_types cct ON cp.config_type_id = cct.id
JOIN connectors c ON cct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule-idp-connector'
  AND cct.config_type_key = 'idp:config'
  AND cp.provider_key = 'idp-connection';

-- Insert runtime config values with property placeholders
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp_param.id,
    CASE cp_param.api_name
        WHEN 'organisationId' THEN '#[p('mulesoft.anypoint.idp.orgId')]'
        WHEN 'username' THEN '#[p('mulesoft.anypoint.idp.username')]'
        WHEN 'password' THEN '#[p('mulesoft.anypoint.idp.password')]'
        WHEN 'serviceBaseUrl' THEN '#[p('mulesoft.anypoint.idp.service.host')]'
        WHEN 'platformBaseUrl' THEN '#[p('mulesoft.anypoint.idp.platform.host')]'
        WHEN 'clientId' THEN '#[p('mulesoft.anypoint.idp.clientId')]'
        WHEN 'clientSecret' THEN '#[p('mulesoft.anypoint.idp.clientSecret')]'
        WHEN 'tokenUrl' THEN '#[p('mulesoft.anypoint.idp.tokenUrl')]'
        WHEN 'scopes' THEN '#[p('mulesoft.anypoint.idp.scopes')]'
    END,
    CASE cp_param.api_name
        WHEN 'password' THEN true
        WHEN 'clientSecret' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cp_param ON cp_param.provider_id = cp.id
WHERE rc.name = 'IDP_Universal_Connection'
  AND cp.provider_key = 'idp-connection';

-- =====================================================
-- END OF SEED FILE
-- =====================================================

