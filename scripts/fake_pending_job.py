#!/usr/bin/env python3
"""Fake pending job payload generator for Control Channel testing."""

import json
from datetime import datetime, timezone

payload = {
    "type": "pending_job",
    "job_id": "job_fake_001",
    "file_name": "sample.pdf",
    "pages": 12,
    "copies": 1,
    "balance_before": 30,
    "created_at": datetime.now(timezone.utc).isoformat(),
}

print(json.dumps(payload, indent=2))
