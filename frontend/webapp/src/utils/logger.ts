/**
 * Logging utility
 * 
 * Provides structured logging with environment-aware behavior.
 * Debug logs only appear in development mode.
 */

import { isDev } from '../config/api';

export const logger = {
  /**
   * Debug-level logging (only in development)
   * Use for verbose debugging information
   */
  debug: (...args: any[]) => {
    if (isDev) {
      console.log('[DEBUG]', ...args);
    }
  },

  /**
   * Info-level logging
   * Use for general informational messages
   */
  info: (...args: any[]) => {
    console.info('[INFO]', ...args);
  },

  /**
   * Warning-level logging
   * Use for potentially problematic situations
   */
  warn: (...args: any[]) => {
    console.warn('[WARN]', ...args);
  },

  /**
   * Error-level logging
   * Use for error conditions
   */
  error: (...args: any[]) => {
    console.error('[ERROR]', ...args);
  },
};

