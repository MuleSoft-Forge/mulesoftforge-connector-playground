import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

// No proxy: API runs on http://localhost:8081; configure CORS in Mule for dev.
export default defineConfig(({ command }) => ({
  base: command === 'build' ? '/webapp/' : '/',
  plugins: [vue()],
  server: {
    port: 5173,
    strictPort: true
  },
  build: {
    outDir: 'dist'
  }
}));


