-- Campus Print Gateway initial schema
-- This is a draft schema for handoff and MVP planning.

CREATE TABLE IF NOT EXISTS users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(128) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    balance INT NOT NULL DEFAULT 0,
    status VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    locked_reason VARCHAR(255) NULL,
    locked_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS print_jobs (
    job_id VARCHAR(64) PRIMARY KEY,
    user_id BIGINT NULL,
    status VARCHAR(32) NOT NULL,
    file_name VARCHAR(255) NULL,
    file_hash VARCHAR(128) NULL,
    pages INT NULL,
    copies INT NOT NULL DEFAULT 1,
    balance_before INT NULL,
    balance_after INT NULL,
    overprint_triggered BOOLEAN NOT NULL DEFAULT FALSE,
    cups_job_id VARCHAR(128) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    confirmed_at DATETIME NULL,
    submitted_at DATETIME NULL,
    completed_at DATETIME NULL,
    expires_at DATETIME NULL,
    CONSTRAINT fk_print_jobs_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS job_events (
    event_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    job_id VARCHAR(64) NOT NULL,
    event_type VARCHAR(64) NOT NULL,
    message TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_job_events_job
        FOREIGN KEY (job_id) REFERENCES print_jobs(job_id)
        ON DELETE CASCADE
);
