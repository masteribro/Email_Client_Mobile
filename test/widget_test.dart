import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:email_client_mobile/app/app.dart';
import 'package:email_client_mobile/data/repositories/auth_repository_impl.dart';
import 'package:email_client_mobile/data/repositories/email_repository_impl.dart';
import 'package:email_client_mobile/presentation/blocs/auth/auth_cubit.dart';
import 'package:email_client_mobile/presentation/blocs/email/email_cubit.dart';

void main() {
  testWidgets('App renders login screen on cold start', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthCubit(AuthRepositoryImpl())),
          BlocProvider(create: (_) => EmailCubit(EmailRepositoryImpl())),
        ],
        child: const EmailClientApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sign In'), findsOneWidget);
  });
}