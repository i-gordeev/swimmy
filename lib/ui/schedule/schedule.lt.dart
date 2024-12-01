import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import 'edit_training.scr.dart';
import 'schedule_calendar.wgt.dart';
import 'schedule_calendar_labels.wgt.dart';
import 'schedule_list.wgt.dart';
import 'schedule_notify.wgt.dart';

class ScheduleLayout extends StatefulWidget {
  const ScheduleLayout({super.key});

  @override
  State<ScheduleLayout> createState() => _ScheduleLayoutState();
}

class _ScheduleLayoutState extends State<ScheduleLayout> {
  final _dayStreamController = StreamController<DateTime>.broadcast();
  StreamSubscription? _subscription;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.parse('${DateTime.now().toIso8601String().split('T').first}T00:00:00.000Z');
    _subscription = _dayStreamController.stream.listen(
      (day) => _selectedDay = day,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScheduleCalendar(selectedDaySink: _dayStreamController.sink),
            const SizedBox(height: CustomTheme.padding),
            const ScheduleCalendarLabels(),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ScheduleList(
              initialDay: _selectedDay,
              dayStream: _dayStreamController.stream,
            ),
          ],
        ),
        const SizedBox(height: CustomTheme.padding * 2),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return EditTrainingScreen(item: null, startAt: _selectedDay);
              },
            ));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add new workout'),
              SizedBox(width: CustomTheme.padding),
              InsertSvg(CustomIcons.plus, width: 32, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: CustomTheme.padding * 2),
        const ScheduleNotify(),
        const SizedBox(height: CustomTheme.padding * 2),
      ],
    );
  }
}
