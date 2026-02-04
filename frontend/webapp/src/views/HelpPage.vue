<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 py-12">
    <div class="max-w-5xl mx-auto px-6">
      <!-- Header -->
      <div class="text-center mb-12">
        <h1 class="text-4xl font-bold text-gray-900 mb-4">
          MuleSoftForge Connector Playground Help
        </h1>
        <p class="text-lg text-gray-600">
          Your guide to using the Connector Playground effectively
        </p>
      </div>

      <!-- Help Sections -->
      <div class="space-y-6">
        <!-- External Help Files Section -->
        <div class="bg-white rounded-xl shadow-lg border-4 border-transparent animate-gradient-border p-6 relative overflow-hidden">
          <!-- Animated border effect -->
          <div class="absolute inset-0 rounded-xl bg-gradient-to-r from-green-400 via-blue-500 to-purple-600 opacity-75 blur-sm -z-10 animate-pulse"></div>
          
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center">
              <div class="w-10 h-10 bg-gradient-to-br from-green-400 to-blue-500 rounded-lg flex items-center justify-center mr-3">
                <svg class="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
              </div>
              <div>
                <h2 class="text-2xl font-bold text-gray-900">📄 External Help Files</h2>
                <p class="text-sm text-gray-600">Loaded from external source - always up to date</p>
              </div>
            </div>
            <a 
              :href="externalHelpUrl" 
              target="_blank"
              class="inline-flex items-center px-4 py-2 bg-gradient-to-r from-blue-600 to-purple-600 text-white rounded-lg hover:from-blue-700 hover:to-purple-700 transition-all text-sm font-medium shadow-md hover:shadow-lg"
            >
              Open in New Tab
              <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"/>
              </svg>
            </a>
          </div>

          <div class="bg-blue-50 border border-blue-200 rounded-lg p-3 mb-4">
            <p class="text-sm text-blue-900">
              💡 <strong>Always Current:</strong> This content is loaded from an external location that can be updated anytime. 
              Check here first for the latest troubleshooting tips, known issues, and solutions!
            </p>
          </div>

          <!-- iframe for external help content -->
          <div class="bg-gray-50 rounded-lg border-2 border-gray-200 overflow-hidden" style="height: 600px;">
            <iframe 
              :src="externalHelpUrl"
              class="w-full h-full"
              frameborder="0"
              title="External Help Files"
              sandbox="allow-same-origin allow-scripts allow-popups allow-forms"
            ></iframe>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
// HelpPage - Basic help and support information with external help files

// External Help URL - Update this to point to your external help page
// This allows you to update help content anytime without redeploying the app
const externalHelpUrl = 'https://mulesoft-forge.github.io/mule-connector-playground-help/';

// Alternative example URLs you might use:
// const externalHelpUrl = 'https://docs.google.com/document/d/YOUR_DOC_ID/pub?embedded=true';
// const externalHelpUrl = 'https://notion.so/your-workspace/external-help';
// const externalHelpUrl = 'https://github.com/your-org/mce-help/blob/main/EXTERNAL_HELP.md';
</script>
