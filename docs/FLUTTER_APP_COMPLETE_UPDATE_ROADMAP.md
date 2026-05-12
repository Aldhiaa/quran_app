# Quran Flutter App Complete Update Roadmap

**Project:** `quran_mobile_ui`  
**Target product:** نظام المنارة mobile app for students, teachers, center supervisors, and guides.  
**Backend target:** `quran_admin` Laravel API under `/api/v1`.

---

## 1. Product Goal

Update the Flutter app from a visual prototype into a complete operational mobile app that supports:

- Student learning transparency.
- Teacher daily entry.
- Supervisor approval and center monitoring.
- Guide quality visits and training follow-up.
- Offline work in weak internet environments.
- Real backend API integration.

---

## 2. Development Order

The safest order is:

1. Foundation architecture.
2. Auth and role routing.
3. Shared UI and API state.
4. Teacher workflow.
5. Supervisor workflow.
6. Guide workflow.
7. Student polish.
8. Offline sync.
9. Reports and exports.
10. QA, build, and release.

Teacher workflow comes early because it creates the daily operational data that supervisor and guide screens need.

---

## Phase 0 - Environment and Baseline

**Duration:** 1 day

### Tasks

- Install Flutter SDK or add it to PATH.
- Run:



### Deliverables

- Known analyzer status.
- Known dependency status.
- Baseline issue list.

### Acceptance Criteria

- `flutter pub get` works.
- Analyzer output is documented.
- App can be launched locally on Android emulator or physical device.

---

## Phase 1 - Foundation Refactor

**Duration:** 4-6 days

### Tasks

1. Create `lib/app.dart`.
2. Keep `main.dart` small.
3. Add `go_router`.
4. Add route path constants.
5. Add role route guards.
6. Add `AuthUser` model.
7. Update `AuthProvider`.
8. Split theme into smaller files if needed.
9. Split API constants into endpoint groups.
10. Add central `ApiClient`.
11. Add `ApiException` and Arabic error mapper.
12. Add loading, empty, error, and retry widgets.

### Recommended packages

```yaml
dio: ^5.0.0
go_router: ^14.0.0
equatable: ^2.0.0
uuid: ^4.4.0
```

### Deliverables

- Cleaner app bootstrap.
- Role-based routing.
- Central API client.
- Generic auth user.

### Acceptance Criteria

- Login redirects by role.
- Invalid role goes to login or role switch safely.
- Token is injected automatically.
- 401 clears session and returns user to login.

---

## Phase 2 - Endpoint and Model Layer

**Duration:** 5-7 days

### Tasks

1. Add endpoint files:

```text
auth_endpoints.dart
student_endpoints.dart
teacher_endpoints.dart
supervisor_endpoints.dart
guide_endpoints.dart
sync_endpoints.dart
report_endpoints.dart
```

2. Add model folders:

```text
models/auth
models/student
models/teacher
models/supervisor
models/guide
models/reports
models/sync
```

3. Add repositories:

```text
auth_repository.dart
student_repository.dart
teacher_repository.dart
supervisor_repository.dart
guide_repository.dart
sync_repository.dart
report_repository.dart
```

4. Add service methods for mobile endpoints.
5. Add DTO parsing helpers for backend `data` wrappers and paginated responses.

### Deliverables

- Flutter has a typed API contract for all mobile endpoint groups.

### Acceptance Criteria

- No screen constructs raw endpoint strings.
- No screen reads secure storage directly.
- Every service method returns typed model or typed result.

---

## Phase 3 - Shared UI System Completion

**Duration:** 4-6 days

### Tasks

- Split `common_widgets.dart` into organized widget folders.
- Keep existing widgets but improve naming and reuse.
- Add missing shared components:

```text
RoleDashboardHeader
KpiGrid
KpiCard
SearchFilterBar
StatusBadge
ProgressRing
QuickActionGrid
DraftSubmitBar
ApprovalActionBar
OfflineSyncBanner
LoadingSkeleton
AppEmptyState
AppErrorState
ScoreInputRow
RatingSelector
ReportCard
VisitCard
RecommendationCard
TrainingNeedCard
CenterCard
CircleCard
StudentCard
TeacherCard
```

### Deliverables

- Shared UI primitives ready for all role screens.

### Acceptance Criteria

- Every list screen has loading, empty, and error states.
- Every form has submit loading and validation states.
- Dashboard cards no longer shift layout when values load.

---

## Phase 4 - Teacher Workflow Completion

**Duration:** 10-14 days

### Backend endpoints

Use:

