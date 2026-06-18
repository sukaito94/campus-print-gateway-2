# Architecture

## System Overview

```text
Windows Native Print
        ↓
Print Channel
        ↓
Linux Print Receiver
        ↓
Spool + Analyze
        ↓
Control Channel
        ↓
Windows Helper Confirmation
        ↓
PostgreSQL Account / Log
        ↓
CUPS
        ↓
Printer
```

## Components

### Windows Native Print

The user prints normally from Windows applications such as Word, browser, or PDF reader.

### Windows Helper

A lightweight local helper that maintains a persistent connection to the Linux Control Server.

Responsibilities:

- Receive `pending_job` events.
- Show per-document login and confirmation UI.
- Send username/password and confirmation result.
- Display job result or error status.

### Linux Print Gateway

The central authorization and routing layer.

Responsibilities:

- Receive print data.
- Create `job_id`.
- Store temporary spool files.
- Analyze basic print information.
- Notify Windows Helper.
- Validate account credentials.
- Check account status and quota.
- Log print jobs and job events.
- Submit approved jobs to CUPS.
- Update quota and lock accounts when needed.
- Clean up temporary files.

### PostgreSQL

Stores users, password hashes, quota/balance, account status, print jobs, and job events.

### CUPS

Receives only confirmed jobs from the Linux Gateway and performs actual printer submission.

## Channels

### Print Channel

```text
Windows Native Print → Linux Print Receiver
```

Used only for print data transfer.

### Control Channel

```text
Windows Helper ↔ Linux Control Server
```

Used for job notification, login, confirmation, heartbeat, and result messages.
