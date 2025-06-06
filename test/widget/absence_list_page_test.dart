import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend_coding_challenge/presentation/pages/absence_list_page.dart';
import 'package:frontend_coding_challenge/presentation/bloc/absence_list/absence_list_bloc.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';

class MockAbsenceListBloc extends Mock implements AbsenceListBloc {}

class FakeAbsenceListEvent extends Fake implements AbsenceListEvent {}

class FakeAbsenceListState extends Fake implements AbsenceListState {}

void main() {
  late AbsenceListBloc mockBloc;

  final mockAbsence = Absence(
    id: 1,
    userId: 1,
    type: AbsenceType.vacation,
    startDate: DateTime(2023, 1, 1),
    endDate: DateTime(2023, 1, 5),
    memberNote: 'Trip',
    admitterNote: '',
    confirmedAt: DateTime(2023, 1, 2),
    createdAt: DateTime(2022, 12, 31),
    crewId: 1,
    rejectedAt: null,
    admitterId: null,
  );

  final mockMember = Member(
    id: 1,
    userId: 1,
    name: 'Max',
    image: '',
    crewId: 1,
  );

  final data = <(Absence, Member)>[(mockAbsence, mockMember)];

  setUpAll(() {
    registerFallbackValue(FakeAbsenceListEvent());
    registerFallbackValue(FakeAbsenceListState());
  });

  setUp(() {
    mockBloc = MockAbsenceListBloc();
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream<AbsenceListState>.empty());
  });

  /// Test case: Rendering loading indicator when bloc is in loading state
  /// This test checks if the CircularProgressIndicator is displayed
  /// when the AbsenceListBloc is in the AbsenceListLoading state.
  testWidgets('displays CircularProgressIndicator when loading', (
    tester,
  ) async {
    when(() => mockBloc.state).thenReturn(AbsenceListLoading());

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsenceListBloc>.value(
          value: mockBloc,
          child: const AbsenceListPage(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  /// Test case: Rendering error message when bloc is in error state
  /// This test checks if the error message is displayed
  /// when the AbsenceListBloc is in the AbsenceListError state.
  testWidgets('displays error message when error occurs', (tester) async {
    when(() => mockBloc.state).thenReturn(AbsenceListError('Failed to load'));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsenceListBloc>.value(
          value: mockBloc,
          child: const AbsenceListPage(),
        ),
      ),
    );

    expect(find.text('Error: Failed to load'), findsOneWidget);
  });

  /// Test case: Displays "No Absences Found" when loaded with empty data
  /// This test checks if the text "No Absences Found" is displayed
  /// when the AbsenceListBloc is in the AbsenceListLoaded state with an empty list.
  testWidgets('displays No Absences Found when data is empty', (tester) async {
    when(() => mockBloc.state).thenReturn(
      AbsenceListLoaded(
        const [],
        filter: const AbsenceListFilterModel(),
        totalCount: 0,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsenceListBloc>.value(
          value: mockBloc,
          child: const AbsenceListPage(),
        ),
      ),
    );

    expect(find.text('No Absences Found'), findsOneWidget);
  });

  /// Test case: Displays absence count and Load More button if more data is available
  /// This test checks if the bottom view displays the correct count
  /// and the Load More button when the AbsenceListBloc is in the AbsenceListLoaded state
  /// with hasMore set to true.
  testWidgets(
    'displays bottom view with count and Load More if hasMore is true',
    (tester) async {
      when(() => mockBloc.state).thenReturn(
        AbsenceListLoaded(
          data,
          filter: const AbsenceListFilterModel(),
          totalCount: 10,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AbsenceListBloc>.value(
            value: mockBloc,
            child: const AbsenceListPage(),
          ),
        ),
      );

      expect(find.text('1 out of 10'), findsOneWidget);
      expect(find.text('Load More'), findsOneWidget);
    },
  );

  /// Test case: Displays share icon when data is available
  /// This test checks if the share icon is displayed
  /// when the AbsenceListBloc is in the AbsenceListLoaded state with data.
  testWidgets('displays share icon when data is available', (tester) async {
    when(() => mockBloc.state).thenReturn(
      AbsenceListLoaded(
        data,
        filter: const AbsenceListFilterModel(),
        totalCount: 1,
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<AbsenceListBloc>.value(
          value: mockBloc,
          child: const AbsenceListPage(),
        ),
      ),
    );

    expect(find.byIcon(Icons.share), findsOneWidget);
  });
}
