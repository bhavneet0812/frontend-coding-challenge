import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/utils/nullable_value.dart';
import 'package:frontend_coding_challenge/data/enums/absence_status.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';

class AbsenceListFilterModel {
  final AbsenceStatus? status;
  final AbsenceType? type;
  final DateTimeRange? dateRange;

  bool get isEmpty => status == null && type == null && dateRange == null;

  const AbsenceListFilterModel({this.status, this.type, this.dateRange});

  AbsenceListFilterModel copyWith({
    NullableValue<AbsenceStatus>? status,
    NullableValue<AbsenceType>? type,
    NullableValue<DateTimeRange>? dateRange,
  }) {
    return AbsenceListFilterModel(
      status: status == null ? this.status : status.value,
      type: type == null ? this.type : type.value,
      dateRange: dateRange == null ? this.dateRange : dateRange.value,
    );
  }
}
