import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

extension StringExtension on String {
  // bool isUrlValid() {
  //   final regex = RegexUtils.URL_VALID;
  //   return regex.hasMatch(this);
  // }

  /// Format the date to a named format
  ///  E.g `"20-03-2020T02:00:00Z".toDate('dd-MMMM-yyyy')` => `"20-Mar-2020"`
  String toDate([String format = "yyyy-MM-dd"]) {
    return DateFormat(format).format(DateTime.parse(this));
  }

  /// Capitalize each word inside string
  /// Example: `your name` => `Your Name`
  String get capitalize {
    return split(' ').map((e) => e.capitalizeFirst).join(' ');
  }

  String toBytes() {
    final number = int.tryParse(this) ?? 0;
    if (number >= 1048576) return "${(number / 1048576).ceil()} MB";
    if (number >= 1024) return "${(number / 1024).ceil()} KB";
    if (number > 1) return "$number bytes";
    if (number == 1) return "$number byte";
    return "0 bytes";
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: `your name` => `Your name`
  String get capitalizeFirst {
    if (isEmpty) return "";
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }

  String? toMimeType() => lookupMimeType(this);

  String toTimeAgo() {
    DateTime date = DateTime.parse(this).toLocal();
    final now = DateTime.now().toLocal();
    final difference = now.difference(date);
    int inSeconds = difference.inSeconds;
    int inMinutes = difference.inMinutes;
    int inHours = difference.inHours;
    if (inSeconds < 5) return 'now';
    if (inMinutes <= 60) return '${inMinutes}m ago';
    if (inHours <= 24) return '${inHours}h ago';
    return toDate('MMM dd');
  }

  String toDaysLeft() {
    int daysLeft = DateTime.parse(this).difference(DateTime.now()).inDays;
    if (daysLeft == 0) return 'Today';
    if (daysLeft == 1) return 'Tomorrow';
    return '$daysLeft Days Left';
  }

  String dutytime() {
    var hour = DateTime.parse(this).hour;
    if (hour < 4) return 'Midnight';
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 19) return 'Evening';
    return 'Night';
  }

  String? decodeJWTAndGetUserId() {
    final splitToken = split(".");
    if (splitToken.length != 3) return null;
    try {
      final payloadBase64 = splitToken[1];
      final normalizedPayload = base64.normalize(payloadBase64);
      final payload = utf8.decode(base64.decode(normalizedPayload));
      return Map.from(json.decode(payload))['sub'];
    } catch (error) {
      return null;
    }
  }

  String toTitleCase() {
    return split('_').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}
