import 'package:intl/intl.dart';

class DateFormatter {
  static final _timeFormat = DateFormat('h:mm a');
  static final _dateFormat = DateFormat('MMM d');
  static final _fullDateFormat = DateFormat('MMM d, y • h:mm a');

  static String formatMessageTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }

  static String formatConversationTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0 && now.day == dateTime.day) {
      return _timeFormat.format(dateTime);
    } else if (difference.inDays < 7) {
      return DateFormat('EEE').format(dateTime);
    } else {
      return _dateFormat.format(dateTime);
    }
  }

  static String formatFullDate(DateTime dateTime) {
    return _fullDateFormat.format(dateTime);
  }
}
