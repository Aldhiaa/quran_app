# Quran Flutter App Current Audit

**Project:** `quran_mobile_ui`  
**Date:** 2026-05-12  
**Purpose:** Deep audit of the existing Flutter app before the full update plan.

---

## 1. Executive Summary

The Flutter app already has a strong visual prototype for four roles:

- Student
- Teacher
- Center supervisor
- Guide / الموجهة

However, the app is still not production-ready. The current code is mostly a role-based UI shell with many hardcoded metrics, static navigation, and partial API services. The backend inside `quran_admin` already exposes many mobile-specific endpoints, but the Flutter app does not yet use most of them.

The main update is therefore not just “add more screens”. The real work is:

1. Refactor app architecture.
2. Replace static/demo data with real mobile APIs.
3. Add role-specific providers and repositories.
4. Add offline draft and sync support.
5. Complete teacher daily workflow first.
6. Complete supervisor review/approval workflow.
7. Complete guide visit/quality workflow.
8. Add tests, build setup, and release readiness.

---

## 2. Files Reviewed

### Root

- `pubspec.yaml`
- `README.md`
- `codemagic.yaml`

### Core Flutter files

- `lib/main.dart`
- `lib/core/api_constants.dart`
- `lib/core/app_theme.dart`
- `lib/core/connectivity_helper.dart`

### State and services

- `lib/providers/auth_provider.dart`
- `lib/services/auth_service.dart`
- `lib/services/student_service.dart`
- `lib/services/teacher_service.dart`
- `lib/services/communication_service.dart`

### Shared widgets

- `lib/widgets/common_widgets.dart`
- `lib/widgets/quran_range_picker.dart`

### Role shells

- `lib/screens/common/student_shell.dart`
- `lib/screens/common/teacher_shell.dart`
- `lib/screens/common/supervisor_shell.dart`
- `lib/screens/common/guide_shell.dart`

### Role screens

- `lib/screens/student/*`
- `lib/screens/teacher/*`
- `lib/screens/supervisor/*`
- `lib/screens/guide/*`

### Backend API source checked for mobile integration

- `quran_admin/routes/api.php`
- `quran_admin/app/Http/Controllers/Api/V1/Mobile/MobileTeacherController.php`
- `quran_admin/app/Http/Controllers/Api/V1/Mobile/MobileSupervisorController.php`
- `quran_admin/app/Http/Controllers/Api/V1/Mobile/MobileGuideController.php`
- `quran_admin/app/Http/Controllers/Api/V1/Mobile/SyncController.php`

---

## 3. Current App Strengths

## 3.1 Role coverage exists

The app already includes folders for:

```text
lib/screens/student
lib/screens/teacher
lib/screens/supervisor
lib/screens/guide
```

This is a good start because the product direction now requires all four roles.

## 3.2 Visual system is already aligned

`lib/core/app_theme.dart` already defines a deep green / gold / warm background identity:

- `primary`
- `primaryDark`
- `primaryDeep`
- `accentGold`
- `background`

This matches the required Al-Manara direction and can be kept.

## 3.3 Reusable widgets exist

`lib/widgets/common_widgets.dart` already contains reusable dashboard pieces such as:

- Green header scaffold
- KPI cards
- Quick action grid
- Status badge
- Progress ring
- Info tiles

These should be kept and reorganized later into smaller widget files.

## 3.4 Quran range picker exists

`lib/widgets/quran_range_picker.dart` already provides:

- From surah
- From ayah
- To surah
- To ayah
- JSON output

This should become the base for all memorization, review, monthly test, and visit evaluation workflows.

## 3.5 Backend mobile endpoints exist

The Laravel API has dedicated mobile groups:

```text
/api/v1/mobile/auth
/api/v1/mobile/teacher
/api/v1/mobile/supervisor
/api/v1/mobile/guide
/api/v1/sync
```

This means Flutter should switch from generic endpoints to role-specific mobile endpoints.

---

## 4. Current Technical Gaps

## 4.1 Static route table is too large

`lib/main.dart` imports every screen and registers every route in one huge `MaterialApp.routes` map. This works for a prototype but becomes hard to maintain.

Problems:

- No route guards.
- No parameterized routes like `/teacher/circles/:id`.
- No deep links from notifications.
- No central role redirect.
- Too many imports in `main.dart`.

