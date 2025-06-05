import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/extensions/date_extension.dart';
import 'package:frontend_coding_challenge/core/extensions/generic_extension.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/enums/absence_status.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';

class AbsenceListFilterButton extends StatefulWidget {
  final AbsenceListFilterModel initialFilter;
  final void Function(AbsenceListFilterModel) onFilterChanged;

  const AbsenceListFilterButton({
    super.key,
    required this.initialFilter,
    required this.onFilterChanged,
  });

  @override
  State<AbsenceListFilterButton> createState() =>
      _AbsenceListFilterButtonState();
}

class _AbsenceListFilterButtonState extends State<AbsenceListFilterButton> {
  late AbsenceListFilterModel _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<AbsenceListFilterModel>(
      tooltip: 'Filter',
      icon: Badge(
        isLabelVisible: !widget.initialFilter.isEmpty,
        child: const Icon(Icons.filter_list),
      ),
      onSelected: (value) {
        widget.onFilterChanged(_filter);
      },
      onCanceled: () {
        _filter = widget.initialFilter;
      },
      itemBuilder:
          (context) => [
            PopupMenuItem(
              enabled: false,
              child: Text(
                'Filter Options',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            PopupMenuItem(
              enabled: false,
              child: StatefulBuilder(
                builder: (context, setInnerState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Type'),
                      DropdownButton<AbsenceType?>(
                        value: _filter.type,
                        isExpanded: true,
                        hint: Text("Select Type"),
                        onChanged: (value) {
                          setInnerState(() {
                            _filter = _filter.copyWith(type: value.asNullable);
                          });
                        },
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
                },
              ),
            ),
            PopupMenuItem(
              enabled: false,
              child: StatefulBuilder(
                builder: (context, setInnerState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Status'),
                      DropdownButton<AbsenceStatus?>(
                        value: _filter.status,
                        isExpanded: true,
                        hint: Text("Select Status"),
                        onChanged: (value) {
                          setInnerState(() {
                            _filter = _filter.copyWith(
                              status: value.asNullable,
                            );
                          });
                        },
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
                },
              ),
            ),
            PopupMenuItem(
              enabled: false,
              child: StatefulBuilder(
                builder: (context, setInnerState) {
                  return _DateRangeSelection(
                    initialDateRange: _filter.dateRange,
                    onDateRangeSelected: (range) {
                      setInnerState(() {
                        _filter = _filter.copyWith(dateRange: range.asNullable);
                      });
                    },
                  );
                },
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              enabled: false,
              child: _Actions(
                onReset: () {
                  _filter = AbsenceListFilterModel();
                  widget.onFilterChanged(_filter);
                  Navigator.pop(context);
                },
                onApply: () {
                  widget.onFilterChanged(_filter);
                  Navigator.pop(context);
                },
              ),
            ),
          ],
    );
  }
}

class _DateRangeSelection extends StatelessWidget {
  final DateTimeRange? initialDateRange;
  final void Function(DateTimeRange?) onDateRangeSelected;

  const _DateRangeSelection({
    required this.initialDateRange,
    required this.onDateRangeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              initialDateRange: initialDateRange,
            );
            if (picked != null) {
              onDateRangeSelected(picked);
            }
          },
          // icon: Icon(Icons.date_range),
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
    );
  }
}

/// Actions widget for the filter button
/// Contains Reset and Apply buttons
class _Actions extends StatelessWidget {
  final void Function() onReset;
  final void Function() onApply;

  const _Actions({required this.onReset, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8.0,
          children: [
            Expanded(
              child: TextButton(onPressed: onReset, child: Text('Reset')),
            ),
            Expanded(
              child: FilledButton(onPressed: onApply, child: Text('Apply')),
            ),
          ],
        ),
      ],
    );
  }
}
