part of 'absence_list_filter_button.dart';

/// Actions widget for the filter button
/// contains Reset and Apply buttons
/// calls [onReset] and [onApply] when pressed
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
