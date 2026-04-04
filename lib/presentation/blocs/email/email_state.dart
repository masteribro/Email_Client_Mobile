import 'package:equatable/equatable.dart';

import '../../../domain/entities/email.dart';

sealed class EmailState extends Equatable {
  final List<Email> allEmails;
  final EmailFolder currentFolder;

  const EmailState({
    this.allEmails = const [],
    this.currentFolder = EmailFolder.inbox,
  });

  List<Email> get currentEmails {
    List<Email> filtered;
    if (currentFolder == EmailFolder.starred) {
      filtered = allEmails.where((e) => e.isStarred).toList();
    } else {
      filtered = allEmails.where((e) => e.folder == currentFolder).toList();
    }
    filtered.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return filtered;
  }

  int get inboxUnreadCount =>
      allEmails.where((e) => e.folder == EmailFolder.inbox && !e.isRead).length;

  Email? emailById(String id) {
    try {
      return allEmails.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [allEmails, currentFolder];
}

final class EmailInitial extends EmailState {
  const EmailInitial();
}

final class EmailLoading extends EmailState {
  const EmailLoading({super.allEmails, super.currentFolder});
}

final class EmailLoaded extends EmailState {
  const EmailLoaded({super.allEmails, super.currentFolder});
}

final class EmailError extends EmailState {
  final String message;

  const EmailError({
    required this.message,
    super.allEmails,
    super.currentFolder,
  });

  @override
  List<Object?> get props => [...super.props, message];
}

final class EmailSendInProgress extends EmailState {
  const EmailSendInProgress({super.allEmails, super.currentFolder});
}

final class EmailSendSuccess extends EmailState {
  const EmailSendSuccess({super.allEmails, super.currentFolder});
}

final class EmailSendFailure extends EmailState {
  final String message;

  const EmailSendFailure({
    required this.message,
    super.allEmails,
    super.currentFolder,
  });

  @override
  List<Object?> get props => [...super.props, message];
}