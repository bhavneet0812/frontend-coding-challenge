part of 'absence_list_filter_button.dart';

/// Date range selection widget
/// Displays a button to select a date range
/// and calls [onDateRangeSelected] when changed
class _DateRangeSelection extends StatelessWidget {
  final DateTimeRange? initialDateRange;
  final void Function(DateTimeRange?) onDateRangeSelected;

  const _DateRangeSelection({
    required this.initialDateRange,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () async {
              final picked = await showDialog<DateTimeRange>(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 400,
                        maxHeight: 600,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: DateRangePickerDialog(
                          initialDateRange: initialDateRange,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                          initialEntryMode: DatePickerEntryMode.calendarOnly,
                        ),
                      ),
                    ),
                  );
                },
              );

              if (picked != null) {
                onDateRangeSelected(picked);
              }
            },
            label: Text(
              initialDateRange == null
                  ? 'Select Date Range'
                  : '${initialDateRange!.start.MMMdy} → ${initialDateRange!.end.MMMdy}',
            ),
          ),
          if (initialDateRange != null)
            TextButton(
              onPressed: () {
                onDateRangeSelected(null);
              },
              child: Text(
                'Clear Date Range',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
