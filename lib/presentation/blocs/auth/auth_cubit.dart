import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email, password);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthUnauthenticated(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> logout() async {
    await _repository.logout();

    emit(const AuthUnauthenticated());
  }
}