import 'package:flutter/services.dart';

enum AbsenceType {
  sickness('Sickness', Color(0xFFFF9800)),
  vacation('Vacation', Color(0xFF2196F3)),
  other('Other', null);

  final String title;
  final Color? color;

  const AbsenceType(this.title, this.color);
}
