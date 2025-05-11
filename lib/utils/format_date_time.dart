import 'package:intl/intl.dart';

String formatMatchDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime matchDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  if (matchDate == today) {
    return 'Today';
  } else {
    return DateFormat(
      'E, d MMM y',
    ).format(dateTime); // Example: Wed, 19 Jun 2025
  }
}

String formatFullDateTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  return DateFormat('EEEE, d MMMM y \'at\' HH:mm').format(dateTime);
  // Example: Sunday, 3 February 2025 at 21:00
}

String formatTime(String dateString) {
  DateTime dateTime = DateTime.parse(dateString).toLocal();
  return DateFormat('HH:mm').format(dateTime); // Example: 21:00
}

DateTime parseFixtureToUtc(String input) {
  // 1) Trim any whitespace
  input = input.trim();

  // 2) Detect an AM/PM suffix
  final ampmMatch = RegExp(
    r'\b(AM|PM)\b',
    caseSensitive: false,
  ).firstMatch(input);

  DateTime localDt;
  if (ampmMatch != null) {
    // 12-hour format, e.g. "04:00PM, 09-05-2025" or "4:00 am, 09-05-2025"
    // Make sure the format matches exactly: hour:minute + AM/PM, then comma + date
    final formatter = DateFormat("hh:mma, dd-MM-yyyy");
    localDt = formatter.parse(input.toUpperCase());
  } else {
    // 24-hour format, e.g. "16:00, 09-05-2025"
    final formatter = DateFormat("HH:mm, dd-MM-yyyy");
    localDt = formatter.parse(input);
  }

  // 3) Convert to UTC
  return localDt.toUtc();
}
