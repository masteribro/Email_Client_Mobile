import 'package:go_router/go_router.dart';

import '../../presentation/screens/compose/compose_screen.dart';
import '../../presentation/screens/email_detail/email_detail_screen.dart';
import '../../presentation/screens/inbox/inbox_screen.dart';
import '../../presentation/screens/login/login_screen.dart';
import '../../presentation/screens/search/search_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/inbox',
        builder: (context, state) => const InboxScreen(),
      ),
      GoRoute(
        path: '/email/:id',
        builder: (context, state) =>
            EmailDetailScreen(emailId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/compose',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return ComposeScreen(
            replyToEmail: extra?['replyToEmail'],
            replyToName: extra?['replyToName'],
            replySubject: extra?['replySubject'],
          );
        },
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}