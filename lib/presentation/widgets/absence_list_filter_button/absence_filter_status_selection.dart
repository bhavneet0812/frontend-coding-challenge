part of 'absence_list_filter_button.dart';

/// Type selection widget
/// Displays a dropdown to select absence type
/// and calls [onStatusSelected] when changed
class _StatusSelection extends StatelessWidget {
  final AbsenceStatus? selectedStatus;
  final void Function(AbsenceStatus?) onStatusSelected;

  const _StatusSelection({
    required this.selectedStatus,
    required this.onStatusSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Status'),
        DropdownButton<AbsenceStatus?>(
          value: selectedStatus,
          isExpanded: true,
          hint: Text("Select Status"),
          onChanged: onStatusSelected,
          items:
              [null, ...AbsenceStatus.values]
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(status?.title ?? 'All'),
                    ),
                  )
                  .toList(),
        ),
      ],
    );
  }
}
