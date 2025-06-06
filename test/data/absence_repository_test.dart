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

  /// Tests for AbsenceRepository.getAbsenceDetails
  /// This method fetches absences and matches them with members.
  /// It returns a list of tuples containing (Absence, Member) and the total count of absences.
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

  /// Tests for AbsenceRepository.getAbsenceDetails
  /// This method should skip absences if no matching member is found.
  /// It should return an empty list and the total count of absences.
  /// This is important to ensure that the absence list does not contain entries without valid member data.
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

  /// Tests for AbsenceRepository.getAbsenceDetails
  /// This method should filter absences by status and return only those that match the provided status.
  /// This is important to ensure that the absence list can be filtered based on specific criteria.
  /// It should return a list of absences that match the given status.
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
