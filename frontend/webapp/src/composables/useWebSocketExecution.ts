import { ref } from 'vue'
import { WebSocketExecutor, type StreamingEvent, type WebSocketExecutionParams } from '../utils/websocket'
import { logger } from '../utils/logger'

export function useWebSocketExecution() {
  const executing = ref(false)
  const streamingEvents = ref<StreamingEvent[]>([])
  const lastResponse = ref<any>(null)
  const executionError = ref<any>(null)
  const connected = ref(false)

  let executor: WebSocketExecutor | null = null

  function executeViaWebSocket(params: WebSocketExecutionParams) {
    // Reset state
    executing.value = true
    streamingEvents.value = []
    lastResponse.value = null
    executionError.value = null
    connected.value = false

    logger.info('Starting WebSocket execution:', params)

    executor = new WebSocketExecutor({
      onConnect: () => {
        connected.value = true
        logger.info('WebSocket connected')
      },

      onEvent: (event: StreamingEvent) => {
        logger.info('🎯 Streaming event received in composable:', event)
        streamingEvents.value.push(event)
        logger.info(`📊 Total events now: ${streamingEvents.value.length}`)
      },

      onComplete: (result: any) => {
        logger.info('✅ Execution complete:', result)
        logger.info(`📊 Final event count: ${streamingEvents.value.length}`)
        logger.info('📋 All events:', streamingEvents.value)
        lastResponse.value = result
        executing.value = false
        
        // Auto-close the connection after complete
        setTimeout(() => {
          closeConnection()
        }, 500)
      },

      onError: (error: any) => {
        logger.error('WebSocket error:', error)
        executionError.value = error
        executing.value = false
      },

      onClose: () => {
        connected.value = false
        logger.info('🔌 WebSocket closed')
        
        if (executing.value) {
          // Connection closed - treat as completion if we have events
          if (streamingEvents.value.length > 0) {
            logger.info('✅ Connection closed with events - completing execution')
            
            // Create a final response with all collected events
            lastResponse.value = {
              executionId: 'ws-' + Date.now(),
              status: 'success',
              result: {
                events: streamingEvents.value
              }
            }
          }
          
          executing.value = false
        }
      }
    })

    executor.execute(params)
  }

  function closeConnection() {
    if (executor) {
      executor.close()
      executor = null
      connected.value = false
    }
  }

  function clearResults() {
    streamingEvents.value = []
    lastResponse.value = null
    executionError.value = null
  }

  return {
    executing,
    streamingEvents,
    lastResponse,
    executionError,
    connected,
    executeViaWebSocket,
    closeConnection,
    clearResults
  }
}

