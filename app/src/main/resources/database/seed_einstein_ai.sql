-- =====================================================
-- EINSTEIN AI CONNECTOR SEED DATA
-- =====================================================
-- This script populates the database with metadata for
-- the Einstein AI Connector 1.2
--
-- GUI-FRIENDLY: No psql-specific commands
-- Can be run in pgAdmin, DBeaver, DataGrip, etc.
--
-- Includes:
-- - Connector metadata
-- - Configuration types and providers
-- - Operations and parameters (9 operations)
-- - Runtime configuration with real credentials
-- =====================================================

-- =====================================================
-- 1. INSERT CONNECTOR
-- =====================================================

INSERT INTO connectors (maven_artifact_id, name, version, category, description, doc_url, icon, is_active)
VALUES (
    'mule4-einstein-ai-connector',
    'Einstein AI',
    '1.2.1',
    'AI',
    '**Salesforce Einstein Trust Layer** provides enterprise-grade governance, security, and observability for LLM interactions. The **MuleSoft Einstein AI Connector** gives developers access to multiple LLM models through a unified, secure interface.

**Key capabilities:**
- **Multi-model access** - Use OpenAI, Anthropic, Cohere, Google, Amazon models
- **Trust Layer protection** - Data masking, toxicity detection, prompt injection prevention, audit logging
- **Chat completions** - Build conversational AI with streaming support
- **Vector embeddings** - Generate embeddings for semantic search and RAG

**Use cases:** AI agents, RAG applications, content generation, semantic search.',
    'https://docs.mulesoft.com/einstein-ai-connector/latest/',
    'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPGcgY2xpcC1wYXRoPSJ1cmwoI2NsaXAwXzc5XzE2OSkiPgo8cGF0aCBkPSJNOSAxOEMxMy45NzA2IDE4IDE4IDEzLjk3MDYgMTggOUMxOCA0LjAyOTQ0IDEzLjk3MDYgMCA5IDBDNC4wMjk0NCAwIDAgNC4wMjk0NCAwIDlDMCAxMy45NzA2IDQuMDI5NDQgMTggOSAxOFoiIGZpbGw9IiNDRkU5RkUiLz4KPHBhdGggZD0iTTcuNTk0NzMgMTEuNjE0NUM3Ljg2MTUyIDExLjYxNDUgOC4wNzc3OSAxMS4zMDEzIDguMDc3NzkgMTAuOTE0OUM4LjA3Nzc5IDEwLjUyODYgNy44NjE1MiAxMC4yMTU0IDcuNTk0NzMgMTAuMjE1NEM3LjMyNzk1IDEwLjIxNTQgNy4xMTE2OCAxMC41Mjg2IDcuMTExNjggMTAuOTE0OUM3LjExMTY4IDExLjMwMTMgNy4zMjc5NSAxMS42MTQ1IDcuNTk0NzMgMTEuNjE0NVoiIGZpbGw9IiMwMTc2RDMiLz4KPHBhdGggZD0iTTEwLjU1NjkgMTEuNjE0NUMxMC44MjM3IDExLjYxNDUgMTEuMDQgMTEuMzAxMyAxMS4wNCAxMC45MTQ5QzExLjA0IDEwLjUyODYgMTAuODIzNyAxMC4yMTU0IDEwLjU1NjkgMTAuMjE1NEMxMC4yOTAxIDEwLjIxNTQgMTAuMDczOSAxMC41Mjg2IDEwLjA3MzkgMTAuOTE0OUMxMC4wNzM5IDExLjMwMTMgMTAuMjkwMSAxMS42MTQ1IDEwLjU1NjkgMTEuNjE0NVoiIGZpbGw9IiMwMTc2RDMiLz4KPHBhdGggZD0iTTExLjM5MDggMTMuMDIwNEMxMS4xNTcxIDEyLjgxNzYgMTAuNTg2MyAxMi4zODM3IDkuODEwNjcgMTIuMTk3OEM5LjY4NDc0IDEyLjM4OTkgOS40MjcyMyAxMi41MjE4IDkuMTI5NjMgMTIuNTIxOEM4LjgzMjAzIDEyLjUyMTggOC41NTg4NiAxMi4zODE4IDguNDM3MzIgMTIuMTgwOEM3Ljk2MzAzIDEyLjI4MzggNy40NTQ5MiAxMi41MTA1IDYuOTI5MjYgMTIuOTE5OUM2Ljc5ODMyIDEzLjAyMTYgNi43MTE4NiAxMy4xODE4IDYuNzEyNDggMTMuMzU0NEM2LjcxMjQ4IDE0LjQ5NDggNy44OTM0OSAxMy41NzMgOS4wNzMyNCAxMy41OTE4QzEwLjI3OTMgMTMuNjExMyAxMS41NDU1IDE0LjQwNjIgMTEuNTQ1NSAxMy4zNzM5QzExLjU1MyAxMy4yMzc2IDExLjQ5MDQgMTMuMTA3NyAxMS4zOTA4IDEzLjAyMVYxMy4wMjA0WiIgZmlsbD0iIzAxNzZEMyIvPgo8cGF0aCBkPSJNNy4xNjYyMiAxNC4wMjUxQzcuMDI5NjQgMTQuMDI1MSA2LjkxMjQ3IDEzLjk5NjIgNi44MTcyNCAxMy45MjI3QzYuNjc5NDEgMTMuODE2IDYuNjEyOTkgMTMuNjMwMSA2LjYxMjk5IDEzLjM1MzJDNi42MTIzNyAxMy4xNTczIDYuNzA3NiAxMi45NjUxIDYuODY4NjIgMTIuODM5NUM3LjM2NjA4IDEyLjQ1MjEgNy44ODY3MyAxMi4xOTcyIDguNDE2NzcgMTIuMDgyM0M4LjQ1ODEyIDEyLjA3MjggOC41MDEzNSAxMi4wOTE3IDguNTIzMjggMTIuMTI4MUM4LjYzMTA0IDEyLjMwNTggOC44NjkxMyAxMi40MjEzIDkuMTI5NzYgMTIuNDIxM0M5LjM5MDQgMTIuNDIxMyA5LjYxNjU3IDEyLjMxMjEgOS43Mjc0NyAxMi4xNDI1QzkuNzUwNjUgMTIuMTA3NCA5Ljc5MzI1IDEyLjA5MDQgOS44MzM5OCAxMi4xMDA1QzEwLjY0MjggMTIuMjk0NSAxMS4yMzggMTIuNzU1NCAxMS40NTYxIDEyLjk0NUMxMS41ODMyIDEzLjA1NTUgMTEuNjU0IDEzLjIxNzUgMTEuNjQ1MyAxMy4zNzg5QzExLjY0NTMgMTMuNjEzMSAxMS41ODI2IDEzLjc4MDIgMTEuNDUyOSAxMy44ODQ0QzExLjE5NzkgMTQuMDg5MSAxMC43NDQzIDEzLjk4NjggMTAuMjE5MyAxMy44Njg3QzkuODYzNDMgMTMuNzg4MyA5LjQ1OTk0IDEzLjY5NzkgOS4wNzE0OSAxMy42OTE2QzguNjcwNTIgMTMuNjg1NCA4LjI2ODI4IDEzLjc5MTUgNy45MTE3OSAxMy44ODVDNy42MjM1OSAxMy45NjA0IDcuMzcyMzUgMTQuMDI2MyA3LjE2NTU5IDE0LjAyNjNMNy4xNjYyMiAxNC4wMjUxWk04LjM5MzU5IDEyLjI5MjZDNy45MTU1NSAxMi40MDc1IDcuNDQzNzcgMTIuNjQ0OSA2Ljk5MDc5IDEyLjk5NzhDNi44Nzg2NCAxMy4wODUxIDYuODExNiAxMy4yMTgyIDYuODEyMjMgMTMuMzUyNkM2LjgxMjIzIDEzLjU2MzUgNi44NTM1OCAxMy42OTg1IDYuOTM4NzkgMTMuNzY0NUM3LjEwMDQzIDEzLjg5MDEgNy40NTMxNyAxMy43OTcxIDcuODYxMDQgMTMuNjkwNEM4LjIzMDA3IDEzLjU5MzcgOC42NDY3MSAxMy40ODI1IDkuMDc0NjMgMTMuNDkwN0M5LjQ4Mzc1IDEzLjQ5NzYgOS44OTc4OSAxMy41OTA1IDEwLjI2MzIgMTMuNjcyOEMxMC43MzgxIDEzLjc3OTUgMTEuMTQ3OCAxMy44NzE4IDExLjMyODMgMTMuNzI3NEMxMS40MDcyIDEzLjY2NCAxMS40NDYgMTMuNTQ3OCAxMS40NDYgMTMuMzcyNkMxMS40NTE3IDEzLjI2NzIgMTEuNDA2NiAxMy4xNjYxIDExLjMyNTcgMTMuMDk1N0MxMS4xMjQgMTIuOTIxMiAxMC41ODQ2IDEyLjUwMjMgOS44NTE1MiAxMi4zMTA4QzkuNjkzMDEgMTIuNTA0MiA5LjQyMzYgMTIuNjIxNiA5LjEyOTc2IDEyLjYyMTZDOC44MzU5MiAxMi42MjE2IDguNTQ5NiAxMi40OTczIDguMzkzNTkgMTIuMjkzMlYxMi4yOTI2WiIgZmlsbD0iIzAxNzZEMyIvPgo8cGF0aCBkPSJNNS42NDc0NSAxMy4zODIxQzQuNjcyNTcgMTMuOTUxIDMuNzgxMDIgMTMuNDY2OCAzLjQ0MzMyIDEzLjIxNzVDNC4wMTIyMSAxMi44MjU3IDQuMjA3NjkgMTIuNjg4MiA0LjIzMzM4IDEyLjM5NjJDMy40NjA4NyAxMi40MjUxIDIuODkzODYgMTIuMzU5OCAyLjE0NzAzIDExLjA5MzlDMi45MjM5MyAxMC44NjQ3IDIuNzQ5NzUgMTAuNjkwOCA0LjAyMTYxIDEwLjI3ODlDMy45ODY1MiAxMC4wNTcyIDIuOTk0MSAxMC4yMDE2IDIuNjQ1NzUgOS44NDgwOUMyLjk0ODk5IDkuNjI1MTggMy4yNzY2NiA4LjY3NzY0IDMuNjIgOC41MjM4QzMuMjAyNzMgOC41Mjg4MiAyLjc4NTQ3IDguNTMzODQgMi4zNjgyIDguNTM5NDlDMi42MTEyOSA3LjcwNjIzIDMuMzU0OTggNi45Njk2OCA0LjA5MjQxIDYuNTEzMTdDMy45NzkgNi4zNjMxIDMuNjU4ODUgNi4yMzA2MSAzLjUwNzIzIDYuMTE5NDZDNC4wMzc5IDUuNjE1ODcgNS4zMzU0NCA1LjI1Nzk1IDUuODc4MDEgNS42NzExMkM1Ljc5NDY5IDQuMzQzNjkgNi44OTY3NSAzLjk4NTE0IDYuODg3MzUgMy4wMjk0M0M3LjQ1MjQ4IDMuMjAyNzQgOC4yODA3NSAzLjk1Mzc0IDguNDA2NjggNC41MzI2OUM4Ljc3MzgzIDQuMDc0OTMgOS45NDc5NSAzLjYxNzggMTAuNjY2NiAzLjQzNjMzQzEwLjkzMTYgMy41NjM4IDExLjEwMzkgMy44MzYzMiAxMS4xODEgNC4xMjAxNEMxMS4yNTggNC40MDM5NyAxMS4yNTI0IDUuMDcyNzEgMTEuMjQ2NyA1LjM2NzIxQzEzLjE1NzcgNC41OTA0NiAxNC4yNTk3IDUuNTU2ODQgMTQuNjQ1IDYuMDY0MkMxNC41MzczIDYuMjYzMjYgMTQuMTg4OSA2LjU3MzQ1IDE0LjAwMDMgNi43MDk3MUMxNC43MjQgNy4xMTI4NCAxNS4xNDU2IDcuNTQ2MTEgMTUuMzQ0MiA4LjI3MkMxNC44Nzg3IDguNDA4MjYgMTQuNTgzNiA4LjQ1NzIzIDE0LjExMTkgOC42NDE4NEMxNC4zMjkzIDguOTE5MzkgMTQuODIzIDkuMDUwNjMgMTUuMTczMiA5LjE5MjU0QzE0Ljk1MTQgOS45MjAzIDE0LjQ5MzQgOS43NDg4OCAxNC4xNTIgOS44MTYwN0MxNC42NDk0IDEwLjc3OTMgMTUuMzE3OSAxMC44MTY0IDE1Ljg1MyAxMC45MTQ5QzE1LjUzNDEgMTEuODI2NyAxNC42NSAxMi41ODUyIDEzLjY3NyAxMi41NjUxQzEzLjczNjYgMTIuNzM2NiAxMy45Njg0IDEzLjA2NTYgMTQuMTQ3NiAxMy4wOTA3QzEzLjYxMDYgMTMuNjY5IDEzLjE1NDUgMTMuNjI3IDEyLjQ5MSAxMy40OTEzQzEzLjU3OTMgMTEuNDU4MSAxMi43MDAzIDkuMzAwNTQgMTIuMjk1NSA4LjczOThDMTIuMjMyMyA4Ljk3MDg4IDEyLjEyOTUgOS4xODY4OSAxMS43ODYyIDkuMjI1MTlDMTEuMjY4IDguMzczNzIgOS44NDAxOCA3LjYzNzE2IDguODY4NDQgNy40MjI0MUM4Ljc4Njk5IDcuOTE3MjIgOC45MzM2IDguNDQ1MyA5LjI1ODE0IDguODI3NzFDOC43MzkzNyA4LjgyMTQzIDcuNTY3NzYgOC40MTU3OSA3LjE3OTk0IDguMDcwNDNDNS43NzA4OCA5LjE0MzU2IDQuNDkyMTMgMTAuNDA1MSA1LjY0ODA4IDEzLjM4MjFINS42NDc0NVoiIGZpbGw9IiMwMTc2RDMiLz4KPHBhdGggZD0iTTQuNjk3NjUgMTMuNzk2NUM0LjA0OTE5IDEzLjc5NjUgMy41NDE3MSAxMy40NzMxIDMuMzU2MjUgMTMuMzM2MkMzLjMxODAzIDEzLjMwOCAzLjI5NTQ4IDEzLjI2MjggMy4yOTYxMSAxMy4yMTVDMy4yOTY3MyAxMy4xNjczIDMuMzIwNTQgMTMuMTIyNyAzLjM2MDAxIDEzLjA5NTdDMy43NjM1IDEyLjgxNzYgMy45NTI3MSAxMi42ODMyIDQuMDM0MTYgMTIuNTQ4MkMzLjMyNDkzIDEyLjU1MDEgMi43MzQxMSAxMi4zNzg2IDIuMDIwNDkgMTEuMTY4NkMxLjk5NzMxIDExLjEyOTcgMS45OTM1NSAxMS4wODIgMi4wMTA0NyAxMS4wMzkzQzIuMDI3MzggMTAuOTk2NiAyLjA2MjQ3IDEwLjk2NDUgMi4xMDU3IDEwLjk1MkMyLjQzOTAxIDEwLjg1MzQgMi41ODI0OSAxMC43NjkzIDIuNzY0MTggMTAuNjYyNUMyLjkzOTYxIDEwLjU1OTUgMy4xNDgyNCAxMC40MzcxIDMuNTc3NDIgMTAuMjc2M0MzLjU1NTQ5IDEwLjI3MzggMy41MzM1NiAxMC4yNzEzIDMuNTEzNTEgMTAuMjY4OEMzLjE4MDgyIDEwLjIyOTkgMi43NjczMSAxMC4xODE1IDIuNTQxMTQgOS45NTE3QzIuNTExMDYgOS45MjA5MyAyLjQ5NTQgOS44Nzg4NiAyLjQ5OTE2IDkuODM2MTZDMi41MDI5MiA5Ljc5MzQ2IDIuNTI0MjIgOS43NTM5IDIuNTU4NjggOS43Mjg3OUMyLjY3MDgzIDkuNjQ1OSAyLjgxMDU1IDkuNDAxNjQgMi45NDQ2MiA5LjE2NTUzQzMuMDQ1NDkgOC45ODc4MyAzLjE0Mzg2IDguODE1NzggMy4yNDY2MSA4LjY3NTc1TDIuMzY5NDcgOC42ODY0M0MyLjMyNTYxIDguNjg2NDMgMi4yNzg2MiA4LjY2NTcgMi4yNTA0MyA4LjYyODAzQzIuMjIyMjMgOC41OTA5OCAyLjIxMzQ2IDguNTQyIDIuMjI2NjIgOC40OTc0MkMyLjQzNTg4IDcuNzc5MDcgMy4wMzYxIDcuMDQxMjYgMy44NDc0NSA2LjQ5NDk2QzMuNzgzNTUgNi40NTIyNiAzLjcwODM2IDYuNDEwMTkgMy42NDEzMiA2LjM3MzE0QzMuNTU4NjIgNi4zMjY2OCAzLjQ4MDkzIDYuMjgyNzIgMy40MjAxNiA2LjIzODc3QzMuMzg0NDUgNi4yMTMwMiAzLjM2MjUyIDYuMTcyODMgMy4zNjAwMSA2LjEyODg4QzMuMzU3NTEgNi4wODQ5MiAzLjM3MzggNi4wNDIyMyAzLjQwNTc1IDYuMDEyMDhDMy44ODgxOCA1LjU1NDk1IDUuMDM3ODYgNS4xNzMxOCA1LjcyNzY2IDUuNDI0OTdDNS43NTcxMSA0Ljc5MTQgNi4wNTAzMyA0LjM4MTM2IDYuMzEyODQgNC4wMTQwMkM2LjU0MzQgMy42OTEyNyA2Ljc0MjY0IDMuNDEzMSA2LjczODg4IDMuMDMwNjlDNi43Mzg4OCAyLjk4MzU5IDYuNzYwMTggMi45MzkwMSA2Ljc5Nzc4IDIuOTEwNzVDNi44MzUzNyAyLjg4MjUgNi44ODQyNCAyLjg3NDMzIDYuOTI5MzUgMi44ODgxNUM3LjQ2NjkxIDMuMDUzMjkgOC4yMDI0NSAzLjY3NjIgOC40NjgxIDQuMjYxNDNDOC45ODQ5OSAzLjgyNTAyIDEwLjAyMzEgMy40NDUxMiAxMC42Mjk2IDMuMjkyNTNDMTAuNjYyOCAzLjI4Mzc0IDEwLjY5ODUgMy4yODc1MSAxMC43MjkyIDMuMzAyNThDMTEuMDA4IDMuNDM2OTYgMTEuMjI0MiAzLjcyMDc4IDExLjMyMTkgNC4wODEyMUMxMS4zODQ2IDQuMzEyMjkgMTEuMzk4NCA0Ljc1Njg2IDExLjM5NTkgNS4xNTE4M0MxMy4zOTQ1IDQuNDQyOSAxNC40NzIxIDUuNTkzODkgMTQuNzYxIDUuOTc1MDRDMTQuNzk2IDYuMDIxNSAxNC44MDExIDYuMDgzNjcgMTQuNzczNSA2LjEzNTE2QzE0LjY3ODMgNi4zMTA5OCAxNC40NDMzIDYuNTM3MDMgMTQuMjYwNCA2LjY5MTVDMTQuOTQzMyA3LjEwOTcgMTUuMzAzNSA3LjU2ODA5IDE1LjQ4NTkgOC4yMzM2OUMxNS41MDcyIDguMzExNTUgMTUuNDYyIDguMzkxOTMgMTUuMzg1IDguNDE0NTNDMTUuMjM0IDguNDU4NDkgMTUuMTAyNCA4LjQ5MzAyIDE0Ljk3NTIgOC41MjY5M0MxNC43NzcyIDguNTc5MDUgMTQuNTk4NyA4LjYyNjE0IDE0LjM5MTkgOC42OTcxQzE0LjU1ODYgOC44MDc2MiAxNC43ODYgOC44OTExMyAxNC45OTQgOC45Njc3NEMxNS4wNzU1IDguOTk3ODggMTUuMTU0NCA5LjAyNjc2IDE1LjIyNzcgOS4wNTYyN0MxNS4yOTg1IDkuMDg1MTYgMTUuMzM1NSA5LjE2MzAyIDE1LjMxMzYgOS4yMzY0OUMxNS4xMDkzIDkuOTA1ODYgMTQuNjk2NCA5LjkyOTA5IDE0LjM5MjYgOS45NDI5MUMxNC43OTU0IDEwLjU4NCAxNS4yNzcyIDEwLjY2NjkgMTUuNzQ1MiAxMC43NDY3QzE1Ljc5MDMgMTAuNzU0MiAxNS44MzU1IDEwLjc2MjQgMTUuODc5MyAxMC43Njk5QzE1LjkyMTkgMTAuNzc3NCAxNS45NTgzIDEwLjgwMzggMTUuOTgwMiAxMC44NDA4QzE2LjAwMTUgMTAuODc3OSAxNi4wMDU5IDEwLjkyMzEgMTUuOTkyMSAxMC45NjM5QzE1LjY2IDExLjkxMjcgMTQuODEyMyAxMi42MDk3IDEzLjkxNjQgMTIuNzAyNkMxNC4wMDA0IDEyLjgyNTEgMTQuMTA5NCAxMi45MzYyIDE0LjE2ODkgMTIuOTQ0NEMxNC4yMjM0IDEyLjk1MTkgMTQuMjY4NSAxMi45ODk2IDE0LjI4NzMgMTMuMDQxMUMxNC4zMDU1IDEzLjA5MzIgMTQuMjkzNiAxMy4xNTEgMTQuMjU2NiAxMy4xOTEyQzEzLjY2ODkgMTMuODI0OCAxMy4xNDIgMTMuNzc1MSAxMi40NjI5IDEzLjYzNTdDMTIuNDE3MSAxMy42MjYzIDEyLjM3ODkgMTMuNTk2MiAxMi4zNTg4IDEzLjU1MzVDMTIuMzM4OCAxMy41MTE0IDEyLjM0MDcgMTMuNDYxOCAxMi4zNjI2IDEzLjQyMUMxMy4zMTkzIDExLjYzMzkgMTIuNjk1MyA5Ljc4NTMgMTIuMzIgOS4wNjU2OUMxMi4yMjU0IDkuMjE2NCAxMi4wNzE5IDkuMzQxMzUgMTEuODAzMSA5LjM3MTQ5QzExLjc0NjcgOS4zNzc3NyAxMS42OTEgOS4zNTA3NyAxMS42NjA5IDkuMzAxNzlDMTEuMjAzNSA4LjU1MDc5IDkuOTYxMTIgNy44NjA3IDguOTk2ODkgNy42MDUxNEM4Ljk3MzA4IDguMDEwMTUgOS4xMDc3OSA4LjQyMTQ0IDkuMzcwOTMgOC43MzE2NEM5LjQwODUyIDguNzc1NTkgOS40MTY2NyA4LjgzNzc2IDkuMzkyMjMgOC44ODk4N0M5LjM2NzggOC45NDE5OSA5LjMxNTggOC45NzQ2NCA5LjI1ODc4IDguOTc0NjRDOS4yNTg3OCA4Ljk3NDY0IDkuMjU3NTMgOC45NzQ2NCA5LjI1NjkgOC45NzQ2NEM4Ljc1NjkzIDguOTY4OTkgNy42NjY3NyA4LjYxMDQ1IDcuMTc4NzEgOC4yNTY5MkM1LjgwNDczIDkuMzE3NDkgNC43MDAxNiAxMC41MzA2IDUuNzg1OTMgMTMuMzI3NEM1LjgxMjI1IDEzLjM5NTMgNS43ODU5MyAxMy40NzE5IDUuNzIyNjUgMTMuNTA4OUM1LjM2MTc3IDEzLjcxOTkgNS4wMTM0MiAxMy43OTU5IDQuNjk4MjggMTMuNzk1OUw0LjY5NzY1IDEzLjc5NjVaTTMuNzA3NzQgMTMuMjE0NEM0LjA1MTcgMTMuNDE2NiA0LjcyMjA5IDEzLjY4NiA1LjQ2NDUyIDEzLjMxMzZDNC4zNjMwOCAxMC4zNTIzIDUuNjYxODggOS4wNDEyIDcuMDkwOTkgNy45NTMwMUM3LjE0Njc1IDcuOTEwMzEgNy4yMjUwNyA3LjkxMzQ1IDcuMjc4MzIgNy45NTk5MUM3LjU3OTY4IDguMjI4MDQgOC40MDQyIDguNTM2OTggOC45NDk5IDguNjQyNDdDOC43Mzc1MSA4LjI2OTQ4IDguNjUzNTUgNy44MjQyOCA4LjcyMzczIDcuMzk4NTVDOC43Mjk5OSA3LjM1ODM2IDguNzUzMTcgNy4zMjMyIDguNzg2MzggNy4yOTk5NkM4LjgxOTU4IDcuMjc3MzYgOC44NjE1NiA3LjI2OTE5IDguOTAxMDMgNy4yNzc5OUM5LjQyMTA1IDcuMzkyOSAxMC4wMzA3IDcuNjQwMyAxMC41NzI2IDcuOTU3NEMxMC45ODQyIDguMTk3OSAxMS41MzA2IDguNTgwMzEgMTEuODU3NiA5LjA2MjU1QzEyLjAzMzcgOS4wMTYwOSAxMi4xMDA3IDguODk0OSAxMi4xNTQgOC43MDAyNEMxMi4xNjkgOC42NDU2MSAxMi4yMTQxIDguNjA0MTcgMTIuMjY5OSA4LjU5NDEyQzEyLjMyNTYgOC41ODQwNyAxMi4zODIgOC42MDY2OCAxMi40MTUyIDguNjUzMTVDMTIuOTEwMiA5LjMzODIxIDEzLjYzOTUgMTEuNDQ0MyAxMi43MTE2IDEzLjM4MzNDMTMuMjExNiAxMy40NzE5IDEzLjUzOCAxMy40NTMgMTMuOTAyIDEzLjEyNjVDMTMuNzIyMiAxMi45Nzk2IDEzLjU3ODEgMTIuNzI5NiAxMy41MzggMTIuNjEzNUMxMy41MjIzIDEyLjU2NzYgMTMuNTI5OCAxMi41MTc0IDEzLjU1OCAxMi40Nzc4QzEzLjU4NjIgMTIuNDM4OSAxMy42MzA3IDEyLjQxNjkgMTMuNjgwMiAxMi40MTY5QzE0LjQ4NTkgMTIuNDMyNiAxNS4yODk3IDExLjg1ODcgMTUuNjUgMTEuMDI5MkMxNS4xMzA2IDEwLjkzOTQgMTQuNDk3OCAxMC44MDY5IDE0LjAyMSA5Ljg4Mzg4QzEzLjk5OTcgOS44NDI0NCAxMy45OTkxIDkuNzkzNDYgMTQuMDE5MSA5Ljc1MjAyQzE0LjAzOTIgOS43MTA1OCAxNC4wNzggOS42ODA0MyAxNC4xMjM4IDkuNjcxMDJDMTQuMjA2NSA5LjY1NDY5IDE0LjI5MTcgOS42NTA5MiAxNC4zNzQ0IDkuNjQ3MTVDMTQuNjMyNSA5LjYzNTIyIDE0Ljg0MTggOS42MjU4IDE0Ljk4NjUgOS4yNzg1NkMxNC45NTU4IDkuMjY3MjYgMTQuOTI1MSA5LjI1NTk2IDE0Ljg5MzggOS4yNDQwM0MxNC41NjYxIDkuMTIzNDYgMTQuMTk1MiA4Ljk4NjU4IDEzLjk5NjYgOC43MzI4OUMxMy45Njc4IDguNjk1ODQgMTMuOTU4NCA4LjY0ODEyIDEzLjk3MDMgOC42MDI5MUMxMy45ODIyIDguNTU3NyAxNC4wMTU0IDguNTIxMjggMTQuMDU4NiA4LjUwNDMzQzE0LjM4NzUgOC4zNzU2IDE0LjYzNjkgOC4zMDk2NyAxNC45MDEzIDguMjM5OTdDMTQuOTg0NiA4LjIxNzk5IDE1LjA2OTggOC4xOTUzOSAxNS4xNjA3IDguMTcwMjdDMTQuOTcwOCA3LjYwMTM3IDE0LjYxNDMgNy4yMTg5NiAxMy45Mjk2IDYuODM3ODFDMTMuODg1NyA2LjgxMzMyIDEzLjg1NjkgNi43NjgxMSAxMy44NTM3IDYuNzE3MjVDMTMuODUwNiA2LjY2NzAxIDEzLjg3MzggNi42MTgwMyAxMy45MTQ1IDYuNTg4NTJDMTQuMDc4IDYuNDY5ODQgMTQuMzM2MiA2LjIzODE0IDE0LjQ2MzQgNi4wNzExMUMxNC4xMTgxIDUuNjYxNyAxMy4xMDgyIDQuNzY4MTYgMTEuMzAyNSA1LjUwMjIxQzExLjI1NjggNS41MjEwNSAxMS4yMDQyIDUuNTE1MzkgMTEuMTYzNCA1LjQ4NzE0QzExLjEyMjcgNS40NTg4OCAxMS4wOTgzIDUuNDEyNDIgMTEuMDk5NSA1LjM2MjE4QzExLjExMTQgNC43ODEzNSAxMS4wODk1IDQuMzQxOCAxMS4wMzk0IDQuMTU2NTZDMTAuOTY5OCAzLjkwMDM3IDEwLjgyODkgMy42OTY5MiAxMC42NDg0IDMuNTkwOEM5Ljg0NjQ2IDMuODAxMTUgOC44MjI3MiA0LjI0NzYxIDguNTIxOTggNC42MjI0OEM4LjQ4NjI3IDQuNjY3MDcgOC40Mjg2MyA0LjY4NjUzIDguMzczNSA0LjY3Mzk3QzguMzE4MzYgNC42NjA3OSA4LjI3NTEzIDQuNjE3NDYgOC4yNjMyMyA0LjU2MTU3QzguMTc2NzcgNC4xNjQ3MiA3LjU4MDk0IDMuNDk3ODcgNy4wMjA4MiAzLjIzNjY1QzYuOTY0NDMgMy42MDk2NCA2Ljc1NjQyIDMuOTAxIDYuNTU0MDYgNC4xODM1NkM2LjI3MzM3IDQuNTc2MDIgNS45ODMyOSA0Ljk4MTY2IDYuMDI1ODkgNS42NTkxOUM2LjAyOTY1IDUuNzE2OTYgNS45OTg5NSA1Ljc3MTU5IDUuOTQ4MiA1Ljc5ODU5QzUuODk3NDUgNS44MjYyMiA1LjgzNTQzIDUuODIxMiA1Ljc4OTA2IDUuNzg2MDNDNS4zNzA1NCA1LjQ2NzA1IDQuMzI4IDUuNjkzMSAzLjc2MTYyIDYuMDk5MzdDMy43Njk3NiA2LjEwMzc2IDMuNzc3OTEgNi4xMDg3OSAzLjc4NjA1IDYuMTEzMThDMy45NDg5NSA2LjIwNDg2IDQuMTE4MTEgNi4yOTk2OCA0LjIxMDIxIDYuNDIxNDlDNC4yMzUyNyA2LjQ1NDc3IDQuMjQ1MyA2LjQ5Njg1IDQuMjM3NzggNi41Mzc2NkM0LjIzMDI2IDYuNTc4NDggNC4yMDU4MyA2LjYxNDI3IDQuMTcwMTEgNi42MzYyNEMzLjQxMDc2IDcuMTA2NTYgMi44Mjg3MSA3Ljc0ODkzIDIuNTc2MjIgOC4zODY5TDMuNjE4NzcgOC4zNzM3MkMzLjY5MDgyIDguMzczNzIgMy43NDk3MSA4LjQyMTQ0IDMuNzY0NzUgOC40ODk4OEMzLjc3OTc5IDguNTU4MzMgMy43NDQ3IDguNjI4MDMgMy42ODA3OSA4LjY1NjI5QzMuNTM3MzIgOC43MjA5NiAzLjM1MDYxIDkuMDQ3NDggMy4yMDE1IDkuMzA5OTZDMy4wOTA2IDkuNTA0NjEgMi45ODQwOSA5LjY5MTc0IDIuODczODIgOS44MjY3NEMzLjA1MzAxIDkuOTE1MjggMy4zMjI0MiA5Ljk0NjY4IDMuNTQ4NiA5Ljk3MzY4QzMuODc2MjcgMTAuMDEyIDQuMTM1MDMgMTAuMDQyNyA0LjE2ODIzIDEwLjI1MzdDNC4xNzk1MSAxMC4zMjUzIDQuMTM2OTEgMTAuMzk1IDQuMDY3OTkgMTAuNDE3NkMzLjM4NTcgMTAuNjM4NiAzLjEzNTA5IDEwLjc4NTYgMi45MTM5MiAxMC45MTU2QzIuNzU3MjkgMTEuMDA3MiAyLjYxODgzIDExLjA4ODkgMi4zNzEzNSAxMS4xNzU1QzMuMDIzNTcgMTIuMjEyMiAzLjUxNTM5IDEyLjI3MzggNC4yMjgzOCAxMi4yNDY4QzQuMjcwOTggMTIuMjQ1NSA0LjMxMTcxIDEyLjI2MTggNC4zNDA1MyAxMi4yOTI2QzQuMzY5MzUgMTIuMzIzNCA0LjM4NDM5IDEyLjM2NTQgNC4zODA2MyAxMi40MDc1QzQuMzUxODEgMTIuNzMxNSA0LjE1ODIxIDEyLjg5ODYgMy43MDcxMSAxMy4yMTMyTDMuNzA3NzQgMTMuMjE0NFoiIGZpbGw9IiMwMTc2RDMiLz4KPC9nPgo8ZGVmcz4KPGNsaXBQYXRoIGlkPSJjbGlwMF83OV8xNjkiPgo8cmVjdCB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIGZpbGw9IndoaXRlIi8+CjwvY2xpcFBhdGg+CjwvZGVmcz4KPC9zdmc+Cg==',
    true
);

