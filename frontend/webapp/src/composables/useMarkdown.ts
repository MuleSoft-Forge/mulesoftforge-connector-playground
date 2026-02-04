import { marked } from 'marked'
import DOMPurify from 'dompurify'
import { logger } from '../utils/logger'

/**
 * Composable for safely parsing and rendering markdown content
 * Uses marked for parsing and DOMPurify for sanitization to prevent XSS attacks
 */
export function useMarkdown() {
  /**
   * Parse markdown string to sanitized HTML
   * @param markdown - Raw markdown string
   * @returns Sanitized HTML string safe for v-html
   */
  const parseMarkdown = (markdown: string | null | undefined): string => {
    if (!markdown) return ''
    
    try {
      // Configure marked for better rendering
      marked.setOptions({
        breaks: true, // Support GitHub-style line breaks
        gfm: true, // GitHub Flavored Markdown
      })
      
      // Parse markdown to HTML
      const rawHtml = marked.parse(markdown) as string
      
      // Sanitize to prevent XSS attacks
      const cleanHtml = DOMPurify.sanitize(rawHtml, {
        ALLOWED_TAGS: [
          'p', 'br', 'strong', 'em', 'u', 'a', 'ul', 'ol', 'li', 
          'blockquote', 'code', 'pre', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
          'table', 'thead', 'tbody', 'tr', 'th', 'td', 'hr', 'del', 'sup', 'sub'
        ],
        ALLOWED_ATTR: ['href', 'target', 'rel', 'class'],
        ALLOWED_URI_REGEXP: /^(?:(?:(?:f|ht)tps?|mailto|tel|callto|sms|cid|xmpp):|[^a-z]|[a-z+.\-]+(?:[^a-z+.\-:]|$))/i,
      })
      
      return cleanHtml
    } catch (error) {
      logger.error('Error parsing markdown:', error)
      return markdown // Fallback to raw text if parsing fails
    }
  }

  return {
    parseMarkdown
  }
}

