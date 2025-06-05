import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_coding_challenge/data/repository/absence_repository.dart';
import 'package:frontend_coding_challenge/presentation/bloc/absence_list/absence_list_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_coding_challenge/presentation/pages/absence_list_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'absence',
      builder: (context, state) {
        return BlocProvider(
          create: (_) {
            return AbsenceListBloc(AbsenceRepository())..add(LoadAbsences());
          },
          child: AbsenceListPage(),
        );
      },
    ),
    // Add more routes here if needed
  ],
);
