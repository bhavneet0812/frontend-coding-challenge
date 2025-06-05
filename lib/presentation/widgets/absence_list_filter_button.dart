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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setInnerState(() {
                              _filter = _filter.copyWith(
                                dateRange: picked.asNullable,
                              );
                            });
                          }
                        },
                        icon: Icon(Icons.date_range),
                        label: Text('Select Date Range'),
                      ),
                      if (_filter.dateRange != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Range: ${_filter.dateRange!.start.MMMdy} → ${_filter.dateRange!.end.MMMdy}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              enabled: false,
              child: StatefulBuilder(
                builder: (context, setInnerState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8.0,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _filter = AbsenceListFilterModel();
                                });
                                widget.onFilterChanged(_filter);
                                Navigator.pop(context);
                              },
                              child: Text('Reset'),
                            ),
                          ),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                widget.onFilterChanged(_filter);
                                Navigator.pop(context);
                              },
                              child: Text('Apply'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
    );
  }
}
