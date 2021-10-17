extension DurationExtension on int {
  Duration get seconds => Duration(seconds: this);

  Duration get milliseconds => Duration(milliseconds: this);
}
