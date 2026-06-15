# Handoff Tasks

## Task: Linux Current State Inspection

### Goal

Inspect existing Linux-side services, ports, CUPS setup, MySQL schema, spool directories, and logs.

### Output

- `linux_current_state_report.md`
- CUPS queue name
- Port list
- Service list
- MySQL schema dump

### Acceptance Criteria

The current Linux environment is documented well enough for another developer to decide what can be reused.

---

## Task: Windows Print Format Test

### Goal

Confirm what file format Linux receives from Windows native print.

### Output

- `windows_print_format_report.md`
- Sample received file
- `file` command output
- first bytes / header output

### Acceptance Criteria

Linux can reliably identify the received print format.

---

## Task: Control Channel MVP

### Goal

Create a minimal Linux Control Server and Windows Helper communication demo.

### Output

- Linux sends fake `pending_job`.
- Windows Helper shows confirmation UI.
- Helper sends `auth_confirm`.
- Linux returns `job_result`.

### Acceptance Criteria

The two-way control channel works without real printing.

---

## Task: MySQL Schema

### Goal

Create initial MySQL schema for users, print jobs, and job events.

### Output

- `database/schema.sql`
- `database/seed_users.sql`

### Acceptance Criteria

A test user can be created with a password hash and queried by the gateway.

---

## Task: CUPS Submitter

### Goal

Submit a confirmed spool file to CUPS.

### Output

- CUPS submit script or module.
- Test result report.

### Acceptance Criteria

A confirmed job can be submitted to the configured CUPS queue.
