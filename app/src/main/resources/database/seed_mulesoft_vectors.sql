-- =====================================================
-- MULESOFT VECTORS CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the MuleSoft Vectors Connector 1.0
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - Configuration types (Embedding, Store, Transform)
-- - Providers for embeddings and vector stores
-- - Operations and parameters
-- - Placeholder runtime configuration
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-vectors-connector',
    'MuleSoft Vectors',
    '1.0.0',
    'AI',
    '**MuleSoft Vectors Connector** enables semantic search and Retrieval Augmented Generation (RAG) by connecting to vector databases and embedding models. Essential for building AI applications that understand meaning, not just keywords.

**What vectors enable:**
- **Semantic search** - Find documents by meaning, not exact keywords
- **RAG (Retrieval Augmented Generation)** - Ground LLM responses in your proprietary data
- **Similarity matching** - Find related products, documents, or customer profiles
- **Recommendation engines** - Suggest content based on semantic similarity

**Key capabilities:**
- **Embedding generation** - Convert text to vectors using OpenAI, Cohere, Google models
- **Vector storage** - Store/retrieve in Pinecone, Weaviate, Milvus, Qdrant, ChromaDB
- **Similarity search** - Find semantically similar content
- **Metadata filtering** - Combine vector search with traditional filters

**Use cases:** Customer support RAG, product discovery, document search, personalization.',
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTkgMThDMTMuOTcwNiAxOCAxOCAxMy45NzA2IDE4IDlDMTggNC4wMjk0NCAxMy45NzA2IDAgOSAwQzQuMDI5NDQgMCAwIDQuMDI5NDQgMCA5QzAgMTMuOTcwNiA0LjAyOTQ0IDE4IDkgMThaIiBmaWxsPSIjQ0ZFOUZFIi8+CjxwYXRoIGQ9Ik0xMi44NzQzIDkuNTA5MTRDMTMuMDMzOCA5Ljc1NDE5IDEzLjMwNDggOS45MTU5NiAxMy42MTE5IDkuOTE1OTZDMTQuMTAxNCA5LjkxNTk2IDE0LjUwMDEgOS41MDUwNiAxNC41MDAxIDlDMTQuNTAwMSA4LjQ5NDk0IDE0LjEwMTQgOC4wODQwNCAxMy42MTE5IDguMDg0MDRDMTMuMzA0OCA4LjA4NDA0IDEzLjAzNCA4LjI0NTU5IDEyLjg3NDMgOC40OTA2M0wxMC4zNzA0IDcuNjM4NjVMMTIuODc0MyA2Ljc4NjY4QzEzLjAzNCA3LjAzMTcyIDEzLjMwNDggNy4xOTMyNyAxMy42MTE5IDcuMTkzMjdDMTQuMTAxNCA3LjE5MzI3IDE0LjUwMDEgNi43ODIzNyAxNC41MDAxIDYuMjc3MzFDMTQuNTAwMSA1Ljc3MjI1IDE0LjEwMTQgNS4zNjEzNSAxMy42MTE5IDUuMzYxMzVDMTMuMzcwOCA1LjM2MTM1IDEzLjE1MjYgNS40NjE2MyAxMi45OTI0IDUuNjIyOTVMOS44NzEwNCA0LjczODA4QzkuNzkwMyA0LjMxNzg3IDkuNDMwNiA0IDkuMDAwMDYgNEM4LjU2OTMgNCA4LjIwOTgyIDQuMzE3ODcgOC4xMjkzIDQuNzM4MDhMNS4wMDkyNiA1LjYyNDMxQzQuODQ4ODggNS40NjIwOSA0LjYyOTk4IDUuMzYxMzUgNC4zODgyIDUuMzYxMzVDMy44OTg0OCA1LjM2MTM1IDMuNTAwMDYgNS43NzIyNSAzLjUwMDA2IDYuMjc3MzFDMy41MDAwNiA2Ljc4MjM3IDMuODk4NDggNy4xOTMyNyA0LjM4ODIgNy4xOTMyN0M0Ljc3MSA3LjE5MzI3IDUuMDk1MDYgNi45NDA3NCA1LjIxOTU4IDYuNTg5NzRMNy42OTE5NCA3LjYxNzMzTDUuMTI1ODYgOC40OTA2M0M0Ljk2NjM2IDguMjQ1NTkgNC42OTUzMiA4LjA4NDA0IDQuMzg4MiA4LjA4NDA0QzMuODk4NDggOC4wODQwNCAzLjUwMDA2IDguNDk0OTQgMy41MDAwNiA5QzMuNTAwMDYgOS41MDUwNiAzLjg5ODQ4IDkuOTE1OTYgNC4zODgyIDkuOTE1OTZDNC42OTUzMiA5LjkxNTk2IDQuOTY2MTQgOS43NTQxOSA1LjEyNTg2IDkuNTA5MTRMNy42Mjk5IDEwLjM2MTNMNS4xMjU4NiAxMS4yMTMzQzQuOTY2MTQgMTAuOTY4NSA0LjY5NTMyIDEwLjgwNjcgNC4zODgyIDEwLjgwNjdDMy44OTg0OCAxMC44MDY3IDMuNTAwMDYgMTEuMjE3NiAzLjUwMDA2IDExLjcyMjdDMy41MDAwNiAxMi4yMjc4IDMuODk4NDggMTIuNjM4NyA0LjM4ODIgMTIuNjM4N0M0LjYyOTMyIDEyLjYzODcgNC44NDc1NiAxMi41Mzg0IDUuMDA3OTQgMTIuMzc3TDguMTI5MyAxMy4yNjE3QzguMjA5ODIgMTMuNjgxOSA4LjU2OTMgMTQgOS4wMDAwNiAxNEM5LjQzMDYgMTQgOS43OTAzIDEzLjY4MTkgOS44NzA4MiAxMy4yNjE3TDEyLjk5MDYgMTIuMzc1NUMxMy4xNTEgMTIuNTM3OSAxMy4zNzAxIDEyLjYzODcgMTMuNjExOSAxMi42Mzg3QzE0LjEwMTQgMTIuNjM4NyAxNC41MDAxIDEyLjIyNzggMTQuNTAwMSAxMS43MjI3QzE0LjUwMDEgMTEuMjE3NiAxNC4xMDE0IDEwLjgwNjcgMTMuNjExOSAxMC44MDY3QzEzLjIyOTEgMTAuODA2NyAxMi45MDUxIDExLjA1OTMgMTIuNzgwNSAxMS40MUwxMC4zMDggMTAuMzgyNEwxMi44NzQzIDkuNTA5MTRaTTEyLjczOTQgMTEuODgyNEMxMi43NDQ1IDExLjkxMjYgMTIuNzUzIDExLjk0MTIgMTIuNzYxIDExLjk3MDJMOS44NDAyNCAxMi44QzkuNzIzNDIgMTIuNDM0NSA5LjM5MzIgMTIuMTY4MSA5LjAwMDI4IDEyLjE2ODFDOC42MDcxNCAxMi4xNjgxIDguMjc2OTIgMTIuNDM0NyA4LjE2MDMyIDEyLjhMNS4yMzg3MiAxMS45NzJDNS4yNjA3MiAxMS44OTIyIDUuMjc2MzQgMTEuODA5NiA1LjI3NjM0IDExLjcyMjdDNS4yNzYzNCAxMS42OTUyIDUuMjcwODQgMTEuNjY5NCA1LjI2ODQyIDExLjY0MjRMOC4xNjM2MiAxMC42NTcyQzguMjgzNzQgMTEuMDE2NiA4LjYxMTMyIDExLjI3NzEgOS4wMDAwNiAxMS4yNzcxQzkuMzgyODYgMTEuMjc3MSA5LjcwNjkyIDExLjAyNDUgOS44MzE0NCAxMC42NzM4TDEyLjczOTQgMTEuODgyNFpNNS4yNjg2NCA4LjkxOTkxTDguMTYzODQgNy45MzQ3NUM4LjI4Mzk2IDguMjkzOTIgOC42MTE1NCA4LjU1NDM5IDkuMDAwMjggOC41NTQzOUM5LjM4OTAyIDguNTU0MzkgOS43MTY2IDguMjkzOTIgOS44MzY3MiA3LjkzNDUyTDEyLjczMTkgOC45MTk2OEMxMi43Mjk1IDguOTQ2NDUgMTIuNzI0IDguOTcyMzIgMTIuNzI0IDguOTk5NzdDMTIuNzI0IDkuMDI3MjMgMTIuNzI5NSA5LjA1Mjg3IDEyLjczMTcgOS4wNzk2NEw5LjgzNjcyIDEwLjA2NUM5LjcxNjYgOS43MDU2MyA5LjM4OTAyIDkuNDQ1MTYgOS4wMDAyOCA5LjQ0NTE2QzguNjExNTQgOS40NDUxNiA4LjI4Mzk2IDkuNzA1NjMgOC4xNjM4NCAxMC4wNjVMNS4yNjg2NCA5LjA3OTY0QzUuMjcwODQgOS4wNTI4NyA1LjI3NjU2IDkuMDI3IDUuMjc2NTYgOC45OTk1NUM1LjI3NjU2IDguOTcyMDkgNS4yNzA4NCA4Ljk0NjkxIDUuMjY4NjQgOC45MTk5MVpNNS4yNjA3MiA2LjExNzU3QzUuMjU1NjYgNi4wODc0IDUuMjQ3MDggNi4wNTg4MSA1LjIzOTE2IDYuMDI5NzdMOC4xNTk4OCA1LjIwMDI1QzguMjc2NyA1LjU2NTc4IDguNjA2OTIgNS44MzIxNSA4Ljk5OTg0IDUuODMyMTVDOS4zOTI3NiA1LjgzMjE1IDkuNzIzMiA1LjU2NTc4IDkuODM5OCA1LjIwMDI1TDEyLjc2MSA2LjAyODQxQzEyLjczODcgNi4xMDgyNyAxMi43MjMzIDYuMTkwNjMgMTIuNzIzMyA2LjI3NzUzQzEyLjcyMzMgNi4zMDQ5OSAxMi43Mjg4IDYuMzMwODUgMTIuNzMxMyA2LjM1NzYzTDkuODM2MDYgNy4zNDI3OUM5LjcxNTk0IDYuOTgzMzkgOS4zODgzNiA2LjcyMjkyIDguOTk5NjIgNi43MjI5MkM4LjYxNjgyIDYuNzIyOTIgOC4yOTI3NiA2Ljk3NTQ1IDguMTY4MjQgNy4zMjY0NUw1LjI2MDcyIDYuMTE3NTdaIiBmaWxsPSIjMDE3NkQzIi8+Cjwvc3ZnPgo=',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPES
-- =====================================================

