import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/extensions/string_extension.dart';
import 'package:frontend_coding_challenge/core/utils/ical_generator.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

class AbsenceDetailDialog extends StatelessWidget {
  final GlobalKey addToCalendarKey = GlobalKey();

  final Absence absence;
  final Member member;

  AbsenceDetailDialog({super.key, required this.absence, required this.member});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4,
              left: 8,
              right: 8,
              bottom: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading:
                      member.image.isNotEmptyString
                          ? CachedNetworkImage(
                            imageUrl: member.image!,
                            imageBuilder: (_, image) {
                              return CircleAvatar(backgroundImage: image);
                            },
                            progressIndicatorBuilder: (_, _, dp) {
                              return CircularProgressIndicator(
                                value: dp.progress,
                              );
                            },
                            errorWidget: (_, _, _) {
                              return CircleAvatar(child: Icon(Icons.error));
                            },
                          )
                          : CircleAvatar(child: Icon(Icons.person)),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(member.name)),
                      Text(
                        absence.status.title,
                        style: TextStyle(
                          color: absence.status.color,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: 'Reason: '),
                            TextSpan(
                              text: absence.type.title,
                              style: TextStyle(color: absence.type.color),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${absence.startDateFormatted} - ${absence.endDateFormatted}',
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 4.0,
                    children: [
                      Text(
                        absence.memberNote.isNotEmpty
                            ? 'Member Note: ${absence.memberNote}'
                            : 'No additional notes from member.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      if (absence.admitterNote.isNotEmpty)
                        Text(
                          'Admitter Note: ${absence.admitterNote}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Divider(),
                TextButton(
                  key: addToCalendarKey,
                  onPressed: () async {
                    Rect? positionRect;

                    final renderBox =
                        addToCalendarKey.currentContext?.findRenderObject()
                            as RenderBox?;
                    if (renderBox != null) {
                      final size = renderBox.size;
                      final position = renderBox.localToGlobal(Offset.zero);
                      positionRect = Rect.fromLTWH(
                        position.dx,
                        position.dy,
                        size.width,
                        size.height,
                      );
                    }
                    await ICalGenerator.exportAndShare([
                      (absence, member),
                    ], position: positionRect);
                  },
                  child: Text("Export Calendar Event"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
