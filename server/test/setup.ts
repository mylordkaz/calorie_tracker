import { beforeAll, afterEach } from 'vitest';
import { env } from 'cloudflare:test';

beforeAll(async () => {
	// Debug: Check if DB is available
	console.log('DB available:', !!env.DB);
	console.log('DB methods:', env.DB ? Object.getOwnPropertyNames(Object.getPrototypeOf(env.DB)) : 'No DB');

	if (!env.DB || !env.DB.prepare) {
		throw new Error('D1 Database not properly initialized in test environment');
	}

	// Initialize test database schema - create tables individually
	try {
		await env.DB.prepare(`
      CREATE TABLE IF NOT EXISTS users (
        user_hash VARCHAR(64) UNIQUE NOT NULL PRIMARY KEY,
        trial_started_at INTEGER,
        trial_expires_at INTEGER,
        has_used_trial BOOLEAN DEFAULT FALSE,
        is_purchased BOOLEAN DEFAULT FALSE,
        purchase_token VARCHAR(500),
        purchase_platform VARCHAR(10) CHECK (purchase_platform IN ('apple', 'google')),
        purchase_validated_at INTEGER,
        created_at INTEGER DEFAULT (strftime('%s', 'now')),
        updated_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
    `).run();

		await env.DB.prepare(`
      CREATE TABLE IF NOT EXISTS promo_codes (
        code VARCHAR(50) UNIQUE NOT NULL PRIMARY KEY,
        is_active BOOLEAN DEFAULT TRUE,
        usage_limit INTEGER,
        used_count INTEGER DEFAULT 0,
        expires_at INTEGER,
        created_at INTEGER DEFAULT (strftime('%s', 'now'))
      )
    `).run();

		await env.DB.prepare(`
      CREATE TABLE IF NOT EXISTS promo_redemptions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_hash VARCHAR(64) NOT NULL,
        promo_code VARCHAR(50) NOT NULL,
        redeemed_at INTEGER DEFAULT (strftime('%s', 'now')),
        FOREIGN KEY (user_hash) REFERENCES users(user_hash) ON DELETE CASCADE,
        FOREIGN KEY (promo_code) REFERENCES promo_codes(code) ON DELETE CASCADE,
        UNIQUE(user_hash, promo_code)
      )
    `).run();

		console.log('✅ Database tables created successfully');
	} catch (error) {
		console.error('❌ Failed to create database tables:', error);
		throw error;
	}
});

afterEach(async () => {
	// Clean up test data after each test
	try {
		await env.DB.prepare('DELETE FROM promo_redemptions').run();
		await env.DB.prepare('DELETE FROM promo_codes').run();
		await env.DB.prepare('DELETE FROM users').run();
	} catch (error) {
		console.error('❌ Failed to clean up test data:', error);
	}
});
