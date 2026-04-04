import '../../domain/entities/email.dart';
import '../../domain/repositories/email_repository.dart';
import '../datasources/mock_email_datasource.dart';

class EmailRepositoryImpl implements EmailRepository {
  final List<Email> _emails = MockEmailDatasource.generateEmails();

  @override
  Future<List<Email>> getAllEmails() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return List.unmodifiable(_emails);
  }

  @override
  Future<void> sendEmail(Email email) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _emails.insert(0, email);
  }

  @override
  Future<void> updateEmail(Email email) async {
    final index = _emails.indexWhere((e) => e.id == email.id);
    if (index != -1) {
      _emails[index] = email;
    }
  }

  @override
  Future<void> deleteEmail(String id) async {
    _emails.removeWhere((e) => e.id == id);
  }
}