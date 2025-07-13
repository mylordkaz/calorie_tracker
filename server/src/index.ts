export interface Env {
	DB: D1Database;
}

interface StartTrialRequest {
	user_hash: string;
}

interface ValidatePurchaseRequest {
	user_hash: string;
	purchase_token: string;
	platform: 'apple' | 'google';
}

interface RedeemPromoRequest {
	user_hash: string;
	promo_code: string;
}

export default {
	async fetch(request: Request, env: Env): Promise<Response> {
		const url = new URL(request.url);
		const path = url.pathname;

		// CORS
		const corsHeaders = {
			'Access-Control-Allow-Origin': '*',
			'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
			'Access-Control-Allow-Headers': 'Content-Type, Authorization',
		}

		if (request.method === 'OPTIONS') {
			return new Response(null, { headers: corsHeaders });
		}

		try {
			let response: Response;

			switch (path) {
				case '/api/user/status':
					response = await handleUserStatus(request, env);
					break;
				case '/api/user/start-trial':
					response = await handleStartTrial(request, env);
					break;
				case '/api/user/validate-purchase':
					response = await handleValidatePurchase(request, env);
					break;
				case '/api/promo/redeem':
					response = await handleRedeemPromo(request, env);
					break;
				default:
					response = new Response('Not Found', { status: 404 });
			}

			// add CORS to response
			Object.entries(corsHeaders).forEach(([key, value]) => {
				response.headers.set(key, value);
			});

			return response;
		} catch (error) {
			console.error('API Error:', error);
			return new Response(JSON.stringify({ error: 'Internal Server Error' }), {
				status: 500,
				headers: { ...corsHeaders, 'Content-Type': 'application/json' }
			});
		}
	}
};

