<template>
  <div>
    <!-- Hero Section -->
    <section :class="`relative bg-gradient-to-br ${seasonalTheme.heroGradient} overflow-hidden`">
      <div class="absolute inset-0 bg-grid-pattern opacity-5"></div>
      
      <!-- Seasonal particles -->
      <div :class="`seasonal-particles ${seasonalTheme.particles}`">
        <div class="particle-container">
          <div v-for="(particle, index) in particles" :key="index" 
               class="particle" 
               :style="particle.style">
            {{ particle.emoji }}
          </div>
        </div>
      </div>
      
      <!-- Floating elements for visual interest -->
      <div :class="`absolute top-20 left-10 w-20 h-20 ${seasonalTheme.floatingColor1} rounded-full blur-3xl animate-pulse`"></div>
      <div :class="`absolute bottom-20 right-10 w-32 h-32 ${seasonalTheme.floatingColor2} rounded-full blur-3xl animate-pulse`" style="animation-delay: 1s;"></div>
      
      <div class="max-w-7xl mx-auto px-6 py-12 md:py-16 relative">
        <!-- Hero Content - Centered -->
        <div class="text-center max-w-4xl mx-auto mb-12">
          <!-- Badge -->
          <div class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-full shadow-sm mb-6">
            <span class="w-2 h-2 bg-green-500 rounded-full animate-pulse"></span>
            <span class="text-sm text-mulesoft-gray font-medium">{{ seasonalTheme.emoji }} {{ seasonalTheme.badgeText }}</span>
          </div>
          
          <!-- Main Heading -->
          <h1 class="text-4xl md:text-5xl lg:text-6xl font-bold text-mulesoft-dark mb-4 leading-tight">
            Explore MuleSoft
            <span class="bg-gradient-to-r from-mulesoft-cyan to-blue-600 bg-clip-text text-transparent">AI Connectors</span>
          </h1>
          
          <!-- Tagline -->
          <div class="mb-6">
            <p class="text-2xl md:text-3xl font-bold bg-gradient-to-r from-mulesoft-cyan to-blue-600 bg-clip-text text-transparent inline-block">
              {{ seasonalTheme.tagline }}
            </p>
          </div>
          
          <p class="text-lg md:text-xl text-mulesoft-gray leading-relaxed">
            AI is just an idea until you can connect it. Go hands-on with MuleSoft's new AI connectors and evangelize their power in a real-time, interactive lab.
          </p>
        </div>

        <!-- Feature Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-7xl mx-auto">
        <!-- Discover -->
        <div class="group bg-white rounded-xl p-6 shadow-sm border border-gray-100 hover:shadow-lg hover:border-mulesoft-cyan transition-all duration-300">
          <div class="w-14 h-14 mb-4 group-hover:scale-110 transition-transform duration-300">
            <img v-if="connectorsIconUrl" :src="connectorsIconUrl" alt="Connectors" class="w-full h-full" />
          </div>
          <h3 class="text-lg font-semibold text-mulesoft-dark mb-2">Discover Connectors</h3>
          <p class="text-sm text-mulesoft-gray leading-relaxed mb-3">
            Browse the complete catalog of AI connectors including Agentforce, Einstein AI, and MuleSoft Inference with detailed documentation.
          </p>
          <router-link to="/browse" class="inline-flex items-center text-mulesoft-cyan font-medium hover:gap-2 transition-all">
            Browse now
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </router-link>
        </div>

        <!-- Test -->
        <div class="group bg-white rounded-xl p-6 shadow-sm border border-gray-100 hover:shadow-lg hover:border-mulesoft-cyan transition-all duration-300">
          <div class="w-14 h-14 mb-4 group-hover:scale-110 transition-transform duration-300">
            <img v-if="playgroundIconUrl" :src="playgroundIconUrl" alt="Playground" class="w-full h-full" />
          </div>
          <h3 class="text-lg font-semibold text-mulesoft-dark mb-2">Test in Real-Time</h3>
          <p class="text-sm text-mulesoft-gray leading-relaxed mb-3">
            Use the Playground Lab to test connector operations with your credentials. See results instantly without writing code.
          </p>
          <router-link to="/lab" class="inline-flex items-center text-mulesoft-cyan font-medium hover:gap-2 transition-all">
            Try the lab
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </router-link>
        </div>

        <!-- Manage -->
        <div class="group bg-white rounded-xl p-6 shadow-sm border border-gray-100 hover:shadow-lg hover:border-mulesoft-cyan transition-all duration-300">
          <div class="w-14 h-14 mb-4 group-hover:scale-110 transition-transform duration-300">
            <img v-if="manageCenterIconUrl" :src="manageCenterIconUrl" alt="Manage Center" class="w-full h-full" />
          </div>
          <h3 class="text-lg font-semibold text-mulesoft-dark mb-2">Manage Everything</h3>
          <p class="text-sm text-mulesoft-gray leading-relaxed mb-3">
            Add connectors, configure operations, and manage runtime credentials all from the admin dashboard.
          </p>
          <router-link to="/admin" class="inline-flex items-center text-mulesoft-cyan font-medium hover:gap-2 transition-all">
            Admin panel
            <svg class="w-4 h-4 ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
            </svg>
          </router-link>
        </div>
        </div>
      </div>
    </section>

    <!-- MCP & A2A Innovation Section -->
    <section :class="`relative py-16 bg-gradient-to-br ${seasonalTheme.mcpSectionGradient} overflow-hidden`">
      <!-- Floating elements -->
      <div :class="`absolute top-10 left-20 w-32 h-32 ${seasonalTheme.mcpFloating1} rounded-full blur-3xl`"></div>
      <div :class="`absolute bottom-10 right-20 w-40 h-40 ${seasonalTheme.mcpFloating2} rounded-full blur-3xl`"></div>
      
      <div class="max-w-7xl mx-auto px-6 relative">
        <!-- Section Header -->
        <div class="text-center mb-12">
          <div class="inline-flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-red-500 to-pink-500 text-white rounded-full shadow-lg font-bold text-sm mb-4 animate-pulse">
            ✨ INCLUDED & READY
          </div>
          <h2 class="text-3xl md:text-4xl lg:text-5xl font-bold text-transparent bg-gradient-to-r from-purple-600 via-blue-600 to-cyan-500 bg-clip-text mb-4">
            MCP & A2A Servers Included
          </h2>
          <p class="text-lg text-mulesoft-gray max-w-3xl mx-auto">
            <span class="font-semibold text-mulesoft-dark">No setup required!</span> MCE comes with fully functional MCP and A2A servers ready to explore and test immediately.
          </p>
        </div>

        <!-- MCP & A2A Cards - Horizontal Layout -->
        <div class="grid md:grid-cols-2 gap-8 max-w-6xl mx-auto">
          <!-- MCP Card -->
          <div class="group relative bg-gradient-to-br from-blue-600 to-cyan-500 rounded-2xl p-1 shadow-2xl hover:shadow-3xl transform hover:-translate-y-2 transition-all duration-300">
            <div class="bg-white rounded-xl p-8 h-full">
              <div class="flex items-start gap-6 mb-6">
                <div class="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-blue-100 to-cyan-100 rounded-2xl shadow-lg flex items-center justify-center p-3 group-hover:scale-110 transition-transform duration-300">
                  <img :src="mcpIcon" alt="MCP" class="w-full h-full object-contain" />
                </div>
                <div class="flex-1">
                  <h3 class="text-2xl font-bold text-mulesoft-dark mb-2">MCP Server</h3>
                  <p class="text-sm font-semibold text-blue-600 mb-3">Model Context Protocol • Included & Running</p>
                  <p class="text-base text-mulesoft-gray leading-relaxed">
                    Start connecting Claude Desktop and ChatGPT to enterprise systems right away. Test context-aware AI interactions instantly - no configuration needed.
                  </p>
                </div>
              </div>
              
              <div class="flex flex-wrap gap-2 pt-4 border-t border-gray-100">
                <span class="px-3 py-1 bg-green-50 text-green-700 text-xs font-medium rounded-full border border-green-200">✓ Ready to Test</span>
                <span class="px-3 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full">Claude Desktop</span>
                <span class="px-3 py-1 bg-blue-50 text-blue-700 text-xs font-medium rounded-full">ChatGPT</span>
                <span class="px-3 py-1 bg-green-50 text-green-700 text-xs font-medium rounded-full border border-green-200">✓ No Setup</span>
              </div>
            </div>
          </div>

          <!-- A2A Card -->
          <div class="group relative bg-gradient-to-br from-purple-600 to-pink-500 rounded-2xl p-1 shadow-2xl hover:shadow-3xl transform hover:-translate-y-2 transition-all duration-300">
            <div class="bg-white rounded-xl p-8 h-full">
              <div class="flex items-start gap-6 mb-6">
                <div class="flex-shrink-0 w-20 h-20 bg-gradient-to-br from-purple-100 to-pink-100 rounded-2xl shadow-lg flex items-center justify-center p-3 group-hover:scale-110 transition-transform duration-300">
                  <img :src="a2aIcon" alt="A2A" class="w-full h-full object-contain" />
                </div>
                <div class="flex-1">
                  <h3 class="text-2xl font-bold text-mulesoft-dark mb-2">A2A Server</h3>
                  <p class="text-sm font-semibold text-purple-600 mb-3">Agent-to-Agent Protocol • Included & Running</p>
                  <p class="text-base text-mulesoft-gray leading-relaxed">
                    Experiment with multi-agent communication immediately. See how autonomous agents collaborate - just click and explore, zero setup required.
                  </p>
                </div>
              </div>
              
              <div class="flex flex-wrap gap-2 pt-4 border-t border-gray-100">
                <span class="px-3 py-1 bg-green-50 text-green-700 text-xs font-medium rounded-full border border-green-200">✓ Ready to Test</span>
                <span class="px-3 py-1 bg-purple-50 text-purple-700 text-xs font-medium rounded-full">Multi-Agent</span>
                <span class="px-3 py-1 bg-purple-50 text-purple-700 text-xs font-medium rounded-full">Autonomous</span>
                <span class="px-3 py-1 bg-green-50 text-green-700 text-xs font-medium rounded-full border border-green-200">✓ No Setup</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Bottom Badge -->
        <div class="text-center mt-12">
          <div class="inline-flex items-center gap-3 px-6 py-3 bg-white rounded-full shadow-lg border-2 border-green-300">
            <svg class="w-5 h-5 text-green-600" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
            <span class="text-base font-bold text-transparent bg-gradient-to-r from-green-600 via-blue-600 to-purple-600 bg-clip-text">
              Included with MCE • Start Testing in Minutes
            </span>
            <svg class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
              <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
            </svg>
          </div>
        </div>
      </div>
    </section>

    <!-- Official MuleSoft AI Platform Section -->
    <section class="max-w-7xl mx-auto px-6 py-12">
      <div class="bg-gradient-to-br from-blue-50 to-cyan-50 rounded-2xl p-8 md:p-12 border border-blue-100 shadow-lg">
        <div class="max-w-4xl mx-auto">
          <div class="flex items-start gap-4 mb-6">
            <div class="flex-shrink-0">
              <div class="w-14 h-14 bg-gradient-to-br from-mulesoft-cyan to-blue-600 rounded-xl flex items-center justify-center shadow-md">
                <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                </svg>
              </div>
            </div>
            <div class="flex-1">
              <div class="inline-flex items-center gap-2 px-3 py-1 bg-white border border-blue-200 rounded-full text-xs font-medium text-blue-700 mb-3">
                <span class="w-1.5 h-1.5 bg-blue-500 rounded-full"></span>
                OFFICIAL MULESOFT PLATFORM
              </div>
              <h2 class="text-2xl md:text-3xl font-bold text-mulesoft-dark mb-4">
                Powered by MuleSoft Anypoint Platform
              </h2>
              <p class="text-base text-mulesoft-gray leading-relaxed mb-6">
                This playground showcases connectors from the official <span class="font-semibold text-mulesoft-dark">MuleSoft Anypoint Platform</span>, 
                designed to simplify autonomous agent development and bridge AI models with enterprise systems. 
                Build sophisticated AI agents that seamlessly integrate with your existing MuleSoft infrastructure.
              </p>
              <div class="flex flex-col sm:flex-row gap-3">
                <a 
                  href="https://www.mulesoft.com/platform/ai/ai-connector" 
                  target="_blank"
                  rel="noopener noreferrer"
                  class="inline-flex items-center justify-center px-6 py-3 bg-gradient-to-r from-mulesoft-cyan to-blue-600 text-white font-semibold rounded-lg shadow-md hover:shadow-lg transform hover:-translate-y-0.5 transition-all duration-200"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"></path>
                  </svg>
                  Visit MuleSoft AI Connectors landing page
                  <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"></path>
                  </svg>
                </a>
                <a 
                  href="https://www.mulesoft.com/exchange/?search=ai%20connectors&sort=score"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="inline-flex items-center justify-center px-6 py-3 bg-white text-mulesoft-dark font-semibold rounded-lg shadow-md hover:shadow-lg border border-gray-200 transform hover:-translate-y-0.5 transition-all duration-200"
                >
                  <img v-if="anypointExchangeIcon" :src="anypointExchangeIcon" alt="Anypoint Exchange" class="w-5 h-5 mr-2" />
                  Browse on Anypoint Exchange
                </a>
                <a 
                  href="https://docs.mulesoft.com/general/learning-map-mulesoft-ai"
                  target="_blank"
                  rel="noopener noreferrer"
                  class="inline-flex items-center justify-center px-6 py-3 bg-white text-mulesoft-dark font-semibold rounded-lg shadow-md hover:shadow-lg border border-gray-200 transform hover:-translate-y-0.5 transition-all duration-200"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"></path>
                  </svg>
                  View Documentation
                </a>
              </div>
            </div>
          </div>
          
          <!-- Key Features Badges -->
          <div class="flex flex-wrap gap-2 mt-6 pt-6 border-t border-blue-200">
            <span class="px-3 py-1.5 bg-white text-xs font-medium text-gray-700 rounded-lg border border-blue-100 shadow-sm">
              🤖 Autonomous AI Agents
            </span>
            <span class="px-3 py-1.5 bg-white text-xs font-medium text-gray-700 rounded-lg border border-blue-100 shadow-sm">
              🔗 Enterprise Integration
            </span>
            <span class="px-3 py-1.5 bg-white text-xs font-medium text-gray-700 rounded-lg border border-blue-100 shadow-sm">
              ⚡ Model Context Protocol
            </span>
            <span class="px-3 py-1.5 bg-white text-xs font-medium text-gray-700 rounded-lg border border-blue-100 shadow-sm">
              🔄 Agent-to-Agent Communication
            </span>
            <span class="px-3 py-1.5 bg-white text-xs font-medium text-gray-700 rounded-lg border border-blue-100 shadow-sm">
              🧠 Einstein AI Integration
            </span>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA Section -->
    <section class="bg-gradient-to-r from-mulesoft-cyan to-blue-600 py-12 mt-8">
      <div class="max-w-4xl mx-auto px-6 text-center">
        <h2 class="text-2xl md:text-3xl font-bold text-white mb-4">
          Ready to explore AI connectors?
        </h2>
        <p class="text-base text-blue-100 mb-6">
          Start discovering and testing MuleSoft AI connectors today
        </p>
        <router-link 
          to="/browse" 
          class="inline-flex items-center px-6 py-3 bg-white text-mulesoft-cyan font-semibold rounded-lg shadow-lg hover:shadow-xl transform hover:-translate-y-0.5 transition-all duration-200"
        >
          Get Started
          <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6"></path>
          </svg>
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted } from 'vue';
import { PLAYGROUND_BROWSE_ICON, PLAYGROUND_LAB_ICON, PLAYGROUND_MANAGE_ICON, MCP_ICON, A2A_ICON, ANYPOINT_EXCHANGE_ICON } from '../constants/assets';

