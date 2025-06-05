import 'package:flutter/services.dart';

enum AbsenceStatus {
  pending('Pending', Color(0xFFFF9800)),
  confirmed('Confirmed', Color(0xFF4CAF50)),
  rejected('Rejected', Color(0xFFF44336));

  final String title;
  final Color color;

  const AbsenceStatus(this.title, this.color);
}