Required fix:

- Add `lib/app.dart`.
- Add `lib/core/routing/app_router.dart`.
- Use `go_router`.
- Move route names to `route_paths.dart`.
- Add role guard redirects.

## 4.2 Auth model is wrong for four roles

`AuthProvider` stores the logged-in user as `StudentModel`.

Current issue:

```dart
StudentModel? _user;
String get role => _user?.role ?? 'student';
```

This is not valid for:

- Teacher
- Center supervisor
- Guide
- Parent later
- Sponsor later

Required fix:

- Create `AuthUser`.
- Keep `StudentModel` only for student profile data.
- Add role helper getters: `isTeacher`, `isStudent`, `isSupervisor`, `isGuide`.

## 4.3 Services duplicate API logic

Current services each create their own `http.Client`, read token from `FlutterSecureStorage`, build headers, decode responses, and handle errors.

Files affected:

- `auth_service.dart`
- `student_service.dart`
- `teacher_service.dart`
- `communication_service.dart`

Problems:

- Repeated token/header code.
- Inconsistent response parsing.
- Inconsistent Arabic error handling.
- No retry/interceptor support.
- No file download support.
- No cancellation.
- No central 401 logout behavior.

Required fix:

- Add `ApiClient`.
- Prefer `dio` for interceptors, downloads, multipart upload, and retry.
- Add `ApiException`.
- Add response parser and error mapper.

## 4.4 Missing services for supervisor and guide

Screens exist for supervisor and guide, but there are no matching services:

Missing:

```text
SupervisorService
GuideService
ReportService
SyncService
LookupService
NotificationService
```

Required fix:

- Add services and providers for each role.
- Bind each screen to a provider instead of hardcoded lists.

## 4.5 API constants are incomplete

`lib/core/api_constants.dart` has only generic teacher/student endpoints. It does not expose the backend mobile endpoint groups.

Missing:

- Mobile auth endpoint `/mobile/auth/login`
- Mobile teacher endpoints
- Mobile supervisor endpoints
- Mobile guide endpoints
- Sync endpoints
- Reports endpoints
- Device registration endpoint

Required fix:

- Split endpoint files by domain.
- Use backend mobile routes as the source of truth.

## 4.6 Most dashboards are hardcoded

Examples:

- Teacher dashboard shows `2` circles, `24` students, `21` attendance.
- Supervisor dashboard shows `4` centers, `12` active circles.
- Guide dashboard shows `6` centers, `8` supervisors.

Required fix:

- Replace each hardcoded metric with provider state loaded from role dashboard APIs.
- Keep skeleton placeholders while loading.
- Add empty/error/retry states.

## 4.7 No offline sync implementation in Flutter

The backend has:

```text
GET  /api/v1/sync/pull
POST /api/v1/sync/push
GET  /api/v1/sync/status
POST /api/v1/sync/conflicts/{conflict}/resolve
```

Flutter currently has `connectivity_plus`, but no real local queue.

Required fix:

- Add local database/cache.
- Add sync queue.
- Add idempotency keys.
- Add offline banners.
- Enable offline drafts for teacher sessions, supervisor visits, guide visits, and recommendations.

## 4.8 Quran range picker lacks validation UX

Current picker can select invalid order, for example a later `from` range than `to`.

Required fix:

- Add validator utility.
- Prevent invalid ranges.
- Show Arabic validation message.
- Add page/juz metadata later.
- Remember last student range.

## 4.9 Project lacks platform folders locally

The app folder contains `lib`, `pubspec.yaml`, `README.md`, and `codemagic.yaml`, but no local `android`, `ios`, `test`, or platform folders.

Codemagic generates Android/iOS folders during CI:

```yaml
yes | flutter create --platforms android .
yes | flutter create --platforms ios .
```

This is acceptable for a prototype, but production work needs stable platform folders committed once native settings begin.

Required fix:

- Generate and commit platform folders when adding app icons, permissions, Firebase, push notifications, and release signing.

## 4.10 Flutter SDK unavailable in current shell

Command result:

```text
flutter : The term 'flutter' is not recognized
```

Because of this, `flutter analyze` could not be run from this environment. The first developer task after installing Flutter or fixing PATH is:

```bash
flutter pub get
flutter analyze
flutter test
```

