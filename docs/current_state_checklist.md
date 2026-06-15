# Current State Checklist

Use this checklist to inspect the existing Linux-side system before implementation.

## Linux Services

- [ ] List current systemd services.
- [ ] Identify old print receiver service.
- [ ] Identify old control service.
- [ ] Identify cleanup scripts or cron jobs.

## Ports

- [ ] List open ports.
- [ ] Identify print port.
- [ ] Identify control port.
- [ ] Check firewall / ufw / iptables rules.

## CUPS

- [ ] Check CUPS is installed.
- [ ] List printer queues.
- [ ] Test `lp` command.
- [ ] Record CUPS queue name.
- [ ] Record duplex / color / copies options.

## MySQL

- [ ] Identify database name.
- [ ] Inspect users table.
- [ ] Check whether password is hash or plaintext.
- [ ] Inspect balance/quota field.
- [ ] Inspect print log tables.
- [ ] Export schema for documentation.

## Spool / Logs

- [ ] Locate spool directory.
- [ ] Locate log files.
- [ ] Check file permissions.
- [ ] Check whether old temporary files remain.

## Windows Print Format

- [ ] Send a test job from Windows.
- [ ] Capture received file on Linux.
- [ ] Run `file received_job`.
- [ ] Run `head -c 64 received_job`.
- [ ] Confirm whether format is PDF, PS, PCL, XPS, or RAW.