-- =====================================================
-- 2. INSERT CONFIGURATION TYPE
-- =====================================================

INSERT INTO connector_config_types (connector_id, config_type_key, display_name, description)
SELECT 
    id,
    'ms-einstein-ai:config',
    'Einstein_AI_Configuration',
    'Only OAuth Client Credentials for Salesforce'
FROM connectors 
WHERE maven_artifact_id = 'mule4-einstein-ai-connector';

-- =====================================================
-- 3. INSERT CONFIG PROVIDER
-- =====================================================

INSERT INTO config_providers (config_type_id, provider_key, display_name, description)
SELECT 
    ct.id,
    'Config_Connection',
    'Salesforce',
    'OAuth Client Credentials connection to Salesforce for Einstein AI services.'
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('clientId', 'Client ID', 'String', true, NULL, 'The OAuth public client ID as registered with the service provider.', 1),
        ('clientSecret', 'Client Secret', 'String', true, NULL, 'The OAuth client secret that corresponds to the client ID.', 2),
        ('tokenUrl', 'Token URL', 'String', false, 'https://{salesforceorg}/services/oauth2/token/', 'The service provider''s token endpoint URL.', 3),
        ('scopes', 'Scopes', 'String', false, NULL, 'The OAuth scopes to request during the OAuth dance. If not provided, it defaults the scopes in the annotation.', 4),
        ('salesforceOrg', 'Salesforce Org', 'String', true, NULL, 'Salesforce org hostname (e.g., storm-bc10ebcc1814e0.my.salesforce.com)', 5)
) AS param(api_name, display_name, data_type, is_required, default_value, description, parameter_order)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND cp.provider_key = 'Config_Connection';