---

## 5. Current Product Gaps By Role

## 5.1 Student

Existing screens:

- Dashboard
- Daily tasks
- Progress
- Review
- Results
- Attendance
- Goals
- Memorization file
- Achievements
- My plan
- Homework
- Teacher notes

Missing or incomplete:

- Real dashboard endpoint binding.
- Published monthly test result detail.
- Attendance calendar.
- Homework status sync.
- Teacher notes visibility rules.
- Student progress by surah/juz.
- Notification deep links.

## 5.2 Teacher

Existing screens:

- Dashboard
- Halaqat / circles
- Students
- Student detail
- Daily follow-up
- Daily report entry
- Attendance entry
- Weekly evaluation
- Monthly exams
- Grade entry
- Reports center

Missing or incomplete:

- Today session API flow.
- Open/resume session.
- Bulk daily student entries tied to backend session ID.
- Real circle roster from `/mobile/teacher/circles/{circle}`.
- Offline draft.
- Returned report handling.
- Weak student follow-up.
- Parent contact logs.
- Supervisor recommendations.
- Monthly test submit state.

## 5.3 Center Supervisor

Existing screens:

- Dashboard
- Centers
- Center detail
- Teachers
- Circles
- Attendance alerts
- Visits
- Visit form
- Educational supervision
- Weekly review
- Monthly approval
- Risk cases
- Parent communication
- Reports
- Tasks
- Requests

Missing or incomplete:

- `SupervisorService`.
- `SupervisorProvider`.
- Real pending approvals.
- Approve/return actions with required comments.
- Real attendance alerts.
- Center request create/approve flow.
- Visit form persistence.
- Report download flow.

## 5.4 Guide / الموجهة

Existing screens:

- Dashboard
- Centers
- Supervisors
- Circles
- Visits
- Visit form
- Plans review
- Educational supervision
- Model circle evaluation
- Training needs
- Training plan
- Recommendations
- Monthly approval
- Reports

Missing or incomplete:

- `GuideService`.
- `GuideProvider`.
- Real visit schedule.
- Real model circle evaluation.
- Student evaluation bulk save.
- Plans approve/return.
- Training needs create/update.
- Training plan create.
- Recommendation follow-up.
- Offline visit drafts.

---

## 6. Backend Alignment Notes

Use these mobile endpoints first, not the generic admin endpoints:

### Auth

```text
POST /api/v1/mobile/auth/login
GET  /api/v1/mobile/auth/me
POST /api/v1/mobile/auth/register-device
```

### Teacher

```text
GET  /api/v1/mobile/teacher/home
GET  /api/v1/mobile/teacher/circles
GET  /api/v1/mobile/teacher/circles/{circle}
GET  /api/v1/mobile/teacher/today
GET  /api/v1/mobile/teacher/pending-actions
POST /api/v1/mobile/teacher/daily-sessions/open
POST /api/v1/mobile/teacher/daily-sessions/{session}/entries/bulk
POST /api/v1/mobile/teacher/daily-sessions/{session}/submit
POST /api/v1/mobile/teacher/attendance/bulk
GET  /api/v1/mobile/teacher/weekly-evaluations
POST /api/v1/mobile/teacher/weekly-evaluations
GET  /api/v1/mobile/teacher/monthly-tests
POST /api/v1/mobile/teacher/monthly-tests/{test}/results/bulk
GET  /api/v1/mobile/teacher/risk-students
POST /api/v1/mobile/teacher/remedial-plans
POST /api/v1/mobile/teacher/parent-contact-logs
```

### Supervisor

```text
GET  /api/v1/mobile/supervisor/home
GET  /api/v1/mobile/supervisor/centers
GET  /api/v1/mobile/supervisor/centers/{center}
GET  /api/v1/mobile/supervisor/summary
GET  /api/v1/mobile/supervisor/teachers
GET  /api/v1/mobile/supervisor/circles
GET  /api/v1/mobile/supervisor/attendance-alerts
GET  /api/v1/mobile/supervisor/pending-approvals
POST /api/v1/mobile/supervisor/daily-sessions/{session}/review
POST /api/v1/mobile/supervisor/weekly-evaluations/{evaluation}/approve
POST /api/v1/mobile/supervisor/weekly-evaluations/{evaluation}/return
POST /api/v1/mobile/supervisor/monthly-tests/{test}/approve
POST /api/v1/mobile/supervisor/monthly-tests/{test}/return
POST /api/v1/mobile/supervisor/monthly-plans/{plan}/approve
POST /api/v1/mobile/supervisor/monthly-plans/{plan}/return
GET  /api/v1/mobile/supervisor/tasks
POST /api/v1/mobile/supervisor/tasks
PUT  /api/v1/mobile/supervisor/tasks/{task}/status
GET  /api/v1/mobile/supervisor/center-requests
POST /api/v1/mobile/supervisor/center-requests
PUT  /api/v1/mobile/supervisor/center-requests/{request}/approve
```