```text
/mobile/teacher/home
/mobile/teacher/circles
/mobile/teacher/circles/{circle}
/mobile/teacher/today
/mobile/teacher/pending-actions
/mobile/teacher/daily-sessions/open
/mobile/teacher/daily-sessions/{session}/entries/bulk
/mobile/teacher/daily-sessions/{session}/submit
/mobile/teacher/attendance/bulk
/mobile/teacher/weekly-evaluations
/mobile/teacher/monthly-tests
/mobile/teacher/monthly-tests/{test}/results/bulk
/mobile/teacher/risk-students
/mobile/teacher/remedial-plans
/mobile/teacher/parent-contact-logs
```

### Tasks

1. Add `TeacherProvider`.
2. Add `TeacherRepository`.
3. Add typed teacher dashboard model.
4. Replace teacher dashboard hardcoded values.
5. Build circle detail with roster.
6. Build today session open/resume.
7. Rework attendance entry to use `session_id`.
8. Rework daily follow-up to save entries in bulk.
9. Add draft submit bar.
10. Add session submit.
11. Align weekly evaluation with the 10 official criteria.
12. Align monthly test scoring:

```text
memorization 50
recitation 50
ahkam 30
matn 20
behavior 50
total 200
```

13. Add weak student follow-up.
14. Add parent contact logs.
15. Add returned reports.
16. Add supervisor recommendations list.

### Deliverables

- Teacher can complete a real daily session.
- Teacher can enter monthly results.
- Teacher can create follow-up/remedial records.

### Acceptance Criteria

- Teacher sees only assigned circles.
- Teacher can open today session.
- Teacher can bulk save attendance.
- Teacher can bulk save memorization/review.
- Teacher can submit session.
- Approved sessions are read-only.
- Invalid Quran ranges are blocked before submit.

---

## Phase 5 - Supervisor Workflow Completion

**Duration:** 10-14 days

### Backend endpoints

Use:

```text
/mobile/supervisor/home
/mobile/supervisor/centers
/mobile/supervisor/centers/{center}
/mobile/supervisor/summary
/mobile/supervisor/teachers
/mobile/supervisor/circles
/mobile/supervisor/attendance-alerts
/mobile/supervisor/pending-approvals
/mobile/supervisor/daily-sessions/{session}/review
/mobile/supervisor/weekly-evaluations/{evaluation}/approve
/mobile/supervisor/weekly-evaluations/{evaluation}/return
/mobile/supervisor/monthly-tests/{test}/approve
/mobile/supervisor/monthly-tests/{test}/return
/mobile/supervisor/monthly-plans/{plan}/approve
/mobile/supervisor/monthly-plans/{plan}/return
/mobile/supervisor/tasks
/mobile/supervisor/center-requests
```

### Tasks

1. Add `SupervisorProvider`.
2. Add `SupervisorRepository`.
3. Add `SupervisorService`.
4. Replace dashboard hardcoded metrics.
5. Bind centers list and detail.
6. Bind teachers oversight.
7. Bind circle monitoring.
8. Bind attendance alerts.
9. Bind pending approvals.
10. Add approval detail screens.
11. Add return dialog requiring comment.
12. Add center request creation.
13. Add task create/update status.
14. Add reports center with filters.

### Deliverables

- Supervisor can monitor center operations.
- Supervisor can approve/return teacher submissions.
- Supervisor can create tasks and requests.

### Acceptance Criteria

- Return action requires a comment.
- Approve/return writes status immediately.
- Lists refresh after actions.
- Error state appears if action fails.

---

## Phase 6 - Guide Workflow Completion

**Duration:** 12-16 days

### Backend endpoints

Use:

```text
/mobile/guide/home
/mobile/guide/centers
/mobile/guide/centers/{center}
/mobile/guide/summary
/mobile/guide/supervisors
/mobile/guide/circles
/mobile/guide/monthly-plans
/mobile/guide/monthly-plans/{plan}/approve
/mobile/guide/monthly-plans/{plan}/return
/mobile/guide/visits/schedule
/mobile/guide/visits
/mobile/guide/visits/{visit}
/mobile/guide/visits/{visit}/students/bulk
/mobile/guide/visits/{visit}/submit
/mobile/guide/visits/{visit}/approve
/mobile/guide/training-needs
/mobile/guide/training-plan
```

### Tasks

1. Add `GuideProvider`.
2. Add `GuideRepository`.
3. Add `GuideService`.
4. Replace dashboard hardcoded metrics.
5. Bind centers and center detail.
6. Bind supervisors oversight.
7. Bind circle monitoring.
8. Bind monthly plans review.
9. Add approve/return for plans.
10. Bind visit schedule.
11. Build visit create/update flow.
12. Build student bulk evaluation.
13. Build submit/approve visit.
14. Bind educational supervision form.
15. Bind model circle evaluation.
16. Bind training needs.
17. Bind training plan.
18. Bind recommendations.

