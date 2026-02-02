
# Release History -- 1.1.0 - 2026-02-02

## Changelog

Summaries of all user-facing changes made since the previous release.

### Web UI

Add inline editing to dashboard widgets [NOTE](#note-1_1_0-PROJ-310)

Fix modal overflow on small screens [NOTE](#note-1_1_0-PROJ-983)

Add missing keyboard shortcuts to Help page [NOTE](#note-1_1_0-PROJ-399)

### API

Add rate limiting headers to public API [NOTE](#note-1_1_0-PROJ-467)

Fix JSON serialization issue with null values [NOTE](#note-1_1_0-PROJ-987)

Add batch export API endpoint [NOTE](#note-1_1_0-PROJ-777)

## Release Notes

Descriptions of any specially notable changes or additions since the previous release.

### Breaking Changes

#### API
<a id="note-1_1_0-PROJ-467"></a>### Added rate limiting headers to public API
The API now includes standard `X-RateLimit-*` headers in all responses to better inform consumers of usage thresholds.

> **NOTE:** The default rate limit remains unchanged.

### Features

#### API
<a id="note-1_1_0-PROJ-777"></a>### Added batch export API endpoint
A new batch export endpoint is now available at `/api/export/batch`. Supported formats:

- CSV (default)
- JSON with optional compression

Example usage:

```bash
curl -X POST /api/export/batch \
  -H "Content-Type: application/json" \
  -d '{"format": "csv", "ids": [1,2,3]}'
```

### Bug Fixes

#### Web UI
<a id="note-1_1_0-PROJ-983"></a>### Fixed modal overflow on small screens
Modals now scroll correctly on devices with < 600px screen width.

#### API
<a id="note-1_1_0-PROJ-987"></a>### Fixed JSON serialization issue with null values
Previously, null values were omitted from JSON payloads. This has been corrected.

> **WARNING:** **Impact:** Clients expecting explicit nulls will now receive them as specified.

### Improvements

#### Web UI
<a id="note-1_1_0-PROJ-310"></a>### Added inline editing to dashboard widgets
Introduces an interactive editor directly in the dashboard, allowing users to modify widgets without navigating away.

This significantly streamlines common tasks.

<a id="note-1_1_0-PROJ-399"></a>### Added missing keyboard shortcuts to Help page
The Help page now includes a full list of supported keyboard shortcuts, including:

- / to focus search
- ? to show help modal

