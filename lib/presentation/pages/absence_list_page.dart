import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_coding_challenge/data/repository/absence_repository.dart';
import 'package:frontend_coding_challenge/presentation/bloc/absence_list/absence_list_bloc.dart';
import '../widgets/absence_card.dart';

class AbsenceListPage extends StatelessWidget {
  const AbsenceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AbsenceListBloc(AbsenceRepository())..add(LoadAbsences()),
      child: _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absence Manager'), centerTitle: false),
      body: BlocBuilder<AbsenceListBloc, AbsenceListState>(
        builder: (context, state) {
          switch (state) {
            case AbsenceListLoading _:
              return Center(child: CircularProgressIndicator());
            case AbsenceListError error:
              return Center(child: Text('Error: ${error.message}'));
            case AbsenceListLoaded state:
              if (state.data.isEmpty) {
                return Center(child: Text('No Absences Found'));
              }
              final double viewInsetsBottom =
                  MediaQuery.of(context).viewPadding.bottom;
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          state.hasMore
                              ? state.data.length + 1
                              : state.data.length,
                      padding: EdgeInsets.only(bottom: viewInsetsBottom),
                      itemBuilder: (context, index) {
                        if (index >= state.data.length) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed:
                                  () => context.read<AbsenceListBloc>().add(
                                    LoadNextAbsencesPage(),
                                  ),
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
                  ),
                ],
              );
            default:
              return SizedBox();
          }
        },
      ),
    );
  }
}
