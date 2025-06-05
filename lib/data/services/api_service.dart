import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  /// Get absences from the local JSON file.
  /// Uses [compute] to parse the JSON data in a separate isolate for better performance.
  /// Returns a list of [Absence] objects.
  /// Throws an exception if the JSON file cannot be loaded or parsed.
  Future<(List<Absence> absences, int totalCount)> getAbsences({
    AbsenceListFilterModel? filter,
    int skip = 0,
    int limit = 10,
  }) async {
    final data = await rootBundle.loadString('assets/json_files/absences.json');
    final jsonResult = await compute(
      (message) => json.decode(data),
      'parseAbsencesJson',
    );
    final jsonList = jsonResult['payload'] as List;
    final absences = jsonList.map((e) => Absence.fromJson(e)).toList();
    // Apply filter if provided
    if (filter != null) {
      // Filter by absence status
      if (filter.status != null) {
        absences.removeWhere((absence) => absence.status != filter.status);
      }

      // Filter by absence type
      if (filter.type != null) {
        absences.removeWhere((absence) => absence.type != filter.type);
      }

      // Filter by date range
      if (filter.dateRange != null) {
        absences.removeWhere((absence) {
          final startDate = absence.startDate;
          final endDate = absence.endDate;
          final filterStartDate = filter.dateRange!.start;
          final filterEndDate = filter.dateRange!.end;

          return !(startDate.isAfter(filterEndDate) ||
              endDate.isBefore(filterStartDate));
        });
      }
    }

    return (absences.skip(skip).take(limit).toList(), absences.length);
  }

  /// Get members from the local JSON file.
  /// Uses [compute] to parse the JSON data in a separate isolate for better performance.
  /// Returns a list of [Member] objects.
  /// Throws an exception if the JSON file cannot be loaded or parsed.
  Future<List<Member>> getMembers() async {
    final data = await rootBundle.loadString('assets/json_files/members.json');
    final jsonResult = await compute(
      (message) => json.decode(data),
      'parseMembersJson',
    );
    return (jsonResult['payload'] as List)
        .map((e) => Member.fromJson(e))
        .toList();
  }
}