// get user status
async function handleUserStatus(request: Request, env: Env): Promise<Response> {
	if (request.method !== 'GET') {
		return new Response('Method Not Allowed', { status: 405 });
	}

	const url = new URL(request.url);
	const userHash = url.searchParams.get('user_hash');

	if (!userHash) {
		return new Response(JSON.stringify({ error: 'user_hash required' }), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	const user = await env.DB.prepare(
		'SELECT * FROM users WHERE user_hash = ?'
	).bind(userHash).first();

	const now = Math.floor(Date.now() / 1000);

	if (!user) {
		return new Response(JSON.stringify({
			can_start_trial: true,
			has_used_trial: false,
			is_purchased: false,
			trial_active: false
		}), {
			headers: { 'Content-Type': 'application/json' }
		});
	}

	// Type assertions for database values
	const trialStartedAt = user.trial_started_at as number | null;
	const trialExpiresAt = user.trial_expires_at as number | null;
	const hasUsedTrial = user.has_used_trial as boolean;
	const isPurchased = user.is_purchased as boolean;

	const trialActive = trialStartedAt && trialExpiresAt && trialExpiresAt > now;

	return new Response(JSON.stringify({
		can_start_trial: !hasUsedTrial && !isPurchased,
		has_used_trial: hasUsedTrial,
		is_purchased: isPurchased,
		trial_active: trialActive,
		trial_expires_at: trialExpiresAt
	}), {
		headers: { 'Content-Type': 'application/json' }
	});
}

// Start trial
async function handleStartTrial(request: Request, env: Env): Promise<Response> {
	if (request.method !== 'POST') {
		return new Response('Method Not Allowed', { status: 405 });
	}

	const { user_hash }: StartTrialRequest = await request.json();

	if (!user_hash) {
		return new Response(JSON.stringify({ error: 'user_hash required' }), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	// Check if user already exists and has used trial
	const existingUser = await env.DB.prepare(
		'SELECT * FROM users WHERE user_hash = ?'
	).bind(user_hash).first();

	if (existingUser && (existingUser.has_used_trial || existingUser.is_purchased)) {
		return new Response(JSON.stringify({
			success: false,
			error: 'Trial already used or user has purchased'
		}), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	const now = Math.floor(Date.now() / 1000);
	const trialExpires = now + (14 * 24 * 60 * 60); // 14 days

	if (existingUser) {
		// Update existing user
		await env.DB.prepare(`
      UPDATE users
      SET trial_started_at = ?, trial_expires_at = ?, has_used_trial = TRUE, updated_at = ?
      WHERE user_hash = ?
    `).bind(now, trialExpires, now, user_hash).run();
	} else {
		// Create new user
		await env.DB.prepare(`
      INSERT INTO users (user_hash, trial_started_at, trial_expires_at, has_used_trial, created_at, updated_at)
      VALUES (?, ?, ?, TRUE, ?, ?)
    `).bind(user_hash, now, trialExpires, now, now).run();
	}

	return new Response(JSON.stringify({
		success: true,
		trial_started_at: now,
		trial_expires_at: trialExpires
	}), {
		headers: { 'Content-Type': 'application/json' }
	});
}

// Validate purchase
async function handleValidatePurchase(request: Request, env: Env): Promise<Response> {
	if (request.method !== 'POST') {
		return new Response('Method Not Allowed', { status: 405 });
	}

	const { user_hash, purchase_token, platform }: ValidatePurchaseRequest = await request.json();

	if (!user_hash || !purchase_token || !platform) {
		return new Response(JSON.stringify({ error: 'Missing required fields' }), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	if (!['apple', 'google'].includes(platform)) {
		return new Response(JSON.stringify({ error: 'Invalid platform' }), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	// TODO: Add actual receipt validation with Apple/Google
	// For now, we'll just mark as purchased

	const now = Math.floor(Date.now() / 1000);

	const existingUser = await env.DB.prepare(
		'SELECT * FROM users WHERE user_hash = ?'
	).bind(user_hash).first();

	if (existingUser) {
		await env.DB.prepare(`
      UPDATE users
      SET is_purchased = TRUE, purchase_token = ?, purchase_platform = ?, purchase_validated_at = ?, updated_at = ?
      WHERE user_hash = ?
    `).bind(purchase_token, platform, now, now, user_hash).run();
	} else {
		await env.DB.prepare(`
      INSERT INTO users (user_hash, is_purchased, purchase_token, purchase_platform, purchase_validated_at, created_at, updated_at)
      VALUES (?, TRUE, ?, ?, ?, ?, ?)
    `).bind(user_hash, purchase_token, platform, now, now, now).run();
	}

	return new Response(JSON.stringify({
		success: true,
		is_purchased: true
	}), {
		headers: { 'Content-Type': 'application/json' }
	});
}

// Redeem promo code
async function handleRedeemPromo(request: Request, env: Env): Promise<Response> {
	if (request.method !== 'POST') {
		return new Response('Method Not Allowed', { status: 405 });
	}

	// Handle JSON parsing errors
	let requestData: RedeemPromoRequest;
	try {
		requestData = await request.json() as RedeemPromoRequest;
	} catch (error) {
		return new Response(JSON.stringify({ error: 'Invalid JSON' }), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	const { user_hash, promo_code } = requestData;

	if (!user_hash || !promo_code) {
		return new Response(JSON.stringify({ error: 'Missing required fields' }), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	const now = Math.floor(Date.now() / 1000);

	// Check if promo code exists and is valid
	const promoCode = await env.DB.prepare(
		'SELECT * FROM promo_codes WHERE code = ? AND is_active = TRUE AND (expires_at IS NULL OR expires_at > ?)'
	).bind(promo_code, now).first();

	if (!promoCode) {
		return new Response(JSON.stringify({
			success: false,
			error: 'Invalid or expired promo code'
		}), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	// Type assertions for database values
	const usageLimit = promoCode.usage_limit as number | null;
	const usedCount = promoCode.used_count as number;

	// Check usage limit
	if (usageLimit && usedCount >= usageLimit) {
		return new Response(JSON.stringify({
			success: false,
			error: 'Promo code usage limit exceeded'
		}), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	// Check if user already redeemed this code
	const existingRedemption = await env.DB.prepare(
		'SELECT * FROM promo_redemptions WHERE user_hash = ? AND promo_code = ?'
	).bind(user_hash, promo_code).first();

	if (existingRedemption) {
		return new Response(JSON.stringify({
			success: false,
			error: 'Promo code already redeemed'
		}), {
			status: 400,
			headers: { 'Content-Type': 'application/json' }
		});
	}

	try {
		// Check if user exists first
		const existingUser = await env.DB.prepare(
			'SELECT * FROM users WHERE user_hash = ?'
		).bind(user_hash).first();

		const statements = [];

		if (existingUser) {
			// Update existing user
			statements.push(
				env.DB.prepare(`
					UPDATE users
					SET is_purchased = TRUE, updated_at = ?
					WHERE user_hash = ?
				`).bind(now, user_hash)
			);
		} else {
			// Create new user
			statements.push(
				env.DB.prepare(`
					INSERT INTO users (user_hash, is_purchased, created_at, updated_at)
					VALUES (?, TRUE, ?, ?)
				`).bind(user_hash, now, now)
			);
		}

		statements.push(
			env.DB.prepare(`
				INSERT INTO promo_redemptions (user_hash, promo_code, redeemed_at)
				VALUES (?, ?, ?)
			`).bind(user_hash, promo_code, now)
		);

		statements.push(
			env.DB.prepare(`
				UPDATE promo_codes
				SET used_count = used_count + 1
				WHERE code = ?
			`).bind(promo_code)
		);

		await env.DB.batch(statements);

		return new Response(JSON.stringify({
			success: true,
			is_purchased: true
		}), {
			headers: { 'Content-Type': 'application/json' }
		});

	} catch (error) {
		console.error('Promo redemption error:', error);
		return new Response(JSON.stringify({
			success: false,
			error: 'Failed to redeem promo code'
		}), {
			status: 500,
			headers: { 'Content-Type': 'application/json' }
		});
	}
}