### Guide

```text
GET  /api/v1/mobile/guide/home
GET  /api/v1/mobile/guide/centers
GET  /api/v1/mobile/guide/centers/{center}
GET  /api/v1/mobile/guide/summary
GET  /api/v1/mobile/guide/supervisors
GET  /api/v1/mobile/guide/circles
GET  /api/v1/mobile/guide/monthly-plans
POST /api/v1/mobile/guide/monthly-plans/{plan}/approve
POST /api/v1/mobile/guide/monthly-plans/{plan}/return
GET  /api/v1/mobile/guide/visits/schedule
POST /api/v1/mobile/guide/visits
GET  /api/v1/mobile/guide/visits/{visit}
PUT  /api/v1/mobile/guide/visits/{visit}
POST /api/v1/mobile/guide/visits/{visit}/students/bulk
POST /api/v1/mobile/guide/visits/{visit}/submit
POST /api/v1/mobile/guide/visits/{visit}/approve
GET  /api/v1/mobile/guide/training-needs
POST /api/v1/mobile/guide/training-needs
GET  /api/v1/mobile/guide/training-plan
POST /api/v1/mobile/guide/training-plan
```

### Sync

```text
GET  /api/v1/sync/pull
POST /api/v1/sync/push
GET  /api/v1/sync/status
POST /api/v1/sync/conflicts/{conflict}/resolve
```

---

## 7. Recommended Target Architecture

```text
lib/
  app.dart
  main.dart
  core/
    api/
      api_client.dart
      api_exception.dart
      api_response.dart
      endpoints/
        auth_endpoints.dart
        student_endpoints.dart
        teacher_endpoints.dart
        supervisor_endpoints.dart
        guide_endpoints.dart
        sync_endpoints.dart
        report_endpoints.dart
    config/
      app_config.dart
    routing/
      app_router.dart
      route_paths.dart
      route_guards.dart
    storage/
      secure_storage.dart
      local_cache.dart
      sync_queue_store.dart
    theme/
      app_colors.dart
      app_theme.dart
      app_text_styles.dart
    utils/
      quran_range_validator.dart
      score_calculator.dart
      api_error_mapper.dart
      date_formatter.dart
  data/
    models/
      auth/
      student/
      teacher/
      supervisor/
      guide/
      reports/
      sync/
    repositories/
      auth_repository.dart
      student_repository.dart
      teacher_repository.dart
      supervisor_repository.dart
      guide_repository.dart
      sync_repository.dart
      report_repository.dart
    services/
      auth_service.dart
      student_service.dart
      teacher_service.dart
      supervisor_service.dart
      guide_service.dart
      sync_service.dart
      report_service.dart
      notification_service.dart
  providers/
    auth_provider.dart
    student_provider.dart
    teacher_provider.dart
    supervisor_provider.dart
    guide_provider.dart
    sync_provider.dart
  screens/
  widgets/
    layout/
    cards/
    forms/
    quran/
    feedback/
    reports/
```

---

## 8. Highest Priority Fixes

1. Install Flutter SDK or fix PATH, then run `flutter analyze`.
2. Create `AuthUser` and stop using `StudentModel` as the authenticated user.
3. Add `ApiClient` and endpoint groups.
4. Switch auth to `/api/v1/mobile/auth/login`.
5. Add role-specific providers and services for teacher, supervisor, and guide.
6. Bind dashboards to real mobile home endpoints.
7. Complete teacher daily session flow with backend session ID.
8. Add offline draft queue before finishing field workflows.
9. Add approve/return actions for supervisor and guide.
10. Add tests and platform folders before production release.

