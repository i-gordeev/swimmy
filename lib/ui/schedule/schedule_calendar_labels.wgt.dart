import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class ScheduleCalendarLabels extends StatelessWidget {
  const ScheduleCalendarLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CustomTheme.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: CustomTheme.color1),
              const SizedBox(width: CustomTheme.padding / 2),
              Text(
                'Speed',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CustomTheme.color1),
              ),
            ],
          ),
          const SizedBox(width: CustomTheme.padding / 2),
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: CustomTheme.color2),
              const SizedBox(width: CustomTheme.padding / 2),
              Text(
                'Technique',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CustomTheme.color2),
              ),
            ],
          ),
          const SizedBox(width: CustomTheme.padding / 2),
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: CustomTheme.color3),
              const SizedBox(width: CustomTheme.padding / 2),
              Text(
                'Endurance',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CustomTheme.color3),
              ),
            ],
          ),
          const SizedBox(width: CustomTheme.padding / 2),
          Row(
            children: [
              const Icon(Icons.circle, size: 10, color: CustomTheme.color4),
              const SizedBox(width: CustomTheme.padding / 2),
              Text(
                'General',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CustomTheme.color4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
