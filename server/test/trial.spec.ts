import { describe, it, expect, beforeEach } from 'vitest';
import { env, createExecutionContext, waitOnExecutionContext, SELF } from 'cloudflare:test';
import type { ExecutionContext } from '@cloudflare/workers-types';

describe('Trial Functionality', () => {
	let ctx: ExecutionContext;

	beforeEach(() => {
		ctx = createExecutionContext();
	});

	describe('GET /api/user/status', () => {
		it('should return trial available for new user', async () => {
			const request = new Request('http://localhost/api/user/status?user_hash=new_user_hash_123', {
				method: 'GET'
			});

			const response = await SELF.fetch(request);
			await waitOnExecutionContext(ctx);

			expect(response.status).toBe(200);
			const data = await response.json();
			expect(data).toEqual({
				can_start_trial: true,
				has_used_trial: false,
				is_purchased: false,
				trial_active: false
			});
		});

		it('should return correct status for user with active trial', async () => {
			// First start a trial
			const startRequest = new Request('http://localhost/api/user/start-trial', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ user_hash: 'active_trial_user' })
			});
			await SELF.fetch(startRequest);

			// Then check status
			const statusRequest = new Request('http://localhost/api/user/status?user_hash=active_trial_user', {
				method: 'GET'
			});

			const response = await SELF.fetch(statusRequest);
			const data = await response.json();

			expect(data.can_start_trial).toBe(false);
			expect(data.has_used_trial).toBeTruthy(); // Accept 1 or true
			expect(data.trial_active).toBeTruthy(); // Accept 1 or true
			expect(data.trial_expires_at).toBeGreaterThan(Math.floor(Date.now() / 1000));
		});

		it('should require user_hash parameter', async () => {
			const request = new Request('http://localhost/api/user/status', {
				method: 'GET'
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.error).toBe('user_hash required');
		});
	});

	describe('POST /api/user/start-trial', () => {
		it('should start trial for new user', async () => {
			const request = new Request('http://localhost/api/user/start-trial', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ user_hash: 'trial_start_user' })
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(200);
			expect(data.success).toBe(true);
			expect(data.trial_started_at).toBeTypeOf('number');
			expect(data.trial_expires_at).toBeTypeOf('number');
			expect(data.trial_expires_at - data.trial_started_at).toBe(14 * 24 * 60 * 60); // 14 days
		});

		it('should reject starting trial for user who already used trial', async () => {
			const userHash = 'used_trial_user';

			// Start trial first time
			const firstRequest = new Request('http://localhost/api/user/start-trial', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ user_hash: userHash })
			});
			await SELF.fetch(firstRequest);

			// Try to start trial again
			const secondRequest = new Request('http://localhost/api/user/start-trial', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({ user_hash: userHash })
			});

			const response = await SELF.fetch(secondRequest);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.success).toBe(false);
			expect(data.error).toBe('Trial already used or user has purchased');
		});

		it('should require user_hash parameter', async () => {
			const request = new Request('http://localhost/api/user/start-trial', {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify({})
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(response.status).toBe(400);
			expect(data.error).toBe('user_hash required');
		});
	});

	describe('Trial expiration logic', () => {
		it('should detect expired trial', async () => {
			const userHash = 'expired_trial_user';

			// Manually insert expired trial user
			const pastTime = Math.floor(Date.now() / 1000) - (15 * 24 * 60 * 60); // 15 days ago
			const expiredTime = pastTime + (14 * 24 * 60 * 60); // 1 day ago

			await env.DB.prepare(`
        INSERT INTO users (user_hash, trial_started_at, trial_expires_at, has_used_trial, created_at, updated_at)
        VALUES (?, ?, ?, TRUE, ?, ?)
      `).bind(userHash, pastTime, expiredTime, pastTime, pastTime).run();

			// Check status
			const request = new Request(`http://localhost/api/user/status?user_hash=${userHash}`, {
				method: 'GET'
			});

			const response = await SELF.fetch(request);
			const data = await response.json();

			expect(data.trial_active).toBe(false);
			expect(data.has_used_trial).toBeTruthy(); // Accept 1 or true
			expect(data.can_start_trial).toBe(false);
		});
	});
});
