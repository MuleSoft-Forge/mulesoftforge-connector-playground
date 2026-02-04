import { WS_URL } from '../config/api'
import { logger } from './logger'

export interface StreamingEvent {
  kind: 'task' | 'status-update' | 'artifact-update' | 'message'
  taskId?: string
  contextId?: string
  status?: {
    state: string
    message?: any
    timestamp?: string
  }
  artifact?: any
  final?: boolean
  [key: string]: any
}

export interface WebSocketExecutionParams {
  operationId: number
  runtimeConfigId: number
  parameters: Record<string, any>
  enableLogging: boolean
  enableValidation: boolean
}

export interface WebSocketExecutionCallbacks {
  onConnect?: () => void
  onEvent?: (event: StreamingEvent) => void
  onComplete?: (result: any) => void
  onError?: (error: any) => void
  onClose?: () => void
}

export class WebSocketExecutor {
  private ws: WebSocket | null = null
  private callbacks: WebSocketExecutionCallbacks = {}

  constructor(callbacks: WebSocketExecutionCallbacks = {}) {
    this.callbacks = callbacks
  }

  execute(params: WebSocketExecutionParams): void {
    // Close existing connection if any
    this.close()

    const wsUrl = WS_URL + '/execute'
    logger.info('Connecting to WebSocket:', wsUrl)

    this.ws = new WebSocket(wsUrl)

    this.ws.onopen = () => {
      logger.info('WebSocket connected')
      this.callbacks.onConnect?.()

      // Send execution request
      const payload = JSON.stringify(params)
      logger.info('Sending execution request:', params)
      this.ws?.send(payload)
    }

    this.ws.onmessage = async (event) => {
      try {
        // Handle Blob data (convert to text first)
        let messageText: string
        if (event.data instanceof Blob) {
          messageText = await event.data.text()
          logger.info('🔵 WebSocket Blob received, converted to text')
        } else {
          messageText = event.data
        }
        
        const data = JSON.parse(messageText)
        logger.info('🔵 WebSocket message received:', data)

        // Check if this is a JSON-RPC response (A2A streaming from Mule)
        if (data.jsonrpc && data.result) {
          logger.info('📦 JSON-RPC message detected')
          const event = data.result
          
          // Process the event
          if (event.kind) {
            logger.info(`📥 Processing ${event.kind} event, final: ${event.final}`)
            this.callbacks.onEvent?.(event as StreamingEvent)
            
            // Check if this is the final event
            if (event.final === true) {
              logger.info('🏁 Final event received (final=true), completing execution')
              
              // Create completion response
              const completionResponse = {
                executionId: data.id || 'ws-' + Date.now(),
                status: 'success',
                result: { events: [] }  // Events already sent via onEvent
              }
              
              this.callbacks.onComplete?.(completionResponse)
            } else {
              logger.info('⏳ Waiting for more events (final=false)...')
            }
          }
        } else if (data.events && Array.isArray(data.events)) {
          logger.info('🌊 Found events array with', data.events.length, 'events')
          
          // Process each event
          data.events.forEach((evt: StreamingEvent, index: number) => {
            logger.info(`📥 Processing event ${index + 1}:`, evt.kind, evt)
            this.callbacks.onEvent?.(evt)
          })
          
          // DON'T call onComplete - wait for more messages or connection close
          logger.info('⏳ Keeping connection open for more messages...')
        } else if (data.executionId && data.status) {
          logger.info('✅ Detected standard execution response with executionId:', data.executionId)
          
          // Standard response with result
          if (data.result && data.result.events && Array.isArray(data.result.events)) {
            logger.info('🌊 Found events array in result with', data.result.events.length, 'events')
            
            // A2A streaming response with events array
            data.result.events.forEach((evt: StreamingEvent, index: number) => {
              logger.info(`📥 Processing event ${index + 1}:`, evt.kind, evt)
              this.callbacks.onEvent?.(evt)
            })
          }
          
          // This is a final wrapped response - complete execution
          logger.info('🏁 Final response with executionId, completing')
          this.callbacks.onComplete?.(data)
        } else if (data.kind) {
          logger.info('📦 Detected individual streaming event:', data.kind)
          
          // Individual streaming event
          this.callbacks.onEvent?.(data as StreamingEvent)
          
          // Check if this is the final event
          if (data.final === true) {
            logger.info('🏁 Final event received, completing')
            this.callbacks.onComplete?.(data)
          }
        } else {
          logger.warn('⚠️ Unknown response format')
          // DON'T complete - just log it
          logger.info('Raw data:', data)
        }
      } catch (err) {
        logger.error('❌ Failed to parse WebSocket message:', err)
        this.callbacks.onError?.(err)
      }
    }

    this.ws.onerror = (error) => {
      logger.error('WebSocket error:', error)
      this.callbacks.onError?.(error)
    }

    this.ws.onclose = () => {
      logger.info('WebSocket connection closed')
      this.callbacks.onClose?.()
      this.ws = null
    }
  }

  close(): void {
    if (this.ws) {
      logger.info('Closing WebSocket connection')
      this.ws.close()
      this.ws = null
    }
  }

  isConnected(): boolean {
    return this.ws !== null && this.ws.readyState === WebSocket.OPEN
  }
}

