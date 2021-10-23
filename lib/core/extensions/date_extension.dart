extension DateExtension on DateTime {
  int getDiffInSeconds({DateTime? date}) {
    DateTime? dateFrom = date;
    dateFrom ??= DateTime.now();
    return difference(dateFrom).inSeconds;
  }

  /// Returns the [Duration] from 01.01.1970 (epoch/unix time) until this.
  ///
  /// Example:
  /// ```dart
  /// DateTime.now().duration(); // Duration from 01.01.1970 until now
  /// ```
  Duration get duration => Duration(milliseconds: millisecondsSinceEpoch);
}
