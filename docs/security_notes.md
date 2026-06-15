# Security Notes

## Passwords

- Do not store plaintext passwords.
- Store only password hashes.
- Do not log passwords.
- Windows Helper must not save user passwords.

## Configuration

- Do not commit `.env`.
- Store database credentials in protected local config files.
- Commit only `.env.example`.

## Temporary Print Files

- Store spool files in a protected Linux directory.
- Use `job_id` or UUID as file names.
- Do not use original file name as the actual path.
- Delete expired, cancelled, failed, or completed spool files.
- Avoid storing user documents longer than necessary.

## Git Hygiene

Do not commit:

- `.env`
- logs
- real print documents
- spool files
- received jobs
- database dumps
- private keys
