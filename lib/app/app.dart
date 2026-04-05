import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../presentation/blocs/auth/auth_cubit.dart';
import '../presentation/blocs/auth/auth_state.dart';

class EmailClientApp extends StatelessWidget {
  const EmailClientApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          AppRouter.router.go('/inbox');
        } else if (state is AuthUnauthenticated && state.errorMessage == null) {
          AppRouter.router.go('/login');
        }
      },
      child: MaterialApp.router(
        title: 'MailBox',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}