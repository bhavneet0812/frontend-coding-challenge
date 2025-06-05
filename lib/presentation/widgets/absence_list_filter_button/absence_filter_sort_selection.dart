part of 'absence_list_filter_button.dart';

/// Sort selection widget
class _SortSelection extends StatelessWidget {
  final AbsenceSortType selectedSortType;
  final void Function(AbsenceSortType) onSortTypeSelected;

  const _SortSelection({
    required this.selectedSortType,
    required this.onSortTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AbsenceSortType>(
      value: selectedSortType,
      isExpanded: true,
      hint: Text("Select Sort By Type"),
      onChanged: (value) {
        if (value != null) {
          onSortTypeSelected(value);
        }
      },
      items:
          AbsenceSortType.values.map((v) {
            return DropdownMenuItem(value: v, child: Text(v.title));
          }).toList(),
    );
  }
}
