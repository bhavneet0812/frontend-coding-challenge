extension StringExtension on String? {
  /// Returns true if the object is a String and not empty.
  bool get isNotEmptyString => this is String && (this as String).isNotEmpty;

  /// Returns true if the object is a String and empty.
  bool get isEmptyString => this is String && (this as String).isEmpty;
}
