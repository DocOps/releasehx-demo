
# Release History -- 1.1.0 - 2026-05-29

<!-- .release-section --><!-- .changelog-section -->

## Changelog

Summaries of all user-facing changes made since the previous release.

### Web UI<!-- .change-entry -->

Add inline editing to dashboard widgets <span class="badge tag-badge tag-highlighted">highlighted</span> [📝](#note-1_1_0-PROJ-310)
<!-- .change-entry -->

Fix modal overflow on small screens [📝](#note-1_1_0-PROJ-983)
<!-- .change-entry -->

Add missing keyboard shortcuts to Help page [📝](#note-1_1_0-PROJ-399)

### API<!-- .change-entry -->

Add rate limiting headers to public API <span class="badge tag-badge tag-breaking">breaking</span> [📝](#note-1_1_0-PROJ-467)
<!-- .change-entry -->

Fix JSON serialization issue with null values [📝](#note-1_1_0-PROJ-987)
<!-- .change-entry -->

Add batch export API endpoint <span class="badge tag-badge tag-highlighted">highlighted</span> [📝](#note-1_1_0-PROJ-777)

<!-- .notes-section -->

## Release Notes

Descriptions of any specially notable changes or additions since the previous release.

### Breaking Changes
#### API<!-- .release-note -->
<a id="note-1_1_0-PROJ-467"></a>
  | Note | Metadata | |------|----------| | **Added rate limiting headers to public API**<br>Implements middleware to attach X-RateLimit headers.

The API now includes standard `X-RateLimit-*` headers in all responses to better inform consumers of usage thresholds.

> **Note:** The default rate limit remains unchanged. | <span class="badge part-badge part-api">API</span> PROJ-467 |