// Icon URLs for static content
const connectorsIconUrl = PLAYGROUND_BROWSE_ICON;
const playgroundIconUrl = PLAYGROUND_LAB_ICON;
const manageCenterIconUrl = PLAYGROUND_MANAGE_ICON;
const mcpIcon = MCP_ICON;
const a2aIcon = A2A_ICON;
const anypointExchangeIcon = ANYPOINT_EXCHANGE_ICON;

// Seasonal theme detection
type Season = 'spring' | 'summer' | 'autumn' | 'winter';

const currentSeason = ref<Season>('spring');

const getSeason = (): Season => {
  const month = new Date().getMonth(); // 0-11
  if (month >= 2 && month <= 4) return 'spring'; // Mar-May
  if (month >= 5 && month <= 7) return 'summer'; // Jun-Aug
  if (month >= 8 && month <= 10) return 'autumn'; // Sep-Nov
  return 'winter'; // Dec-Feb
};

// Generate seasonal particles with random positions and timing
interface Particle {
  emoji: string;
  style: {
    left: string;
    fontSize: string;
    animationDelay: string;
    animationDuration: string;
  };
}

const particles = ref<Particle[]>([]);

const generateParticles = (season: Season) => {
  const particleList: Particle[] = [];
  const count = 25; // Number of particles
  
  const emojiMap: Record<Season, string> = {
    winter: '❄️',
    spring: '🌸',
    summer: '✨',
    autumn: '🍂'
  };
  
  for (let i = 0; i < count; i++) {
    particleList.push({
      emoji: emojiMap[season],
      style: {
        left: `${Math.random() * 100}%`,
        fontSize: `${20 + Math.random() * 20}px`, // 20-40px
        animationDelay: `${Math.random() * 15}s`,
        animationDuration: `${10 + Math.random() * 10}s` // 10-20s
      }
    });
  }
  
  particles.value = particleList;
};

