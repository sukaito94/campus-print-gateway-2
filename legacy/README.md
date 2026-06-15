# Legacy Notes

This folder documents the previous prototype and the reasons it is no longer the formal architecture.

## Previous Prototype

The earlier version used a custom web-based print interface.

It included:

- PDF file upload.
- PDF.js preview.
- Page navigation.
- Print settings UI.
- Printer selection.
- Copies setting.
- Page range setting.
- Orientation setting.
- Color mode setting.
- Advanced settings such as paper size, N-up, margins, scale, duplex, and headers/footers.
- Job Ticket JSON generation.
- Mock send-to-agent flow.
- JSON preview and download.

## Why It Is Deprecated

The old design duplicated many features already provided by Windows native printing.

Maintenance problems included:

- Maintaining a custom PDF preview UI.
- Maintaining a custom print settings interface.
- Generating and validating frontend Job Ticket JSON.
- Keeping frontend and Linux-side behavior consistent.
- Handling print settings that Windows already supports.
- Increasing the number of custom protocols and moving parts.

## New Direction

The new architecture uses Windows native printing as the formal entry point.

```text
Windows Native Print
        ↓
Linux Print Gateway
        ↓
Windows Helper Confirmation
        ↓
MySQL Account / Log
        ↓
CUPS
        ↓
Printer
```

The old prototype may still be useful as:

- historical reference
- UI reference
- debug tool
- proof of earlier design direction

It should not be treated as the formal user entry point for the new system.

## Reusable Ideas

Some ideas from the previous prototype may still be useful:

- Job metadata structure
- JSON inspection for debugging
- Visual explanation of print settings
- Gateway-facing job record concept

However, the new MVP should avoid rebuilding a full custom print UI.