-- =====================================================
-- 5. INSERT OPERATIONS
-- =====================================================

-- Operation 1: AGENT Define Prompt Template
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'AGENT Define Prompt Template',
    'ms-einstein-ai:agent-define-prompt-template',
    'Use specific prompt templates. The prompt template language is a simple way to define and compose AI functions using plain text. You can use it to create natural language prompts, generate responses, extract information, invoke other prompts, or perform any other task that can be expressed with text.',
    'Agent'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-agent-operations#configure-the-agent-define-prompt-template-operation',
    1,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('template', 'Template', 'String', false, 'Prompt template for the operation.', 'You are a customer satisfaction agent, who analyses the customer feedback in the dataset. Answer via json output and add a type for the result only with positive or negative as well as the complete answer', 1, NULL),
        ('instructions', 'Instructions', 'String', true, 'Instructions for the LLM, outlining the goals of the task.', 'If the customer feedback in the dataset is negative, open a service satisfaction case and apologize to the customer. If the customer feedback in the dataset is positive, thank the customer and wish them a nice day. Don''t repeat the feedback and be more direct starting the conversation with formal greetings', 2, NULL),
        ('dataset', 'Dataset', 'String', true, 'Dataset for the LLM to evaluate using the provided template and instructions.', 'The training last week was amazing, we learned so much and the trainer was very friendly.', 3, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultGPT4Omni', 4, '{"enum":["sfdc_ai__DefaultBedrockAmazonNovaLite","sfdc_ai__DefaultBedrockAmazonNovaPro","sfdc_ai__DefaultBedrockAnthropicClaude3Haiku","sfdc_ai__DefaultBedrockAnthropicClaude37Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude4Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet","sfdc_ai__DefaultAzureOpenAIGPT35Turbo","sfdc_ai__DefaultAzureOpenAIGPT35Turbo_16k","sfdc_ai__DefaultAzureOpenAIGPT4Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo_16k","sfdc_ai__DefaultOpenAIGPT4","sfdc_ai__DefaultOpenAIGPT4_32k","sfdc_ai__DefaultGPT4Omni","sfdc_ai__DefaultGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4Turbo","sfdc_ai__DefaultGPT41","sfdc_ai__DefaultGPT41Mini","sfdc_ai__DefaultGPT5","sfdc_ai__DefaultGPT5Mini","sfdc_ai__DefaultVertexAIGemini20Flash001","sfdc_ai__DefaultVertexAIGemini20FlashLite001","sfdc_ai__DefaultVertexAIGemini25Flash001","sfdc_ai__DefaultVertexAIGemini25FlashLite001","sfdc_ai__DefaultVertexAIGeminiPro25"]}'),
        ('probability', 'Probability', 'Number', false, 'Probability of the model API staying accurate.', '0.8', 5, NULL),
        ('locale', 'Locale', 'String', false, 'Localization information, which can include the default locale, input locale(s), and expected output locale(s).', 'en_US', 6, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:agent-define-prompt-template';

-- Operation 2: CHAT Answer Prompt
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'CHAT Answer Prompt',
    'ms-einstein-ai:chat-answer-prompt',
    'Sends a prompt request to the configured LLM. It uses a plain text prompt as input and responds with a plain text answer.',
    'Chat'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-chat-operations#configure-the-chat-answer-prompt-operation',
    2,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('prompt', 'Prompt', 'String', false, 'Plain text prompt to send to the LLM.', NULL, 1, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultGPT4Omni', 2, '{"enum":["sfdc_ai__DefaultBedrockAmazonNovaLite","sfdc_ai__DefaultBedrockAmazonNovaPro","sfdc_ai__DefaultBedrockAnthropicClaude3Haiku","sfdc_ai__DefaultBedrockAnthropicClaude37Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude4Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet","sfdc_ai__DefaultAzureOpenAIGPT35Turbo","sfdc_ai__DefaultAzureOpenAIGPT35Turbo_16k","sfdc_ai__DefaultAzureOpenAIGPT4Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo_16k","sfdc_ai__DefaultOpenAIGPT4","sfdc_ai__DefaultOpenAIGPT4_32k","sfdc_ai__DefaultGPT4Omni","sfdc_ai__DefaultGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4Turbo","sfdc_ai__DefaultGPT41","sfdc_ai__DefaultGPT41Mini","sfdc_ai__DefaultGPT5","sfdc_ai__DefaultGPT5Mini","sfdc_ai__DefaultVertexAIGemini20Flash001","sfdc_ai__DefaultVertexAIGemini20FlashLite001","sfdc_ai__DefaultVertexAIGemini25Flash001","sfdc_ai__DefaultVertexAIGemini25FlashLite001","sfdc_ai__DefaultVertexAIGeminiPro25"]}'),
        ('probability', 'Probability', 'Number', false, 'Probability of the model API staying accurate.', '0.8', 3, NULL),
        ('locale', 'Locale', 'String', false, 'Localization information, which can include the default locale, input locale(s), and expected output locale(s).', 'en_US', 4, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:chat-answer-prompt';

-- Operation 3: CHAT Generate From Messages
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'CHAT Generate From Messages',
    'ms-einstein-ai:chat-generate-from-messages',
    'A prompt request operation with provided messages to the configured LLM. It uses a plain text prompt as input and responds with a plain text answer.',
    'Chat'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-chat-operations#configure-the-chat-generate-from-messages-operation',
    3,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

INSERT INTO operation_parameters (operation_id, api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order, validation_rules)
SELECT 
    o.id,
    param.api_name,
    param.display_name,
    param.data_type::parameter_data_type,
    param.is_required,
    param.description,
    param.default_value,
    param.example_value,
    param.parameter_order,
    param.validation_rules::jsonb
FROM operations o
JOIN connectors c ON o.connector_id = c.id
CROSS JOIN (
    VALUES
        ('messages', 'Messages', 'JSON', false, 'Array of message objects with role and content. Each message represents a turn in the conversation.', '[{"role":"user","content":"Can you give me a recipe for cherry pie?"},{"role":"assistant","content":"Certainly! I have a great recipe for a classic cherry pie. Are you planning on using fresh, frozen, or canned cherries?"},{"role":"user","content":"I''d prefer to use fresh cherries if possible."},{"role":"assistant","content":"Fresh cherries are perfect! This recipe also includes instructions for a homemade flaky crust. Would you like the full recipe now?"},{"role":"user","content":"Yes, please. Also, any tips for making a lattice top?"}]', NULL, 1, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultGPT4Omni', NULL, 2, '{"enum":["sfdc_ai__DefaultBedrockAmazonNovaLite","sfdc_ai__DefaultBedrockAmazonNovaPro","sfdc_ai__DefaultBedrockAnthropicClaude3Haiku","sfdc_ai__DefaultBedrockAnthropicClaude37Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude4Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet","sfdc_ai__DefaultAzureOpenAIGPT35Turbo","sfdc_ai__DefaultAzureOpenAIGPT35Turbo_16k","sfdc_ai__DefaultAzureOpenAIGPT4Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo_16k","sfdc_ai__DefaultOpenAIGPT4","sfdc_ai__DefaultOpenAIGPT4_32k","sfdc_ai__DefaultGPT4Omni","sfdc_ai__DefaultGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4Turbo","sfdc_ai__DefaultGPT41","sfdc_ai__DefaultGPT41Mini","sfdc_ai__DefaultGPT5","sfdc_ai__DefaultGPT5Mini","sfdc_ai__DefaultVertexAIGemini20Flash001","sfdc_ai__DefaultVertexAIGemini20FlashLite001","sfdc_ai__DefaultVertexAIGemini25Flash001","sfdc_ai__DefaultVertexAIGemini25FlashLite001","sfdc_ai__DefaultVertexAIGeminiPro25"]}'),
        ('probability', 'Probability', 'Number', false, 'Probability of the model API staying accurate.', '0.8', NULL, 3, NULL),
        ('locale', 'Locale', 'String', false, 'Localization information, which can include the default locale, input locale(s), and expected output locale(s).', 'en_US', NULL, 4, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, example_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:chat-generate-from-messages';

-- Operation 4: EMBEDDING Adhoc File Query
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'EMBEDDING Adhoc File Query',
    'ms-einstein-ai:embedding-adhoc-file-query',
    'Generates embeddings from a file and executes a query against them.',
    'Embedding'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-embeddings-operations#adhoc-file-query',
    4,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('prompt', 'Prompt', 'String', false, 'Plain text prompt to send to the LLM.', NULL, 1, NULL),
        ('inputStream', 'Input Stream', 'Base64', true, 'When fileType is CSV/PDF/TEXT: Base64 encoded file data. When fileType is URL: provide the URL string directly.', NULL, 2, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultOpenAITextEmbeddingAda_002', 3, '{"enum": ["sfdc_ai__DefaultOpenAITextEmbeddingAda_002", "sfdc_ai__DefaultAzureOpenAITextEmbeddingAda_002"]}'),
        ('fileType', 'File Type', 'String', false, 'Type of the document to ingest: CSV, PDF, TEXT, or URL.', 'PDF', 4, '{"enum": ["CSV", "PDF", "TEXT", "URL"]}'),
        ('optionType', 'Option Type', 'String', false, 'How to split the document prior to ingestion into the embedding or vector database.', 'FULL', 5, '{"enum": ["FULL", "PARAGRAPH"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:embedding-adhoc-file-query';

-- Operation 5: EMBEDDING Generate From File
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'EMBEDDING Generate From File',
    'ms-einstein-ai:embedding-generate-from-file',
    'Generates embeddings from a file input.',
    'Embedding'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-embeddings-operations#generate-from-file',
    5,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('inputStream', 'Input Stream', 'Base64', false, 'When fileType is CSV/PDF/TEXT: Base64 encoded file data. When fileType is URL: provide the URL string directly.', NULL, 1, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultOpenAITextEmbeddingAda_002', 2, '{"enum": ["sfdc_ai__DefaultOpenAITextEmbeddingAda_002", "sfdc_ai__DefaultAzureOpenAITextEmbeddingAda_002"]}'),
        ('fileType', 'File Type', 'String', false, 'Type of the document to ingest: CSV, PDF, TEXT, or URL.', 'PDF', 3, '{"enum": ["CSV", "PDF", "TEXT", "URL"]}'),
        ('optionType', 'Option Type', 'String', false, 'How to split the document prior to ingestion.', 'FULL', 4, '{"enum": ["FULL", "PARAGRAPH"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:embedding-generate-from-file';

-- Operation 6: EMBEDDING Generate From Text
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'EMBEDDING Generate From Text',
    'ms-einstein-ai:embedding-generate-from-text',
    'Generates embeddings from text input.',
    'Embedding'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-embeddings-operations#generate-from-text',
    6,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('text', 'Text', 'String', false, 'Text to generate embeddings from.', NULL, 1, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultOpenAITextEmbeddingAda_002', 2, '{"enum": ["sfdc_ai__DefaultOpenAITextEmbeddingAda_002", "sfdc_ai__DefaultAzureOpenAITextEmbeddingAda_002"]}')
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:embedding-generate-from-text';

-- Operation 7: RAG Adhoc Load Document
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'RAG Adhoc Load Document',
    'ms-einstein-ai:rag-adhoc-load-document',
    'Loads a document into the embedding store for RAG-based queries.',
    'RAG'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-rag-operations#configure-the-rag-adhoc-load-document-operation',
    7,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('prompt', 'Prompt', 'String', false, 'Plain text prompt to send to the LLM.', 'Is this a purchase order, answer with yes or no', 1, NULL),
        ('fileType', 'File Type', 'String', false, 'Type of the document to ingest: CSV, PDF, TEXT, or URL.', 'PDF', 2, '{"enum": ["CSV", "PDF", "TEXT", "URL"]}'),
        ('inputStream', 'Input Stream', 'Base64', true, 'When fileType is CSV/PDF/TEXT: Base64 encoded file data. When fileType is URL: provide the URL string directly.', NULL, 3, NULL),
        ('embeddingName', 'Embedding Name', 'String', false, 'Name of the embedding model to use.', 'sfdc_ai__DefaultOpenAITextEmbeddingAda_002', 4, '{"enum": ["sfdc_ai__DefaultOpenAITextEmbeddingAda_002", "sfdc_ai__DefaultAzureOpenAITextEmbeddingAda_002"]}'),
        ('optionType', 'Option Type', 'String', false, 'How to split the document prior to ingestion into the embedding or vector database.', 'FULL', 5, '{"enum": ["FULL", "PARAGRAPH"]}'),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultGPT4Omni', 6, '{"enum":["sfdc_ai__DefaultBedrockAmazonNovaLite","sfdc_ai__DefaultBedrockAmazonNovaPro","sfdc_ai__DefaultBedrockAnthropicClaude3Haiku","sfdc_ai__DefaultBedrockAnthropicClaude37Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude4Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet","sfdc_ai__DefaultAzureOpenAIGPT35Turbo","sfdc_ai__DefaultAzureOpenAIGPT35Turbo_16k","sfdc_ai__DefaultAzureOpenAIGPT4Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo_16k","sfdc_ai__DefaultOpenAIGPT4","sfdc_ai__DefaultOpenAIGPT4_32k","sfdc_ai__DefaultGPT4Omni","sfdc_ai__DefaultGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4Turbo","sfdc_ai__DefaultGPT41","sfdc_ai__DefaultGPT41Mini","sfdc_ai__DefaultGPT5","sfdc_ai__DefaultGPT5Mini","sfdc_ai__DefaultVertexAIGemini20Flash001","sfdc_ai__DefaultVertexAIGemini20FlashLite001","sfdc_ai__DefaultVertexAIGemini25Flash001","sfdc_ai__DefaultVertexAIGemini25FlashLite001","sfdc_ai__DefaultVertexAIGeminiPro25"]}'),
        ('probability', 'Probability', 'Number', false, 'Probability of the model API staying accurate.', '0.8', 7, NULL),
        ('locale', 'Locale', 'String', false, 'Localization information.', 'en_US', 8, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:rag-adhoc-load-document';

-- Operation 8: TOOLS Use AI Service
INSERT INTO operations (connector_id, display_name, operation_key, description, category, required_config_type_id, help_url, operation_order, is_active)
SELECT 
    c.id,
    'TOOLS Use AI Service',
    'ms-einstein-ai:tools-use-ai-service',
    'Invokes AI services with tool integration capabilities.',
    'Tools'::operation_category,
    ct.id,
    'https://docs.mulesoft.com/einstein-ai-connector/latest/configuring-tools-operations',
    8,
    true
FROM connectors c
JOIN connector_config_types ct ON ct.connector_id = c.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config';

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
        ('prompt', 'Prompt', 'String', false, 'Plain text prompt to send to the LLM.', 'Get me the CRM accounts', 1, NULL),
        ('inputStream', 'Input Stream', 'String', true, 'Tool definitions as JSON array. Can be entered as JSON or uploaded as file.', '[{"action":"Execute POST requests for API endpoints.","url":"http://check-inventory-material.cloudhub.io/mmbe","name":"Check Inventory","method":"POST","headers":"Basic XXX","example-payload":"{\n \"materialNo\": \"paramValue\"}","query":["Check inventory in SAP","Check Stock Overview","Show product availability for MULETEST0","Check the inventory for MULETEST0","Check Stock for 400-110"],"description":"Check inventory details for material in SAP by providing the materialNo as input for paramValue. Please use the materialNo and not materialNumber. This action applies whenever users'' intent is ''Stock overview'', ''product availability'', ''Inventory'', ''available stock''. Use the headers to perform the request."},{"action":"Execute GET requests for API endpoints.","url":"https://anypoint.mulesoft.com/mocking/api/v1/sources/exchange/assets/612eb739-4266-4f4c-bf2f-29953c153d80/accounts-api/1.0.1/m/accounts","name":"Show Accounts","method":"GET","headers":"","example-payload":"{}","query":["Get all accounts","Show all accounts from CRM"],"description":"Get all accounts from a CRM. This action applies whenever users'' intent is ''CRM accounts'', ''customers'', ''customer accounts'', ''accounts''."},{"action":"Execute GET requests for API endpoints.","url":"https://anypoint.mulesoft.com/mocking/api/v1/sources/exchange/assets/7b99cead-a984-497b-9e6c-c16a3b4dcb76/employee-api/1.0.1/m/employees","name":"Show Employees","method":"GET","headers":"","example-payload":"{}","query":["Get all employee information","Show employees for the country Switzerland","How many employees do we have","Show a list of all employees"],"description":"Get all information about employees. This action applies whenever users'' intent is ''employees'', ''workforce''."}]', 2, NULL),
        ('modelApiName', 'Model API Name', 'String', false, 'Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html', 'sfdc_ai__DefaultGPT4Omni', 3, '{"enum":["sfdc_ai__DefaultBedrockAmazonNovaLite","sfdc_ai__DefaultBedrockAmazonNovaPro","sfdc_ai__DefaultBedrockAnthropicClaude3Haiku","sfdc_ai__DefaultBedrockAnthropicClaude37Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude4Sonnet","sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet","sfdc_ai__DefaultAzureOpenAIGPT35Turbo","sfdc_ai__DefaultAzureOpenAIGPT35Turbo_16k","sfdc_ai__DefaultAzureOpenAIGPT4Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo","sfdc_ai__DefaultOpenAIGPT35Turbo_16k","sfdc_ai__DefaultOpenAIGPT4","sfdc_ai__DefaultOpenAIGPT4_32k","sfdc_ai__DefaultGPT4Omni","sfdc_ai__DefaultGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4OmniMini","sfdc_ai__DefaultOpenAIGPT4Turbo","sfdc_ai__DefaultGPT41","sfdc_ai__DefaultGPT41Mini","sfdc_ai__DefaultGPT5","sfdc_ai__DefaultGPT5Mini","sfdc_ai__DefaultVertexAIGemini20Flash001","sfdc_ai__DefaultVertexAIGemini20FlashLite001","sfdc_ai__DefaultVertexAIGemini25Flash001","sfdc_ai__DefaultVertexAIGemini25FlashLite001","sfdc_ai__DefaultVertexAIGeminiPro25"]}'),
        ('probability', 'Probability', 'Number', false, 'Probability of the model API staying accurate.', '0.8', 4, NULL),
        ('locale', 'Locale', 'String', false, 'Localization information.', 'en_US', 5, NULL)
) AS param(api_name, display_name, data_type, is_required, description, default_value, parameter_order, validation_rules)
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND o.operation_key = 'ms-einstein-ai:tools-use-ai-service';

-- =====================================================
-- 6. CREATE RUNTIME CONFIGURATION
-- =====================================================

-- Create runtime configuration for Salesforce Connected App
INSERT INTO runtime_configurations (config_type_id, provider_id, name, description, is_active)
SELECT 
    ct.id,
    cp.id,
    'Salesforce Connection (Default)',
    'Production Salesforce Connected App for Einstein AI integration.',
    true
FROM connector_config_types ct
JOIN connectors c ON ct.connector_id = c.id
JOIN config_providers cp ON cp.config_type_id = ct.id
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND ct.config_type_key = 'ms-einstein-ai:config'
  AND cp.provider_key = 'Config_Connection';

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
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
  AND rc.name = 'Salesforce Connection (Default)';

-- =====================================================
-- SEED COMPLETE - Summary Query
-- =====================================================

SELECT 
    '✅ Einstein AI connector seed data inserted successfully!' AS status;

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
WHERE c.maven_artifact_id = 'mule4-einstein-ai-connector'
GROUP BY c.name;
