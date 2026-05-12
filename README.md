# نظام المنارة - Quran Mobile UI

Flutter mobile app for the Quran education system covering students, teachers, center supervisors, and guide supervisors.

## Setup

### Backend
```bash
cd quran_admin
cp .env.example .env
php artisan key:generate
php artisan migrate:fresh
php artisan db:seed
```

### Flutter App
```bash
cd quran_mobile_ui
flutter pub get
flutter run
```

## Test Credentials
- Admin: `admin@quran.app` / `password123`
- Teacher: `ahmed@quran.local` / `password123`
- Student: `student@quran.app` / `password123`

## Architecture
- **API Base URL**: `https://baherit.tech/api/v1` (configurable in `lib/core/api_constants.dart`)
- **Auth**: Token-based via Sanctum (`POST /mobile/auth/login`, with legacy fallback to `POST /auth/token`)
- **State**: Provider pattern
- **Storage**: FlutterSecureStorage for tokens
- **Mobile APIs**: Dedicated `/mobile/teacher`, `/mobile/supervisor`, `/mobile/guide`, and `/sync` endpoint groups
