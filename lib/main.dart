import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/app.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/email_repository_impl.dart';
import 'presentation/blocs/auth/auth_cubit.dart';
import 'presentation/blocs/email/email_cubit.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit(AuthRepositoryImpl())),
        BlocProvider(create: (_) => EmailCubit(EmailRepositoryImpl())),
      ],
      child: const EmailClientApp(),
    ),
  );
}