
---
title: Release History for 1.2.0
version: 1.2.0
date: 2026-02-02
---

# 1.2.0 Release - February 02, 2026




## Release Notes & Highlights



Detailed information about the most important changes in 1.2.0.

This section focuses on changes that directly impact users and require attention during upgrades.


<a id="note-1_2_0-FEAT-001-introduce-plugin-syste"></a>### Introduce plugin system for extensibility
Introduced a powerful plugin system that allows developers to create custom extensions. Features include:
- Plugin marketplace integration
- Sandboxed execution environment
- Rich API for plugin development
- Hot-loading of plugins without restart

This opens up endless possibilities for customization and third-party integrations.


<a id="note-1_2_0-FEAT-002-added-mobile-applicati"></a>### Added mobile application supported
Launched native mobile applications for iOS and Android! The mobile apps provide:
- Full feature parity with web application
- Offline mode with automatic sync
- Push notifications for important updates
- Optimized touch interface
- Biometric authentication support

Download from the App Store or Google Play Store.


<a id="note-1_2_0-FEAT-003-implemented-advanced-a"></a>### Implemented advanced analytics dashboard
Introduced an advanced analytics dashboard providing deep insights into:
- User engagement patterns
- Content performance metrics
- System usage statistics
- Custom report generation
- Data export capabilities
- Real-time monitoring

Perfect for administrators and teams wanting to optimize their workflows.


<a id="note-1_2_0-BREAKING-001-removed-deprecated-bas"></a>### Removed deprecated basic authentication
**Breaking Change:** Removed basic authentication support as previously announced. All API access now requires OAuth2 authentication.

If you haven't migrated yet:
1. Set up OAuth2 application credentials
2. Update your API clients to use OAuth2 flow
3. Test your integration before upgrading

See our migration guide for detailed instructions.


<a id="note-1_2_0-IMPROVE-005-enhanced-ai-suggestion"></a>### Enhanced AI suggestions with context awareness
Significantly enhanced AI-powered suggestions with context awareness. The AI now:
- Considers document structure and content
- Learns from user preferences and patterns
- Provides more relevant and accurate suggestions
- Adapts to different content types

Note: This feature has graduated from experimental status and is now fully supported.


<a id="note-1_2_0-IMPROVE-006-redesign-user-interfac"></a>### Redesign user interface with modern design system
Unveiled a completely redesigned user interface built on our new design system:
- Modern, clean aesthetic
- Improved accessibility (WCAG 2.1 AA compliant)
- Better responsive design for all screen sizes
- Consistent component library
- Enhanced dark mode support
- Customizable themes

The new design improves usability while maintaining familiar workflows.




