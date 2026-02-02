
# Release History -- 1.1.0 - 2026-02-02

## Changelog

Summaries of all user-facing changes made since the previous release.

### New features

#### API

Add batch export API endpoint [NOTE](#note-1_1_0-PROJ-777)

### Bug fixes

#### Web UI

Fix modal overflow on small screens [NOTE](#note-1_1_0-PROJ-983)

#### API

Fix JSON serialization issue with null values [NOTE](#note-1_1_0-PROJ-987)

### Improvements

#### Web UI

Add inline editing to dashboard widgets [NOTE](#note-1_1_0-PROJ-310)

Add missing keyboard shortcuts to Help page [NOTE](#note-1_1_0-PROJ-399)

#### API

Add rate limiting headers to public API [NOTE](#note-1_1_0-PROJ-467)

## Release Notes

Descriptions of any specially notable changes or additions since the previous release.

### Breaking Changes

#### Improvements
<a id="note-1_1_0-PROJ-467"></a>### Added rate limiting headers to public API
The API now includes standard `X-RateLimit-*` headers in all responses to better inform consumers of usage thresholds.

> **NOTE:** The default rate limit remains unchanged.

### Highlighted

#### New features
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

#### Improvements
<a id="note-1_1_0-PROJ-310"></a>### Added inline editing to dashboard widgets
Introduces an interactive editor directly in the dashboard, allowing users to modify widgets without navigating away.

This significantly streamlines common tasks.