const seasonalTheme = computed(() => {
  const themes = {
    spring: {
      heroGradient: 'from-pink-50 via-violet-50 to-green-50',
      emoji: '🌸',
      tagline: '👑 Connectivity is King. Growing Possibilities.',
      badgeText: 'Discover & Test AI-Powered Connectors',
      floatingColor1: 'bg-pink-400/10',
      floatingColor2: 'bg-violet-400/10',
      mcpSectionGradient: 'from-violet-50 via-pink-50 to-green-50',
      mcpFloating1: 'bg-pink-300/20',
      mcpFloating2: 'bg-violet-300/20',
      particles: 'petals'
    },
    summer: {
      heroGradient: 'from-amber-50 via-orange-50 to-yellow-50',
      emoji: '☀️',
      tagline: '👑 Connectivity is King. Bright Ideas Ahead.',
      badgeText: 'Discover & Test AI-Powered Connectors',
      floatingColor1: 'bg-orange-400/10',
      floatingColor2: 'bg-amber-400/10',
      mcpSectionGradient: 'from-orange-50 via-yellow-50 to-amber-50',
      mcpFloating1: 'bg-yellow-300/20',
      mcpFloating2: 'bg-orange-300/20',
      particles: 'sunshine'
    },
    autumn: {
      heroGradient: 'from-orange-50 via-amber-50 to-red-50',
      emoji: '🍂',
      tagline: '👑 Connectivity is King. Harvest Innovation.',
      badgeText: 'Discover & Test AI-Powered Connectors',
      floatingColor1: 'bg-orange-400/10',
      floatingColor2: 'bg-red-400/10',
      mcpSectionGradient: 'from-amber-50 via-orange-50 to-red-50',
      mcpFloating1: 'bg-orange-300/20',
      mcpFloating2: 'bg-red-300/20',
      particles: 'leaves'
    },
    winter: {
      heroGradient: 'from-blue-50 via-cyan-50 to-slate-50',
      emoji: '❄️',
      tagline: '👑 Connectivity is King. Made Tangible.',
      badgeText: 'Discover & Test AI-Powered Connectors',
      floatingColor1: 'bg-cyan-400/10',
      floatingColor2: 'bg-blue-400/10',
      mcpSectionGradient: 'from-cyan-50 via-blue-50 to-slate-50',
      mcpFloating1: 'bg-cyan-300/20',
      mcpFloating2: 'bg-blue-300/20',
      particles: 'snowflakes'
    }
  };
  return themes[currentSeason.value];
});

