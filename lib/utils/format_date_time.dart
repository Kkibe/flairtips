import 'package:intl/intl.dart';

/// Step 1: Parse the UTC date string and return local DateTime.
DateTime parseUtcFixtureToLocal(String input) {
  input = input.trim().toUpperCase();

  // Detect if AM/PM is present
  final hasAmPm = input.contains('AM') || input.contains('PM');
  final DateFormat inputFormat =
      hasAmPm
          ? DateFormat("hh:mma, dd-MM-yyyy")
          : DateFormat("HH:mm, dd-MM-yyyy");

  // Parse as UTC
  final utcDateTime = inputFormat.parseUtc(input);

  // Convert to local time
  //return utcDateTime.toLocal();
  return utcDateTime;
}

/// Step 2: Format local DateTime as "Wed, 29 Apr 2025"
String formatMatchDate(String utcInput) {
  final localDateTime = parseUtcFixtureToLocal(utcInput);
  return DateFormat('E, d MMM y').format(localDateTime);
}

/// Step 3: Format local DateTime as "21:00"
String formatTime(String utcInput) {
  final localDateTime = parseUtcFixtureToLocal(utcInput);
  return DateFormat('HH:mm').format(localDateTime);
}
