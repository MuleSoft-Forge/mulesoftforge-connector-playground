-- =====================================================
-- MULESOFT CONNECTOR PLAYGROUND - DATABASE SCHEMA
-- =====================================================
-- PostgreSQL database schema for MuleSoftForge Connector Playground
--
-- Database: mule_connector_playground
--
-- IDEMPOTENT: This script drops and recreates all objects
-- Includes execution tracking tables and stored procedures
-- =====================================================

-- Drop existing tables (in reverse dependency order)
DROP TABLE IF EXISTS api_access_log CASCADE;
DROP TABLE IF EXISTS execution_errors CASCADE;
DROP TABLE IF EXISTS execution_archives CASCADE;
DROP TABLE IF EXISTS execution_logs CASCADE;
DROP TABLE IF EXISTS runtime_config_values CASCADE;
DROP TABLE IF EXISTS runtime_configurations CASCADE;
DROP TABLE IF EXISTS config_parameters CASCADE;
DROP TABLE IF EXISTS config_providers CASCADE;
DROP TABLE IF EXISTS connector_config_types CASCADE;
DROP TABLE IF EXISTS operation_parameters CASCADE;
DROP TABLE IF EXISTS operations CASCADE;
DROP TABLE IF EXISTS connectors CASCADE;

-- Drop existing enums
DROP TYPE IF EXISTS connector_category CASCADE;
DROP TYPE IF EXISTS operation_category CASCADE;
DROP TYPE IF EXISTS parameter_data_type CASCADE;
DROP TYPE IF EXISTS execution_status CASCADE;

