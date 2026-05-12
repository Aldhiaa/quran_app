# Flutter Screen and API Implementation Plan

**Project:** `quran_mobile_ui`  
**Purpose:** Exact mapping between current Flutter screens, required backend endpoints, missing services/providers, and implementation priority.

---

## 1. Global Implementation Rules

1. Screens must not call API services directly.
2. Screens should read Provider/ViewModel state.
3. Services should use `ApiClient`.
4. Every list screen needs loading, empty, error, and retry states.
5. Every form supports save draft where the workflow allows it.
6. Submit actions must validate required fields.
7. Return/reject actions must require a comment.
8. Approved records are read-only.
9. Student role must never receive other students' data.
10. Offline drafts must use idempotency keys to avoid duplicate submissions.

---

## 2. Auth and App Shell

### Current files

```text
lib/main.dart
lib/providers/auth_provider.dart
lib/services/auth_service.dart
lib/screens/auth/login_screen.dart
lib/screens/common/student_shell.dart
lib/screens/common/teacher_shell.dart
lib/screens/common/supervisor_shell.dart
lib/screens/common/guide_shell.dart
```

### Required backend endpoints

```text
POST /api/v1/mobile/auth/login
GET  /api/v1/mobile/auth/me
POST /api/v1/mobile/auth/register-device
POST /api/v1/auth/logout
```

### Required implementation

- Add `AuthUser`.
- Update `AuthProvider`.
- Use mobile auth endpoint.
- Add `RouteGuard`.
- Add deep link-ready routes.
- Add role switch only for demo/dev mode or multi-role users.

### Priority

P0

---

## 3. Student Screens

## 3.1 Student Dashboard

### Current file

```text
lib/screens/student/student_dashboard_screen.dart
```

### API

```text
GET /api/v1/student/summary
GET /api/v1/student/daily-tasks
GET /api/v1/student/plan
GET /api/v1/student/teacher-notes
```

### Required state

```text
StudentDashboardState
- loading
- summary
- todayTasks
- currentPlan
- latestNote
- error
```

### Implementation notes

- Replace static greeting cards with real summary.
- Add retry when API fails.
- Show cached data when offline.

### Priority

P1

## 3.2 My Plan

### Current file

```text
lib/screens/student/my_plan_screen.dart
```

### API

```text
GET /api/v1/student/plan
GET /api/v1/student/homework
POST /api/v1/student/homework/{id}/status
```

### Required implementation

- Monthly plan card.
- Today memorization range.
- Review range.
- Homework status.
- Prepared / need help buttons.

### Priority

P1

## 3.3 Student Progress

### Current file

```text
lib/screens/student/student_progress_screen.dart
```

### API

```text
GET /api/v1/student/summary
GET /api/v1/student/plan
```

### Required implementation

- Progress by memorization.
- Review consistency.
- Attendance rate.
- Monthly result trend.
- Optional charts later.

### Priority

P2

## 3.4 Student Results

### Current file

```text
lib/screens/student/student_results_screen.dart
```

### API

Backend may need a dedicated mobile endpoint if generic monthly tests do not scope to student:

```text
GET /api/v1/mobile/student/results
GET /api/v1/mobile/student/results/{id}
```

### Required backend note

If these endpoints do not exist yet, add them. Student results must return only approved/published personal results.

### Priority

P1

## 3.5 Attendance

### Current file

```text
lib/screens/student/attendance_screen.dart
```

### API

Recommended:

```text
GET /api/v1/mobile/student/attendance
```

### Required backend note

Generic `/attendance` should not be used unless it scopes by student role correctly.

### Priority

P2

---

## 4. Teacher Screens

## 4.1 Teacher Dashboard

### Current file

```text
lib/screens/teacher/teacher_dashboard_screen.dart
```

### API

```text
GET /api/v1/mobile/teacher/home
GET /api/v1/mobile/teacher/pending-actions
```

### Required implementation

- Replace hardcoded KPI values.
- Show today's circles.
- Show pending report count.
- Show weak students.
- Show sync status.

### Priority

P0

## 4.2 Halaqat / My Circles

### Current file

```text
lib/screens/teacher/halaqat_screen.dart
```

