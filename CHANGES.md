# Changes
This file documents modifications made to the upstream project in compliance with
Section 4(b) of the Apache License, Version 2.0.

## Upstream
- **Original project:** [leyu-mobile](https://github.com/dave-lab12/leyu-mobile)
- **License:** MIT License
- **Fork:** [iCog-Labs-Dev/hyperdata-mobile](https://github.com/iCog-Labs-Dev/hyperdata-mobile)

## Modifications (by category & date)

### Branding and rebranding
- Updated app title, meta tags, and LICENSE copyright from Leyu to Mahder
- Relocated sample APK to Google Drive and updated documentation
- Added screenshots, sample APK, and quick start guide to documentation

### Package and structure refactor
- Refactored project structure and updated package names from Leyu to Mahder
- Enabled Flutter web support and fixed web compilation issues
- Removed unused dart:ffi import to fix web compilation

### Localization and i18n
- Added multi-language support: English (en_US), Amharic (am_ET), Oromo (om_ET)
- Created translation files and updated app_translations.dart
- Updated LocalizationController if needed

### Documentation and assets
- Added CHANGELOG.md for version history and changes
- Added CONTRIBUTORS.md for project contributors
- Added CODE_OF_CONDUCT.md for community guidelines
- Added ARCHITECTURE.md for app architecture and design patterns
- Added API_DOCUMENTATION.md for API integration guide
- Added SETUP.md for complete setup guide
- Moved sample APK to Google Drive and updated documentation
- Added screenshots and quick start guide

### Testing and code quality
- Added widget tests and configuration
- Set up flutter test and flutter_lints for code quality
- Configured build_runner and hive_generator for code generation
- Updated Dart SDK and Flutter SDK constraints

* **PR #1**: Fix: Prevent blank screen on Android release build and Enable apk build without keystore
  - Fixed Android release build issues
  - Configured keystore settings for APK building
- **PR #2**: Feat: enable support for Flutter web
  - Added web support with favicon, manifest, and web icons (Icon-192, Icon-512, Icon-maskable-192, Icon-maskable-512)
  - Created `web/index.html` and `web/manifest.json` for web deployment
  - Enabled Flutter web compilation and fixed related imports
- **PR #3**: Sync dev with main
  - Merged development branch with main branch
  - Synchronized dependencies and configurations
- **PR #4**: Feat: rebrand to mahder across all modules
  - Updated app title, meta tags, and LICENSE copyright from Leyu to Mahder
  - Relocated sample APK to Google Drive and updated documentation
  - Added screenshots and quick start guide to documentation

## How to record future changes
- When making non-trivial modifications, add a short entry under a new dated section below
- Split commits by cohesive behavior or deployable concern, use Conventional Commit messages
- Do not include documentation-only files in implementation commits (exception: CHANGES.md may be committed separately)
- Before committing implementation changes, record a concise, dated summary in this file

## 2026-09-07

### Mobile workflow compatibility
- Removed the unsupported batch field from text contribution JSON while preserving existing callers and audio submission fields.
- Aligned automatic token refresh with the IAM endpoint, refresh_token request field, and nested token response.
- Read detail deadline and list dead_line values without dropping list API compatibility.
- Guarded text widget disposal when successful submission has already cleared the selected task or micro-task index.
- Added focused regression tests for text submission payloads and task deadline parsing.
- Handle successful 2xx refresh responses using data.refresh_token in both refresh paths, with transport tests for token persistence and invalid-response rejection.
- Replaced environment-dependent notification tests and the obsolete counter test with deterministic API-contract and button-widget tests.
- Reviewed regression coverage: retained HTTP 200/201 refresh success and malformed/empty/unauthorized rejection cases, made HTTP 204 fixtures bodyless, and registered failure-safe test cleanup.
