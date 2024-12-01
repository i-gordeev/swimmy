import 'package:flutter/material.dart';

import '../../controllers/main.ctr.dart';
import '../../data/services/shared_preferences_service.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class ScheduleNotify extends StatefulWidget {
  const ScheduleNotify({super.key});

  @override
  State<ScheduleNotify> createState() => _ScheduleNotifyState();
}

class _ScheduleNotifyState extends State<ScheduleNotify> {
  final _main = MainController();
  int _value = 0;

  @override
  void initState() {
    super.initState();
    _value = SharedPreferencesService.getInt('notify_before') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InsertSvg(CustomIcons.notify, width: 24, color: _value > 0 ? CustomTheme.primaryColor : Colors.white54),
        const SizedBox(width: CustomTheme.padding),
        Text(
          'Notify before the workout:',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
        ),
        const Spacer(),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: CustomTheme.faintColor),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: '$_value',
              onChanged: (value) {
                _value = int.parse('${value ?? 0}');
                SharedPreferencesService.setInt('notify_before', _value).then((_) => _main.createNotifications());
                setState(() {});
              },
              borderRadius: BorderRadius.circular(25),
              dropdownColor: CustomTheme.formColor,
              padding: const EdgeInsets.only(left: CustomTheme.padding, right: CustomTheme.padding / 2),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              items: const [
                DropdownMenuItem(
                  value: '0',
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: '15',
                  child: Text('15 minutes'),
                ),
                DropdownMenuItem(
                  value: '30',
                  child: Text('30 minutes'),
                ),
                DropdownMenuItem(
                  value: '60',
                  child: Text('1 hour'),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
