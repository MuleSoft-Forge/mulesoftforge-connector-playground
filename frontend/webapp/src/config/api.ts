/**
 * Centralized API configuration
 * 
 * This module provides a single source of truth for API URLs across the application.
 * All components should import from here instead of duplicating the logic.
 */

/**
 * Check if we're in development mode
 * In dev, Vite runs on port 5173 and we proxy to Mule on 8081
 */
export const isDev = typeof window !== 'undefined' && window.location.port === '5173';

/**
 * Base URL for API calls
 * - Development: Points to Mule server on localhost:8081
 * - Production: Uses same origin (served through Mule)
 */
export const API_BASE = isDev ? 'http://localhost:8081' : '';

/**
 * Alias for API_BASE (used in some components for clarity)
 */
export const MULE_ORIGIN = API_BASE;

/**
 * WebSocket URL for real-time streaming operations
 * - Development: Points to Mule WebSocket server on localhost:8081
 * - Production: Uses same host with ws:// or wss:// protocol
 */
export const WS_URL = isDev 
  ? 'ws://localhost:8081/ws' 
  : `${window.location.protocol === 'https:' ? 'wss:' : 'ws:'}//${window.location.host}/ws`;

/**
 * Get the base URL for static assets served by Mule
 * In development, assets are proxied through the Vite dev server
 */
export const getAssetUrl = (path: string): string => {
  if (!path) return '';
  
  // Already a full URL or data URI
  if (path.startsWith('http://') || path.startsWith('https://') || path.startsWith('data:')) {
    return path;
  }
  
  // Ensure leading slash
  const normalizedPath = path.startsWith('/') ? path : `/${path}`;
  
  return `${MULE_ORIGIN}${normalizedPath}`;
};

