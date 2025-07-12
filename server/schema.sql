CREATE TABLE users (
    user_hash VARCHAR(64) UNIQUE NOT NULL PRIMARY KEY,
    trial_started_at INTEGER, -- Unix timestamp
    trial_expires_at INTEGER,  -- Unix timestamp
    has_used_trial BOOLEAN DEFAULT FALSE,
    is_purchased BOOLEAN DEFAULT FALSE,
    purchase_token VARCHAR(500),
    purchase_platform VARCHAR(10) CHECK (purchase_platform IN ('apple', 'google')),
    purchase_validated_at INTEGER, -- Unix timestamp
    created_at INTEGER DEFAULT (strftime('%s', 'now')), -- Unix timestamp
    updated_at INTEGER DEFAULT (strftime('%s', 'now'))  -- Unix timestamp
);

CREATE TABLE promo_codes (
    code VARCHAR(50) UNIQUE NOT NULL PRIMARY KEY,
    is_active BOOLEAN DEFAULT TRUE,
    usage_limit INTEGER,
    used_count INTEGER DEFAULT 0,
    expires_at INTEGER, -- Unix timestamp
    created_at INTEGER DEFAULT (strftime('%s', 'now')) -- Unix timestamp
);

CREATE TABLE promo_redemptions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_hash VARCHAR(64) NOT NULL,
    promo_code VARCHAR(50) NOT NULL,
    redeemed_at INTEGER DEFAULT (strftime('%s', 'now')), -- Unix timestamp
    FOREIGN KEY (user_hash) REFERENCES users(user_hash) ON DELETE CASCADE,
    FOREIGN KEY (promo_code) REFERENCES promo_codes(code) ON DELETE CASCADE,
    UNIQUE(user_hash, promo_code)
);

CREATE INDEX idx_users_trial_expires ON users(trial_expires_at);
CREATE INDEX idx_users_purchase_status ON users(is_purchased);
CREATE INDEX idx_users_has_used_trial ON users(has_used_trial);
CREATE INDEX idx_promo_codes_active ON promo_codes(is_active);
CREATE INDEX idx_promo_codes_expires ON promo_codes(expires_at);
CREATE INDEX idx_promo_redemptions_user ON promo_redemptions(user_hash);
CREATE INDEX idx_promo_redemptions_code ON promo_redemptions(promo_code);

INSERT INTO promo_codes (code, usage_limit, expires_at) VALUES
    ('TEST123', 100, strftime('%s', 'now', '+1 year')),
    ('LAUNCH50', 50, strftime('%s', 'now', '+6 months')),
    ('UNLIMITED', NULL, NULL);
