
---
title: Release History for 1.1.0
version: 1.1.0
date: 2026-02-02
---

# Release 1.1.0 - February 02, 2026



## Release Highlights & Important Notes



Detailed information about significant changes, new features, and important considerations for 1.1.0.

Please review breaking changes and deprecations carefully before upgrading.



### ⚠️ Breaking Changes

#### Application Programming Interface
<a id="note-1_1_0-PROJ-467-added-rate-limiti"></a>### Added rate limiting headers to public API
The API now includes standard `X-RateLimit-*` headers in all responses to better inform consumers of usage thresholds.

> **NOTE:** The default rate limit remains unchanged.



### 🌟 Highlighted Features

#### Web User Interface
<a id="note-1_1_0-PROJ-310-added-inline-edit"></a>### Added inline editing to dashboard widgets
Introduces an interactive editor directly in the dashboard, allowing users to modify widgets without navigating away.

This significantly streamlines common tasks.



#### Application Programming Interface
<a id="note-1_1_0-PROJ-777-added-batch-expor"></a>### Added batch export API endpoint
A new batch export endpoint is now available at `/api/export/batch`. Supported formats:

- CSV (default)
- JSON with optional compression

Example usage:

```bash
curl -X POST /api/export/batch \
  -H "Content-Type: application/json" \
  -d '{"format": "csv", "ids": [1,2,3]}'
```



