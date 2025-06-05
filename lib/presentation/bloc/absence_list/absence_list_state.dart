part of 'absence_list_bloc.dart';

abstract class AbsenceListState extends Equatable {
  const AbsenceListState();
  @override
  List<Object> get props => [];
}

class AbsenceListLoading extends AbsenceListState {}

class AbsenceListLoaded extends AbsenceListState {
  final AbsenceListFilterModel filter;
  final List<(Absence, Member)> data;
  final int totalCount;

  bool get hasMore => data.length < totalCount;

  const AbsenceListLoaded(
    this.data, {
    required this.filter,
    required this.totalCount,
  });
  @override
  List<Object> get props => [data, filter, totalCount];
}

class AbsenceListError extends AbsenceListState {
  final String message;
  const AbsenceListError(this.message);
  @override
  List<Object> get props => [message];
}
