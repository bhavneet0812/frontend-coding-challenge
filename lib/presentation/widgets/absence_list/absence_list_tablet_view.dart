import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:frontend_coding_challenge/presentation/widgets/absence_card.dart';

class AbsenceListTabletView extends StatelessWidget {
  const AbsenceListTabletView({
    super.key,
    required this.absences,
    required this.onRefresh,
  });

  final List<(Absence, Member)> absences;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final double viewInsetsBottom = MediaQuery.of(context).viewPadding.bottom;
    return RefreshIndicator.adaptive(
      onRefresh: onRefresh,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 160,
          maxCrossAxisExtent: 700,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: absences.length,
        padding: EdgeInsets.only(bottom: viewInsetsBottom),
        itemBuilder: (context, index) {
          return AbsenceCard(
            absence: absences[index].$1,
            member: absences[index].$2,
          );
        },
      ),
    );
  }
}