-- Embedding Config
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'ms-vectors:embedding-config',
    'Embedding Configuration',
    'Configuration for generating embeddings from text using various AI model providers'
FROM connectors 
WHERE maven_artifact_id = 'mule4-vectors-connector';

-- Store Config
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'ms-vectors:store-config',
    'Store Configuration',
    'Configuration for connecting to vector databases and stores'
FROM connectors 
WHERE maven_artifact_id = 'mule4-vectors-connector';

-- Transform Config
INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'ms-vectors:transform-config',
    'Transform Configuration',
    'Configuration for document parsing and text chunking operations'
FROM connectors 
WHERE maven_artifact_id = 'mule4-vectors-connector';

-- =====================================================
-- 3. INSERT PROVIDERS FOR EMBEDDING CONFIG
-- =====================================================

-- OpenAI Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'openai-connection',
    'OpenAI',
    'Generate embeddings using OpenAI models'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Einstein (Salesforce) Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'salesforce-connection',
    'Einstein',
    'Generate embeddings using Salesforce Einstein AI'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Azure OpenAI Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'azure-openai-connection',
    'Azure OpenAI',
    'Generate embeddings using Azure OpenAI models'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Azure AI Vision Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'azure-ai-vision-connection',
    'Azure AI Vision',
    'Generate embeddings using Azure AI Vision (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Hugging Face Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'huggingface-connection',
    'Hugging Face',
    'Generate embeddings using Hugging Face models (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Mistral AI Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'mistral-ai-connection',
    'Mistral AI',
    'Generate embeddings using Mistral AI models (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Nomic Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'nomic-connection',
    'Nomic',
    'Generate embeddings using Nomic models (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- Ollama Embedding Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'ollama-connection',
    'Ollama',
    'Generate embeddings using Ollama local models (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:embedding-config';

