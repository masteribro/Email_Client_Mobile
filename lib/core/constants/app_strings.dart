class AppStrings {
  AppStrings._();

  static const String appName = 'MailBox';
  static const String appVersion = 'MailBox v1.0.0';

  static const String welcome = 'Welcome to MailBox';
  static const String signInToContinue = 'Sign in to continue';
  static const String emailAddress = 'Email address';
  static const String password = 'Password';
  static const String signIn = 'Sign In';
  static const String signOut = 'Sign out';
  static const String demoCredentials = 'Demo credentials';
  static const String enterEmail = 'Enter your email';
  static const String enterValidEmail = 'Enter a valid email';
  static const String enterPassword = 'Enter your password';
  static const String close = 'Close';
  static const String cancel = 'Cancel';
  static const String unknown = 'Unknown';

  static const String inbox = 'Inbox';
  static const String starred = 'Starred';
  static const String sent = 'Sent';
  static const String drafts = 'Drafts';
  static const String trash = 'Trash';

  static const String compose = 'Compose';
  static const String movedToTrash = 'Moved to Trash';
  static const String undo = 'Undo';
  static const String retry = 'Retry';
  static const String noEmailsHere = 'No emails here';

  static const String emptyInbox =
      'Your inbox is empty.\nNew emails will appear here.';
  static const String emptyStarred =
      'Star important emails\nand they\'ll show up here.';
  static const String emptySent = 'Emails you send\nwill appear here.';
  static const String emptyDrafts =
      'Unfinished emails\nwill be saved here.';
  static const String emptyTrash = 'Deleted emails\nwill appear here.';

  static const String newMessage = 'New message';
  static const String from = 'From';
  static const String to = 'To';
  static const String subject = 'Subject';
  static const String composeHint = 'Compose email';
  static const String recipients = 'Recipients';
  static const String send = 'Send';
  static const String discardDraft = 'Discard draft?';
  static const String discardMessage = 'This message will not be saved.';
  static const String discard = 'Discard';
  static const String messageSent = 'Message sent';
  static const String attachFile = 'Attach file';
  static const String insertLink = 'Insert link';
  static const String insert = 'Insert';
  static const String urlLabel = 'URL';
  static const String displayTextLabel = 'Display text (optional)';
  static const String invalidRecipient =
      'Please enter a valid recipient email';
  static const String sendFailed =
      'Failed to send message. Please try again.';

  static const String emailNotFound = 'Email not found';
  static const String starTooltip = 'Star';
  static const String unstarTooltip = 'Unstar';
  static const String markAsUnread = 'Mark as unread';
  static const String markAsRead = 'Mark as read';
  static const String moveToTrash = 'Move to trash';

  static const String settings = 'Settings';
  static const String searchInMail = 'Search in mail';
  static const String notifications = 'Email notifications';
  static const String notificationsSubtitle = 'Get notified about new emails';
  static const String autoMarkRead = 'Auto-mark as read';
  static const String autoMarkReadSubtitle = 'Mark emails as read when opened';
  static const String about = 'About';
  static const String version = 'Version';
  static const String manageAccount = 'Manage your account';
  static const String addAccount = 'Add another account';
  static const String signOutAll = 'Sign out of all accounts';
  static const String account = 'Account';
  static const String general = 'General';
  static const String noSearchResults = 'No results found';
  static const String searchHint = 'Search emails...';

  static String replySubject(String s) => 'Re: $s';
  static String forwardSubject(String s) => 'Fwd: $s';
  static String toRecipient(String email) => 'To: $email';
}