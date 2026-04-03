
import '../entities/email.dart';

abstract class EmailRepository {
  Future<List<Email>> getAllEmails();
  Future<void> sendEmail(Email email);
  Future<void> updateEmail(Email email);
  Future<void> deleteEmail(String id);
}
