
%dw 2.0
output application/java 
---
 {
  id: 10,
  operation_id: 4,
  api_name: "modelApiName",
  display_name: "Model API Name",
  data_type: "String",
  is_required: false,
  default_value: "sfdc_ai__DefaultGPT4Omni",
  description: "Name of the API model that interacts with the LLM. @https://developer.salesforce.com/docs/einstein/genai/guide/supported-models.html",
  validation_rules: {
    "type": "jsonb",
    "null": false,
    value: "{\"enum\": [\"sfdc_ai__DefaultBedrockAmazonNovaLite\", \"sfdc_ai__DefaultBedrockAmazonNovaPro\", \"sfdc_ai__DefaultBedrockAnthropicClaude3Haiku\", \"sfdc_ai__DefaultBedrockAnthropicClaude37Sonnet\", \"sfdc_ai__DefaultBedrockAnthropicClaude4Sonnet\", \"sfdc_ai__DefaultBedrockAnthropicClaude45Sonnet\", \"sfdc_ai__DefaultAzureOpenAIGPT35Turbo\", \"sfdc_ai__DefaultAzureOpenAIGPT35Turbo_16k\", \"sfdc_ai__DefaultAzureOpenAIGPT4Turbo\", \"sfdc_ai__DefaultOpenAIGPT35Turbo\", \"sfdc_ai__DefaultOpenAIGPT35Turbo_16k\", \"sfdc_ai__DefaultOpenAIGPT4\", \"sfdc_ai__DefaultOpenAIGPT4_32k\", \"sfdc_ai__DefaultGPT4Omni\", \"sfdc_ai__DefaultGPT4OmniMini\", \"sfdc_ai__DefaultOpenAIGPT4OmniMini\", \"sfdc_ai__DefaultOpenAIGPT4Turbo\", \"sfdc_ai__DefaultGPT41\", \"sfdc_ai__DefaultGPT41Mini\", \"sfdc_ai__DefaultGPT5\", \"sfdc_ai__DefaultGPT5Mini\", \"sfdc_ai__DefaultVertexAIGemini20Flash001\", \"sfdc_ai__DefaultVertexAIGemini20FlashLite001\", \"sfdc_ai__DefaultVertexAIGemini25Flash001\", \"sfdc_ai__DefaultVertexAIGemini25FlashLite001\", \"sfdc_ai__DefaultVertexAIGeminiPro25\"]}"
  },
  example_value: null,
  parameter_order: 4,
  created_at: |2025-11-13T13:05:52.080618|,
  updated_at: |2025-11-13T13:05:52.080618|
}