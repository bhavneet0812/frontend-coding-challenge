enum AbsenceSortType {
  date('Date'),
  type('Reason'),
  status('Status');

  final String title;
  const AbsenceSortType(this.title);
}
