import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:frontend_coding_challenge/data/services/api_service.dart';

class AbsenceRepository {
  const AbsenceRepository();

  ApiService get apiService => ApiService.instance;

  /// Fetches absence list and member details.
  /// Returns a list of tuples containing [Absence] and corresponding [Member].
  /// If a member is not found for an absence, the member will be null.
  Future<(List<(Absence, Member)> results, int totalCount)> getAbsenceDetails({
    AbsenceListFilterModel? filter,
    int skip = 0,
    int limit = 10,
  }) async {
    final absenceListData = await apiService.getAbsences(
      filter: filter,
      skip: skip,
      limit: limit,
    );

    final members = await apiService.getMembers();

    final absences = absenceListData.$1;
    final totalCount = absenceListData.$2;

    final result = absences.map((absence) {
      final memberIndex = members.indexWhere((m) => m.userId == absence.userId);
      final member = memberIndex != -1 ? members[memberIndex] : null;
      return member != null ? (absence, member) : null;
    });

    return (result.whereType<(Absence, Member)>().toList(), totalCount);
  }
}
