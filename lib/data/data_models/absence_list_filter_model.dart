import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/utils/nullable_value.dart';
import 'package:frontend_coding_challenge/data/enums/absence_sort_type.dart';
import 'package:frontend_coding_challenge/data/enums/absence_status.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';

class AbsenceListFilterModel {
  final AbsenceStatus? status;
  final AbsenceType? type;
  final DateTimeRange? dateRange;
  final AbsenceSortType sortType;

  bool get isEmpty => status == null && type == null && dateRange == null;

  const AbsenceListFilterModel({
    this.status,
    this.type,
    this.dateRange,
    this.sortType = AbsenceSortType.date,
  });

  /// Creates a copy of the current filter model with the option to override specific fields.
  AbsenceListFilterModel copyWith({
    NullableValue<AbsenceStatus>? status,
    NullableValue<AbsenceType>? type,
    NullableValue<DateTimeRange>? dateRange,
    AbsenceSortType? sortType,
  }) {
    return AbsenceListFilterModel(
      status: status == null ? this.status : status.value,
      type: type == null ? this.type : type.value,
      dateRange: dateRange == null ? this.dateRange : dateRange.value,
      sortType: sortType ?? this.sortType,
    );
  }
}
