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

    /// Tests for ICalGenerator.generate()
    /// This method generates an ICS string for a list of (Absence, Member) tuples.
    /// It formats the absence details into a valid ICS format.
    /// The ICS format includes:
    /// - BEGIN:VCALENDAR
    /// - VERSION:2.0
    /// - BEGIN:VEVENT
    /// - SUMMARY:Absence Type - Member Name
    /// - UID:Absence ID
    /// - DTSTART:Start Date in UTC format
    /// - DTEND:End Date in UTC format (next day)
    /// - DESCRIPTION:Member's Note - Admitter's Note
    /// - END:VEVENT
    /// - END:VCALENDAR
    ///
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

    /// Tests for ICalGenerator.generate() with multiple absences
    /// This method generates ICS content for multiple (Absence, Member) tuples.
    /// It ensures that each absence is correctly formatted in the ICS output.
    test('generate() skips description if notes are empty', () {
      final absenceNoNotes = absence.copyWith(memberNote: '', admitterNote: '');
      final ics = ICalGenerator.generate([(absenceNoNotes, member)]);

      expect(ics, isNot(contains('DESCRIPTION')));
    });
  });
}