onMounted(() => {
  currentSeason.value = getSeason();
  generateParticles(currentSeason.value);
});

// Landing page is fully static - no API calls
// Authentication will be triggered when user navigates to protected routes
</script>

<style scoped>
.bg-grid-pattern {
  background-image: 
    linear-gradient(to right, rgba(0, 160, 223, 0.1) 1px, transparent 1px),
    linear-gradient(to bottom, rgba(0, 160, 223, 0.1) 1px, transparent 1px);
  background-size: 40px 40px;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Seasonal Particles Container */
.seasonal-particles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  overflow: hidden;
}

/* Respect reduced motion preferences */
@media (prefers-reduced-motion: reduce) {
  .particle {
    animation: none !important;
  }
}

/* All Seasonal Particles */
.particle-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  pointer-events: none;
}

.particle {
  position: absolute;
  top: -50px;
  opacity: 0.8;
  user-select: none;
}

/* Winter Snowflakes */
.seasonal-particles.snowflakes .particle {
  animation: fall 12s linear infinite;
  text-shadow: 0 0 8px rgba(255, 255, 255, 0.9), 0 0 16px rgba(200, 230, 255, 0.6);
  filter: drop-shadow(0 0 4px rgba(255, 255, 255, 1));
}

/* Spring Petals */
.seasonal-particles.petals .particle {
  animation: fall-drift 15s ease-in-out infinite;
  text-shadow: 0 0 8px rgba(255, 182, 193, 0.9), 0 0 16px rgba(219, 112, 147, 0.6);
  filter: drop-shadow(0 0 4px rgba(255, 192, 203, 1));
}

