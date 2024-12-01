import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_theme.dart';

class ScheduleCalendar extends StatefulWidget {
  final StreamSink<DateTime> selectedDaySink;
  const ScheduleCalendar({super.key, required this.selectedDaySink});

  @override
  State<ScheduleCalendar> createState() => _ScheduleCalendarState();
}

class _ScheduleCalendarState extends State<ScheduleCalendar> {
  final _main = MainController();
  StreamSubscription? _subscription;
  late DateTime _selectedDay;

  DateTime get currentDate => DateTime.parse('${DateTime.now().toIso8601String().split('T').first}T00:00:00.000Z');

  @override
  void initState() {
    super.initState();
    _selectedDay = currentDate;
    _subscription = _main.trainingsStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dtNow = DateTime.now();

    return TableCalendar(
      firstDay: DateTime.utc(dtNow.year - 3, dtNow.month, dtNow.day),
      lastDay: DateTime.utc(dtNow.year + 1, dtNow.month, dtNow.day),
      focusedDay: _selectedDay,
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextFormatter: (date, locale) => DateFormat.yMMMM(locale).format(date),
        titleTextStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: CustomTheme.faintColor),
        leftChevronIcon: const Icon(Icons.chevron_left, color: CustomTheme.faintColor),
        rightChevronIcon: const Icon(Icons.chevron_right, color: CustomTheme.faintColor),
      ),
      weekendDays: const [],
      daysOfWeekHeight: 50,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle:
            Theme.of(context).textTheme.labelSmall?.copyWith(color: CustomTheme.faintColor) ?? const TextStyle(),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        widget.selectedDaySink.add(selectedDay);
        setState(() => _selectedDay = selectedDay);
      },
      calendarBuilders: CalendarBuilders(
        prioritizedBuilder: (context, day, focusedDay) {
          final trainings = _main.trainings
              .where((e) => e.startAt.day == day.day && e.startAt.month == day.month && e.startAt.year == day.year)
              .toList();

          Color? textColor;
          Color? underlineColor;

          if (trainings.isNotEmpty) {
            final item = trainings.first;
            textColor = () {
              switch (item.trainingType) {
                case 'Speed Improvement':
                  return CustomTheme.color1;
                case 'Technique Improvement':
                  return CustomTheme.color2;
                case 'Endurance Improvement':
                  return CustomTheme.color3;
                case 'General':
                  return CustomTheme.color4;
                default:
                  return null;
              }
            }();

            underlineColor = () {
              if (item.startAt.add(const Duration(minutes: 60)).isBefore(dtNow)) {
                return item.completed ? CustomTheme.successColor : CustomTheme.warningColor;
              }
              return null;
            }();
          }

          return Container(
            width: 38,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: '$currentDate' != '$day' ? Colors.transparent : Colors.white.withOpacity(.07),
              borderRadius: BorderRadius.circular(8),
              border: '$_selectedDay' == '$day' ? Border.all(color: Colors.white24) : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 3),
                Expanded(
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style:
                          Theme.of(context).textTheme.bodyLarge?.copyWith(color: textColor ?? CustomTheme.faintColor),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 3,
                  color: underlineColor,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
