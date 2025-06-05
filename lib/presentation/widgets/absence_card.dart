import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/extensions/string_extension.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

class AbsenceCard extends StatelessWidget {
  final Absence absence;
  final Member member;

  const AbsenceCard({super.key, required this.absence, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
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
              'Duration: ${absence.startDateFormatted} - ${absence.endDateFormatted}',
            ),
            if (absence.memberNote.isNotEmpty)
              Text('Note: ${absence.memberNote}'),
            if (absence.admitterNote.isNotEmpty)
              Text('Admitter: ${absence.admitterNote}'),
          ],
        ),
      ),
    );
  }
}
