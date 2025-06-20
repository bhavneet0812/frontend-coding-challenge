import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontend_coding_challenge/core/extensions/date_extension.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/enums/absence_sort_type.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

class ApiService {
  const ApiService._privateConstructor();

  static const ApiService instance = ApiService._privateConstructor();

  /// Get absences from the local JSON file.
  /// Uses [compute] to parse the JSON data in a separate isolate for better performance.
  /// Returns a list of [Absence] objects.
  /// Throws an exception if the JSON file cannot be loaded or parsed.
  Future<(List<Absence> absences, int totalCount)> getAbsences({
    AbsenceListFilterModel? filter,
    int skip = 0,
    int? limit = 10,
  }) async {
    try {
      final data = await rootBundle.loadString(
        'assets/json_files/absences.json',
      );
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

            return !startDate.isBetween(filter.dateRange!) &&
                !endDate.isBetween(filter.dateRange!);
          });
        }

        /// Sort absences based on the provided filter.
        absences.sort((a, b) {
          // Sort by date if sort type is date
          final dateSort = b.startDate.compareTo(a.startDate);

          // Sort by type if sort type is type
          if (filter.sortType == AbsenceSortType.type) {
            final typeSort = a.type.index.compareTo(b.type.index);
            return typeSort != 0 ? typeSort : dateSort;
          }
          // Sort by status if sort type is status
          else if (filter.sortType == AbsenceSortType.status) {
            final statusSort = a.status.index.compareTo(b.status.index);
            return statusSort != 0 ? statusSort : dateSort;
          }
          return 0; // Default case
        });
      }
      final skippedAbsences = absences.skip(skip);
      final limitedAbsences =
          limit != null ? skippedAbsences.take(limit) : skippedAbsences;

      return (limitedAbsences.toList(), absences.length);
    } catch (e) {
      throw Exception('Failed to load absences: $e');
    }
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