### API

```text
GET /api/v1/mobile/teacher/circles
GET /api/v1/mobile/teacher/circles/{circle}
```

### Required implementation

- Add circle cards from API.
- Add center, schedule, active students, latest session.
- Navigate to circle detail with ID.

### Priority

P0

## 4.3 Today Session

### Current status

Missing as a dedicated screen.

### New file

```text
lib/screens/teacher/today_session_screen.dart
```

### API

```text
GET  /api/v1/mobile/teacher/today?circle_id={id}
POST /api/v1/mobile/teacher/daily-sessions/open
```

### Required implementation

- Open or resume session.
- Show session status.
- Show roster.
- Entry points: attendance, follow-up, homework, submit.

### Priority

P0

## 4.4 Attendance Entry

### Current file

```text
lib/screens/teacher/attendance_entry_screen.dart
```

### API

```text
POST /api/v1/mobile/teacher/attendance/bulk
```

### Payload

```json
{
  "session_id": 1,
  "attendance": [
    {
      "student_id": 1,
      "status": "present",
      "reason": null
    }
  ]
}
```

### Required implementation

- Load roster from today session.
- Default all present.
- Status chips: present, late, absent_excused, absent_unexcused.
- Save draft offline.
- Submit online when possible.

### Priority

P0

## 4.5 Daily Follow-up Notebook

### Current file

```text
lib/screens/teacher/daily_followup_screen.dart
```

### API

```text
POST /api/v1/mobile/teacher/daily-sessions/{session}/entries/bulk
```

### Payload fields

```text
student_id
attendance_status
memorization_from_surah
memorization_from_ayah
memorization_to_surah
memorization_to_ayah
review_from_surah
review_from_ayah
review_to_surah
review_to_ayah
tajweed_observation
performance_level
needs_followup
teacher_note
homework_note
```

### Required implementation

- Support card mode on phones.
- Support compact matrix mode later for tablets.
- Use improved Quran range picker.
- Save draft locally.
- Bulk save to backend.

### Priority

P0

## 4.6 Daily Report Entry

### Current file

```text
lib/screens/teacher/daily_report_entry_screen.dart
```

### API

```text
POST /api/v1/mobile/teacher/daily-sessions/{session}/submit
```

### Required implementation

- Show completion summary.
- Validate required entries.
- Submit final session.
- Lock after submit unless returned.

### Priority

P0

## 4.7 Weekly Evaluation

### Current file

```text
lib/screens/teacher/weekly_evaluation_screen.dart
```

### API

```text
GET  /api/v1/mobile/teacher/weekly-evaluations
POST /api/v1/mobile/teacher/weekly-evaluations
```

### Required implementation

Official 10 criteria:

1. الالتزام بالشعائر التعبدية
2. الأدب العام والأخلاق الحسنة
3. الانضباط في المواعيد
4. الانضباط والاجتهاد في الحلقة القرآنية
5. الانضباط والاجتهاد في الدراسة النظامية
6. النظافة والترتيب الشخصي والعام
7. المحافظة على ممتلكات الدار
8. روح المبادرة والتعاون
9. التميز في جانب معين
10. التأثير الإيجابي في الآخرين

### Priority

P1

## 4.8 Monthly Tests and Grade Entry

### Current files

```text
lib/screens/teacher/monthly_exams_screen.dart
lib/screens/teacher/monthly_exam_create_screen.dart
lib/screens/teacher/grades_entry_screen.dart
lib/screens/teacher/exam_results_screen.dart
lib/screens/teacher/exam_result_detail_screen.dart
```

### API

```text
GET  /api/v1/mobile/teacher/monthly-tests
POST /api/v1/mobile/teacher/monthly-tests/{test}/results/bulk
```

### Required implementation

- Score max validation:
  - Memorization 50
  - Recitation 50
  - Ahkam 30
  - Matn 20
  - Behavior 50
- Auto total out of 200.
- Auto percentage.
- Auto rating.
- Save draft offline.

### Priority

P1

## 4.9 Weak Student Follow-up

### New file

```text
lib/screens/teacher/weak_student_followup_screen.dart
```

### API

