# Control Channel Message Schema

The Control Channel connects Windows Helper and Linux Control Server.

Messages are JSON objects with a `type` field.

## pending_job

Sent from Linux to Windows Helper.

```json
{
  "type": "pending_job",
  "job_id": "job_001",
  "file_name": "example.pdf",
  "pages": 12,
  "copies": 1,
  "balance_before": 30
}
```

## auth_confirm

Sent from Windows Helper to Linux.

```json
{
  "type": "auth_confirm",
  "job_id": "job_001",
  "username": "student001",
  "password": "********",
  "confirmed": true
}
```

If user cancels:

```json
{
  "type": "auth_confirm",
  "job_id": "job_001",
  "username": null,
  "password": null,
  "confirmed": false
}
```

## job_result

Sent from Linux to Windows Helper.

```json
{
  "type": "job_result",
  "job_id": "job_001",
  "status": "submitted_to_cups"
}
```

Possible statuses:

- `submitted_to_cups`
- `auth_failed`
- `user_cancelled`
- `account_locked`
- `expired`
- `cups_failed`
- `error`

## heartbeat

```json
{
  "type": "heartbeat",
  "timestamp": "2026-06-15T12:00:00+08:00"
}
```

## error

```json
{
  "type": "error",
  "job_id": "job_001",
  "code": "AUTH_FAILED",
  "message": "Invalid username or password."
}
```
