import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:frontend_coding_challenge/data/services/api_service.dart';

class AbsenceRepository {
  const AbsenceRepository();

  ApiService get apiService => ApiService.instance;

  /// Fetches absence list and member details.
  /// Returns a list of tuples containing [Absence] and corresponding [Member].
  /// If a member is not found for an absence, the member will be null.
  Future<List<(Absence, Member)>> getAbsenceDetails() async {
    final absences = await apiService.getAbsences();
    final members = await apiService.getMembers();

    return absences
        .map((absence) {
          final memberIndex = members.indexWhere(
            (m) => m.userId == absence.userId,
          );
          final member = memberIndex != -1 ? members[memberIndex] : null;
          return member != null ? (absence, member) : null;
        })
        .whereType<(Absence, Member)>()
        .toList();
  }
}
