import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_coding_challenge/presentation/bloc/absence_list/absence_list_bloc.dart';
import 'package:frontend_coding_challenge/presentation/widgets/absence_list/absence_list_mobile_view.dart';
import 'package:frontend_coding_challenge/presentation/widgets/absence_list/absence_list_tablet_view.dart';
import 'package:frontend_coding_challenge/presentation/widgets/absence_list_filter_button/absence_list_filter_button.dart';

class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Absence Manager'),
          centerTitle: false,
          actions: [
            BlocBuilder<AbsenceListBloc, AbsenceListState>(
              builder: (context, state) {
                if (state is AbsenceListLoading) {
                  return SizedBox.shrink();
                }

                if (state is AbsenceListLoaded) {
                  return AbsenceListFilterButton(
                    initialFilter: state.filter,
                    onFilterChanged: (filter) {
                      context.read<AbsenceListBloc>().add(
                        LoadAbsences(filter: filter),
                      );
                    },
                  );
                }

                return IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    context.read<AbsenceListBloc>().add(LoadAbsences());
                  },
                );
              },
            ),
          ],
        ),
        body: _Body(),
        bottomNavigationBar: BlocBuilder<AbsenceListBloc, AbsenceListState>(
          builder: (context, state) {
            if (state is AbsenceListLoading) {
              return SizedBox.shrink();
            }

            if (state is AbsenceListLoaded) {
              if (state.data.isEmpty) {
                return SizedBox.shrink();
              }

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${state.data.length} out of ${state.totalCount}',
                      style: TextStyle(fontSize: 16),
                    ),
                    if (state.hasMore)
                      TextButton(
                        onPressed: () {
                          context.read<AbsenceListBloc>().add(
                            LoadAbsences(
                              filter: state.filter,
                              currentData: state.data,
                            ),
                          );
                        },
                        child: Text('Load More'),
                      ),
                  ],
                ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

///
class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AbsenceListBloc>().state;
    switch (state) {
      case AbsenceListLoading _:
        return Center(child: CircularProgressIndicator());
      case AbsenceListError error:
        return Center(child: Text('Error: ${error.message}'));
      case AbsenceListLoaded state:
        if (state.data.isEmpty) {
          return Center(child: Text('No Absences Found'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 600) {
              return AbsenceListTabletView(
                absences: state.data,
                onRefresh: () async {
                  context.read<AbsenceListBloc>().add(
                    LoadAbsences(filter: state.filter),
                  );
                },
              );
            }
            return AbsenceListMobileView(
              absences: state.data,
              onRefresh: () async {
                context.read<AbsenceListBloc>().add(
                  LoadAbsences(filter: state.filter),
                );
              },
            );
          },
        );
      default:
        return SizedBox();
    }
  }
}
