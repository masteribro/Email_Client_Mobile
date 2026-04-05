import 'package:intl/intl.dart';

class DateFormatter {
  static String formatEmailTimestamp(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final emailDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (emailDate == today) {
      return DateFormat.jm().format(dateTime);

    } else if (emailDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat.E().format(dateTime);
    } else if (dateTime.year == now.year) {
      return DateFormat('MMM d').format(dateTime);
    } else {
      return DateFormat('MM/dd/yy').format(dateTime);
    }
  }

  static String formatDetailDate(DateTime dateTime) {
    final now = DateTime.now();
    if (dateTime.year == now.year) {

      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
    return DateFormat('MMM d, yyyy, h:mm a').format(dateTime);
  }
}