/* Autumn Leaves */
.seasonal-particles.leaves .particle {
  animation: fall-sway 14s ease-in-out infinite;
  text-shadow: 0 0 8px rgba(255, 140, 0, 0.9), 0 0 16px rgba(210, 105, 30, 0.6);
  filter: drop-shadow(0 0 4px rgba(255, 165, 0, 1));
}

/* Summer Sparkles */
.seasonal-particles.sunshine .particle {
  animation: sparkle 8s ease-in-out infinite;
  text-shadow: 0 0 8px rgba(255, 215, 0, 0.9), 0 0 16px rgba(255, 200, 0, 0.6);
  filter: drop-shadow(0 0 4px rgba(255, 223, 0, 1));
}


/* Animation: Simple fall */
@keyframes fall {
  0% {
    transform: translateY(-50px) translateX(0);
    opacity: 0;
  }
  10% {
    opacity: 0.3;
  }
  90% {
    opacity: 0.3;
  }
  100% {
    transform: translateY(100vh) translateX(0);
    opacity: 0;
  }
}

/* Animation: Fall with drift */
@keyframes fall-drift {
  0% {
    transform: translateY(-50px) translateX(0) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 0.4;
  }
  50% {
    transform: translateY(50vh) translateX(30px) rotate(180deg);
    opacity: 0.4;
  }
  90% {
    opacity: 0.4;
  }
  100% {
    transform: translateY(100vh) translateX(-20px) rotate(360deg);
    opacity: 0;
  }
}

