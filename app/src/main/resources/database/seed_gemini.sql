-- Google Gemini Connector Seed File
-- Maven Artifact ID: gemini-anypoint-connector-model
-- Version: 1.0.0

-- Insert connector
INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'gemini-anypoint-connector-model',
    'Google Gemini',
    '1.0.0',
    'AI',
    'Connect to Google Gemini AI. Perform tasks like generate content, get model information, and list available models.',
    'https://docs.mulesoft.com/google-gemini-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyBpZD0iaWNvbiIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB2aWV3Qm94PSIwIDAgMTYgMTYiPgogICAgPHBhdGggZD0iTTE2IDguMDE2QTguNTIyIDguNTIyIDAgMDA4LjAxNiAxNmgtLjAzMkE4LjUyMSA4LjUyMSAwIDAwMCA4LjAxNnYtLjAzMkE4LjUyMSA4LjUyMSAwIDAwNy45ODQgMGguMDMyQTguNTIyIDguNTIyIDAgMDAxNiA3Ljk4NHYuMDMyeiIgZmlsbD0idXJsKCNwcmVmaXhfX3BhaW50MF9yYWRpYWxfOTgwXzIwMTQ3KSIvPgogICAgPGRlZnM+CiAgICAgICAgPHJhZGlhbEdyYWRpZW50IGlkPSJwcmVmaXhfX3BhaW50MF9yYWRpYWxfOTgwXzIwMTQ3IiBjeD0iMCIgY3k9IjAiIHI9IjEiIGdyYWRpZW50VW5pdHM9InVzZXJTcGFjZU9uVXNlIiBncmFkaWVudFRyYW5zZm9ybT0ibWF0cml4KDE2LjEzMjYgNS40NTUzIC00My43MDA0NSAxMjkuMjMyMiAxLjU4OCA2LjUwMykiPgogICAgICAgICAgICA8c3RvcCBvZmZzZXQ9Ii4wNjciIHN0b3AtY29sb3I9IiM5MTY4QzAiLz4KICAgICAgICAgICAgPHN0b3Agb2Zmc2V0PSIuMzQzIiBzdG9wLWNvbG9yPSIjNTY4NEQxIi8+CiAgICAgICAgICAgIDxzdG9wIG9mZnNldD0iLjY3MiIgc3RvcC1jb2xvcj0iIzFCQTFFMyIvPgogICAgICAgIDwvcmFkaWFsR3JhZGllbnQ+CiAgICA8L2RlZnM+Cjwvc3ZnPgo=',
    true
);

-- Insert config type
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT id, 'gemini:config', 'Gemini Config', 'Configuration for Google Gemini connector'
FROM connectors WHERE maven_artifact_id = 'gemini-anypoint-connector-model';

-- Insert config provider (API Key connection)
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT id, 'gemini:api-key-connection', 'API Key Connection', 'Authenticate using Google AI API Key'
FROM connector_config_types WHERE config_type_key = 'gemini:config';

-- Insert config parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, data_type, is_required, default_value, description, parameter_order)
SELECT 
    id, 
    'apiKey', 
    'API Key', 
    'String', 
    true, 
    NULL, 
    'Google AI API Key for authentication. Get your key from https://aistudio.google.com/app/apikey', 
    1 
FROM config_providers WHERE provider_key = 'gemini:api-key-connection';

INSERT INTO config_parameters (provider_id, api_name, display_name, data_type, is_required, default_value, description, parameter_order)
SELECT 
    id, 
    'baseUri', 
    'Base URI', 
    'String', 
    true, 
    'https://generativelanguage.googleapis.com/v1beta', 
    'Base URI for the Google Gemini API', 
    2 
FROM config_providers WHERE provider_key = 'gemini:api-key-connection';

-- Insert runtime configuration
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Gemini Connection (Default)',
    'Default Google Gemini API configuration. Provides access to Gemini models for content generation.',
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'gemini-anypoint-connector-model'
  AND ct.config_type_key = 'gemini:config'
  AND cp.provider_key = 'gemini:api-key-connection';

-- Insert runtime config values
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp.id,
    CASE cp.api_name
        WHEN 'apiKey' THEN '${google.gemini.apiKey}'
        WHEN 'baseUri' THEN '${google.gemini.baseUri}'
    END,
    CASE cp.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN connector_config_types ct ON rc.config_type_id = ct.id
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers prov ON prov.config_type_id = ct.id
JOIN config_parameters cp ON cp.provider_id = prov.id
WHERE c.maven_artifact_id = 'gemini-anypoint-connector-model'
  AND rc.name = 'Gemini Connection (Default)';

-- Operation 1: List Models
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id, 
    'gemini:list-models', 
    '[Model] List Models', 
    'List all available Gemini models and their capabilities', 
    'General'::operation_category,
    ct.id,
    'https://ai.google.dev/api/models#method:-models.list',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'gemini-anypoint-connector-model'
  AND ct.config_type_key = 'gemini:config';

-- Operation 2: Get Model
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id, 
    'gemini:get-model', 
    '[Model] Get Model', 
    'Get information about a specific Gemini model including capabilities and limits', 
    'General'::operation_category,
    ct.id,
    'https://ai.google.dev/api/models#method:-models.get',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'gemini-anypoint-connector-model'
  AND ct.config_type_key = 'gemini:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, example_value, parameter_order)
SELECT id, 'modelName', 'Model Name', 'The name of the model to retrieve (e.g., gemini-2.0-flash)', 'String', true, 'gemini-2.0-flash', 'gemini-2.0-flash', 1
FROM operations WHERE operation_key = 'gemini:get-model';

-- Operation 3: Generate Content
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id, 
    'gemini:generate-content', 
    '[Chat] Generate Content', 
    'Generate text content using Google Gemini models with multimodal input support', 
    'Chat'::operation_category,
    ct.id,
    'https://ai.google.dev/api/generate-content#endpoint',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'gemini-anypoint-connector-model'
  AND ct.config_type_key = 'gemini:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, example_value, parameter_order)
SELECT id, 'modelName', 'Model Name', 'The Gemini model to use (e.g., gemini-2.0-flash, gemini-2.0-flash-thinking-exp, gemini-2.5-flash)', 'String', true, 'gemini-2.0-flash', 'gemini-2.0-flash', 1
FROM operations WHERE operation_key = 'gemini:generate-content';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, example_value, parameter_order)
SELECT 
    id, 
    'body', 
    'Request Body', 
    'Generate content request with contents array, generation config, and safety settings', 
    'JSON', 
    true, 
    '{}',
    '{"contents": [{"role": "user", "parts": [{"text": "Explain how AI works"}]}], "generationConfig": {"temperature": 0.7, "maxOutputTokens": 1000}}',
    2
FROM operations WHERE operation_key = 'gemini:generate-content';

-- No parameters for list-models operation
