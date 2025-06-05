import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import '../../../data/repository/absence_repository.dart';

part 'absence_list_event.dart';
part 'absence_list_state.dart';

class AbsenceListBloc extends Bloc<AbsenceListEvent, AbsenceListState> {
  final AbsenceRepository repository;

  AbsenceListBloc(this.repository) : super(AbsenceListLoading()) {
    on<LoadAbsences>(_onLoadAbsences);
  }

  Future<void> _onLoadAbsences(
    LoadAbsences event,
    Emitter<AbsenceListState> emit,
  ) async {
    if (event.currentData.isEmpty) {
      emit(AbsenceListLoading());
    }

    try {
      final result = await repository.getAbsenceDetails(
        filter: event.filter,
        skip: event.currentData.length,
        limit: event.pageSize,
      );

      final absences = [...event.currentData, ...result.$1];
      final totalCount = result.$2;

      emit(
        AbsenceListLoaded(
          absences,
          filter: event.filter,
          totalCount: totalCount,
        ),
      );
    } catch (e) {
      emit(AbsenceListError(e.toString()));
    }
  }
}
