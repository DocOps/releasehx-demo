
---
title: Release History for 1.1.0
version: 1.1.0
date: 2026-02-02
---

# Release History -- 1.1.0 - 2026-02-02


## Release Notes


Descriptions of any specially notable changes or additions since the previous release.

<a id="note-1_1_0-42"></a>### Added dark mode toggle to user preferences
Introduced a dark mode toggle in user preferences, allowing users to switch between light and dark themes. The setting is automatically saved and persists across sessions.


<a id="note-1_1_0-43"></a>### Fixed memory leak in background sync process
Fixed a memory leak in the background synchronization process that was causing gradual performance degradation. Users should notice improved stability during long sessions.


<a id="note-1_1_0-44"></a>### Implemented OAuth2 authentication flow
Implemented OAuth2 authentication flow to replace basic authentication. This provides enhanced security and enables seamless integration with third-party services.

**Breaking Change:** Basic authentication will be deprecated in v1.2.0. Please migrate to OAuth2 before then.


<a id="note-1_1_0-45"></a>### Added keyboard shortcuts for common actions
Added keyboard shortcuts for common actions:
- `Ctrl+N` / `Cmd+N`: Create new item
- `Ctrl+S` / `Cmd+S`: Save current work
- `Ctrl+F` / `Cmd+F`: Open search
- `Esc`: Close modals/dialogs


<a id="note-1_1_0-46"></a>### Deprecated legacy API endpoints
The following legacy API endpoints are now deprecated and will be removed in v1.3.0:

- `/api/v1/users` → Use `/api/v2/users` instead
- `/api/v1/projects` → Use `/api/v2/projects` instead
- `/api/v1/tasks` → Use `/api/v2/tasks` instead

The new endpoints provide better performance and additional features.


<a id="note-1_1_0-47"></a>### Updated documentation for new features
NO RELEASE NOTE PROVIDED


## What's Changed


Summary of all changes in this release (using label-based tagging).


- Add dark mode toggle to user preferences [NOTE](#note-1_1_0-42)


- Fix memory leak in background sync process [NOTE](#note-1_1_0-43)


- Implement OAuth2 authentication flow [NOTE](#note-1_1_0-44)


- Add keyboard shortcuts for common actions [NOTE](#note-1_1_0-45)


- Deprecate legacy API endpoints [NOTE](#note-1_1_0-46)


- Update documentation for new features


