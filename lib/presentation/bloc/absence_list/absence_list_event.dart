part of 'absence_list_bloc.dart';

abstract class AbsenceListEvent extends Equatable {
  const AbsenceListEvent();
  @override
  List<Object> get props => [];
}

class LoadAbsences extends AbsenceListEvent {
  final List<(Absence, Member)> currentData;

  final AbsenceListFilterModel filter;
  final int pageSize;

  const LoadAbsences({
    this.currentData = const [],
    this.filter = const AbsenceListFilterModel(),
    this.pageSize = 10,
  });

  @override
  List<Object> get props => [filter, pageSize, currentData.length];
}

class ShareAbsencesCalendarEvents extends AbsenceListEvent {
  final Rect position;
  final AbsenceListFilterModel filter;

  const ShareAbsencesCalendarEvents({
    required this.position,
    this.filter = const AbsenceListFilterModel(),
  });

  @override
  List<Object> get props => [filter];
}
