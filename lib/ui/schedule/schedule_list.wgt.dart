import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_theme.dart';
import 'schedule_list_item.wgt.dart';

class ScheduleList extends StatefulWidget {
  final Stream<DateTime> dayStream;
  final DateTime initialDay;
  const ScheduleList({super.key, required this.dayStream, required this.initialDay});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final _main = MainController();
  StreamSubscription? _daySubscription;
  StreamSubscription? _trainingsSubscription;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.initialDay;
    _daySubscription = widget.dayStream.listen(
      (day) {
        setState(() {
          _selectedDay = day;
        });
      },
    );
    _trainingsSubscription = _main.trainingsStream.listen((_) => setState(() {}));
  }

  @override
  void dispose() {
    _daySubscription?.cancel();
    _trainingsSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dt = DateTime.now();
    final header = (dt.day == _selectedDay.day && dt.month == _selectedDay.month && dt.year == _selectedDay.year)
        ? 'today'
        : DateFormat('dd MMM. yyyy').format(_selectedDay);

    final trainings = _main.trainings
        .where((e) => (e.startAt.day == _selectedDay.day &&
            e.startAt.month == _selectedDay.month &&
            e.startAt.year == _selectedDay.year))
        .toList()
      ..sort(
        (a, b) {
          if (a.startAt == b.startAt) return 0;
          return a.startAt.isAfter(b.startAt) ? 1 : -1;
        },
      );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: CustomTheme.padding / 2),
        Text(
          'Sessions of $header',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: CustomTheme.padding / 2),
        trainings.isEmpty
            ? Text(
                'No results.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
              )
            : ListView.separated(
                padding: const EdgeInsets.only(top: CustomTheme.padding / 2),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => ScheduleListItem(item: trainings[index]),
                separatorBuilder: (context, index) => const SizedBox(height: CustomTheme.padding),
                itemCount: trainings.length,
              ),
      ],
    );
  }
}
