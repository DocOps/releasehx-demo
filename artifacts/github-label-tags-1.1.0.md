---
title: "1.1.0 Release Notes"
version: "1.1.0"
date: "2026-05-29"
permalink: /artifacts/github-label-tags-1.1.0_from-md_/
layout: artifact-markdown
---

# Release History -- 1.1.0 - 2026-05-29

<!-- .release-section --><!-- .changelog-section -->

## What's Changed


Summary of all changes in this release (using label-based tagging).


<!-- .change-entry -->

- Add dark mode toggle to user preferences <span class="badge type-badge type-improvement">Improvement</span> <span class="badge tag-badge tag-enhancement">enhancement</span> <span class="badge tag-badge tag-highlighted">highlighted</span> [📝](#note-1_1_0-42)<!-- .change-entry -->

- Fix memory leak in background sync process <span class="badge tag-badge tag-bug">bug</span> [📝](#note-1_1_0-43)<!-- .change-entry -->

- Implement OAuth2 authentication flow <span class="badge type-badge type-improvement">Improvement</span> <span class="badge tag-badge tag-enhancement">enhancement</span> <span class="badge tag-badge tag-security">security</span> <span class="badge tag-badge tag-highlighted">highlighted</span> <span class="badge tag-badge tag-breaking">breaking</span> [📝](#note-1_1_0-44)<!-- .change-entry -->

- Add keyboard shortcuts for common actions <span class="badge type-badge type-improvement">Improvement</span> <span class="badge tag-badge tag-enhancement">enhancement</span> [📝](#note-1_1_0-45)<!-- .change-entry -->

- Deprecate legacy API endpoints <span class="badge tag-badge tag-deprecation">deprecation</span> [📝](#note-1_1_0-46)<!-- .change-entry -->

- Update documentation for new features <span class="badge tag-badge tag-documentation">documentation</span>

<!-- .notes-section -->

## Release Notes


Descriptions of any specially notable changes or additions since the previous release.

<!-- .release-note -->
<a id="note-1_1_0-42"></a>### Added dark mode toggle to user preferences
  Introduced a dark mode toggle in user preferences, allowing users to switch between light and dark themes. The setting is automatically saved and persists across sessions.

  <span class="badge type-badge type-improvement">Improvement</span> 42

<!-- .release-note -->
<a id="note-1_1_0-43"></a>### Fixed memory leak in background sync process
  Fixed a memory leak in the background synchronization process that was causing gradual performance degradation. Users should notice improved stability during long sessions.

  43

<!-- .release-note -->
<a id="note-1_1_0-44"></a>### Implemented OAuth2 authentication flow
  Implemented OAuth2 authentication flow to replace basic authentication. This provides enhanced security and enables seamless integration with third-party services.

**Breaking Change:** Basic authentication will be deprecated in v1.2.0. Please migrate to OAuth2 before then.

  <span class="badge type-badge type-improvement">Improvement</span> 44

<!-- .release-note -->
<a id="note-1_1_0-45"></a>### Added keyboard shortcuts for common actions
  Added keyboard shortcuts for common actions:
- `Ctrl+N` / `Cmd+N`: Create new item
- `Ctrl+S` / `Cmd+S`: Save current work
- `Ctrl+F` / `Cmd+F`: Open search
- `Esc`: Close modals/dialogs

  <span class="badge type-badge type-improvement">Improvement</span> 45

<!-- .release-note -->
<a id="note-1_1_0-46"></a>### Deprecated legacy API endpoints
  The following legacy API endpoints are now deprecated and will be removed in v1.3.0:

- `/api/v1/users` → Use `/api/v2/users` instead
- `/api/v1/projects` → Use `/api/v2/projects` instead
- `/api/v1/tasks` → Use `/api/v2/tasks` instead

The new endpoints provide better performance and additional features.

  46

<!-- .release-note -->
<a id="note-1_1_0-47"></a>### Updated documentation for new features
  NO RELEASE NOTE PROVIDED

  47


