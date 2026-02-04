import { ref, watch, unref, type Ref, type ComputedRef } from 'vue';
import { logger } from '../utils/logger';

/**
 * Composable to load SVG/images with correct MIME type.
 * Mule server sends application/octet-stream, but browsers need image/svg+xml for SVG.
 * Fetches as blob, corrects MIME type, converts to data URL.
 */
export function useImageWithCorrectMimeType(
  imageUrl: string | undefined | Ref<string | undefined> | ComputedRef<string | undefined>
) {
  const dataUrl = ref<string | null>(null);
  const loading = ref(false);
  const error = ref<string | null>(null);

  async function loadImage() {
    const url = unref(imageUrl);
    
    if (!url) {
      dataUrl.value = null;
      return;
    }

    // If already a data URI, use it directly (no fetch needed!)
    if (url.startsWith('data:')) {
      dataUrl.value = url;
      loading.value = false;
      error.value = null;
      return;
    }

    loading.value = true;
    error.value = null;

    try {
      // Fetch image as blob
      const response = await fetch(url, {
        headers: { 'Accept': 'image/svg+xml,image/png,image/jpeg,image/webp,image/*' }
      });

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`);
      }

      const blob = await response.blob();
      
      // Fix MIME type: if URL ends with .svg, force image/svg+xml; otherwise use blob type
      const correctMimeType = url.endsWith('.svg') ? 'image/svg+xml' : blob.type;
      const correctedBlob = new Blob([blob], { type: correctMimeType });
      
      // Convert to data URL for display
      const reader = new FileReader();
      reader.onloadend = () => {
        dataUrl.value = reader.result as string;
        loading.value = false;
      };
      reader.onerror = () => {
        error.value = 'Failed to read image';
        loading.value = false;
      };
      reader.readAsDataURL(correctedBlob);
    } catch (err: any) {
      logger.error('Error loading image:', err);
      error.value = err?.message || 'Failed to load image';
      loading.value = false;
    }
  }

  watch(() => unref(imageUrl), loadImage, { immediate: true });

  return { dataUrl, loading, error };
}

