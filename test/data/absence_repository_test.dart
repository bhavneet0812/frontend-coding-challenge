import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend_coding_challenge/data/repository/absence_repository.dart';
import 'package:frontend_coding_challenge/data/services/api_service.dart';
import 'package:frontend_coding_challenge/data/models/absence.dart';
import 'package:frontend_coding_challenge/data/models/member.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApiService;
  late AbsenceRepository repository;

  setUp(() {
    mockApiService = MockApiService();
    repository = AbsenceRepository(apiService: mockApiService);
  });

  final mockAbsence = Absence(
    id: 1,
    userId: 101,
    type: AbsenceType.vacation,
    startDate: DateTime(2023, 1, 1),
    endDate: DateTime(2023, 1, 5),
    memberNote: 'Going to Goa',
    admitterNote: '',
    confirmedAt: DateTime(2023, 1, 2),
    createdAt: DateTime(2022, 12, 25),
    crewId: 1,
    rejectedAt: null,
    admitterId: null,
  );

  final mockMember = Member(
    id: 11,
    userId: 101,
    name: 'Max Mustermann',
    image: '',
    crewId: 1,
  );

  /// ✅ Test Case: Returns a list of (Absence, Member) tuples and total count.
  /// This test verifies that the repository correctly joins absence and member data
  /// and returns a valid list with total absence count.
  test('should return list of (Absence, Member) and totalCount', () async {
    when(
      () => mockApiService.getAbsences(
        filter: any(named: 'filter'),
        skip: any(named: 'skip'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => ([mockAbsence], 1));

    when(
      () => mockApiService.getMembers(),
    ).thenAnswer((_) async => [mockMember]);

    final result = await repository.getAbsenceDetails();

    expect(result.$1.length, 1);
    expect(result.$2, 1);
    expect(result.$1.first.$1.id, mockAbsence.id);
    expect(result.$1.first.$2.name, mockMember.name);
  });

  /// ❌ Test Case: Skips absences if no matching member is found.
  /// This test ensures that if there is no member match, the absence is not included in the result.
  /// It avoids including orphan absence records without context.
  test('should skip absence if no matching member found', () async {
    when(
      () => mockApiService.getAbsences(
        filter: any(named: 'filter'),
        skip: any(named: 'skip'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => ([mockAbsence], 1));

    when(() => mockApiService.getMembers()).thenAnswer((_) async => []);

    final result = await repository.getAbsenceDetails();

    expect(result.$1, isEmpty);
    expect(result.$2, 1);
  });

  /// ✅ Test Case: Filters by absence type.
  /// This test ensures that when a filter (e.g., by vacation type) is applied,
  /// the repository returns only the matching absences.
  test('should filter by type and match correctly', () async {
    final filter = AbsenceListFilterModel(type: AbsenceType.vacation);

    when(
      () => mockApiService.getAbsences(
        filter: filter,
        skip: any(named: 'skip'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => ([mockAbsence], 1));

    when(
      () => mockApiService.getMembers(),
    ).thenAnswer((_) async => [mockMember]);

    final result = await repository.getAbsenceDetails(filter: filter);

    expect(result.$1.length, 1);
    expect(result.$1.first.$1.type, AbsenceType.vacation);
  });
}
