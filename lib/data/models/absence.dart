import 'package:equatable/equatable.dart';
import 'package:frontend_coding_challenge/core/extensions/date_extension.dart';
import 'package:frontend_coding_challenge/data/enums/absence_status.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';
import 'package:intl/intl.dart';

class Absence extends Equatable {
  final int id;
  final int userId;
  final int crewId;
  final AbsenceType type;
  final String memberNote;
  final int? admitterId;
  final String admitterNote;
  final DateTime startDate;
  String get startDateFormatted => startDate.MMMdy;
  final DateTime endDate;
  String get endDateFormatted => endDate.MMMdy;
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

  /// Returns the status of the absence based on the confirmed and rejected dates.
  /// /// - If confirmedAt is not null, the status is 'confirmed'.
  /// - If rejectedAt is not null, the status is 'rejected'.
  /// - If neither is set, the status is 'pending'.
  AbsenceStatus get status {
    if (confirmedAt != null) {
      return AbsenceStatus.confirmed;
    } else if (rejectedAt != null) {
      return AbsenceStatus.rejected;
    } else {
      return AbsenceStatus.pending;
    }
  }

  @override
  List<Object?> get props => [id];

  /// Creates a copy of the Absence instance with optional new values.
  /// If a value is not provided, the original value is retained.
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

  /// Creates an Absence instance from a JSON map.
  static Absence fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'],
      userId: json['userId'],
      crewId: json['crewId'],
      type: AbsenceType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AbsenceType.other,
      ),
      memberNote: json['memberNote'],
      admitterId: json['admitterId'],
      admitterNote: json['admitterNote'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      confirmedAt:
          json['confirmedAt'] != null
              ? DateTime.tryParse(json['confirmedAt'])
              : null,
      rejectedAt:
          json['rejectedAt'] != null
              ? DateTime.tryParse(json['rejectedAt'])
              : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Converts the Absence instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'crewId': crewId,
      'type': type.name,
      'memberNote': memberNote,
      'admitterId': admitterId,
      'admitterNote': admitterNote,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'confirmedAt': confirmedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
