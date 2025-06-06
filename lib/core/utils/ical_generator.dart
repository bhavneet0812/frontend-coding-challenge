import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:frontend_coding_challenge/core/extensions/date_extension.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ICalGenerator {
  static final _dateFormatter = DateFormat('yyyyMMddTHHmmssZ');
  static String _formatDate(DateTime date) =>
      _dateFormatter.format(date.toUtc());

  /// Generates an ICS file content for the given absence and member.
  /// The ICS format is used for calendar events.
  /// [absence] is the Absence object containing details of the absence.
  /// [member] is the Member object containing details of the member.
  static String generate(List<(Absence absence, Member member)> absences) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//Absence Calendar//EN');

    for (final (absence, member) in absences) {
      buffer.writeln('BEGIN:VEVENT');
      buffer.writeln('UID:${absence.id}');
      buffer.writeln('DTSTAMP:${_formatDate(absence.createdAt)}');
      buffer.writeln('DTSTART:${_formatDate(absence.startDate)}');
      buffer.writeln(
        'DTEND:${_formatDate(absence.endDate.add(Duration(days: 1)))}',
      );
      buffer.writeln('SUMMARY:${absence.type.title} - ${member.name}');
      if (absence.memberNote.isNotEmpty && absence.admitterNote.isNotEmpty) {
        buffer.writeln(
          'DESCRIPTION:Member\'s Note - ${absence.memberNote}\nAdmitter\'s Note - ${absence.admitterNote}',
        );
      }
      buffer.writeln('END:VEVENT');
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  /// Generates an ICS file content for the given absence and member,
  /// saves it to a temporary file,
  /// and shares it using the SharePlus package.
  /// This method is asynchronous and returns a Future.
  /// [absences] is a list of tuples containing Absence and Member objects.
  /// If the list is empty, the method does nothing.
  /// [position] is an optional parameter that specifies the position
  static Future<ShareResult> exportAndShare(
    List<(Absence absence, Member member)> absences, {
    Rect? position,
  }) async {
    if (absences.isEmpty) return ShareResult.unavailable;

    String title = 'Absences Calendar';

    if (absences.length == 1) {
      // If there is only one absence, use its details to create the title.
      final (absence, member) = absences.first;
      title = 'Absence - ${member.name} - ${absence.type.title}';
    } else if (absences.length > 1) {
      // If there are multiple absences, determine the start and end dates
      // to create a meaningful title.
      final startDateElement = absences.reduce((v, e) {
        final isBefore = v.$1.startDate.isBefore(e.$1.startDate);
        return isBefore ? v : e;
      });
      final endDateElement = absences.reduce((v, e) {
        final isAfter = v.$1.endDate.isAfter(e.$1.endDate);
        return isAfter ? v : e;
      });
      title =
          'Absences '
          'Calendar '
          '${startDateElement.$1.startDate.dMMMy} - '
          '${endDateElement.$1.endDate.dMMMy}';
    }

    final icsContent = generate(absences);

    if (kIsWeb) {
      final xFile = XFile.fromData(
        Uint8List.fromList(icsContent.codeUnits),
        name: '$title.ics',
      );

      return SharePlus.instance.share(
        ShareParams(
          title: title,
          files: [xFile],
          sharePositionOrigin: position,
        ),
      );
    } else {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$title.ics')
        ..create(recursive: true);
      await file.writeAsString(icsContent);

      return SharePlus.instance.share(
        ShareParams(
          title: title,
          files: [
            XFile(file.path, name: '$title.ics', mimeType: 'text/calendar'),
          ],
          sharePositionOrigin: position,
        ),
      );
    }
  }
}
