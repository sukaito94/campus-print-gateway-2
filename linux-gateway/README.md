# Linux Gateway

The Linux Gateway is the central authority of the Campus Print Gateway system. It receives print data from Windows, temporarily spools documents, coordinates per-job user confirmation through Windows Helper, validates accounts using MySQL, records print logs, and submits confirmed jobs to CUPS.

## Role in the System

```text
Windows Native Print
        ↓
Linux Print Receiver
        ↓
Spool + Analyze
        ↓
Control Channel → Windows Helper
        ↓
MySQL Auth / Account / Log
        ↓
CUPS Submitter
        ↓
Printer
```

The Linux Gateway should be treated as the decision point before CUPS. Unconfirmed jobs should not be sent to CUPS.

## Responsibilities

The Linux Gateway is responsible for:

- Receiving print data from Windows.
- Creating a unique `job_id` for each document.
- Writing temporary spool files.
- Analyzing basic print information such as page count and copies.
- Sending `pending_job` events to Windows Helper.
- Receiving username/password confirmation from Windows Helper.
- Verifying credentials against MySQL `password_hash`.
- Checking account status and remaining quota.
- Rejecting locked accounts.
- Recording print jobs and job events.
- Submitting confirmed jobs to CUPS.
- Updating quota after submission.
- Locking accounts after overprint.
- Cleaning up expired, cancelled, or completed spool files.

## Planned Modules

```text
linux-gateway/
├─ app/
│  ├─ main.py
│  ├─ config.py
│  ├─ print_receiver.py
│  ├─ spool_manager.py
│  ├─ job_analyzer.py
│  ├─ control_server.py
│  ├─ auth_service.py
│  ├─ account_manager.py
│  ├─ print_logger.py
│  ├─ cups_submitter.py
│  ├─ cleanup_worker.py
│  └─ db.py
```

### `print_receiver`

Receives print data from the Windows native print flow. It should not directly submit to CUPS.

### `spool_manager`

Creates `job_id`, stores spool files, manages file paths, and enforces TTL rules.

### `job_analyzer`

Analyzes the received print file. The exact implementation depends on the actual format Windows sends to Linux.

Possible formats:

- PDF
- PostScript
- PCL
- XPS
- RAW spool data

### `control_server`

Maintains the persistent Control Channel with Windows Helper.

Responsibilities:

- Accept Helper connection.
- Send `pending_job`.
- Receive `auth_confirm`.
- Send `job_result`.
- Support heartbeat / reconnect behavior.

### `auth_service`

Verifies username/password using MySQL-stored password hashes.

Important rule:

```text
Never store or compare plaintext passwords directly.
```

### `account_manager`

Checks account status and quota.

Expected account states:

- `ACTIVE`
- `LOCKED_OVERPRINT`
- `LOCKED_MANUAL`
- `DISABLED`

### `print_logger`

Writes print job and job event records to MySQL.

### `cups_submitter`

Submits confirmed jobs to CUPS.

MVP may use shell commands such as:

```bash
lp -d "$CUPS_PRINTER_NAME" "$SPOOL_FILE"
```

Later versions may use a CUPS API.

### `cleanup_worker`

Deletes expired, cancelled, failed, or completed temporary files.

## Environment Variables

See `.env.example`.

Expected fields:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=print_gateway
DB_PASSWORD=change_me
DB_NAME=campus_print

CONTROL_HOST=0.0.0.0
CONTROL_PORT=8765

PRINT_RECEIVER_HOST=0.0.0.0
PRINT_RECEIVER_PORT=9100

CUPS_PRINTER_NAME=change_me
SPOOL_DIR=/var/spool/campus-print
JOB_TTL_SECONDS=300
```

## Security Notes

- Do not commit `.env`.
- Do not log passwords.
- Do not keep spool files longer than necessary.
- Use `job_id` or UUID for spool file names.
- Do not use original file names as filesystem paths.
- Store database credentials in a protected local config.
- CUPS should only receive confirmed jobs.

## MVP Development Order

1. Implement Control Server with fake `pending_job`.
2. Implement MySQL connection.
3. Implement credential verification.
4. Implement job logging.
5. Implement CUPS submitter.
6. Implement cleanup worker.
7. Implement real Print Receiver.
8. Implement file analyzer after confirming Windows print format.
