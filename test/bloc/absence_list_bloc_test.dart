import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';
import 'package:frontend_coding_challenge/presentation/bloc/absence_list/absence_list_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:frontend_coding_challenge/data/repository/absence_repository.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';

class MockAbsenceRepository extends Mock implements AbsenceRepository {}

void main() {
  late MockAbsenceRepository mockRepository;
  late AbsenceListBloc bloc;

  setUpAll(() {
    registerFallbackValue(LoadAbsences());
  });

  setUp(() {
    mockRepository = MockAbsenceRepository();
    bloc = AbsenceListBloc(mockRepository);
  });

  final mockAbsence = Absence(
    id: 1,
    userId: 1,
    type: AbsenceType.vacation,
    startDate: DateTime.parse('2023-01-01'),
    endDate: DateTime.parse('2023-01-05'),
    memberNote: 'Holiday',
    admitterNote: '',
    confirmedAt: DateTime.parse('2023-01-02T12:00:00.000Z'),
    createdAt: DateTime.parse('2022-12-31T08:00:00.000Z'),
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

  final mockCombined = <(Absence, Member)>[(mockAbsence, mockMember)];

  /// ✅ Test case: Successful loading of absence list.
  /// This test ensures the bloc emits [AbsenceListLoading] followed by [AbsenceListLoaded]
  /// when [LoadAbsences] is dispatched and the repository returns valid data.
  blocTest<AbsenceListBloc, AbsenceListState>(
    'emits [Loading, Loaded] when LoadAbsences is added',
    build: () {
      when(
        () => mockRepository.getAbsenceDetails(
          filter: any(named: 'filter'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => (mockCombined, mockCombined.length));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadAbsences()),
    expect:
        () => [
          AbsenceListLoading(),
          AbsenceListLoaded(
            mockCombined,
            filter: const AbsenceListFilterModel(),
            totalCount: mockCombined.length,
          ),
        ],
  );

  /// ❌ Test case: Error scenario.
  /// This test ensures the bloc emits [AbsenceListLoading] followed by [AbsenceListError]
  /// when the repository throws an exception (e.g. API failure).
  blocTest<AbsenceListBloc, AbsenceListState>(
    'emits [Loading, Error] when repository throws an exception due to API failure, resulting in AbsenceListError state',
    build: () {
      when(
        () => mockRepository.getAbsenceDetails(
          filter: any(named: 'filter'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      ).thenThrow(Exception('Failed to fetch absence details from the API'));
      return bloc;
    },
    act: (bloc) => bloc.add(const LoadAbsences()),
    expect:
        () => [
          AbsenceListLoading(),
          predicate<AbsenceListError>((error) {
            print(error.message);
            return error.message ==
                'Exception: Failed to fetch absence details from the API';
          }),
        ],
  );

  /// ✅ Test case: LoadAbsences with filter applied.
  /// This test ensures that when a [AbsenceListFilterModel] with a type is provided,
  /// the bloc loads filtered data and emits [AbsenceListLoaded] with the expected result.
  blocTest<AbsenceListBloc, AbsenceListState>(
    'emits [Loading, Loaded with filtered data] when AbsenceListFilterModel is provided',
    build: () {
      when(
        () => mockRepository.getAbsenceDetails(
          filter: any(named: 'filter'),
          skip: any(named: 'skip'),
          limit: any(named: 'limit'),
        ),
      ).thenAnswer((_) async => (mockCombined, mockCombined.length));
      return bloc;
    },
    act:
        (bloc) => bloc.add(
          const LoadAbsences(
            filter: AbsenceListFilterModel(type: AbsenceType.vacation),
          ),
        ),
    expect:
        () => [
          AbsenceListLoading(),
          AbsenceListLoaded(
            mockCombined,
            filter: const AbsenceListFilterModel(type: AbsenceType.vacation),
            totalCount: mockCombined.length,
          ),
        ],
  );

  tearDown(() => bloc.close());
}
