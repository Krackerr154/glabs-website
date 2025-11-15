// @ts-check
import { defineConfig } from 'astro/config';

import tailwindcss from '@tailwindcss/vite';
import sitemap from '@astrojs/sitemap';
import node from '@astrojs/node';

// https://astro.build/config
export default defineConfig({
  site: 'https://g-labs.my.id',
  output: 'server', // SSR
  adapter: node({
    mode: 'standalone'
  }),
  server: {
    // penting: ini yang bikin dia listen di 0.0.0.0 / ::
    port: Number(process.env.PORT) || 4321,
    host: true, // bind ke semua interface, bukan hanya localhost
  },
  integrations: [sitemap()],
  vite: {
    plugins: [tailwindcss()]
  },
  compressHTML: true,
  build: {
    inlineStylesheets: 'auto'
  }
});
