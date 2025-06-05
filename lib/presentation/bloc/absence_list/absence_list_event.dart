part of 'absence_list_bloc.dart';

abstract class AbsenceListEvent extends Equatable {
  const AbsenceListEvent();
  @override
  List<Object> get props => [];
}

class LoadAbsences extends AbsenceListEvent {}

class LoadNextPage extends AbsenceListEvent {}
