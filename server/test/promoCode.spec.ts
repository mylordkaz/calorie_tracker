import { describe, it, expect, beforeEach } from 'vitest';
import { env, createExecutionContext, waitOnExecutionContext, SELF } from 'cloudflare:test';
import type { ExecutionContext } from '@cloudflare/workers-types';

describe('Promo Code Functionality', () => {
	let ctx: ExecutionContext;

	beforeEach(() => {
		ctx = createExecutionContext();
	});

	describe('POST /api/promo/redeem', () => {
		it('should successfully redeem valid promo code for new user', async () => {
			// Insert test promo code
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 100, 0, ?)
      `).bind('TESTCODE123', Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'promo_new_user',
					promo_code: 'TESTCODE123'
				})
			});

			const response = await SELF.fetch(request);
			await waitOnExecutionContext(ctx);

			expect(response.status).toBe(200);
			const data = await response.json();
			expect(data.success).toBe(true);
			expect(data.is_purchased).toBe(true);

			// Verify user was created with purchased status
			const user = await env.DB.prepare(
				'SELECT * FROM users WHERE user_hash = ?'
			).bind('promo_new_user').first();
			expect(user.is_purchased).toBeTruthy();
		});

		it('should successfully redeem valid promo code for existing user', async () => {
			// Create existing user
			const now = Math.floor(Date.now() / 1000);
			await env.DB.prepare(`
        INSERT INTO users (user_hash, has_used_trial, is_purchased, created_at, updated_at)
        VALUES (?, TRUE, FALSE, ?, ?)
      `).bind('existing_user', now, now).run();

			// Insert test promo code
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 50, 5, ?)
      `).bind('EXISTING50', Math.floor(Date.now() / 1000) + (60 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'existing_user',
					promo_code: 'EXISTING50'
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(200);
			expect(data.success).toBe(true);
			expect(data.is_purchased).toBe(true);

			// Verify user was updated to purchased
			const user = await env.DB.prepare(
				'SELECT * FROM users WHERE user_hash = ?'
			).bind('existing_user').first();
			expect(user.is_purchased).toBeTruthy();
		});

		it('should reject invalid promo code', async () => {
			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'invalid_code_user',
					promo_code: 'INVALIDCODE'
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.success).toBe(false);
			expect(data.error).toBe('Invalid or expired promo code');
		});

		it('should reject expired promo code', async () => {
			// Insert expired promo code
			const expiredTime = Math.floor(Date.now() / 1000) - (24 * 60 * 60); // 1 day ago
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 100, 0, ?)
      `).bind('EXPIREDCODE', expiredTime).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'expired_test_user',
					promo_code: 'EXPIREDCODE'
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.success).toBe(false);
			expect(data.error).toBe('Invalid or expired promo code');
		});

		it('should reject inactive promo code', async () => {
			// Insert inactive promo code
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, FALSE, 100, 0, ?)
      `).bind('INACTIVECODE', Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'inactive_test_user',
					promo_code: 'INACTIVECODE'
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.success).toBe(false);
			expect(data.error).toBe('Invalid or expired promo code');
		});

		it('should reject promo code at usage limit', async () => {
			// Insert promo code at usage limit
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 5, 5, ?)
      `).bind('LIMITREACHED', Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'limit_test_user',
					promo_code: 'LIMITREACHED'
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.success).toBe(false);
			expect(data.error).toBe('Promo code usage limit exceeded');
		});

		it('should reject duplicate redemption by same user', async () => {
			const userHash = 'duplicate_user';
			const promoCode = 'DUPLICATETEST';

			// Insert promo code
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 100, 0, ?)
      `).bind(promoCode, Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			// First redemption
			const firstRequest = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: userHash,
					promo_code: promoCode
				})
			});
			await SELF.fetch(firstRequest);

			// Second redemption attempt
			const secondRequest = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: userHash,
					promo_code: promoCode
				})
			});

			const response = await SELF.fetch(secondRequest);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.success).toBe(false);
			expect(data.error).toBe('Promo code already redeemed');
		});

		it('should require user_hash parameter', async () => {
			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ promo_code: 'TESTCODE' })
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.error).toBe('Missing required fields');
		});

		it('should require promo_code parameter', async () => {
			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ user_hash: 'test_user' })
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.error).toBe('Missing required fields');
		});

		it('should handle invalid JSON', async () => {
			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: 'invalid-json'
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.error).toBe('Invalid JSON');
		});

		it('should increment used_count on successful redemption', async () => {
			const promoCode = 'COUNTTEST';

			// Insert promo code with initial count
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 100, 5, ?)
      `).bind(promoCode, Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'count_test_user',
					promo_code: promoCode
				})
			});

			await SELF.fetch(request);

			// Verify used_count was incremented
			const updatedPromo = await env.DB.prepare(
				'SELECT used_count FROM promo_codes WHERE code = ?'
			).bind(promoCode).first();
			expect(updatedPromo.used_count).toBe(6);
		});

		it('should create redemption record', async () => {
			const userHash = 'record_test_user';
			const promoCode = 'RECORDTEST';

			// Insert promo code
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 100, 0, ?)
      `).bind(promoCode, Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: userHash,
					promo_code: promoCode
				})
			});

			await SELF.fetch(request);

			// Verify redemption record was created
			const redemption = await env.DB.prepare(
				'SELECT * FROM promo_redemptions WHERE user_hash = ? AND promo_code = ?'
			).bind(userHash, promoCode).first();

			expect(redemption).toBeTruthy();
			expect(redemption.user_hash).toBe(userHash);
			expect(redemption.promo_code).toBe(promoCode);
			expect(redemption.redeemed_at).toBeTypeOf('number');
		});

		it('should handle unlimited usage promo codes', async () => {
			const promoCode = 'UNLIMITED';

			// Insert unlimited promo code (usage_limit = null)
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, NULL, 999, ?)
      `).bind(promoCode, Math.floor(Date.now() / 1000) + (30 * 24 * 60 * 60)).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'unlimited_user',
					promo_code: promoCode
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(200);
			expect(data.success).toBe(true);
			expect(data.is_purchased).toBe(true);
		});

		it('should handle promo codes with no expiry', async () => {
			const promoCode = 'NOEXPIRY';

			// Insert promo code with no expiry (expires_at = null)
			await env.DB.prepare(`
        INSERT INTO promo_codes (code, is_active, usage_limit, used_count, expires_at)
        VALUES (?, TRUE, 100, 0, NULL)
      `).bind(promoCode).run();

			const request = new Request('http://localhost/api/promo/redeem', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({
					user_hash: 'no_expiry_user',
					promo_code: promoCode
				})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(200);
			expect(data.success).toBe(true);
			expect(data.is_purchased).toBe(true);
		});
	});
});