```text
GET  /api/v1/mobile/teacher/risk-students
POST /api/v1/mobile/teacher/remedial-plans
POST /api/v1/mobile/teacher/parent-contact-logs
```

### Priority

P1

---

## 5. Supervisor Screens

## 5.1 Supervisor Dashboard

### Current file

```text
lib/screens/supervisor/supervisor_dashboard_screen.dart
```

### API

```text
GET /api/v1/mobile/supervisor/home
GET /api/v1/mobile/supervisor/pending-approvals
```

### Priority

P1

## 5.2 Centers and Center Detail

### Current files

```text
lib/screens/supervisor/supervisor_centers_screen.dart
lib/screens/supervisor/supervisor_center_detail_screen.dart
```

### API

```text
GET /api/v1/mobile/supervisor/centers
GET /api/v1/mobile/supervisor/centers/{center}
```

### Priority

P1

## 5.3 Teachers and Circles Oversight

### Current files

```text
lib/screens/supervisor/supervisor_teachers_screen.dart
lib/screens/supervisor/supervisor_circles_screen.dart
```

### API

```text
GET /api/v1/mobile/supervisor/teachers
GET /api/v1/mobile/supervisor/circles
```

### Priority

P2

## 5.4 Attendance Alerts

### Current file

```text
lib/screens/supervisor/supervisor_attendance_alerts_screen.dart
```

### API

```text
GET /api/v1/mobile/supervisor/attendance-alerts
```

### Priority

P1

## 5.5 Approval Screens

### Current files

```text
lib/screens/supervisor/supervisor_weekly_review_screen.dart
lib/screens/supervisor/supervisor_monthly_approval_screen.dart
```

### API

```text
POST /api/v1/mobile/supervisor/daily-sessions/{session}/review
POST /api/v1/mobile/supervisor/weekly-evaluations/{evaluation}/approve
POST /api/v1/mobile/supervisor/weekly-evaluations/{evaluation}/return
POST /api/v1/mobile/supervisor/monthly-tests/{test}/approve
POST /api/v1/mobile/supervisor/monthly-tests/{test}/return
POST /api/v1/mobile/supervisor/monthly-plans/{plan}/approve
POST /api/v1/mobile/supervisor/monthly-plans/{plan}/return
```

### Required implementation

- Approval action bar.
- Return comment dialog.
- Refresh list after action.
- Lock approved record display.

### Priority

P1

## 5.6 Tasks and Requests

### Current files

```text
lib/screens/supervisor/supervisor_tasks_screen.dart
lib/screens/supervisor/supervisor_requests_screen.dart
```

### API

```text
GET  /api/v1/mobile/supervisor/tasks
POST /api/v1/mobile/supervisor/tasks
PUT  /api/v1/mobile/supervisor/tasks/{task}/status
GET  /api/v1/mobile/supervisor/center-requests
POST /api/v1/mobile/supervisor/center-requests
PUT  /api/v1/mobile/supervisor/center-requests/{request}/approve
```

### Priority

P2

---

## 6. Guide Screens

## 6.1 Guide Dashboard

### Current file

```text
lib/screens/guide/guide_dashboard_screen.dart
```

### API

```text
GET /api/v1/mobile/guide/home
```

### Priority

P1

## 6.2 Centers, Supervisors, and Circles

### Current files

```text
lib/screens/guide/guide_centers_screen.dart
lib/screens/guide/guide_supervisors_screen.dart
lib/screens/guide/guide_circles_screen.dart
```

### API

```text
GET /api/v1/mobile/guide/centers
GET /api/v1/mobile/guide/centers/{center}
GET /api/v1/mobile/guide/supervisors
GET /api/v1/mobile/guide/circles
```

### Priority

P1

## 6.3 Plans Review

### Current file

```text
lib/screens/guide/guide_plans_review_screen.dart
```

### API

```text
GET  /api/v1/mobile/guide/monthly-plans
POST /api/v1/mobile/guide/monthly-plans/{plan}/approve
POST /api/v1/mobile/guide/monthly-plans/{plan}/return
```

### Priority

P1

## 6.4 Visits

### Current files

