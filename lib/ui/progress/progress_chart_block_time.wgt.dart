import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_theme.dart';
import 'progress_chart.wgt.dart';

class ProgressChartBlockTime extends StatefulWidget {
  const ProgressChartBlockTime({super.key});

  @override
  State<ProgressChartBlockTime> createState() => _ProgressChartBlockTimeState();
}

class _ProgressChartBlockTimeState extends State<ProgressChartBlockTime> {
  final _main = MainController();
  String _mode = '7';

  @override
  Widget build(BuildContext context) {
    final trainings = _main.trainings;

    Map<String, dynamic> bars = {};
    final now = DateTime.now();
    final beginDate = DateTime(now.year, now.month, now.day);
    final z = int.parse(_mode);
    for (int i = z - 1; i >= 0; i--) {
      final day = beginDate.subtract(Duration(days: i));
      final label = DateFormat('dd/MM').format(day);
      bars.putIfAbsent(label, () {
        final dayItems = trainings
            .where((e) => e.startAt.day == day.day && e.startAt.month == day.month && e.startAt.year == day.year)
            .where((e) => e.completed);
        if (dayItems.isNotEmpty) {
          return dayItems.map((e) => e.trainingTime).reduce(
                (value, element) => value + element,
              );
        }
        return 0;
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Time Tracking metrics',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25), border: Border.all(color: CustomTheme.faintColor)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: _mode,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _mode = value;
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(25),
                  dropdownColor: CustomTheme.formColor,
                  padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding, vertical: 0),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white54),
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Icon(Icons.arrow_drop_down, color: Colors.white54),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: '7',
                      child: Text('Last 7 days'),
                    ),
                    DropdownMenuItem(
                      value: '14',
                      child: Text('Last 14 days'),
                    ),
                    DropdownMenuItem(
                      value: '21',
                      child: Text('Last 21 days'),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: CustomTheme.padding),
        ProgressChart(bars: bars),
      ],
    );
  }
}
