# MailBox – Flutter Email Client

A mobile email client built as part of a Flutter developer assessment. It uses mock data to simulate a real email experience — inbox, compose, email detail, and folder navigation.

## How to Run

Make sure you have Flutter installed (latest stable), then:

```bash
flutter pub get
flutter run
```

That's it. No environment variables or API keys needed since everything runs on mock data.

To log in, use:
- Email: `ibrahim@mailbox.com`
- Password: `demo`

## What's Inside

The app follows clean architecture — domain, data, and presentation layers are kept separate. State management is done with flutter_bloc (Cubits specifically). Navigation uses go_router.

Screens:
- Login with simulated auth and error handling
- Inbox with folder switching (Starred, Sent, Drafts, Trash)
- Email detail with mark as read/unread, star, delete
- Compose with reply and forward support

Packages used: `flutter_bloc`, `go_router`, `intl`, `uuid`

## Challenges

The trickiest part was keeping the email list in sync across screens. When you open an email and it gets marked as read, the inbox behind it needs to reflect that immediately when you go back. I solved this by keeping a single flat list of all emails in the cubit and using `copyWith` to replace entries — both screens read from the same state so they stay in sync automatically.

The other thing that took some back and forth was the BLoC-to-GoRouter auth flow. GoRouter needs a `Listenable` to know when to re-evaluate routes, but the cubit just emits states. I ended up doing the navigation manually inside a `BlocListener` in the app shell instead of using `redirect`, which turned out to be simpler.