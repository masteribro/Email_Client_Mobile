import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_theme.dart';
import '../presentation/blocs/auth/auth_cubit.dart';
import '../presentation/blocs/auth/auth_state.dart';
import '../presentation/screens/compose/compose_screen.dart';
import '../presentation/screens/email_detail/email_detail_screen.dart';
import '../presentation/screens/inbox/inbox_screen.dart';
import '../presentation/screens/login/login_screen.dart';
import '../presentation/screens/search/search_screen.dart';

final _router = GoRouter(
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
      path: '/search',
      builder: (context, state) => const SearchScreen(),
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
  ],
);

class EmailClientApp extends StatelessWidget {
  const EmailClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _router.go('/inbox');
        } else if (state is AuthUnauthenticated && state.errorMessage == null) {
          _router.go('/login');
        }
      },
      child: MaterialApp.router(
        title: 'MailBox',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}