# Flutter Plan Implementation Status

**Date:** 2026-05-12

## Implemented in this pass

- Added a central API layer:
  - `lib/core/api/api_client.dart`
  - `lib/core/api/api_exception.dart`
  - endpoint groups under `lib/core/api/endpoints/`
- Added `AuthUser` and upgraded `AuthProvider` away from using `StudentModel` as the authenticated user.
- Updated `AuthService` to use `/mobile/auth/login` with fallback to `/auth/token`.
- Added mobile-aware services:
  - `TeacherService`
  - `SupervisorService`
  - `GuideService`
  - `SyncService`
- Added role providers:
  - `TeacherProvider`
  - `SupervisorProvider`
  - `GuideProvider`
  - `SyncProvider`
- Registered the new services/providers in `main.dart`.
- Added first offline sync queue primitives:
  - `SyncQueueItem`
  - `SyncQueueStore`
  - in-memory + persisted queue support in `SyncProvider`
- Added shared utilities:
  - Quran range validator
  - Monthly score calculator
  - response parsing helpers
- Updated Quran range picker to show validation errors and avoid emitting invalid ranges.
- Started connecting dashboards to real providers:
  - Teacher dashboard
  - Supervisor dashboard
  - Guide dashboard
- Renamed app title and splash/login brand to `نظام المنارة`.

## Not verified locally

Flutter and Dart commands are not available in the current shell:

```text
flutter: command not found
dart: command not found
```

Run these after installing Flutter or fixing PATH:

```bash
flutter pub get
flutter analyze
flutter test
```

## Still remaining

- Full screen-by-screen API binding for all existing student, teacher, supervisor, and guide screens.
- Persistent offline draft flows inside teacher/visit forms.
- Report download/open flow.
- Notification deep links.
- Tests.
- Platform folder generation and production release configuration.