-- =====================================================
-- 4. INSERT PROVIDERS FOR STORE CONFIG
-- =====================================================

-- PGVector Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'pgvector-connection',
    'PGVector',
    'PostgreSQL with pgvector extension for vector storage (beta, not FIPS-compliant)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- Azure AI Search Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'aisearch-connection',
    'Azure AI Search',
    'Azure AI Search vector store (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- Chroma Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'chroma-connection',
    'Chroma',
    'Chroma vector database (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- Ephemeral File Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'ephemeral-file-connection',
    'Ephemeral File',
    'Temporary file-based vector store for testing (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- Milvus Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'milvus-connection',
    'Milvus',
    'Milvus vector database (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- MongoDB Atlas Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'mongodb-atlas-connection',
    'MongoDB Atlas',
    'MongoDB Atlas vector search (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- OpenSearch Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'opensearch-connection',
    'OpenSearch',
    'OpenSearch vector store (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- Pinecone Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'pinecone-connection',
    'Pinecone',
    'Pinecone vector database (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- Qdrant Store Provider
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'qdrant-connection',
    'Qdrant',
    'Qdrant vector database (beta)'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:store-config';

-- =====================================================
-- 5. INSERT PROVIDER FOR TRANSFORM CONFIG
-- =====================================================

-- Default Transform Provider (no external connection needed)
INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    id,
    'default-connection',
    'Default',
    'Default transform provider for document parsing and text chunking'
