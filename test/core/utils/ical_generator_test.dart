import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_coding_challenge/core/utils/ical_generator.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

void main() {
  group('ICalGenerator', () {
    final absence = Absence(
      id: 1,
      userId: 101,
      type: AbsenceType.sickness,
      startDate: DateTime.utc(2024, 01, 01),
      endDate: DateTime.utc(2024, 01, 03),
      memberNote: 'Sick leave',
      admitterNote: 'Take rest',
      confirmedAt: DateTime.utc(2023, 12, 31),
      createdAt: DateTime.utc(2023, 12, 30),
      crewId: 99,
      rejectedAt: null,
      admitterId: null,
    );

    final member = Member(
      id: 501,
      userId: 101,
      name: 'Alice',
      image: '',
      crewId: 99,
    );

    /// ✅ Test Case: ICS content generation for single absence
    ///
    /// Verifies that `ICalGenerator.generate()` correctly generates a valid ICS
    /// string from a single (Absence, Member) pair. It checks that:
    /// - Calendar start and end markers exist
    /// - Each VEVENT section includes UID, SUMMARY, DTSTART, DTEND
    /// - DESCRIPTION includes both member and admitter notes
    /// - Date formatting is in UTC and end date includes one extra day
    test('generate() returns valid ICS content', () {
      final ics = ICalGenerator.generate([(absence, member)]);

      expect(ics, contains('BEGIN:VCALENDAR'));
      expect(ics, contains('VERSION:2.0'));
      expect(ics, contains('BEGIN:VEVENT'));
      expect(ics, contains('SUMMARY:Sickness - Alice'));
      expect(ics, contains('UID:1'));
      expect(ics, contains('DTSTART:20240101T000000'));
      expect(ics, contains('DTEND:20240104T000000')); // end + 1 day
      expect(ics, contains('DESCRIPTION:Member\'s Note - Sick leave'));
      expect(ics, contains('Admitter\'s Note - Take rest'));
      expect(ics, contains('END:VEVENT'));
      expect(ics, contains('END:VCALENDAR'));
    });

    /// ✅ Test Case: ICS content generation when notes are empty
    ///
    /// Verifies that `ICalGenerator.generate()` correctly omits the DESCRIPTION
    /// field if both `memberNote` and `admitterNote` are empty. This ensures
    /// no empty or unnecessary lines are included in the ICS file.
    test('generate() skips description if notes are empty', () {
      final absenceNoNotes = absence.copyWith(memberNote: '', admitterNote: '');
      final ics = ICalGenerator.generate([(absenceNoNotes, member)]);

      expect(ics, isNot(contains('DESCRIPTION')));
    });
  });
}
