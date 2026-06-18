-- Campus Print Gateway initial PostgreSQL schema
-- Draft schema for handoff and MVP planning.
-- Do not store plaintext passwords or real user data in this repository.

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,

    balance INTEGER NOT NULL DEFAULT 0,

    status TEXT NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN (
            'ACTIVE',
            'LOCKED_OVERPRINT',
            'LOCKED_MANUAL',
            'DISABLED'
        )),

    locked_reason TEXT,
    locked_at TIMESTAMPTZ,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS print_jobs (
    job_id TEXT PRIMARY KEY,

    user_id BIGINT REFERENCES users(user_id) ON DELETE SET NULL,

    status TEXT NOT NULL
        CHECK (status IN (
            'RECEIVED',
            'PENDING_USER_AUTH',
            'AUTH_FAILED',
            'CANCELLED',
            'CONFIRMED',
            'SUBMITTED_TO_CUPS',
            'PRINTED',
            'FAILED',
            'EXPIRED'
        )),

    file_name TEXT,
    file_hash TEXT,

    pages INTEGER,
    copies INTEGER NOT NULL DEFAULT 1,

    balance_before INTEGER,
    balance_after INTEGER,

    overprint_triggered BOOLEAN NOT NULL DEFAULT FALSE,

    cups_job_id TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    confirmed_at TIMESTAMPTZ,
    submitted_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS job_events (
    event_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    job_id TEXT NOT NULL REFERENCES print_jobs(job_id) ON DELETE CASCADE,

    event_type TEXT NOT NULL,
    message TEXT,

    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_print_jobs_user_id
    ON print_jobs(user_id);

CREATE INDEX IF NOT EXISTS idx_print_jobs_status
    ON print_jobs(status);

CREATE INDEX IF NOT EXISTS idx_job_events_job_id
    ON job_events(job_id);
