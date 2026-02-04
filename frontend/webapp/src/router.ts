import { createRouter, createWebHashHistory } from 'vue-router';
import LandingPage from './views/LandingPage.vue';
import ConnectorsPage from './views/ConnectorsPage.vue';
import ConnectorDetailPage from './views/ConnectorDetailPage.vue';
import LabPage from './views/LabPage.vue';
import TestLabRouter from './views/TestLabRouter.vue';
import FlowsPage from './views/FlowsPage.vue';
import StatsPage from './views/StatsPage.vue';
import HelpPage from './views/HelpPage.vue';
import AdminPage from './views/AdminPage.vue';
import AdminConnectorsPage from './views/admin/AdminConnectorsPage.vue';
import ConnectorWizardPage from './views/admin/ConnectorWizardPage.vue';
import AdminRuntimeConfigsPage from './views/admin/AdminRuntimeConfigsPage.vue';
import { authService } from './services/authService';
import { showLoginModal } from './composables/useApi';

export const router = createRouter({
  history: createWebHashHistory(),
  routes: [
    { path: '/', name: 'landing', component: LandingPage, meta: { public: true } },
    { path: '/browse', name: 'browse', component: ConnectorsPage },
    { path: '/connectors/:id', name: 'connector-detail', component: ConnectorDetailPage },
    { path: '/lab', name: 'lab', component: LabPage },
    { path: '/lab/:connectorId', name: 'lab-connector', component: TestLabRouter },
    { path: '/flows', name: 'flows', component: FlowsPage },
    { path: '/stats', name: 'stats', component: StatsPage },
    { path: '/help', name: 'help', component: HelpPage },
    { path: '/admin', name: 'admin', component: AdminPage },
    // Admin sub-routes
    { path: '/admin/connectors', name: 'admin-connectors', component: AdminConnectorsPage },
    { path: '/admin/connectors/new', name: 'new-connector', component: ConnectorWizardPage },
    { path: '/admin/connectors/:id/edit', name: 'edit-connector', component: ConnectorWizardPage },
    { path: '/admin/runtime-configs', name: 'admin-runtime-configs', component: AdminRuntimeConfigsPage }
  ],
  scrollBehavior(to, from, savedPosition) {
    // Always scroll to top on navigation
    if (savedPosition) {
      return savedPosition
    } else {
      return { top: 0, behavior: 'smooth' }
    }
  }
});

// Navigation guard - Check authentication before entering protected routes
router.beforeEach((to, from, next) => {
  // Check if route is public (landing page)
  const isPublicRoute = to.meta.public === true;
  
  // If not public and not authenticated, trigger login modal
  if (!isPublicRoute && !authService.isAuthenticated()) {
    showLoginModal.value = true;
    // Stay on current page (or landing if no previous page)
    if (from.path === '/') {
      next(false); // Cancel navigation
    } else {
      next(from.path || '/'); // Go back or to landing
    }
  } else {
    next(); // Allow navigation
  }
});