FROM connector_config_types 
WHERE config_type_key = 'ms-vectors:transform-config';

-- =====================================================
-- 6. INSERT CONFIG PARAMETERS FOR EMBEDDING PROVIDERS
-- =====================================================

-- OpenAI Embedding Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'apiKey',
    'API Key',
    'OpenAI API key for authentication',
    'String',
    true,
    NULL,
    '{"sensitive": true}',
    1
FROM config_providers 
WHERE provider_key = 'openai-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'timeout',
    'Timeout',
    'Timeout for the operation in milliseconds',
    'Number',
    false,
    '60000',
    '{"min": 1000}',
    2
FROM config_providers 
WHERE provider_key = 'openai-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

-- Einstein (Salesforce) Embedding Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'salesforceOrg',
    'Salesforce Org',
    'Salesforce organization URL',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'salesforce-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'clientId',
    'Client ID',
    'OAuth Client ID for Salesforce',
    'String',
    true,
    NULL,
    '{}',
    2
FROM config_providers 
WHERE provider_key = 'salesforce-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'clientSecret',
    'Client Secret',
    'OAuth Client Secret for Salesforce',
    'String',
    true,
    NULL,
    '{"sensitive": true}',
    3
FROM config_providers 
WHERE provider_key = 'salesforce-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'timeout',
    'Timeout',
    'Timeout for the operation in milliseconds',
    'Number',
    false,
    '60000',
    '{"min": 1000}',
    4
FROM config_providers 
WHERE provider_key = 'salesforce-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

-- Azure OpenAI Embedding Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'endpoint',
    'Endpoint',
    'Azure OpenAI endpoint URL',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'azure-openai-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'apiKey',
    'API Key',
    'Azure OpenAI API key',
    'String',
    true,
    NULL,
    '{"sensitive": true}',
    2
FROM config_providers 
WHERE provider_key = 'azure-openai-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'apiVersion',
    'API Version',
    'Azure OpenAI API version',
    'String',
    true,
    NULL,
    '{}',
    3
