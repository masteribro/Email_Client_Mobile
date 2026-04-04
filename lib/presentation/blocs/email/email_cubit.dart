import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/entities/email.dart';
import '../../../domain/repositories/email_repository.dart';
import 'email_state.dart';

class EmailCubit extends Cubit<EmailState> {
  final EmailRepository _repository;
  final _uuid = const Uuid();

  EmailCubit(this._repository) : super(const EmailInitial()) {
    loadEmails();
  }

  Future<void> loadEmails() async {
    emit(EmailLoading(allEmails: state.allEmails, currentFolder: state.currentFolder));
    try {
      final emails = await _repository.getAllEmails();
      emit(EmailLoaded(allEmails: List<Email>.from(emails), currentFolder: state.currentFolder));
    } catch (e) {
      emit(EmailError(
        message: e.toString().replaceFirst('Exception: ', ''),
        allEmails: state.allEmails,
        currentFolder: state.currentFolder,
      ));
    }
  }

  void setFolder(EmailFolder folder) {
    emit(EmailLoaded(allEmails: state.allEmails, currentFolder: folder));
  }

  Future<void> _update(String id, Email Function(Email) apply) async {
    final email = state.emailById(id);
    if (email == null) return;
    final updated = apply(email);
    await _repository.updateEmail(updated);
    final list = state.allEmails.map((e) => e.id == id ? updated : e).toList();
    emit(EmailLoaded(allEmails: list, currentFolder: state.currentFolder));
  }

  Future<void> toggleRead(String id) =>
      _update(id, (e) => e.copyWith(isRead: !e.isRead));

  Future<void> markRead(String id) async {
    final email = state.emailById(id);
    if (email == null || email.isRead) return;
    await _update(id, (e) => e.copyWith(isRead: true));
  }

  Future<void> toggleStar(String id) =>
      _update(id, (e) => e.copyWith(isStarred: !e.isStarred));

  Future<void> moveToTrash(String id) =>
      _update(id, (e) => e.copyWith(folder: EmailFolder.trash, isRead: true));

  Future<void> sendEmail({
    required String to,
    required String subject,
    required String body,
    required String fromEmail,
    required String fromName,
  }) async {
    emit(EmailSendInProgress(allEmails: state.allEmails, currentFolder: state.currentFolder));
    try {
      final email = Email(
        id: _uuid.v4(),
        senderName: fromName,
        senderEmail: fromEmail,
        recipientEmail: to,
        subject: subject.isEmpty ? '(no subject)' : subject,
        preview: body.length > 100 ? body.substring(0, 100) : body,
        body: body,
        timestamp: DateTime.now(),
        isRead: true,
        folder: EmailFolder.sent,
      );
      await _repository.sendEmail(email);
      final list = [email, ...state.allEmails];
      emit(EmailSendSuccess(allEmails: list, currentFolder: state.currentFolder));
    } catch (e) {
      emit(EmailSendFailure(
        message: e.toString().replaceFirst('Exception: ', ''),
        allEmails: state.allEmails,
        currentFolder: state.currentFolder,
      ));
    }
  }
}