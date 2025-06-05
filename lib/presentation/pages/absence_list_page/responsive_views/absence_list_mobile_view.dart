part of '../absence_list_page.dart';

class _MobileView extends StatelessWidget {
  const _MobileView({required this.state});

  final AbsenceListLoaded state;

  @override
  Widget build(BuildContext context) {
    final double viewInsetsBottom = MediaQuery.of(context).viewPadding.bottom;
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<AbsenceListBloc>().add(LoadAbsences(filter: state.filter));
      },
      child: ListView.builder(
        itemCount: state.hasMore ? state.data.length + 1 : state.data.length,
        padding: EdgeInsets.only(bottom: viewInsetsBottom),
        itemBuilder: (context, index) {
          if (index >= state.data.length) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () {
                  context.read<AbsenceListBloc>().add(
                    LoadAbsences(filter: state.filter, currentData: state.data),
                  );
                },
                child: Text('Load More'),
              ),
            );
          }
          return AbsenceCard(
            absence: state.data[index].$1,
            member: state.data[index].$2,
          );
        },
      ),
    );
  }
}