FROM config_providers 
WHERE provider_key = 'azure-openai-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'timeout',
    'Timeout',
    'Timeout for the operation in milliseconds',
    'Number',
    false,
    '60000',
    '{"min": 1000}',
    4
FROM config_providers 
WHERE provider_key = 'azure-openai-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config');

-- =====================================================
-- 7. INSERT CONFIG PARAMETERS FOR STORE PROVIDERS
-- =====================================================

-- PGVector Store Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'host',
    'Host',
    'PostgreSQL database host',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'pgvector-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'port',
    'Port',
    'PostgreSQL database port',
    'Number',
    true,
    '5432',
    '{"min": 1, "max": 65535}',
    2
FROM config_providers 
WHERE provider_key = 'pgvector-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'database',
    'Database',
    'PostgreSQL database name',
    'String',
    true,
    NULL,
    '{}',
    3
FROM config_providers 
WHERE provider_key = 'pgvector-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'user',
    'User',
    'PostgreSQL database username',
    'String',
    true,
    NULL,
    '{}',
    4
FROM config_providers 
WHERE provider_key = 'pgvector-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'password',
    'Password',
    'PostgreSQL database password',
    'String',
    true,
    NULL,
    '{"sensitive": true}',
    5
FROM config_providers 
WHERE provider_key = 'pgvector-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

-- Azure AI Search Store Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'url',
    'URL',
    'Azure AI Search service URL',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'aisearch-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'apiKey',
    'API Key',
    'Azure AI Search API key',
    'String',
    true,
    NULL,
    '{"sensitive": true}',
    2
FROM config_providers 
WHERE provider_key = 'aisearch-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

-- Chroma Store Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'url',
    'URL',
    'Chroma server URL',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'chroma-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

-- Ephemeral File Store Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'workingDirectory',
    'Working Directory',
    'Directory for creating store files',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'ephemeral-file-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

-- Pinecone Store Parameters
INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'cloud',
    'Cloud',
    'Cloud provider for Pinecone',
    'String',
    true,
    NULL,
    '{}',
    1
FROM config_providers 
WHERE provider_key = 'pinecone-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'region',
    'Region',
    'Region for Pinecone',
    'String',
    true,
    NULL,
    '{}',
    2
FROM config_providers 
WHERE provider_key = 'pinecone-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

