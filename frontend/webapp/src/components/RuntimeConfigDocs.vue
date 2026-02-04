<template>
  <div class="space-y-6">
    <section>
      <h1>Runtime Configuration Dropdown Structure</h1>
      
      <h2>Overview</h2>
      <p>
        The Runtime Configuration dropdown is a hierarchical selector that allows users to choose 
        which configuration to use when executing connector operations in the Lab.
      </p>
    </section>

    <section>
      <h2>Dropdown Hierarchy</h2>
      <p>The dropdown is organized in <strong>3 levels</strong>:</p>
      
      <div class="bg-gray-50 p-4 rounded-lg border border-gray-200 font-mono text-sm my-4">
        <div>📁 Config Type (optgroup label)</div>
        <div class="ml-4">└─ 🔌 Provider → 🎯 Runtime Config (option)</div>
        <div class="ml-4">└─ 🔌 Provider → 🎯 Runtime Config (option)</div>
      </div>
    </section>

    <section>
      <h2>Explanation of Each Level</h2>

      <div class="space-y-4">
        <div class="bg-blue-50 border-l-4 border-blue-500 p-4 rounded">
          <h3 class="text-blue-900">📁 Level 1: Config Type</h3>
          <ul class="text-blue-800 mt-2">
            <li><strong>What:</strong> The type of configuration the connector supports</li>
            <li><strong>Example:</strong> "Config", "Agent", "Text Generation Config"</li>
            <li><strong>From DB:</strong> <code>connector_config_types</code> table</li>
            <li><strong>Purpose:</strong> Groups configurations by their purpose/function</li>
            <li><strong>Display:</strong> Used as the optgroup label in the dropdown</li>
          </ul>
        </div>

        <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded">
          <h3 class="text-green-900">🔌 Level 2: Provider</h3>
          <ul class="text-green-800 mt-2">
            <li><strong>What:</strong> The service provider or authentication method</li>
            <li><strong>Example:</strong> "Salesforce", "OpenAI", "Azure", "Anthropic"</li>
            <li><strong>From DB:</strong> <code>config_providers</code> table</li>
            <li><strong>Purpose:</strong> Identifies which provider/platform the config connects to</li>
            <li><strong>Display:</strong> First part of the option text (before the arrow)</li>
          </ul>
        </div>

        <div class="bg-purple-50 border-l-4 border-purple-500 p-4 rounded">
          <h3 class="text-purple-900">🎯 Level 3: Runtime Config</h3>
          <ul class="text-purple-800 mt-2">
            <li><strong>What:</strong> The actual named configuration instance with credentials/values</li>
            <li><strong>Example:</strong> "Production Salesforce", "Dev OpenAI", "PLACEHOLDER_Salesforce"</li>
            <li><strong>From DB:</strong> <code>runtime_configurations</code> table</li>
            <li><strong>Purpose:</strong> The specific configuration instance selected for operation execution</li>
            <li><strong>Display:</strong> Second part of the option text (after the arrow)</li>
          </ul>
        </div>
      </div>
    </section>

    <section>
      <h2>Example Dropdown Display</h2>

      <h3>Agentforce Connector</h3>
      <div class="bg-gray-50 p-4 rounded-lg border border-gray-200 font-mono text-sm my-3">
        <div class="text-gray-500 mb-2">Choose configuration...</div>
        <div class="font-semibold mb-1">Config</div>
        <div class="ml-4">└─ Salesforce → PLACEHOLDER_Salesforce</div>
        <div class="ml-4">└─ Salesforce → Production_Salesforce</div>
        <div class="ml-4">└─ Salesforce → Dev_Salesforce</div>
      </div>

      <h3>Einstein AI Connector (Hypothetical)</h3>
      <div class="bg-gray-50 p-4 rounded-lg border border-gray-200 font-mono text-sm my-3">
        <div class="text-gray-500 mb-2">Choose configuration...</div>
        <div class="font-semibold mb-1">Text Generation Config</div>
        <div class="ml-4">└─ OpenAI → Production_OpenAI</div>
        <div class="ml-4">└─ OpenAI → Dev_OpenAI</div>
        <div class="ml-4">└─ Azure → Azure_OpenAI_East</div>
        <div class="ml-4">└─ Anthropic → Claude_Production</div>
        <div class="font-semibold mt-3 mb-1">Image Generation Config</div>
        <div class="ml-4">└─ OpenAI → Dall_E_Production</div>
        <div class="ml-4">└─ Stability → StabilityAI_Dev</div>
      </div>
    </section>

    <section>
      <h2>Display Format</h2>
      <p>Each option displays:</p>
      <div class="bg-gray-900 text-gray-100 p-3 rounded font-mono text-sm my-3" v-pre>
        {{ prov.displayName }} → {{ rc.name }}
      </div>
      
      <p>Example rendered option:</p>
      <div class="bg-white border-2 border-mulesoft-cyan p-3 rounded my-3">
        <span class="font-semibold">Salesforce → Production_Salesforce</span>
        <div class="text-sm text-gray-600 mt-2">
          <div><code>Salesforce</code> = Provider display name</div>
          <div><code>→</code> = Visual separator (arrow)</div>
          <div><code>Production_Salesforce</code> = Runtime config name</div>
        </div>
      </div>
    </section>

    <section>
      <h2>Why This Structure?</h2>

      <div class="space-y-3">
        <div class="bg-yellow-50 p-4 rounded-lg border border-yellow-200">
          <h4 class="font-semibold text-yellow-900 mb-2">1️⃣ Config Type Level</h4>
          <p class="text-yellow-800">
            Same connector can have multiple config types
          </p>
          <p class="text-sm text-yellow-700 mt-1">
            <strong>Example:</strong> MuleSoft Inference connector has separate configs for text generation, 
            image generation, vision, and moderation
          </p>
        </div>

        <div class="bg-orange-50 p-4 rounded-lg border border-orange-200">
          <h4 class="font-semibold text-orange-900 mb-2">2️⃣ Provider Level</h4>
          <p class="text-orange-800">
            Same config type can work with multiple providers
          </p>
          <p class="text-sm text-orange-700 mt-1">
            <strong>Example:</strong> Text generation can use OpenAI, Azure OpenAI, Anthropic Claude, etc.
          </p>
        </div>

        <div class="bg-pink-50 p-4 rounded-lg border border-pink-200">
          <h4 class="font-semibold text-pink-900 mb-2">3️⃣ Runtime Config Level</h4>
          <p class="text-pink-800">
            Multiple configs per provider for different environments
          </p>
          <p class="text-sm text-pink-700 mt-1">
            <strong>Example:</strong> Production_OpenAI, Staging_OpenAI, Dev_OpenAI
          </p>
        </div>
      </div>

      <div class="bg-green-100 border border-green-400 rounded-lg p-4 mt-4">
        <p class="font-semibold text-green-900 mb-2">✅ This three-level hierarchy provides maximum flexibility to manage:</p>
        <ul class="text-green-800">
          <li>✅ Multiple connector capabilities</li>
          <li>✅ Multiple service providers</li>
          <li>✅ Multiple environments (Dev, Staging, Production)</li>
          <li>✅ Different credentials and settings per environment</li>
        </ul>
      </div>
    </section>

    <section>
      <h2>User Experience</h2>

      <h3>Selection Required</h3>
      <ul>
        <li>The dropdown defaults to <code>"Choose configuration..."</code></li>
        <li>A runtime configuration <strong>must be selected</strong> before operations can be executed</li>
        <li>Validation message shows: <span class="text-red-600">⚠️ Please select a runtime configuration</span></li>
      </ul>

      <h3>Visual Feedback</h3>
      <ul>
        <li>Selected config ID is stored in <code>selectedRuntimeConfigId</code></li>
        <li>The selection enables the "Execute" button when combined with:
          <ul>
            <li>Selected operation</li>
            <li>All required parameters filled</li>
          </ul>
        </li>
      </ul>
    </section>

    <section>
      <h2>Admin Management</h2>
      <p>Runtime configurations can be managed in the Admin section:</p>
      <ol>
        <li>Navigate to <strong>Admin → Runtime Configs</strong></li>
        <li>Select a connector</li>
        <li>View hierarchical tree: <strong>Config Types → Providers → Runtime Configs</strong></li>
        <li>CRUD operations: Create, Edit, Activate/Deactivate, Delete</li>
      </ol>
      <div class="bg-blue-100 border border-blue-400 rounded-lg p-3 mt-3">
        <p class="text-blue-900">
          💡 <strong>Note:</strong> Only <strong>active</strong> runtime configurations appear in the Lab dropdown.
        </p>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
// This component displays the runtime configuration documentation
</script>

<style scoped>
section {
  margin-bottom: 2rem;
}

h1 {
  font-size: 1.875rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 1rem;
}

h2 {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 0.75rem;
  padding-bottom: 0.5rem;
  border-bottom: 2px solid #e5e7eb;
}

h3 {
  font-size: 1.25rem;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 0.5rem;
  margin-top: 1rem;
}

h4 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1f2937;
  margin-bottom: 0.25rem;
}

p {
  color: #374151;
  margin-bottom: 0.5rem;
  line-height: 1.625;
}

ul, ol {
  margin-left: 1.5rem;
  color: #374151;
}

ul li, ol li {
  margin-top: 0.25rem;
}

ul {
  list-style-type: disc;
}

ol {
  list-style-type: decimal;
}

li {
  line-height: 1.625;
}

code {
  background-color: #f3f4f6;
  padding: 0.125rem 0.5rem;
  border-radius: 0.25rem;
  font-size: 0.875rem;
  font-family: ui-monospace, monospace;
  color: #db2777;
}

strong {
  font-weight: 600;
  color: #111827;
}
</style>

