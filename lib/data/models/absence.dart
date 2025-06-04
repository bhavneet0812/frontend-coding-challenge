import 'package:equatable/equatable.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';

class Absence extends Equatable {
  final int id;
  final int userId;
  final int crewId;
  final AbsenceType type;
  final String memberNote;
  final int? admitterId;
  final String admitterNote;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime? confirmedAt;
  final DateTime? rejectedAt;
  final DateTime createdAt;

  const Absence({
    required this.id,
    required this.userId,
    required this.crewId,
    required this.type,
    required this.memberNote,
    this.admitterId,
    required this.admitterNote,
    required this.startDate,
    required this.endDate,
    this.confirmedAt,
    this.rejectedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id];

  Absence copyWith({
    int? id,
    int? userId,
    int? crewId,
    AbsenceType? type,
    String? memberNote,
    int? admitterId,
    String? admitterNote,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? confirmedAt,
    DateTime? rejectedAt,
    DateTime? createdAt,
  }) => Absence(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    crewId: crewId ?? this.crewId,
    memberNote: memberNote ?? this.memberNote,
    admitterId: admitterId ?? this.admitterId,
    admitterNote: admitterNote ?? this.admitterNote,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    confirmedAt: confirmedAt ?? this.confirmedAt,
    rejectedAt: rejectedAt ?? this.rejectedAt,
    createdAt: createdAt ?? this.createdAt,
    type: type ?? this.type,
  );
}
