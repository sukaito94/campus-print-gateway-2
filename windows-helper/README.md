# Windows Helper

Windows Helper is a lightweight local application that handles per-document login and confirmation for the Campus Print Gateway system.

It does not replace the Windows native print dialog. Users still print normally through Windows. The Helper only appears after Linux receives a print job and requests confirmation.

## Role in the System

```text
Windows Native Print
        ↓
Linux Print Gateway

Windows Helper
        ↑↓
Linux Control Server
```

The Helper is part of the Control Channel, not the Print Channel.

## Responsibilities

Windows Helper is responsible for:

- Starting with the user session or running manually during MVP testing.
- Connecting to the Linux Control Server.
- Maintaining a persistent Control Channel.
- Receiving `pending_job` events.
- Showing per-document login and confirmation UI.
- Asking for username and password for each job.
- Displaying basic job information.
- Displaying remaining quota/balance.
- Sending confirmation or cancellation back to Linux.
- Displaying final job result.
- Not storing user passwords.

## User Flow

1. User prints from a Windows application.
2. Linux receives the document.
3. Linux sends a `pending_job` event to Windows Helper.
4. Helper shows job information.
5. User enters username/password.
6. User confirms or cancels.
7. Helper sends result to Linux.
8. Helper displays final status.

## Example Pending Job UI

```text
Print Confirmation

File: example.pdf
Pages: 12
Copies: 1
Current remaining quota: 30

Please enter your username and password to confirm this print job.

[Username]
[Password]

[Cancel] [Confirm Print]
```

## Important Rules

### Per-Job Login

Every document requires fresh username/password input.

Do not implement a long-lived authenticated session for MVP.

### No Password Storage

The Helper must not save passwords locally.

### Helper Offline Behavior

If Helper is offline when Linux receives a print job, Linux may keep the job pending until TTL expires. After Helper reconnects, Linux can push pending jobs.

## Control Channel Messages

The Helper must support at least:

- `pending_job`
- `auth_confirm`
- `job_result`
- `heartbeat`
- `error`

See `docs/message_schema.md`.

## Environment Variables

See `.env.example`.

Example:

```env
CONTROL_SERVER_URL=ws://localhost:8765
HELPER_RECONNECT_SECONDS=5
```

## MVP Implementation Options

Possible implementation choices:

- Python + Tkinter
- Python + PySide6
- C# WinForms
- C# WPF
- Electron

For MVP, Python + Tkinter is acceptable because the UI only needs to prove the flow.

## MVP Development Order

1. Connect to fake Linux Control Server.
2. Receive fake `pending_job`.
3. Show login/confirmation dialog.
4. Return `auth_confirm`.
5. Display `job_result`.
6. Add reconnect behavior.
7. Add error UI.
