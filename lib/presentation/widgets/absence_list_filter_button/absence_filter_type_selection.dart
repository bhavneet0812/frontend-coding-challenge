part of 'absence_list_filter_button.dart';

/// Types selection widget
/// Displays a dropdown to select absence type
/// and calls [onTypeSelected] when changed
class _TypesSelection extends StatelessWidget {
  final AbsenceType? selectedType;
  final void Function(AbsenceType?) onTypeSelected;

  const _TypesSelection({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Type'),
        DropdownButton<AbsenceType?>(
          value: selectedType,
          isExpanded: true,
          hint: Text("Select Type"),
          onChanged: onTypeSelected,
          items:
              [null, ...AbsenceType.values]
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(type?.title ?? 'All'),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