/* Animation: Fall with sway */
@keyframes fall-sway {
  0% {
    transform: translateY(-50px) translateX(0) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 0.35;
  }
  25% {
    transform: translateY(25vh) translateX(-40px) rotate(90deg);
  }
  50% {
    transform: translateY(50vh) translateX(20px) rotate(180deg);
    opacity: 0.35;
  }
  75% {
    transform: translateY(75vh) translateX(-30px) rotate(270deg);
  }
  90% {
    opacity: 0.35;
  }
  100% {
    transform: translateY(100vh) translateX(10px) rotate(360deg);
    opacity: 0;
  }
}

/* Animation: Pulse glow for sunshine */
@keyframes pulse-glow {
  0%, 100% {
    transform: scale(1);
    opacity: 0.15;
  }
  50% {
    transform: scale(1.2);
    opacity: 0.25;
  }
}

/* Animation: Sparkle for summer */
@keyframes sparkle {
  0% {
    transform: translateY(-50px) translateX(0) scale(0.5) rotate(0deg);
    opacity: 0;
  }
  10% {
    opacity: 0.8;
  }
  25% {
    transform: translateY(25vh) translateX(20px) scale(1) rotate(90deg);
  }
  50% {
    transform: translateY(50vh) translateX(-15px) scale(1.2) rotate(180deg);
    opacity: 0.8;
  }
  75% {
    transform: translateY(75vh) translateX(25px) scale(1) rotate(270deg);
  }
  90% {
    opacity: 0.8;
  }
  100% {
    transform: translateY(100vh) translateX(-10px) scale(0.5) rotate(360deg);
    opacity: 0;
  }
}

.markdown-content :deep(p) {
  margin-bottom: 0;
}

.markdown-content :deep(strong) {
  font-weight: 600;
  color: inherit;
}

.markdown-content :deep(em) {
  font-style: italic;
}

.markdown-content :deep(a) {
  color: #00A0DF;
  text-decoration: underline;
}

.markdown-content :deep(a:hover) {
  color: #0074A6;
}

.markdown-content :deep(code) {
  background: rgba(0, 0, 0, 0.05);
  padding: 0.125rem 0.25rem;
  border-radius: 0.25rem;
  font-size: 0.875em;
}
</style>
