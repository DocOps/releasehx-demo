
# Release 1.1.0 - 2026-05-29

<!-- .release-section --><!-- .changelog-section -->

## Changes

All changes included in this release.

### Collaboration
#### Enhancements<!-- .change-entry -->

1. Implemented real-time collaboration features <span class="badge tag-badge tag-enhancement">enhancement</span> <span class="badge tag-badge tag-highlighted">highlighted</span> [📝](#note-101-implemented)

### Search & Discovery
#### Enhancements<!-- .change-entry -->

1. Added advanced search with filters <span class="badge tag-badge tag-enhancement">enhancement</span> <span class="badge tag-badge tag-highlighted">highlighted</span> [📝](#note-103-added-advanc)

### Database
#### Enhancements<!-- .change-entry -->

1. Migrated to new database schema <span class="badge tag-badge tag-enhancement">enhancement</span> [📝](#note-104-migrated-to)

### AI Features
#### Enhancements<!-- .change-entry -->

1. Added experimental AI-powered suggestions <span class="badge tag-badge tag-enhancement">enhancement</span> <span class="badge tag-badge tag-experimental">experimental</span> <span class="badge tag-badge tag-highlighted">highlighted</span> [📝](#note-106-added-experi)

<!-- .notes-section -->

## Notable Changes

Detailed information about significant changes that may affect users.

### Highlighted Features
#### Collaboration<!-- .release-note -->
<a id="note-101-implemented"></a>
  | Note | Metadata | |------|----------| | Introduced real-time collaboration features allowing multiple users to edit documents simultaneously. Changes are synchronized instantly across all connected clients with conflict resolution. | <span class="badge type-badge type-enhancement">Enhancement</span> <span class="badge part-badge part-collaboration">Collaboration</span> 101 |

#### Search & Discovery<!-- .release-note -->
<a id="note-103-added-advanc"></a>
  | Note | Metadata | |------|----------| | Added advanced search capabilities with filtering options including:
- Date ranges
- Content types
- User assignments
- Status filters
- Custom tags

Search results are now more precise and easier to navigate. | <span class="badge type-badge type-enhancement">Enhancement</span> <span class="badge part-badge part-search">Search</span> 103 |

#### AI Features<!-- .release-note -->
<a id="note-106-added-experi"></a>
  | Note | Metadata | |------|----------| | Introduced experimental AI-powered content suggestions to help users create better content. This feature:
- Suggests improvements to writing
- Recommends relevant tags
- Provides content structure guidance

**Note:** This is an experimental feature and may change in future releases. | <span class="badge type-badge type-enhancement">Enhancement</span> <span class="badge part-badge part-ai">AI</span> 106 |

### Breaking Changes
#### Configuration<!-- .release-note -->
<a id="note-105-removed-depr"></a>
  | Note | Metadata | |------|----------| | Removed the following deprecated configuration options:
- `legacy_mode` (use `compatibility.legacy_support` instead)
- `old_api_format` (use `api.response_format` instead)
- `deprecated_auth` (OAuth2 is now required)

Please update your configuration files accordingly. | <span class="badge part-badge part-configuration">Configuration</span> 105 |

### Removed Features
#### Configuration<!-- .release-note -->
<a id="note-105-removed-depr"></a>
  | Note | Metadata | |------|----------| | Removed the following deprecated configuration options:
- `legacy_mode` (use `compatibility.legacy_support` instead)
- `old_api_format` (use `api.response_format` instead)
- `deprecated_auth` (OAuth2 is now required)

Please update your configuration files accordingly. | <span class="badge part-badge part-configuration">Configuration</span> 105 |

### Experimental Features
#### AI Features<!-- .release-note -->
<a id="note-106-added-experi"></a>
  | Note | Metadata | |------|----------| | Introduced experimental AI-powered content suggestions to help users create better content. This feature:
- Suggests improvements to writing
- Recommends relevant tags
- Provides content structure guidance

**Note:** This is an experimental feature and may change in future releases. | <span class="badge type-badge type-enhancement">Enhancement</span> <span class="badge part-badge part-ai">AI</span> 106 |