### Deliverables

- Guide can perform quality visits and plan reviews from mobile.
- Guide can create training needs and training plan items.

### Acceptance Criteria

- Guide sees scoped centers only.
- Visit drafts can be saved before submit.
- Student evaluations are bulk saved.
- Plan return requires comment.
- Training need creation validates required fields.

---

## Phase 7 - Student App Completion

**Duration:** 6-8 days

### Tasks

1. Add `StudentProvider`.
2. Replace dashboard hardcoded values.
3. Bind daily tasks.
4. Bind homework and update status.
5. Bind plan.
6. Bind progress.
7. Bind results.
8. Bind attendance history.
9. Bind teacher notes.
10. Bind achievements.
11. Add result detail screen.
12. Add attendance calendar.

### Deliverables

- Student sees personal operational data from backend.

### Acceptance Criteria

- Student never sees other students.
- Student sees only published/allowed results.
- Homework status update persists.
- Teacher note visibility is respected.

---

## Phase 8 - Offline Sync and Drafts

**Duration:** 8-12 days

### Recommended packages

```yaml
hive_flutter: ^1.1.0
path_provider: ^2.1.0
```

Alternative: use `drift` if relational local querying becomes important.

### Offline-enabled objects

- Teacher daily session entries.
- Teacher attendance.
- Weekly evaluation draft.
- Monthly test grades draft.
- Supervisor visit draft.
- Guide visit draft.
- Guide model circle evaluation draft.
- Recommendations and task updates.

### Tasks

1. Add local queue model.
2. Add `SyncQueueStore`.
3. Add `SyncProvider`.
4. Add network listener using `connectivity_plus`.
5. Add `OfflineSyncBanner`.
6. Add background/manual retry.
7. Add idempotency key per queued item.
8. Add conflict screen.
9. Bind `/sync/push`, `/sync/pull`, `/sync/status`.

### Acceptance Criteria

- Teacher can save daily entries offline.
- User can see unsynced count.
- Reconnect triggers sync.
- Failed items stay visible with reason.
- Duplicate submit is prevented.

---

## Phase 9 - Reports and Exports

**Duration:** 5-8 days

### Tasks

1. Add `ReportService`.
2. Add `ReportRepository`.
3. Add report list models.
4. Add report filters by role.
5. Add PDF download.
6. Add Excel download where available.
7. Add open/share flow.
8. Add report status badges.

### Recommended packages

```yaml
url_launcher: ^6.3.0
open_filex: ^4.5.0
file_picker: ^8.0.0
path_provider: ^2.1.0
```

### Acceptance Criteria

- Report download shows progress.
- Failed download shows retry.
- Downloaded file opens on device.

---

## Phase 10 - Notifications and Deep Links

**Duration:** 5-8 days

### Tasks

1. Add notification provider.
2. Bind unread counts.
3. Mark read/read all.
4. Add notification route mapping.
5. Add device registration.
6. Add push integration later.

### Deep link examples

```text
/teacher/returned-reports/{id}
/supervisor/monthly-tests/{id}/approval
/guide/visits/{id}
/student/results/{id}
```

### Acceptance Criteria

- Notification tap opens the correct screen.
- Badge count refreshes after mark read.
- Unknown link falls back safely.

---

## Phase 11 - QA and Release

**Duration:** 5-7 days

### Test plan

Unit tests:

- Auth role parsing.
- Quran range validation.
- Monthly test score calculation.
- Weekly evaluation score calculation.
- API error mapping.
- Sync queue serialization.

Widget tests:

- Login screen.
- Role dashboard header.
- Quran range picker.
- Draft submit bar.
- Approval action bar.

Integration tests:

- Login as student.
- Login as teacher.
- Teacher submits daily session.
- Supervisor returns session.
- Teacher resubmits.
- Supervisor approves monthly test.
- Guide submits visit.
- Offline draft sync.

### Release tasks

- Generate platform folders.
- Add app icons.
- Add Android package name.
- Add iOS bundle ID.
- Add network permissions.
- Add secure storage platform config.
- Add signing config.
- Update Codemagic with environment variables.

---

## 3. Final Definition of Done

The Flutter update is complete when:

- Four roles login and route correctly.
- Main dashboards load real backend data.
- Teacher can complete daily workflow end-to-end.
- Supervisor can approve/return records.
- Guide can complete visits and training workflow.
- Student sees real personal progress and results.
- Offline drafts and sync work for field-critical forms.
- Reports can be viewed/downloaded.
- Notifications open correct screens.
- Tests cover calculations, routing, API error handling, and sync queue.
- Android release build is generated successfully.

