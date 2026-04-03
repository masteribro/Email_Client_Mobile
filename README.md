# MailBox – Flutter Email Client

A sample email client mobile app built with Flutter, demonstrating clean architecture, state management with Riverpod, and navigation with go_router.

---

## Features

- **Authentication** – Simulated login with demo credentials and loading/error states
- **Inbox Screen** – Scrollable email list with sender avatar, subject, preview, timestamp, and unread indicators
- **Folder Navigation** – Drawer with Inbox, Starred, Sent, Drafts, and Trash
- **Email Detail** – Full email content with mark as read/unread, star, delete, reply, and forward
- **Compose Email** – New message form with To, Subject, and Body fields; discard confirmation
- **Smooth Transitions** – Slide and fade transitions between screens

---

## Tech Stack

| Concern | Package |
|---|---|
| State management | `flutter_riverpod ^2.5.1` |
| Navigation | `go_router ^14.0.0` |
| Date formatting | `intl ^0.19.0` |
| ID generation | `uuid ^4.4.0` |

---

## Architecture

```
lib/
├── app/                    # App shell, router configuration
├── core/                   # Theme, utilities
├── data/                   # Repository implementations, mock data source
├── domain/                 # Entities, abstract repository interfaces
└── presentation/           # Providers (Riverpod), screens, widgets
```

Clean architecture layers:
- **Domain** – `Email`, `User` entities + abstract `AuthRepository` / `EmailRepository`
- **Data** – `MockEmailDatasource` (realistic in-memory data) + concrete repository implementations
- **Presentation** – `AuthNotifier` (ChangeNotifier), `EmailNotifier` (StateNotifier), four screens, reusable widgets

---

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0 (latest stable recommended)
- Dart SDK >= 3.0.0

### Run

```bash
flutter pub get
flutter run
```

### Demo credentials

| Field | Value |
|---|---|
| Email | `demo@mailbox.com` |
| Password | `demo` |

Any email address with password `password123` also works.

---

## Screens

| Screen | Route |
|---|---|
| Login | `/login` |
| Inbox | `/inbox` |
| Email Detail | `/email/:id` |
| Compose | `/compose` |

---

## Design Decisions

- **Riverpod over Provider/Bloc** – Riverpod's compile-safe providers and `StateNotifier` make it easy to test the state independently of the UI. `ChangeNotifierProvider` is used for `AuthNotifier` so it can serve as go_router's `refreshListenable` directly.
- **go_router redirect** – Auth redirect logic lives entirely in the router, not in individual screens. When auth state changes, the `_AuthStateChangeNotifier` bridge fires, go_router re-evaluates `redirect`, and navigation happens automatically.
- **In-memory mock data** – `MockEmailDatasource` generates 22 emails (15 inbox, 5 sent, 2 drafts) with realistic content and staggered timestamps. All mutations (mark read, star, delete, send) update the in-memory list.
- **No code generation** – freezed/riverpod_generator are intentionally omitted to keep setup simple (no `build_runner` step required).

---

## Challenges

- **go_router + Riverpod auth redirect** – GoRouter's `refreshListenable` requires a `Listenable`. Since `StateNotifier` is not a Flutter `ChangeNotifier`, a thin `_AuthStateChangeNotifier` bridge listens to the Riverpod provider and calls `notifyListeners()`, triggering the router to re-evaluate `redirect`.
- **Reactive state updates** – Marking an email as read in the detail screen must immediately reflect back in the inbox list. This is handled by storing all emails in a single flat `List<Email>` in `EmailNotifier` and replacing entries with `copyWith`, so both screens watching the same provider stay in sync.