INSERT INTO config_parameters (provider_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'apiKey',
    'API Key',
    'Pinecone API key',
    'String',
    true,
    NULL,
    '{"sensitive": true}',
    3
FROM config_providers 
WHERE provider_key = 'pinecone-connection' 
AND config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config');

-- =====================================================
-- 8. INSERT OPERATIONS WITH REQUIRED CONFIG TYPES
-- =====================================================

-- Operation 1: [Embedding] Generate from text
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:embedding-generate-from-text',
    '[Embedding] Generate from text',
    'Generates embeddings from a given text string. The text can optionally be segmented before embedding for better semantic search results.',
    'Embedding'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-embedding-operations#configure-the-embedding-generate-from-text-operation',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:embedding-config';

-- Operation 2: [Store] Add
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:store-add',
    '[Store] Add',
    'Adds embeddings and text segments to the vector store. Used for ingesting documents and data into the vector database.',
    'Store'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-store-operations#configure-the-store-add-operation',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:store-config';

-- Operation 3: [Store] Query
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:query',
    '[Store] Query',
    'Queries an embedding store based on the provided embedding and text segment. Supports metadata filtering for precise retrieval.',
    'Store'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-store-operations#configure-the-store-query-operation',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:store-config';

-- Operation 4: [Store] Query all
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:query-all',
    '[Store] Query all',
    'Lists all sources in the specified embedding store. Useful for browsing and managing stored embeddings.',
    'Store'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-store-operations#configure-the-store-query-all-operation',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:store-config';

-- Operation 5: [Store] Remove
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:store-remove',
    '[Store] Remove',
    'Removes embeddings from the store based on IDs or metadata filter. Supports cleanup and data management operations.',
    'Store'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-store-operations#configure-the-store-remove-operation',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:store-config';

-- Operation 6: [Transform] Chunk text
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:transform-chunk-text',
    '[Transform] Chunk text',
    'Chunks the provided text into multiple segments based on maximum segment size and overlap. Prepares text for embedding generation.',
    'Transform'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-transform-operations#configure-the-transform-chunk-text-operation',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:transform-config';

-- Operation 7: [Transform] Parse document
INSERT INTO operations (connector_id, operation_key, display_name, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'ms-vectors:transform-parse-document',
    '[Transform] Parse document',
    'Parses a document from raw binary or Base64-encoded content. Extracts text from various document formats (PDF, DOCX, etc.).',
    'Transform'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/mulesoft-vectors-connector/latest/configuring-transform-operations#configure-the-transform-parse-document-operation',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
  AND ct.config_type_key = 'ms-vectors:transform-config';

-- =====================================================
-- 9. INSERT OPERATION PARAMETERS
-- =====================================================

-- Parameters for: [Embedding] Generate from text
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'texts',
    'Input Texts',
    'Input list of texts to generate embeddings from (must be a JSON array)',
    'JSON',
    true,
    NULL,
    '{"itemType": "string"}',
    '["In the modern world, technological advancements have become essential for businesses"]',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:embedding-generate-from-text';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'modelName',
    'Model (Deployment) Name',
    'Embedding model (deployment) name to use. For Einstein models see: @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html',
    'String',
    true,
    'text-embedding-3-large',
    '{"enum": ["sfdc_ai__DefaultAzureOpenAITextEmbeddingAda_002", "sfdc_ai__DefaultOpenAITextEmbeddingAda_002", "text-embedding-3-large", "text-embedding-3-small", "text-embedding-ada-002"]}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:embedding-generate-from-text';

-- Parameters for: [Store] Add
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'storeName',
    'Store Name',
    'Name of the vector store collection to add embeddings to',
    'String',
    true,
    NULL,
    '{}',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:store-add';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'textSegmentsAndEmbeddings',
    'Text Segments and Embeddings',
    'Text segments and embeddings to add to the store (typically output from Generate from text)',
    'JSON',
    true,
    NULL,
    '{}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:store-add';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, example_value, parameter_order)
SELECT 
    id,
    'metadataEntries',
    'Metadata Entries',
    'Custom metadata key-value pairs to add to the vector store',
    'JSON',
    false,
    NULL,
    '{}',
    '{"index":"0","source":"s3://ms-vectors/invoicesample.pdf","file_type":"any","file_name":"invoicesample.pdf"}',
    3
FROM operations 
WHERE operation_key = 'ms-vectors:store-add';

-- Parameters for: [Store] Query
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'storeName',
    'Store Name',
    'Name of the vector store collection to query',
    'String',
    true,
    NULL,
    '{}',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:query';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'textSegmentsAndEmbeddings',
    'Text Segment and Embedding',
    'Text segment and embedding to use for querying (must have only one element)',
    'JSON',
    true,
    NULL,
    '{}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:query';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'maxResults',
    'Max Results',
    'Maximum number of results (text segments) to retrieve',
    'Number',
    true,
    '5',
    '{"min": 1}',
    3
FROM operations 
WHERE operation_key = 'ms-vectors:query';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'minScore',
    'Min Score',
    'Minimum score used to filter retrieved results (0-1)',
    'Number',
    true,
    '0.7',
    '{"min": 0, "max": 1}',
    4
FROM operations 
WHERE operation_key = 'ms-vectors:query';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'metadataConditions',
    'Metadata Condition',
    'SQL-like condition for filtering results (e.g., index=1 AND CONTAINS(file_name,''example.pdf''))',
    'String',
    false,
    NULL,
    '{}',
    5
FROM operations 
WHERE operation_key = 'ms-vectors:query';

-- Parameters for: [Store] Query all
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'storeName',
    'Store Name',
    'Name of the vector store collection to query',
    'String',
    true,
    NULL,
    '{}',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:query-all';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'retrieveEmbeddings',
    'Retrieve Embeddings',
    'Flag to indicate whether embeddings should be retrieved',
    'Boolean',
    false,
    'false',
    '{}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:query-all';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'pageSize',
    'Page Size',
    'Page size used when querying the vector store',
    'Number',
    false,
    '5000',
    '{"min": 1}',
    3
FROM operations 
WHERE operation_key = 'ms-vectors:query-all';

-- Parameters for: [Store] Remove
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'storeName',
    'Store Name',
    'Name of the vector store collection to remove embeddings from',
    'String',
    true,
    NULL,
    '{}',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:store-remove';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'ids',
    'IDs',
    'List of embedding IDs to remove',
    'JSON',
    false,
    NULL,
    '{"itemType": "string"}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:store-remove';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'metadataCondition',
    'Metadata Condition',
    'SQL-like condition for filtering embeddings to remove (e.g., file_name=''example.pdf'')',
    'String',
    false,
    NULL,
    '{}',
    3
FROM operations 
WHERE operation_key = 'ms-vectors:store-remove';

-- Parameters for: [Transform] Chunk text
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'text',
    'Text',
    'Input text to chunk into segments',
    'String',
    true,
    NULL,
    '{}',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:transform-chunk-text';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'maxSegmentSize',
    'Max Segment Size (Characters)',
    'Maximum size of a segment in characters',
    'Number',
    true,
    '1000',
    '{"min": 100}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:transform-chunk-text';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'maxOverlapSize',
    'Max Overlap Size (Characters)',
    'Maximum overlap between segments in characters',
    'Number',
    true,
    '100',
    '{"min": 0}',
    3
FROM operations 
WHERE operation_key = 'ms-vectors:transform-chunk-text';

-- Parameters for: [Transform] Parse document
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'document',
    'Document Binary',
    'Raw binary or Base64-encoded content of the document to parse',
    'Base64',
    true,
    NULL,
    '{}',
    1
FROM operations 
WHERE operation_key = 'ms-vectors:transform-parse-document';

INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'documentParser',
    'Document Parser',
    'Document parser type to use',
    'String',
    true,
    'multiformat',
    '{"enum": ["multiformat", "text"]}',
    2
FROM operations 
WHERE operation_key = 'ms-vectors:transform-parse-document';

-- Conditional parameter for multiformat: includeMetadata
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'includeMetadata',
    'Include Metadata',
    'Include document metadata in the output',
    'Boolean',
    false,
    'false',
    '{"conditional": {"parentParameter": "documentParser", "showWhen": "multiformat"}}',
    3
FROM operations 
WHERE operation_key = 'ms-vectors:transform-parse-document';

-- Conditional parameter for text: textDocumentParser
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'textDocumentParser',
    'Text Document Parser',
    'Text parser configuration to use',
    'String',
    false,
    NULL,
    '{"conditional": {"parentParameter": "documentParser", "showWhen": "text"}}',
    4
FROM operations 
WHERE operation_key = 'ms-vectors:transform-parse-document';

-- Conditional parameter for text: name
INSERT INTO operation_parameters (operation_id, api_name, display_name, description, data_type, is_required, default_value, validation_rules, parameter_order)
SELECT 
    id,
    'name',
    'Name',
    'Name for the text document',
    'String',
    false,
    NULL,
    '{"conditional": {"parentParameter": "documentParser", "showWhen": "text"}}',
    5
FROM operations 
WHERE operation_key = 'ms-vectors:transform-parse-document';

-- =====================================================
-- 10. INSERT RUNTIME CONFIGURATIONS
-- =====================================================

-- Runtime Config 1: OpenAI Embedding
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    cct.id,
    cp.id,
    'OpenAI Embedding',
    'OpenAI embedding configuration (text-embedding-3-large)',
    true
FROM config_providers cp
JOIN connector_config_types cct ON cp.config_type_id = cct.id
JOIN connectors c ON cct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
AND cct.config_type_key = 'ms-vectors:embedding-config'
AND cp.provider_key = 'openai-connection';

-- Add config values for OpenAI runtime config
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp_param.id,
    CASE 
        WHEN cp_param.api_name = 'apiKey' THEN '#[p('openai.apiKey')]'
        WHEN cp_param.api_name = 'timeout' THEN '60000'
    END,
    CASE cp_param.api_name
        WHEN 'apiKey' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cp_param ON cp_param.provider_id = cp.id
WHERE cp.provider_key = 'openai-connection'
AND cp.config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config')
AND cp_param.api_name IN ('apiKey', 'timeout');

-- Runtime Config 2: Einstein (Salesforce) Embedding
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    cct.id,
    cp.id,
    'Einstein Embedding',
    'Salesforce Einstein embedding configuration',
    true
FROM config_providers cp
JOIN connector_config_types cct ON cp.config_type_id = cct.id
JOIN connectors c ON cct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
AND cct.config_type_key = 'ms-vectors:embedding-config'
AND cp.provider_key = 'salesforce-connection';

-- Add config values for Einstein runtime config
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp_param.id,
    CASE 
        WHEN cp_param.api_name = 'salesforceOrg' THEN '#[p('salesforce.einstein.salesforceOrg')]'
        WHEN cp_param.api_name = 'clientId' THEN '#[p('salesforce.einstein.clientId')]'
        WHEN cp_param.api_name = 'clientSecret' THEN '#[p('salesforce.einstein.clientSecret')]'
        WHEN cp_param.api_name = 'timeout' THEN '60000'
    END,
    CASE cp_param.api_name
        WHEN 'clientSecret' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cp_param ON cp_param.provider_id = cp.id
WHERE cp.provider_key = 'salesforce-connection'
AND cp.config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:embedding-config')
AND cp_param.api_name IN ('salesforceOrg', 'clientId', 'clientSecret', 'timeout');

-- Runtime Config 3: PGVector Store
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    cct.id,
    cp.id,
    'PGVector Store',
    'PostgreSQL with pgvector extension for vector storage',
    true
FROM config_providers cp
JOIN connector_config_types cct ON cp.config_type_id = cct.id
JOIN connectors c ON cct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
AND cct.config_type_key = 'ms-vectors:store-config'
AND cp.provider_key = 'pgvector-connection';

-- Add config values for PGVector runtime config
INSERT INTO runtime_config_values (runtime_config_id, parameter_id, parameter_value, is_encrypted)
SELECT 
    rc.id,
    cp_param.id,
    CASE 
        WHEN cp_param.api_name = 'host' THEN '#[p('postgresql.host')]'
        WHEN cp_param.api_name = 'port' THEN '#[p('postgresql.port')]'
        WHEN cp_param.api_name = 'database' THEN '#[p('postgresql.database')]'
        WHEN cp_param.api_name = 'user' THEN '#[p('postgresql.user')]'
        WHEN cp_param.api_name = 'password' THEN '#[p('postgresql.password')]'
    END,
    CASE cp_param.api_name
        WHEN 'password' THEN true
        ELSE false
    END
FROM runtime_configurations rc
JOIN config_providers cp ON rc.provider_id = cp.id
JOIN config_parameters cp_param ON cp_param.provider_id = cp.id
WHERE cp.provider_key = 'pgvector-connection'
AND cp.config_type_id IN (SELECT id FROM connector_config_types WHERE config_type_key = 'ms-vectors:store-config')
AND cp_param.api_name IN ('host', 'port', 'database', 'user', 'password');

-- Runtime Config 4: Default Transform
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    cct.id,
    cp.id,
    'Default Transform',
    'Default transform configuration for document parsing and text chunking',
    true
FROM config_providers cp
JOIN connector_config_types cct ON cp.config_type_id = cct.id
JOIN connectors c ON cct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-vectors-connector'
AND cct.config_type_key = 'ms-vectors:transform-config'
AND cp.provider_key = 'default-connection';

-- =====================================================
-- END OF SEED FILE
-- =====================================================
