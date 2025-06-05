part of 'absence_list_bloc.dart';

abstract class AbsenceListState extends Equatable {
  const AbsenceListState();
  @override
  List<Object> get props => [];
}

class AbsenceListLoading extends AbsenceListState {}

class AbsenceListLoaded extends AbsenceListState {
  final List<(Absence, Member)> data;
  final bool hasMore;
  const AbsenceListLoaded(this.data, this.hasMore);
  @override
  List<Object> get props => [data, hasMore];
}

class AbsenceListError extends AbsenceListState {
  final String message;
  const AbsenceListError(this.message);
  @override
  List<Object> get props => [message];
}
