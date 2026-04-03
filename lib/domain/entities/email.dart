enum EmailFolder { inbox, starred, sent, drafts, trash }

class Email {
  final String id;
  final String senderName;
  final String senderEmail;
  final String recipientEmail;
  final String subject;
  final String preview;
  final String body;
  final DateTime timestamp;
  final bool isRead;
  final bool isStarred;
  final EmailFolder folder;

  const Email({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.recipientEmail,
    required this.subject,
    required this.preview,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.isStarred = false,
    this.folder = EmailFolder.inbox,
  });

  Email copyWith({
    String? id,
    String? senderName,
    String? senderEmail,
    String? recipientEmail,
    String? subject,
    String? preview,
    String? body,
    DateTime? timestamp,
    bool? isRead,
    bool? isStarred,
    EmailFolder? folder,
  }) {
    return Email(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      senderEmail: senderEmail ?? this.senderEmail,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      subject: subject ?? this.subject,
      preview: preview ?? this.preview,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      isStarred: isStarred ?? this.isStarred,
      folder: folder ?? this.folder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Email && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}