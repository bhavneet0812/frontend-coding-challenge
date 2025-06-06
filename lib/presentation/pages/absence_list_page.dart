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
          title: Row(
            children: [
              Text('Absence List'),
              BlocBuilder<AbsenceListBloc, AbsenceListState>(
                builder: (context, state) {
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
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
          centerTitle: false,
          actions: [
            BlocBuilder<AbsenceListBloc, AbsenceListState>(
              builder: (context, state) {
                if (state is AbsenceListLoaded && state.data.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25.0),
                      onTapUp: (details) {
                        _onShareCalendarEvents(context, details, state);
                      },
                      child: Tooltip(
                        message: 'Share Calendar Events',
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.share),
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox.shrink();
              },
            ),
          ],
        ),
        body: _AbsenceListBody(),
        bottomNavigationBar: _AbsenceListBottomView(),
      ),
    );
  }
}

/// An extension on the AbsenceListPage Methods
/// that provides additional functionality
extension AbsenceListPageExtension on AbsenceListPage {
  /// Handles the tap event to share calendar events.
  /// This method converts the global tap position to a local position
  /// and dispatches the `ShareAbsencesCalendarEvents` event with the current filter.
  /// /// [context] - The BuildContext of the widget.
  /// [tapDetails] - The details of the tap event, including the global position.
  /// [state] - The current state of the AbsenceListBloc, which contains the filter.
  void _onShareCalendarEvents(
    BuildContext context,
    TapUpDetails tapDetails,
    AbsenceListLoaded state,
  ) {
    final Offset globalOffset = tapDetails.globalPosition;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localOffset = renderBox.globalToLocal(globalOffset);
    // Dispatch the event to share calendar events
    context.read<AbsenceListBloc>().add(
      ShareAbsencesCalendarEvents(
        filter: state.filter,
        position: Rect.fromLTWH(localOffset.dx, localOffset.dy, 0, 0),
      ),
    );
  }
}

/// A widget that builds the body of the Absence List page.
/// It uses the AbsenceListBloc to determine the current state
/// and displays the appropriate content based on the state.
/// It handles loading, error, and loaded states,
/// and displays the absence list in either mobile or tablet view
/// based on the screen width.

class _AbsenceListBody extends StatelessWidget {
  const _AbsenceListBody();

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

/// A widget that builds the bottom view of the Absence List page.
/// It displays the total count of absences and a button to load more absences.
/// It listens to the AbsenceListBloc state to determine if more data is available
/// and whether to show the loading indicator or the load more button.
class _AbsenceListBottomView extends StatelessWidget {
  const _AbsenceListBottomView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AbsenceListBloc>().state;
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
                    LoadAbsences(filter: state.filter, currentData: state.data),
                  );
                },
                child: Text('Load More'),
              ),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }
}
