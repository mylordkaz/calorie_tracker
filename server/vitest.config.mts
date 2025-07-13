import { defineWorkersConfig } from '@cloudflare/vitest-pool-workers/config';

export default defineWorkersConfig({
  test: {
    poolOptions: {
      workers: {
        main: 'src/index.ts',
        miniflare: {
          compatibilityDate: '2025-07-09',
          compatibilityFlags: ['nodejs_compat'],
          d1Databases: {
            DB: 'test-db'
          }
        }
      }
    },
    setupFiles: ['./test/setup.ts']
  }
});
