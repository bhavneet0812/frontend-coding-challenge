import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateExtension on DateTime? {
  /// Checks if the date is between the start and end of the given range.
  /// Returns false if the date is null.
  bool isBetween(DateTimeRange range) {
    if (this == null) return false;
    final date = this!;
    return date.isAfter(range.start) && date.isBefore(range.end);
  }

  /// Formats the date to a string in the format 'MMM d, y'.
  /// Returns an empty string if the date is null.
  String get MMMdy {
    if (this == null) return '';
    final date = this!;
    final formatter = DateFormat('MMM d, y');
    return formatter.format(date);
  }

  /// Formats the date to a string in the format 'd MMM, y'.
  /// Returns an empty string if the date is null.
  String get dMMMy {
    if (this == null) return '';
    final date = this!;
    final formatter = DateFormat('d MMM, y');
    return formatter.format(date);
  }
}
