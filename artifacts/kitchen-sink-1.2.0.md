---
title: Release History for 1.2.0
version: 1.2.0
date: 2026-05-29
---

# 1.2.0 Release - May 29, 2026

<!-- .release-section --><!-- .changelog-section -->

## Complete Changelog


Comprehensive list of all changes in 1.2.0, organized by component and change type.

Each entry includes links to the original issue and commit for detailed information.


<!-- .change-entry -->

- Introduce plugin system for extensibility <span class="badge type-badge type-feature">New feature</span> <span class="badge part-badge part-core">Core</span> <span class="badge part-badge part-api">API</span> <span class="badge tag-badge tag-highlighted">highlighted</span> <span class="badge tag-badge tag-feature">feature</span> [📝](#note-1_2_0-FEAT-001-introduce-plugin-syste)<!-- .change-entry -->

- Added mobile application supported <span class="badge type-badge type-feature">New feature</span> <span class="badge part-badge part-mobile">Mobile</span> <span class="badge tag-badge tag-highlighted">highlighted</span> <span class="badge tag-badge tag-feature">feature</span> [📝](#note-1_2_0-FEAT-002-added-mobile-applicati)<!-- .change-entry -->

- Implemented advanced analytics dashboard <span class="badge type-badge type-feature">New feature</span> <span class="badge tag-badge tag-highlighted">highlighted</span> <span class="badge tag-badge tag-feature">feature</span> [📝](#note-1_2_0-FEAT-003-implemented-advanced-a)<!-- .change-entry -->

- Removed deprecated basic authentication <span class="badge type-badge type-improvement">Improvement</span> <span class="badge part-badge part-api">API</span> <span class="badge tag-badge tag-breaking">breaking</span> <span class="badge tag-badge tag-removal">removal</span> [📝](#note-1_2_0-BREAKING-001-removed-deprecated-bas)<!-- .change-entry -->

- Enhanced AI suggestions with context awareness <span class="badge type-badge type-improvement">Improvement</span> <span class="badge tag-badge tag-highlighted">highlighted</span> <span class="badge tag-badge tag-improvement">improvement</span> [📝](#note-1_2_0-IMPROVE-005-enhanced-ai-suggestion)<!-- .change-entry -->

- Redesign user interface with modern design system <span class="badge type-badge type-improvement">Improvement</span> <span class="badge tag-badge tag-highlighted">highlighted</span> <span class="badge tag-badge tag-improvement">improvement</span> [📝](#note-1_2_0-IMPROVE-006-redesign-user-interfac)

<!-- .notes-section -->

## Release Notes & Highlights


Detailed information about the most important changes in 1.2.0.

This section focuses on changes that directly impact users and require attention during upgrades.


<!-- .release-note -->
<a id="note-1_2_0-FEAT-001-introduce-plugin-syste"></a>
  | Note | Metadata | |------|----------| | **Introduce plugin system for extensibility**<br>Introduced a powerful plugin system that allows developers to create custom extensions. Features include:
- Plugin marketplace integration
- Sandboxed execution environment
- Rich API for plugin development
- Hot-loading of plugins without restart

This opens up endless possibilities for customization and third-party integrations. | <span class="badge type-badge type-feature">New feature</span> <span class="badge part-badge part-core">Core</span> <span class="badge part-badge part-api">API</span> FEAT-001 |
<!-- .release-note -->
<a id="note-1_2_0-FEAT-002-added-mobile-applicati"></a>
  | Note | Metadata | |------|----------| | **Added mobile application supported**<br>Launched native mobile applications for iOS and Android! The mobile apps provide:
- Full feature parity with web application
- Offline mode with automatic sync
- Push notifications for important updates
- Optimized touch interface
- Biometric authentication support

Download from the App Store or Google Play Store. | <span class="badge type-badge type-feature">New feature</span> <span class="badge part-badge part-mobile">Mobile</span> FEAT-002 |
<!-- .release-note -->
<a id="note-1_2_0-FEAT-003-implemented-advanced-a"></a>
  | Note | Metadata | |------|----------| | **Implemented advanced analytics dashboard**<br>Introduced an advanced analytics dashboard providing deep insights into:
- User engagement patterns
- Content performance metrics
- System usage statistics
- Custom report generation
- Data export capabilities
- Real-time monitoring

Perfect for administrators and teams wanting to optimize their workflows. | <span class="badge type-badge type-feature">New feature</span> FEAT-003 |
<!-- .release-note -->
<a id="note-1_2_0-BREAKING-001-removed-deprecated-bas"></a>
  | Note | Metadata | |------|----------| | **Removed deprecated basic authentication**<br>**Breaking Change:** Removed basic authentication support as previously announced. All API access now requires OAuth2 authentication.

If you haven't migrated yet:
1. Set up OAuth2 application credentials
2. Update your API clients to use OAuth2 flow
3. Test your integration before upgrading

See our migration guide for detailed instructions. | <span class="badge type-badge type-improvement">Improvement</span> <span class="badge part-badge part-api">API</span> BREAKING-001 |
<!-- .release-note -->
<a id="note-1_2_0-IMPROVE-005-enhanced-ai-suggestion"></a>
  | Note | Metadata | |------|----------| | **Enhanced AI suggestions with context awareness**<br>Significantly enhanced AI-powered suggestions with context awareness. The AI now:
- Considers document structure and content
- Learns from user preferences and patterns
- Provides more relevant and accurate suggestions
- Adapts to different content types

Note: This feature has graduated from experimental status and is now fully supported. | <span class="badge type-badge type-improvement">Improvement</span> IMPROVE-005 |
<!-- .release-note -->
<a id="note-1_2_0-IMPROVE-006-redesign-user-interfac"></a>
  | Note | Metadata | |------|----------| | **Redesign user interface with modern design system**<br>Unveiled a completely redesigned user interface built on our new design system:
- Modern, clean aesthetic
- Improved accessibility (WCAG 2.1 AA compliant)
- Better responsive design for all screen sizes
- Consistent component library
- Enhanced dark mode support
- Customizable themes

The new design improves usability while maintaining familiar workflows. | <span class="badge type-badge type-improvement">Improvement</span> IMPROVE-006 |




