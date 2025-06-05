import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

class ApiService {
  ApiService._privateConstructor();

  static final ApiService instance = ApiService._privateConstructor();

  /// Get absences from the local JSON file.
  /// Uses [compute] to parse the JSON data in a separate isolate for better performance.
  /// Returns a list of [Absence] objects.
  /// Throws an exception if the JSON file cannot be loaded or parsed.
  Future<List<Absence>> getAbsences() async {
    final data = await rootBundle.loadString('assets/json_files/absences.json');
    final jsonResult = await compute(json.decode(data), 'parseAbsencesJson');
    return (jsonResult['payload'] as List)
        .map((e) => Absence.fromJson(e))
        .toList();
  }

  /// Get members from the local JSON file.
  /// Uses [compute] to parse the JSON data in a separate isolate for better performance.
  /// Returns a list of [Member] objects.
  /// Throws an exception if the JSON file cannot be loaded or parsed.
  Future<List<Member>> getMembers() async {
    final data = await rootBundle.loadString('assets/json_files/members.json');
    final jsonResult = await compute(json.decode(data), 'parseMembersJson');
    return (jsonResult['payload'] as List)
        .map((e) => Member.fromJson(e))
        .toList();
  }
}
