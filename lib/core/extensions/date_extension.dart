import 'package:intl/intl.dart';

extension DateExtension on DateTime? {
  String get MMMdy {
    if (this == null) return '';
    final date = this!;
    final formatter = DateFormat('MMM d, y');
    return formatter.format(date);
  }

  String get dMMMy {
    if (this == null) return '';
    final date = this!;
    final formatter = DateFormat('d MMM, y');
    return formatter.format(date);
  }
}
