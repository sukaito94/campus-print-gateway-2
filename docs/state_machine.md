# State Machine

## Job States

Minimal job state set:

```text
RECEIVED
  ↓
ANALYZED
  ↓
PENDING_CONFIRM
  ↓
CONFIRMED
  ↓
SUBMITTED_TO_CUPS
  ↓
COMPLETED
```

## Failure / Terminal States

```text
AUTH_FAILED
USER_CANCELLED
ACCOUNT_LOCKED
EXPIRED
CUPS_FAILED
```

## Account States

```text
ACTIVE
LOCKED_OVERPRINT
LOCKED_MANUAL
DISABLED
```

## Overprint Rule

Overprint does not fail the current job.

If the current job causes overprint:

```text
COMPLETED + overprint_triggered = true
```

Then the account becomes:

```text
LOCKED_OVERPRINT
```

The next print is rejected until the account is unlocked.
