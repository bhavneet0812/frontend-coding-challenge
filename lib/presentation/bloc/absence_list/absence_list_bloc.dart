import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import '../../../data/repository/absence_repository.dart';

part 'absence_list_event.dart';
part 'absence_list_state.dart';

class AbsenceListBloc extends Bloc<AbsenceListEvent, AbsenceListState> {
  final AbsenceRepository repository;
  final int _pageSize = 10;

  List<(Absence, Member)> _allData = [];
  int _currentPage = 1;

  AbsenceListBloc(this.repository) : super(AbsenceListLoading()) {
    on<LoadAbsences>(_onLoadAbsences);
    on<LoadNextAbsencesPage>(_onLoadNextPage);
  }

  Future<void> _onLoadAbsences(
    LoadAbsences event,
    Emitter<AbsenceListState> emit,
  ) async {
    emit(AbsenceListLoading());
    try {
      _currentPage = 1;
      _allData = await repository.getAbsenceDetails();
      final paginated = _allData.take(_pageSize).toList();
      emit(AbsenceListLoaded(paginated, _allData.length > _pageSize));
    } catch (e) {
      emit(AbsenceListError(e.toString()));
    }
  }

  Future<void> _onLoadNextPage(
    LoadNextAbsencesPage event,
    Emitter<AbsenceListState> emit,
  ) async {
    if (state is AbsenceListLoaded) {
      _currentPage++;
      final nextData = _allData.take(_currentPage * _pageSize).toList();
      emit(AbsenceListLoaded(nextData, nextData.length < _allData.length));
    }
  }
}
