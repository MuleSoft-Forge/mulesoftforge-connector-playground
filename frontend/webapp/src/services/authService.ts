/**
 * Authentication Service
 * 
 * Manages client credentials for MuleSoft API authentication using HTTP Basic Auth.
 * Credentials are stored in sessionStorage and sent with every API request.
 */

import { ref } from 'vue';

// Reactive state for authentication status (shared across app)
export const isAuthenticated = ref(false);

export class AuthService {
  private clientId: string = '';
  private clientSecret: string = '';
  private readonly STORAGE_KEY_ID = 'mce_client_id';
  private readonly STORAGE_KEY_SECRET = 'mce_client_secret';

  constructor() {
    // Auto-load credentials from session on initialization
    this.loadFromSession();
  }

  /**
   * Set authentication credentials
   */
  setCredentials(clientId: string, clientSecret: string): void {
    this.clientId = clientId;
    this.clientSecret = clientSecret;
    
    // Update reactive state
    isAuthenticated.value = !!(clientId && clientSecret);
    
    // Persist to sessionStorage
    if (clientId && clientSecret) {
      sessionStorage.setItem(this.STORAGE_KEY_ID, clientId);
      sessionStorage.setItem(this.STORAGE_KEY_SECRET, clientSecret);
    }
  }

  /**
   * Get HTTP Basic Auth header value
   * Returns: "Basic base64(clientId:clientSecret)"
   */
  getAuthHeader(): string {
    if (this.clientId && this.clientSecret) {
      const credentials = `${this.clientId}:${this.clientSecret}`;
      const encoded = btoa(credentials);
      return `Basic ${encoded}`;
    }
    return '';
  }

  /**
   * Check if user is authenticated
   */
  isAuthenticated(): boolean {
    return !!(this.clientId && this.clientSecret);
  }

  /**
   * Load credentials from sessionStorage
   */
  loadFromSession(): void {
    const clientId = sessionStorage.getItem(this.STORAGE_KEY_ID);
    const clientSecret = sessionStorage.getItem(this.STORAGE_KEY_SECRET);
    
    if (clientId && clientSecret) {
      this.clientId = clientId;
      this.clientSecret = clientSecret;
      isAuthenticated.value = true;
    }
  }

  /**
   * Clear credentials and log out
   */
  logout(): void {
    this.clientId = '';
    this.clientSecret = '';
    isAuthenticated.value = false;
    sessionStorage.removeItem(this.STORAGE_KEY_ID);
    sessionStorage.removeItem(this.STORAGE_KEY_SECRET);
  }

  /**
   * Get current client ID (for display purposes)
   */
  getClientId(): string {
    return this.clientId;
  }
}

// Export singleton instance
export const authService = new AuthService();