```text
lib/screens/guide/guide_visits_screen.dart
lib/screens/guide/guide_visit_form_screen.dart
lib/screens/guide/guide_model_circle_evaluation_screen.dart
lib/screens/guide/guide_educational_supervision_screen.dart
```

### API

```text
GET  /api/v1/mobile/guide/visits/schedule
POST /api/v1/mobile/guide/visits
GET  /api/v1/mobile/guide/visits/{visit}
PUT  /api/v1/mobile/guide/visits/{visit}
POST /api/v1/mobile/guide/visits/{visit}/students/bulk
POST /api/v1/mobile/guide/visits/{visit}/submit
POST /api/v1/mobile/guide/visits/{visit}/approve
```

### Required implementation

- Visit draft.
- Visit update.
- Student evaluations.
- Submit/approve.
- Offline draft.

### Priority

P1

## 6.5 Training Needs and Training Plan

### Current files

```text
lib/screens/guide/guide_training_needs_screen.dart
lib/screens/guide/guide_training_plan_screen.dart
```

### API

```text
GET  /api/v1/mobile/guide/training-needs
POST /api/v1/mobile/guide/training-needs
GET  /api/v1/mobile/guide/training-plan
POST /api/v1/mobile/guide/training-plan
```

### Priority

P2

---

## 7. Reports

### Current files

```text
lib/screens/teacher/reports_center_screen.dart
lib/screens/supervisor/supervisor_reports_screen.dart
lib/screens/guide/guide_reports_screen.dart
```

### API

```text
GET  /api/v1/reports
POST /api/v1/reports/generate
GET  /api/v1/reports/{report}/pdf
GET  /api/v1/reports/{report}/excel
```

### Required implementation

- Shared report repository.
- Role-aware filters.
- Download progress.
- Open downloaded file.

### Priority

P2

---

## 8. Offline Sync

### New files

```text
lib/data/models/sync/sync_queue_item.dart
lib/data/services/sync_service.dart
lib/data/repositories/sync_repository.dart
lib/providers/sync_provider.dart
lib/core/storage/sync_queue_store.dart
lib/screens/common/sync_queue_screen.dart
```

### API

```text
GET  /api/v1/sync/pull
POST /api/v1/sync/push
GET  /api/v1/sync/status
POST /api/v1/sync/conflicts/{conflict}/resolve
```

### Queue model

```dart
class SyncQueueItem {
  final String localId;
  final String endpoint;
  final String method;
  final Map<String, dynamic> payload;
  final String status;
  final int retryCount;
  final String idempotencyKey;
  final DateTime createdAt;
  final String? lastError;
}
```

### Priority

P0 for teacher drafts. P1 for supervisor/guide drafts.

---

## 9. Missing Backend Endpoints Recommended For Student Mobile

The backend has several student engagement endpoints, but the Flutter app will be cleaner with a dedicated student mobile group:

```text
GET  /api/v1/mobile/student/home
GET  /api/v1/mobile/student/plan
GET  /api/v1/mobile/student/progress
GET  /api/v1/mobile/student/attendance
GET  /api/v1/mobile/student/results
GET  /api/v1/mobile/student/results/{result}
GET  /api/v1/mobile/student/homework
POST /api/v1/mobile/student/homework/{homework}/status
GET  /api/v1/mobile/student/teacher-notes
GET  /api/v1/mobile/student/achievements
```

Until these exist, use generic student endpoints only if backend scoping is verified.

---

## 10. Priority Summary

### P0

- Flutter analyzer baseline.
- AuthUser model.
- ApiClient.
- Mobile auth.
- Role router.
- Teacher dashboard real API.
- Teacher circles real API.
- Today session.
- Attendance bulk.
- Daily follow-up bulk.
- Teacher offline draft queue.

### P1

- Weekly evaluation.
- Monthly test scoring.
- Supervisor dashboard.
- Supervisor approvals.
- Guide dashboard.
- Guide visits.
- Student dashboard and results.
- Sync push/pull.

### P2

- Reports export.
- Training needs.
- Center requests.
- Parent communication.
- Advanced charts.
- Notification deep links.

### P3

- Push notifications.
- Voice notes.
- Attachments.
- QR attendance.
- Advanced analytics.
- Full bilingual mode.

