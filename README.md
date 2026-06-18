# Campus Print Gateway

A Windows-native campus print gateway using a Linux authorization layer, PostgreSQL account records, and a CUPS backend.

## Project Overview

Campus Print Gateway is a redesigned campus printing workflow. The project replaces the previous custom web-based print interface with the Windows native print flow.

Instead of asking users to upload PDFs through a custom browser UI, the new system lets users print normally from Windows applications. The Linux side receives the print job, temporarily spools it, asks a Windows Helper application for per-job login confirmation, records the job, and submits approved jobs to CUPS.

```text
Windows Native Print
        ↓
Linux Print Receiver
        ↓
Spool + Analyze
        ↓
Windows Helper Confirmation
        ↓
PostgreSQL Account / Log
        ↓
CUPS
        ↓
Printer
```

## Why This Refactor

The previous design depended on a custom print UI, custom request flow, and frontend-generated Job Ticket JSON. While that approach was flexible, it also created a large maintenance surface:

- The project had to maintain its own PDF upload flow.
- The project had to maintain its own print settings UI.
- The frontend had to assemble a Job Ticket.
- The Linux side had to interpret custom frontend requests.
- The system duplicated features that Windows already provides through native printing.

The new design keeps the part that actually matters for the campus environment:

- account confirmation
- print logging
- quota / balance tracking
- overprint account locking
- CUPS submission control

## Core Design Principles

1. **Use Windows native printing as the formal entry point.**  
   Users should print from Word, browser, PDF reader, or other Windows applications normally.

2. **Separate print data from account interaction.**  
   Print data goes through the Print Channel. Login, confirmation, and status messages go through the Control Channel.

3. **Require per-document authorization.**  
   Every print job requires fresh username/password input. This avoids someone printing under another user's previous login.

4. **Keep Linux as the authority.**  
   Linux Gateway receives the job, validates accounts, records logs, updates quota, and decides whether to submit to CUPS.

5. **Treat overprint as a post-job account state.**  
   If a job causes overprint, the current job may complete, but the account is locked for the next print.

6. **Treat the old Web UI as legacy/reference.**  
   The old custom PDF upload / preview / Job Ticket UI is no longer the formal entry point.

## System Architecture

```text
┌────────────────────────────┐
│ Windows Client              │
│                            │
│  Windows Native Print       │
│       │                    │
│       ↓                    │
│  Print Channel              │
│                            │
│  Windows Helper             │
│       ↑↓                   │
│  Persistent Control Channel │
└───────────┬────────────────┘
            │
            ↓
┌────────────────────────────┐
│ Linux Print Gateway         │
│                            │
│  Print Receiver             │
│  Spool Manager              │
│  Job Analyzer               │
│  Control Server             │
│  Auth Service               │
│  Account Manager            │
│  Print Logger               │
│  CUPS Submitter             │
│  Cleanup Worker             │
└───────────┬────────────────┘
            ↓
          CUPS
            ↓
        Printer
```

## Components

### Windows Native Print

The user-facing print entry point. Users print normally through Windows.

### Windows Helper

A lightweight local application that keeps a persistent connection to the Linux Control Server. It receives pending job notifications, asks the user for username/password, shows job information and remaining quota, and sends confirmation or cancellation back to Linux.

### Linux Print Gateway

The core backend. It receives print data, creates job records, spools files, analyzes basic job metadata, requests confirmation through Windows Helper, validates credentials, records logs, updates quota, and submits approved jobs to CUPS.

### PostgreSQL

Stores users, password hashes, account status, remaining quota/balance, print jobs, and job events.

PostgreSQL is the persistent authority for account state, print job state, quota/balance updates, and audit logs.

### CUPS

The final print backend. It should only receive jobs that have already been confirmed by the Linux Gateway.

## Repository Structure

```text
campus-print-gateway-2/
├─ README.md
├─ docs/
│  ├─ architecture.md
│  ├─ workflow.md
│  ├─ message_schema.md
│  ├─ database_schema.md
│  ├─ state_machine.md
│  ├─ security_notes.md
│  ├─ current_state_checklist.md
│  └─ handoff_tasks.md
│
├─ linux-gateway/
│  ├─ README.md
│  └─ .env.example
│
├─ windows-helper/
│  ├─ README.md
│  └─ .env.example
│
├─ database/
│  ├─ schema.sql
│  └─ seed_users.sql
│
├─ scripts/
│  ├─ test_cups_print.sh
│  ├─ inspect_received_file.sh
│  └─ fake_pending_job.py
│
├─ legacy/
│  └─ README.md
│
└─ samples/
```

## MVP Scope

The minimum viable version should support:

- Windows native printing to Linux.
- Linux receiving and spooling print data.
- Linux creating a `job_id` for each document.
- Linux analyzing page count and basic job information.
- Windows Helper maintaining a persistent Control Channel.
- Per-document username/password input.
- MySQL credential validation using `password_hash`.
- Displaying remaining quota/balance before confirmation.
- User confirmation or cancellation.
- Job logging in MySQL.
- CUPS submission after confirmation.
- Quota update after job submission.
- Account locking after overprint.
- TTL cleanup for expired or cancelled spool files.

## Out of Scope

The initial version does not need:

- Full custom Web print UI.
- Frontend PDF preview.
- Frontend Job Ticket generation.
- Real-time payment or refund system.
- Multi-client routing.
- Dynamic printer capability profiles.
- Complex admin dashboard.
- Cloud deployment.

## Current Status

This repository is currently an engineering handoff package. It is meant to make the system architecture, responsibilities, workflows, and development tasks clear before full implementation.

## Next Steps

Recommended development order:

1. Inspect the existing Linux environment.
2. Confirm CUPS can print independently.
3. Test what format Windows sends to Linux.
4. Implement a fake Control Channel MVP.
5. Implement Windows Helper MVP.
6. Implement MySQL schema and test users.
7. Implement Print Receiver.
8. Implement Job Analyzer.
9. Implement CUPS Submitter.
10. Implement Cleanup Worker.
11. Integrate and test the full flow.
