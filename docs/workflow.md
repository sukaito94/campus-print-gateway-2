# Workflow

## Normal Print Flow

1. User prints from Windows native print dialog.
2. Windows sends the print document to Linux Print Receiver.
3. Linux creates a `job_id`.
4. Linux stores the document in spool storage.
5. Linux analyzes basic print information.
6. Linux sends a `pending_job` event to Windows Helper.
7. Windows Helper shows login and confirmation UI.
8. User enters username and password.
9. Linux validates credentials against MySQL `password_hash`.
10. Linux checks account status and remaining quota.
11. Helper shows job information and current quota.
12. User confirms the job.
13. Linux records the print job.
14. Linux submits the job to CUPS.
15. Linux updates quota after submission.
16. If overprint is triggered, Linux locks the account for the next print.
17. Linux updates job status and cleans temporary files.

## Cancel Flow

1. User cancels in Windows Helper.
2. Linux marks job as `USER_CANCELLED`.
3. Linux writes a job event.
4. Linux deletes the temporary spool file.

## Account Locked Flow

1. User logs in for a job.
2. Linux detects account status is not `ACTIVE`.
3. Linux rejects the job.
4. Helper shows account locked message.
5. Linux deletes or expires the spool file.

## Helper Offline Flow

1. Linux receives and spools a document.
2. No Helper is connected.
3. Job remains pending until Helper reconnects.
4. If TTL expires, job becomes `EXPIRED`.
5. Linux deletes the temporary spool file.

## Overprint Flow

1. User confirms print.
2. Linux sends job to CUPS.
3. Linux updates quota.
4. If quota becomes negative or exceeds the allowed limit, the account is marked `LOCKED_OVERPRINT`.
5. The current print is allowed to complete.
6. The next print is rejected until unlocked.
