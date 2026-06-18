# Database Schema

The system uses PostgreSQL for user accounts, password hashes, print jobs, quota/balance records, and event logs.

PostgreSQL is treated as the persistent authority for account state and print job state. The Windows Helper must not directly access PostgreSQL.

## users

| Field | Purpose |
|---|---|
| user_id | Internal user ID |
| username | Login name |
| password_hash | Hashed password only; never store plaintext passwords |
| balance | Remaining print quota or balance |
| status | `ACTIVE`, `LOCKED_OVERPRINT`, `LOCKED_MANUAL`, `DISABLED` |
| locked_reason | Reason for lock |
| locked_at | Lock timestamp |
| created_at | Creation timestamp |
| updated_at | Last update timestamp |

## print_jobs

| Field | Purpose |
|---|---|
| job_id | Unique print job ID |
| user_id | Authorized user |
| status | Job status |
| file_name | Original display name, if available |
| file_hash | Hash of spool file |
| pages | Parsed page count |
| copies | Number of copies |
| balance_before | Quota before print |
| balance_after | Quota after print |
| overprint_triggered | Whether this job caused overprint lock |
| cups_job_id | CUPS job ID |
| created_at | Job creation time |
| confirmed_at | User confirmation time |
| submitted_at | CUPS submission time |
| completed_at | Completion time, if tracked |
| expires_at | TTL expiration time |

## job_events

| Field | Purpose |
|---|---|
| event_id | Internal event ID |
| job_id | Related job |
| event_type | Event name |
| message | Debug or audit message |
| created_at | Event timestamp |

## Password Rule

User passwords must never be stored as plaintext. Store only `password_hash`, such as Argon2 or bcrypt.
