import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/mock_email_datasource.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  // Pre-seeded demo accounts so the switcher is non-empty from the start
  final List<User> _savedAccounts = [
    MockEmailDatasource.currentUser,
    const User(
      id: 'user_2',
      name: 'Ahmed Hassan',
      email: 'ahmed@mailbox.com',
    ),
  ];

  AuthCubit(this._repository) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email, password);
      if (!_savedAccounts.any((u) => u.id == user.id)) {
        _savedAccounts.add(user);
      }
      emit(AuthAuthenticated(
        user,
        savedAccounts: List.unmodifiable(_savedAccounts),
      ));
    } catch (e) {
      emit(AuthUnauthenticated(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void switchAccount(User user) {
    emit(AuthAuthenticated(
      user,
      savedAccounts: List.unmodifiable(_savedAccounts),
    ));
  }

  Future<void> logout() async {
    await _repository.logout();
    _savedAccounts
      ..clear()
      ..add(MockEmailDatasource.currentUser)
      ..add(const User(
        id: 'user_2',
        name: 'Ahmed Hassan',
        email: 'ahmed@mailbox.com',
      ));
    emit(const AuthUnauthenticated());
  }
}