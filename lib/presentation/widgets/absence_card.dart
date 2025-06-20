import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/extensions/string_extension.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:frontend_coding_challenge/presentation/dialogs/absence_detail_dialog.dart';

class AbsenceCard extends StatelessWidget {
  final Absence absence;
  final Member member;

  const AbsenceCard({super.key, required this.absence, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AbsenceDetailDialog(absence: absence, member: member);
            },
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          return CircularProgressIndicator(value: dp.progress);
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
                    style: TextStyle(color: absence.status.color, fontSize: 14),
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
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 12.0),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (absence.admitterNote.isNotEmpty)
                    Text(
                      'Admitter Note: ${absence.admitterNote}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
