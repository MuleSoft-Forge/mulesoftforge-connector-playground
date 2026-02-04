import { ref } from 'vue';
import { API_BASE } from '../config/api';
import { authService } from '../services/authService';

// Global error state (shared across all components)
export const showErrorModal = ref(false);
export const apiError = ref<{
  endpoint: string;
  method: string;
  status: number;
  statusText: string;
  requestPayload: any;
  responseBody: any;
  timestamp: string;
} | null>(null);

// Global auth state - triggers login modal
export const showLoginModal = ref(false);
export const authRequired = ref(false);

/**
 * Make an API call with detailed error tracking for MuleSoft developers
 * 
 * @param endpoint - The API endpoint (e.g., '/connectors' or '/connectors/1')
 * @param method - HTTP method (GET, POST, PUT, DELETE)
 * @param payload - Optional request body (will be JSON stringified)
 * @returns Promise with the parsed response body
 * @throws Error with detailed API error information captured in global state
 */
export async function apiCall(endpoint: string, method: string = 'GET', payload?: any) {
  const url = `${API_BASE}${endpoint}`;
  const timestamp = new Date().toISOString();
  
  try {
    // Build headers with authentication
    const headers: Record<string, string> = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    
    // Add Authorization header if authenticated
    const authHeader = authService.getAuthHeader();
    if (authHeader) {
      headers['Authorization'] = authHeader;
    }
    
    const response = await fetch(url, {
      method,
      headers,
      body: payload ? JSON.stringify(payload) : undefined
    });

    // Read response as text first, then try to parse as JSON
    const responseText = await response.text();
    let responseBody;
    try {
      responseBody = JSON.parse(responseText);
    } catch {
      // If response is not valid JSON, keep as text
      responseBody = responseText;
    }

    if (!response.ok) {
      // Handle 401 Unauthorized - trigger login
      if (response.status === 401) {
        authService.logout(); // Clear invalid credentials
        showLoginModal.value = true;
        authRequired.value = true;
        throw new Error('Authentication required');
      }
      
      // Capture full error details for developers
      apiError.value = {
        endpoint: url,
        method,
        status: response.status,
        statusText: response.statusText,
        requestPayload: payload || null,
        responseBody,
        timestamp
      };
      showErrorModal.value = true;
      throw new Error(`API Error: ${response.status} ${response.statusText}`);
    }

    return responseBody;
  } catch (error: any) {
    if (!apiError.value) {
      // Network error or other non-response error
      apiError.value = {
        endpoint: url,
        method,
        status: 0,
        statusText: 'Network Error',
        requestPayload: payload || null,
        responseBody: { error: error.message },
        timestamp
      };
      showErrorModal.value = true;
    }
    throw error;
  }
}

/**
 * Helper functions for common HTTP methods
 */
export async function apiGet<T = any>(endpoint: string): Promise<T> {
  return apiCall(endpoint, 'GET');
}

export async function apiPost<T = any>(endpoint: string, payload?: any): Promise<T> {
  return apiCall(endpoint, 'POST', payload);
}

export async function apiPut<T = any>(endpoint: string, payload?: any): Promise<T> {
  return apiCall(endpoint, 'PUT', payload);
}

export async function apiDelete<T = any>(endpoint: string): Promise<T> {
  return apiCall(endpoint, 'DELETE');
}

/**
 * Composable for using the API with error handling
 */
export function useApi() {
  return {
    apiCall,
    apiGet,
    apiPost,
    apiPut,
    apiDelete,
    showErrorModal,
    apiError,
    showLoginModal,
    authRequired
  };
}