-- Drop existing functions
DROP FUNCTION IF EXISTS update_updated_at_column() CASCADE;
DROP FUNCTION IF EXISTS sp_log_execution_start(INTEGER, INTEGER, JSONB, VARCHAR, TEXT) CASCADE;
DROP FUNCTION IF EXISTS sp_log_execution_complete(UUID, JSONB, INTEGER, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS sp_log_execution_error(UUID, VARCHAR, TEXT, VARCHAR, TEXT, TEXT, INTEGER, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS sp_get_execution_history(INTEGER, INTEGER, VARCHAR, VARCHAR, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE, INTEGER, INTEGER) CASCADE;
DROP FUNCTION IF EXISTS sp_get_execution_detail CASCADE;
DROP FUNCTION IF EXISTS sp_get_execution_stats(INTEGER, INTEGER, TIMESTAMP WITH TIME ZONE, TIMESTAMP WITH TIME ZONE) CASCADE;

-- =====================================================
-- 1. CREATE ENUMS
-- =====================================================

-- Connector categories
CREATE TYPE connector_category AS ENUM (
  'AI'
);

COMMENT ON TYPE connector_category IS 'Categories for connectors (AI, Database, SaaS, etc.)';

-- Operation categories
CREATE TYPE operation_category AS ENUM (
  'Agent',
  'Chat',
  'Embedding',
  'RAG',
  'Store',
  'Transform',
  'Tools',
  'Resources',
  'Image',
  'Vision',
  'Moderation',
  'Text',
  'General',
  'Service',
  'Execution',
  'Review',
  'Platform',
  'Core Operations',
  'Task Management',
  'Push Notifications'
);

COMMENT ON TYPE operation_category IS 'Categories for operations to group functionality';

-- Parameter data types
CREATE TYPE parameter_data_type AS ENUM (
  'String',
  'Number',
  'Boolean',
  'Base64',
  'JSON'
);

COMMENT ON TYPE parameter_data_type IS 'Data types for operation and configuration parameters';

-- Execution status
CREATE TYPE execution_status AS ENUM (
  'started',
  'success',
  'error',
  'timeout'
);

COMMENT ON TYPE execution_status IS 'Status of connector operation execution';

-- =====================================================
-- 2. CREATE CORE TABLES
-- =====================================================

-- Main connector registry
CREATE TABLE connectors (
    id SERIAL PRIMARY KEY,
    maven_artifact_id VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    version VARCHAR(50) NOT NULL,
    category connector_category NOT NULL,
    description TEXT,
    doc_url VARCHAR(500),
    icon TEXT,
    is_active BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE connectors IS 'Main registry of MuleSoft AI connectors';
COMMENT ON COLUMN connectors.maven_artifact_id IS 'Maven artifact ID - primary business key';
COMMENT ON COLUMN connectors.version IS 'Connector version (e.g., 1.2, 1.0)';
COMMENT ON COLUMN connectors.category IS 'Connector category (AI, Database, SaaS, etc.)';
COMMENT ON COLUMN connectors.is_active IS 'Whether connector is active and available for use';

-- Operations per connector
CREATE TABLE operations (
    id SERIAL PRIMARY KEY,
    connector_id INTEGER NOT NULL REFERENCES connectors(id) ON DELETE CASCADE,
    display_name VARCHAR(255) NOT NULL,
    operation_key VARCHAR(255) NOT NULL,
    description TEXT,
    category operation_category NOT NULL,
    required_config_type_id INTEGER,
    help_url VARCHAR(500),
    operation_order INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(connector_id, operation_key)
);

COMMENT ON TABLE operations IS 'Operations available for each connector';
COMMENT ON COLUMN operations.operation_key IS 'XML operation key (e.g., ms-einstein-ai:chat-answer-prompt)';
COMMENT ON COLUMN operations.required_config_type_id IS 'Required configuration type for this operation';
COMMENT ON COLUMN operations.operation_order IS 'Display order for operations within a connector';

-- Input parameters for operations
CREATE TABLE operation_parameters (
    id SERIAL PRIMARY KEY,
    operation_id INTEGER NOT NULL REFERENCES operations(id) ON DELETE CASCADE,
    api_name VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    data_type parameter_data_type NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT false,
    default_value TEXT,
    description TEXT,
    validation_rules JSONB,
    example_value TEXT,
    parameter_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(operation_id, api_name)
);

COMMENT ON TABLE operation_parameters IS 'Input parameters for each operation';
COMMENT ON COLUMN operation_parameters.api_name IS 'Parameter name used in API calls';
COMMENT ON COLUMN operation_parameters.validation_rules IS 'JSON schema for validation (enums, min/max, patterns)';
COMMENT ON COLUMN operation_parameters.parameter_order IS 'Display order in UI forms';

-- =====================================================
-- 3. CREATE CONFIG METADATA TABLES
-- =====================================================

-- Configuration types required by operations
CREATE TABLE connector_config_types (
    id SERIAL PRIMARY KEY,
    connector_id INTEGER NOT NULL REFERENCES connectors(id) ON DELETE CASCADE,
    config_type_key VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(connector_id, config_type_key)
);

COMMENT ON TABLE connector_config_types IS 'Configuration types supported by connectors (e.g., text-generation-config)';
COMMENT ON COLUMN connector_config_types.config_type_key IS 'Configuration type key representing the XML element (e.g., text-generation-config, image-generation-config)';

-- Providers that support each config type
CREATE TABLE config_providers (
    id SERIAL PRIMARY KEY,
    config_type_id INTEGER NOT NULL REFERENCES connector_config_types(id) ON DELETE CASCADE,
    provider_key VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(config_type_id, provider_key)
);

COMMENT ON TABLE config_providers IS 'Providers that support each configuration type (e.g., OpenAI, Azure, Anthropic)';
COMMENT ON COLUMN config_providers.provider_key IS 'Provider key (e.g., OpenAI, Azure, Anthropic)';

-- Parameters needed by each provider
CREATE TABLE config_parameters (
    id SERIAL PRIMARY KEY,
    provider_id INTEGER NOT NULL REFERENCES config_providers(id) ON DELETE CASCADE,
    api_name VARCHAR(255) NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    data_type parameter_data_type NOT NULL,
    is_required BOOLEAN NOT NULL DEFAULT false,
    default_value TEXT,
    description TEXT,
    validation_rules JSONB,
    parameter_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(provider_id, api_name)
);

COMMENT ON TABLE config_parameters IS 'Configuration parameters required by each provider';
COMMENT ON COLUMN config_parameters.api_name IS 'Parameter name used in configuration';
COMMENT ON COLUMN config_parameters.validation_rules IS 'JSON schema for validation';

-- =====================================================
-- 4. CREATE RUNTIME CONFIG TABLES
-- =====================================================

-- Named runtime configurations
CREATE TABLE runtime_configurations (
    id SERIAL PRIMARY KEY,
    config_type_id INTEGER NOT NULL REFERENCES connector_config_types(id) ON DELETE CASCADE,
    provider_id INTEGER NOT NULL REFERENCES config_providers(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    is_active BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(config_type_id, provider_id, name)
);

COMMENT ON TABLE runtime_configurations IS 'Runtime configuration instances (named configs with actual values)';
COMMENT ON COLUMN runtime_configurations.name IS 'Configuration name used in UI and as Mule XML config-ref (e.g., Jeffcock_OpenAI, Production_OpenAI, Dev_Salesforce)';
COMMENT ON COLUMN runtime_configurations.provider_id IS 'ID of the provider for this runtime configuration (e.g., OpenAI, Azure OpenAI)';
COMMENT ON COLUMN runtime_configurations.is_active IS 'Whether this config is active and can be used';

-- Actual configuration values for each runtime config
CREATE TABLE runtime_config_values (
    id SERIAL PRIMARY KEY,
    runtime_config_id INTEGER NOT NULL REFERENCES runtime_configurations(id) ON DELETE CASCADE,
    parameter_id INTEGER NOT NULL REFERENCES config_parameters(id) ON DELETE CASCADE,
    parameter_value TEXT,
    is_encrypted BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(runtime_config_id, parameter_id)
);

COMMENT ON TABLE runtime_config_values IS 'Actual parameter values for runtime configurations';
COMMENT ON COLUMN runtime_config_values.parameter_value IS 'Actual value (encrypted if is_encrypted=true)';
COMMENT ON COLUMN runtime_config_values.is_encrypted IS 'Whether this value is encrypted';

-- =====================================================
-- 5. CREATE EXECUTION TRACKING TABLES
-- =====================================================

-- Main execution log table (normalized)
CREATE TABLE execution_logs (
    id SERIAL PRIMARY KEY,
    execution_id UUID NOT NULL UNIQUE DEFAULT gen_random_uuid(),
    operation_id INTEGER REFERENCES operations(id) ON DELETE SET NULL,
    runtime_config_id INTEGER REFERENCES runtime_configurations(id) ON DELETE SET NULL,
    connector_id INTEGER REFERENCES connectors(id) ON DELETE SET NULL,
    maven_artifact_id VARCHAR(255),
    operation_key VARCHAR(255),
    status execution_status NOT NULL,
    execution_started_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    execution_completed_at TIMESTAMP WITH TIME ZONE,
    duration_ms INTEGER,
    http_status_code INTEGER,
    source_ip VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE execution_logs IS 'Main execution tracking table with normalized fields';
COMMENT ON COLUMN execution_logs.execution_id IS 'Unique UUID for this execution instance';
COMMENT ON COLUMN execution_logs.operation_id IS 'Foreign key to operations (SET NULL on delete to preserve history)';
COMMENT ON COLUMN execution_logs.runtime_config_id IS 'Foreign key to runtime_configurations (SET NULL on delete)';
COMMENT ON COLUMN execution_logs.connector_id IS 'Foreign key to connectors (SET NULL on delete)';
COMMENT ON COLUMN execution_logs.maven_artifact_id IS 'Denormalized for quick filtering even if connector deleted';
COMMENT ON COLUMN execution_logs.operation_key IS 'Denormalized operation key for filtering';
COMMENT ON COLUMN execution_logs.status IS 'Execution status: started, success, error, timeout';
COMMENT ON COLUMN execution_logs.execution_started_at IS 'When execution began';
COMMENT ON COLUMN execution_logs.execution_completed_at IS 'When execution completed (NULL if still running)';
COMMENT ON COLUMN execution_logs.duration_ms IS 'Duration in milliseconds';
COMMENT ON COLUMN execution_logs.http_status_code IS 'HTTP status code returned';
COMMENT ON COLUMN execution_logs.source_ip IS 'Client IP address (supports IPv6)';
COMMENT ON COLUMN execution_logs.user_agent IS 'Client user agent string';

-- Full JSON archive table
CREATE TABLE execution_archives (
    id SERIAL PRIMARY KEY,
    execution_id UUID NOT NULL UNIQUE REFERENCES execution_logs(execution_id) ON DELETE CASCADE,
    request_payload JSONB NOT NULL,
    response_payload JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE execution_archives IS 'Full request/response JSON payloads for executions';
COMMENT ON COLUMN execution_archives.execution_id IS 'Foreign key to execution_logs (CASCADE delete)';
COMMENT ON COLUMN execution_archives.request_payload IS 'Complete request payload as JSONB';
COMMENT ON COLUMN execution_archives.response_payload IS 'Complete response payload as JSONB (NULL until execution completes)';

-- Error details table
CREATE TABLE execution_errors (
    id SERIAL PRIMARY KEY,
    execution_id UUID NOT NULL REFERENCES execution_logs(execution_id) ON DELETE CASCADE,
    error_type VARCHAR(255),
    error_code VARCHAR(255),
    error_message TEXT NOT NULL,
    error_description TEXT,
    stack_trace TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE execution_errors IS 'Detailed error information for failed executions';
COMMENT ON COLUMN execution_errors.execution_id IS 'Foreign key to execution_logs (CASCADE delete)';
COMMENT ON COLUMN execution_errors.error_type IS 'Mule error type identifier';
COMMENT ON COLUMN execution_errors.error_code IS 'Error code or namespace';
COMMENT ON COLUMN execution_errors.error_message IS 'Human-readable error message';
COMMENT ON COLUMN execution_errors.error_description IS 'Detailed error description';
COMMENT ON COLUMN execution_errors.stack_trace IS 'Stack trace if available';

-- API Access Log (for Client ID monitoring)
CREATE TABLE api_access_log (
    id SERIAL PRIMARY KEY,
    client_id VARCHAR(255) NOT NULL DEFAULT 'unknown',
    endpoint VARCHAR(500) NOT NULL,
    method VARCHAR(10) NOT NULL,
    source_ip VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE api_access_log IS 'Lightweight log of all API access by client_id';
COMMENT ON COLUMN api_access_log.client_id IS 'Client ID from Basic Auth header, or "unknown" if not authenticated';
COMMENT ON COLUMN api_access_log.endpoint IS 'API endpoint path (e.g., /connectors, /execute)';
COMMENT ON COLUMN api_access_log.method IS 'HTTP method (GET, POST, PUT, DELETE)';
COMMENT ON COLUMN api_access_log.source_ip IS 'Client IP address';
COMMENT ON COLUMN api_access_log.user_agent IS 'Client user agent string';
COMMENT ON COLUMN api_access_log.timestamp IS 'When the API call was made';

-- =====================================================
-- 6. CREATE INDEXES
-- =====================================================

-- Connectors
CREATE INDEX idx_connectors_maven_artifact_id ON connectors(maven_artifact_id);
CREATE INDEX idx_connectors_is_active ON connectors(is_active);
CREATE INDEX idx_connectors_category ON connectors(category);

-- Operations
CREATE INDEX idx_operations_connector_id ON operations(connector_id);
CREATE INDEX idx_operations_is_active ON operations(is_active);
CREATE INDEX idx_operations_category ON operations(category);
CREATE INDEX idx_operations_config_type_id ON operations(required_config_type_id);

-- Operation Parameters
CREATE INDEX idx_operation_parameters_operation_id ON operation_parameters(operation_id);
CREATE INDEX idx_operation_parameters_is_required ON operation_parameters(is_required);

-- Config Types
CREATE INDEX idx_connector_config_types_connector_id ON connector_config_types(connector_id);

-- Config Providers
CREATE INDEX idx_config_providers_config_type_id ON config_providers(config_type_id);

-- Config Parameters
CREATE INDEX idx_config_parameters_provider_id ON config_parameters(provider_id);
CREATE INDEX idx_config_parameters_is_required ON config_parameters(is_required);

-- Runtime Configurations
CREATE INDEX idx_runtime_configurations_config_type_id ON runtime_configurations(config_type_id);
CREATE INDEX idx_runtime_configurations_provider_id ON runtime_configurations(provider_id);
CREATE INDEX idx_runtime_configurations_is_active ON runtime_configurations(is_active);

-- Runtime Config Values
CREATE INDEX idx_runtime_config_values_runtime_config_id ON runtime_config_values(runtime_config_id);
CREATE INDEX idx_runtime_config_values_parameter_id ON runtime_config_values(parameter_id);

-- Execution Logs
CREATE INDEX idx_execution_logs_operation_started ON execution_logs(operation_id, execution_started_at DESC);
CREATE INDEX idx_execution_logs_connector_status ON execution_logs(connector_id, status, execution_started_at DESC);
CREATE INDEX idx_execution_logs_maven_artifact ON execution_logs(maven_artifact_id, execution_started_at DESC);
CREATE INDEX idx_execution_logs_status ON execution_logs(status, execution_started_at DESC);
CREATE INDEX idx_execution_logs_execution_id ON execution_logs(execution_id);
CREATE INDEX idx_execution_logs_started_at ON execution_logs(execution_started_at DESC);

-- Execution Errors
CREATE INDEX idx_execution_errors_execution_id ON execution_errors(execution_id);
CREATE INDEX idx_execution_errors_error_type ON execution_errors(error_type);

-- API Access Log
CREATE INDEX idx_api_access_client_id ON api_access_log(client_id);
CREATE INDEX idx_api_access_timestamp ON api_access_log(timestamp DESC);
CREATE INDEX idx_api_access_client_timestamp ON api_access_log(client_id, timestamp DESC);

-- =====================================================
-- 7. CREATE TRIGGERS FOR updated_at TIMESTAMPS
-- =====================================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column() RETURNS TRIGGER AS 'BEGIN NEW.updated_at = CURRENT_TIMESTAMP; RETURN NEW; END;' LANGUAGE plpgsql;

COMMENT ON FUNCTION update_updated_at_column() IS 'Automatically updates the updated_at column to the current timestamp';

-- =====================================================
-- 8. CREATE EXECUTION TRACKING STORED PROCEDURES
-- =====================================================

-- sp_log_execution_start: Logs the start of a connector operation execution and returns execution_id
CREATE OR REPLACE FUNCTION sp_log_execution_start(p_operation_id INTEGER, p_runtime_config_id INTEGER, p_request_payload JSONB, p_source_ip VARCHAR DEFAULT NULL, p_user_agent TEXT DEFAULT NULL) RETURNS UUID LANGUAGE plpgsql AS 'DECLARE v_execution_id UUID; v_connector_id INTEGER; v_maven_artifact_id VARCHAR(255); v_operation_key VARCHAR(255); BEGIN SELECT o.connector_id, c.maven_artifact_id, o.operation_key INTO v_connector_id, v_maven_artifact_id, v_operation_key FROM operations o JOIN connectors c ON c.id = o.connector_id WHERE o.id = p_operation_id; INSERT INTO execution_logs (operation_id, runtime_config_id, connector_id, maven_artifact_id, operation_key, status, source_ip, user_agent) VALUES (p_operation_id, p_runtime_config_id, v_connector_id, v_maven_artifact_id, v_operation_key, CAST(''started'' AS execution_status), p_source_ip, p_user_agent) RETURNING execution_id INTO v_execution_id; INSERT INTO execution_archives (execution_id, request_payload) VALUES (v_execution_id, p_request_payload); RETURN v_execution_id; EXCEPTION WHEN OTHERS THEN RAISE EXCEPTION ''Failed to log execution start: %'', SQLERRM; END;';

COMMENT ON FUNCTION sp_log_execution_start IS 'Logs the start of a connector operation execution and returns execution_id';

-- sp_log_execution_complete: Logs successful completion of an execution
CREATE OR REPLACE FUNCTION sp_log_execution_complete(p_execution_id UUID, p_response_payload JSONB, p_http_status_code INTEGER, p_duration_ms INTEGER) RETURNS VOID LANGUAGE plpgsql AS 'BEGIN UPDATE execution_logs SET status = CAST(''success'' AS execution_status), execution_completed_at = CURRENT_TIMESTAMP, duration_ms = p_duration_ms, http_status_code = p_http_status_code WHERE execution_id = p_execution_id; UPDATE execution_archives SET response_payload = p_response_payload WHERE execution_id = p_execution_id; EXCEPTION WHEN OTHERS THEN RAISE EXCEPTION ''Failed to log execution complete: %'', SQLERRM; END;';

COMMENT ON FUNCTION sp_log_execution_complete IS 'Logs successful completion of a connector operation execution';

-- sp_log_execution_error: Logs failed execution with error details
CREATE OR REPLACE FUNCTION sp_log_execution_error(p_execution_id UUID, p_error_type VARCHAR, p_error_message TEXT, p_error_code VARCHAR DEFAULT NULL, p_error_description TEXT DEFAULT NULL, p_stack_trace TEXT DEFAULT NULL, p_duration_ms INTEGER DEFAULT NULL, p_http_status_code INTEGER DEFAULT 500) RETURNS VOID LANGUAGE plpgsql AS 'BEGIN UPDATE execution_logs SET status = CAST(''error'' AS execution_status), execution_completed_at = CURRENT_TIMESTAMP, duration_ms = p_duration_ms, http_status_code = p_http_status_code WHERE execution_id = p_execution_id; INSERT INTO execution_errors (execution_id, error_type, error_code, error_message, error_description, stack_trace) VALUES (p_execution_id, p_error_type, p_error_code, p_error_message, p_error_description, p_stack_trace); EXCEPTION WHEN OTHERS THEN RAISE EXCEPTION ''Failed to log execution error: %'', SQLERRM; END;';

COMMENT ON FUNCTION sp_log_execution_error IS 'Logs failed execution with error details';

-- sp_get_execution_history: Retrieves execution history with filtering and pagination
CREATE OR REPLACE FUNCTION sp_get_execution_history(p_operation_id INTEGER DEFAULT NULL, p_connector_id INTEGER DEFAULT NULL, p_maven_artifact_id VARCHAR DEFAULT NULL, p_status VARCHAR DEFAULT NULL, p_start_date TIMESTAMP WITH TIME ZONE DEFAULT NULL, p_end_date TIMESTAMP WITH TIME ZONE DEFAULT NULL, p_limit INTEGER DEFAULT 100, p_offset INTEGER DEFAULT 0) RETURNS TABLE (execution_id UUID, operation_id INTEGER, operation_key VARCHAR, connector_id INTEGER, connector_name VARCHAR, maven_artifact_id VARCHAR, runtime_config_id INTEGER, runtime_config_name VARCHAR, status execution_status, execution_started_at TIMESTAMP WITH TIME ZONE, execution_completed_at TIMESTAMP WITH TIME ZONE, duration_ms INTEGER, http_status_code INTEGER, source_ip VARCHAR) LANGUAGE plpgsql AS 'BEGIN RETURN QUERY SELECT el.execution_id, el.operation_id, el.operation_key, el.connector_id, c.name AS connector_name, el.maven_artifact_id, el.runtime_config_id, rc.name AS runtime_config_name, el.status, el.execution_started_at, el.execution_completed_at, el.duration_ms, el.http_status_code, el.source_ip FROM execution_logs el LEFT JOIN connectors c ON c.id = el.connector_id LEFT JOIN runtime_configurations rc ON rc.id = el.runtime_config_id WHERE (p_operation_id IS NULL OR el.operation_id = p_operation_id) AND (p_connector_id IS NULL OR el.connector_id = p_connector_id) AND (p_maven_artifact_id IS NULL OR el.maven_artifact_id = p_maven_artifact_id) AND (p_status IS NULL OR el.status = CAST(p_status AS execution_status)) AND (p_start_date IS NULL OR el.execution_started_at >= p_start_date) AND (p_end_date IS NULL OR el.execution_started_at <= p_end_date) ORDER BY el.execution_started_at DESC LIMIT p_limit OFFSET p_offset; EXCEPTION WHEN OTHERS THEN RAISE EXCEPTION ''Failed to get execution history: %'', SQLERRM; END;';

COMMENT ON FUNCTION sp_get_execution_history IS 'Retrieves execution history with filtering and pagination';

-- sp_get_execution_detail: Retrieves complete execution details including full JSON
CREATE OR REPLACE FUNCTION sp_get_execution_detail(p_execution_id UUID) RETURNS TABLE(execution_id UUID, operation_id INTEGER, operation_key VARCHAR, operation_name VARCHAR, connector_id INTEGER, connector_name VARCHAR, maven_artifact_id VARCHAR, runtime_config_id INTEGER, runtime_config_name VARCHAR, status VARCHAR, execution_started_at TIMESTAMP WITH TIME ZONE, execution_completed_at TIMESTAMP WITH TIME ZONE, duration_ms INTEGER, http_status_code INTEGER, source_ip VARCHAR, user_agent TEXT, request_payload JSONB, response_payload JSONB, error_type VARCHAR, error_message TEXT, error_code VARCHAR, error_description TEXT, created_at TIMESTAMP WITH TIME ZONE, updated_at TIMESTAMP WITH TIME ZONE) LANGUAGE sql AS 'SELECT el.execution_id, el.operation_id, el.operation_key, o.display_name as operation_name, el.connector_id, c.name as connector_name, el.maven_artifact_id, el.runtime_config_id, rc.name as runtime_config_name, el.status::VARCHAR, el.execution_started_at, el.execution_completed_at, el.duration_ms, el.http_status_code, el.source_ip, el.user_agent, ea.request_payload, ea.response_payload, ee.error_type, ee.error_message, ee.error_code, ee.error_description, el.created_at, el.updated_at FROM execution_logs el LEFT JOIN execution_archives ea ON ea.execution_id = el.execution_id LEFT JOIN execution_errors ee ON ee.execution_id = el.execution_id LEFT JOIN operations o ON o.id = el.operation_id LEFT JOIN connectors c ON c.id = el.connector_id LEFT JOIN runtime_configurations rc ON rc.id = el.runtime_config_id WHERE el.execution_id = p_execution_id;';

COMMENT ON FUNCTION sp_get_execution_detail IS 'Retrieves complete execution details including request/response JSON';

-- sp_get_execution_stats: Retrieves aggregated execution statistics
CREATE OR REPLACE FUNCTION sp_get_execution_stats(p_operation_id INTEGER DEFAULT NULL, p_connector_id INTEGER DEFAULT NULL, p_start_date TIMESTAMP WITH TIME ZONE DEFAULT NULL, p_end_date TIMESTAMP WITH TIME ZONE DEFAULT NULL) RETURNS JSONB LANGUAGE plpgsql AS 'DECLARE v_result JSONB; v_total_executions INTEGER; v_success_count INTEGER; v_error_count INTEGER; v_timeout_count INTEGER; v_success_rate NUMERIC; v_avg_duration INTEGER; v_min_duration INTEGER; v_max_duration INTEGER; v_error_breakdown JSONB; BEGIN SELECT COUNT(*), COUNT(*) FILTER (WHERE status = ''success''), COUNT(*) FILTER (WHERE status = ''error''), COUNT(*) FILTER (WHERE status = ''timeout'') INTO v_total_executions, v_success_count, v_error_count, v_timeout_count FROM execution_logs WHERE (p_operation_id IS NULL OR operation_id = p_operation_id) AND (p_connector_id IS NULL OR connector_id = p_connector_id) AND (p_start_date IS NULL OR execution_started_at >= p_start_date) AND (p_end_date IS NULL OR execution_started_at <= p_end_date); IF v_total_executions > 0 THEN v_success_rate := ROUND((v_success_count::NUMERIC / v_total_executions::NUMERIC) * 100, 2); ELSE v_success_rate := 0; END IF; SELECT ROUND(AVG(duration_ms))::INTEGER, MIN(duration_ms), MAX(duration_ms) INTO v_avg_duration, v_min_duration, v_max_duration FROM execution_logs WHERE duration_ms IS NOT NULL AND (p_operation_id IS NULL OR operation_id = p_operation_id) AND (p_connector_id IS NULL OR connector_id = p_connector_id) AND (p_start_date IS NULL OR execution_started_at >= p_start_date) AND (p_end_date IS NULL OR execution_started_at <= p_end_date); SELECT COALESCE(jsonb_agg(jsonb_build_object(''errorType'', ee.error_type, ''count'', error_count, ''percentage'', ROUND((error_count::NUMERIC / v_error_count::NUMERIC) * 100, 2))), ''[]''::jsonb) INTO v_error_breakdown FROM (SELECT ee.error_type, COUNT(*) as error_count FROM execution_errors ee JOIN execution_logs el ON el.execution_id = ee.execution_id WHERE (p_operation_id IS NULL OR el.operation_id = p_operation_id) AND (p_connector_id IS NULL OR el.connector_id = p_connector_id) AND (p_start_date IS NULL OR el.execution_started_at >= p_start_date) AND (p_end_date IS NULL OR el.execution_started_at <= p_end_date) GROUP BY ee.error_type ORDER BY error_count DESC) ee; v_result := jsonb_build_object(''totalExecutions'', v_total_executions, ''successCount'', v_success_count, ''errorCount'', v_error_count, ''timeoutCount'', v_timeout_count, ''successRate'', v_success_rate, ''avgDurationMs'', v_avg_duration, ''minDurationMs'', v_min_duration, ''maxDurationMs'', v_max_duration, ''errorBreakdown'', v_error_breakdown, ''dateRange'', jsonb_build_object(''startDate'', p_start_date, ''endDate'', p_end_date)); RETURN v_result; EXCEPTION WHEN OTHERS THEN RAISE EXCEPTION ''Failed to get execution stats: %'', SQLERRM; END;';

COMMENT ON FUNCTION sp_get_execution_stats IS 'Retrieves aggregated execution statistics with error breakdown';

-- Trigger for connectors table
CREATE TRIGGER update_connectors_updated_at
    BEFORE UPDATE ON connectors
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for operations table
CREATE TRIGGER update_operations_updated_at
    BEFORE UPDATE ON operations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for operation_parameters table
CREATE TRIGGER update_operation_parameters_updated_at
    BEFORE UPDATE ON operation_parameters
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for connector_config_types table
CREATE TRIGGER update_connector_config_types_updated_at
    BEFORE UPDATE ON connector_config_types
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for config_providers table
CREATE TRIGGER update_config_providers_updated_at
    BEFORE UPDATE ON config_providers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for config_parameters table
CREATE TRIGGER update_config_parameters_updated_at
    BEFORE UPDATE ON config_parameters
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for runtime_configurations table
CREATE TRIGGER update_runtime_configurations_updated_at
    BEFORE UPDATE ON runtime_configurations
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for runtime_config_values table
CREATE TRIGGER update_runtime_config_values_updated_at
    BEFORE UPDATE ON runtime_config_values
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Trigger for execution_logs table
CREATE TRIGGER update_execution_logs_updated_at
    BEFORE UPDATE ON execution_logs
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- =====================================================
-- SCHEMA CREATION COMPLETE
-- =====================================================

SELECT '✅ Schema created successfully with auto-increment primary keys!' AS status;
SELECT 
    'Tables created: ' || COUNT(*) AS summary
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE';
