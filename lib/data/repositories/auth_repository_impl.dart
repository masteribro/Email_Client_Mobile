import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_email_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {


  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }

    final isDemo =
        email.toLowerCase() == 'ibrahim@mailbox.com' && password == 'demo';
    final isGeneric = password == 'password123' && email.contains('@');

    if (!isDemo && !isGeneric) {
      throw Exception('Invalid email or password. Try ibrahim@mailbox.com / demo');
    }

    return MockEmailDatasource.currentUser;
  }

  @override
  Future<void> logout() async {

    await Future.delayed(const Duration(milliseconds: 300));
  }
}