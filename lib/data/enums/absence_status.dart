enum AbsenceStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  rejected('Rejected');

  final String title;

  const AbsenceStatus(this.title);
}
