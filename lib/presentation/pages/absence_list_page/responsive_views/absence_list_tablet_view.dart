part of '../absence_list_page.dart';

class _TabletView extends StatelessWidget {
  const _TabletView({required this.state});

  final AbsenceListLoaded state;

  @override
  Widget build(BuildContext context) {
    final double viewInsetsBottom = MediaQuery.of(context).viewPadding.bottom;
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<AbsenceListBloc>().add(LoadAbsences(filter: state.filter));
      },
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          mainAxisExtent: 160,
          maxCrossAxisExtent: 700,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
        ),
        itemCount: state.data.length,
        padding: EdgeInsets.only(bottom: viewInsetsBottom),
        itemBuilder: (context, index) {
          return AbsenceCard(
            absence: state.data[index].$1,
            member: state.data[index].$2,
          );
        },
      ),
    );
  }
}
