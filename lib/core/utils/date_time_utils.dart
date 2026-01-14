import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

const String dateTimeFormatPattern = 'dd/MM/yyyy';

extension DateTimeExtension on DateTime {
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }
    return DateFormat(pattern, locale).format(this);
  }

  String formatCurrentDate() {
    DateTime now = DateTime.now();

// Define date format
    DateFormat dateFormat = DateFormat('EEEE, d MMMM yyyy');

// Format date
    String formattedDate = dateFormat.format(now);
    return formattedDate;
  }

  static String getTimeAgo(String dateTimeStr) {
    // final year = int.parse(timestamp.substring(0, 4));
    // final month = int.parse(timestamp.substring(5, 7));
    // final day = int.parse(timestamp.substring(8, 10));
    // final hour = int.parse(timestamp.substring(11, 13));
    // final minute = int.parse(timestamp.substring(14, 16));

    final DateTime videoDate = DateTime.parse(dateTimeStr).toLocal();
    final int diffInHours = DateTime.now().difference(videoDate).inHours;

    String timeAgo = '';
    String timeUnit = '';
    int timeValue = 0;

    if (diffInHours < 1) {
      final diffInMinutes = DateTime.now().difference(videoDate).inMinutes;
      timeValue = diffInMinutes;
      timeUnit = 'minute';
    } else if (diffInHours < 24) {
      timeValue = diffInHours;
      timeUnit = 'hour';
    } else if (diffInHours >= 24 && diffInHours < 24 * 7) {
      timeValue = (diffInHours / 24).floor();
      timeUnit = 'day';
    } else if (diffInHours >= 24 * 7 && diffInHours < 24 * 30) {
      timeValue = (diffInHours / (24 * 7)).floor();
      timeUnit = 'week';
    } else if (diffInHours >= 24 * 30 && diffInHours < 24 * 12 * 30) {
      timeValue = (diffInHours / (24 * 30)).floor();
      timeUnit = 'month';
    } else {
      timeValue = (diffInHours / (24 * 365)).floor();
      timeUnit = 'year';
    }

    timeAgo = timeValue.toString() + ' ' + timeUnit;
    timeAgo += timeValue > 1 ? 's' : '';

    return timeAgo + ' ago';
  }
}

String formatDuration(double totalSeconds) {
  final totalSecondsInt =
      totalSeconds.floor(); // Get the integer part of seconds
  final fractionalSeconds =
      totalSeconds - totalSecondsInt; // Get the fractional part

  final hours = totalSecondsInt ~/ 3600; // Get total hours
  final minutes = (totalSecondsInt % 3600) ~/ 60; // Get remaining minutes
  final seconds = totalSecondsInt % 60; // Get remaining seconds

  final formattedSeconds = fractionalSeconds > 0
      ? '${(seconds + fractionalSeconds).toStringAsFixed(1)}s' // Include fraction if present
      : '${seconds}s'; // No fraction

  if (hours > 0) {
    return '${hours}h ${minutes}m $formattedSeconds';
  } else if (minutes > 0) {
    return '${minutes}m $formattedSeconds';
  } else {
    return formattedSeconds;
  }
}

String formatDateinDdMmYy(String isoDateString) {
  DateTime parsedDate = DateTime.parse(isoDateString);

  DateFormat format = DateFormat('dd/MM/yy');
  return format.format(parsedDate);
}

String formatTimeinAmPm(String isoDateString) {
  DateTime parsedDate = DateTime.parse(isoDateString);
  DateFormat format = DateFormat('hh:mm a');
  return format.format(parsedDate);
}
