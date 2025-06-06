import 'package:flutter/material.dart';
import 'package:frontend_coding_challenge/core/extensions/date_extension.dart';
import 'package:frontend_coding_challenge/core/extensions/generic_extension.dart';
import 'package:frontend_coding_challenge/data/data_models/absence_list_filter_model.dart';
import 'package:frontend_coding_challenge/data/enums/absence_sort_type.dart';
import 'package:frontend_coding_challenge/data/enums/absence_status.dart';
import 'package:frontend_coding_challenge/data/enums/absence_type.dart';

part 'absence_filter_sort_selection.dart';
part 'absence_filter_type_selection.dart';
part 'absence_filter_status_selection.dart';
part 'absence_filter_date_selection.dart';
part 'absence_filter_actions.dart';

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
  void didUpdateWidget(covariant AbsenceListFilterButton oldWidget) {
    if (oldWidget.initialFilter != widget.initialFilter) {
      _filter = widget.initialFilter;
    }
    super.didUpdateWidget(oldWidget);
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
      itemBuilder: (context) {
        return [
          /// Filter options title
          PopupMenuItem(
            enabled: false,
            child: Text(
              'Sort By',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ),

          /// Sort by selection
          PopupMenuItem(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setInnerState) {
                return _SortSelection(
                  selectedSortType: _filter.sortType,
                  onSortTypeSelected: (sortType) {
                    setInnerState(() {
                      _filter = _filter.copyWith(sortType: sortType);
                    });
                  },
                );
              },
            ),
          ),

          /// Filter options title
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

          /// Type selection
          PopupMenuItem(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setInnerState) {
                return _TypesSelection(
                  selectedType: _filter.type,
                  onTypeSelected: (type) {
                    setInnerState(() {
                      _filter = _filter.copyWith(type: type.asNullable);
                    });
                  },
                );
              },
            ),
          ),

          /// Status selection
          PopupMenuItem(
            enabled: false,
            child: StatefulBuilder(
              builder: (context, setInnerState) {
                return _StatusSelection(
                  selectedStatus: _filter.status,
                  onStatusSelected: (status) {
                    setInnerState(() {
                      _filter = _filter.copyWith(status: status.asNullable);
                    });
                  },
                );
              },
            ),
          ),

          /// Date range selection
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

          /// Actions
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
        ];
      },
    );
  }
}
