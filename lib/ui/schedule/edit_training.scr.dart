import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/main.ctr.dart';
import '../../data/models/training.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/bottom_padding_ios.wgt.dart';
import '../shared_widgets/custom_select.wgt.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class EditTrainingScreen extends StatefulWidget {
  final TrainingModel? item;
  final DateTime? startAt;

  const EditTrainingScreen({super.key, required this.item, this.startAt});

  @override
  State<EditTrainingScreen> createState() => _EditTrainingScreenState();
}

class _EditTrainingScreenState extends State<EditTrainingScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _editingControllerSwimmingStyle;
  late final TextEditingController _editingControllerTrainingType;
  late final TextEditingController _editingControllerTrainingTime;
  late final TextEditingController _editingControllerDistance;
  late final TextEditingController _editingControllerStartAtDate;
  late final TextEditingController _editingControllerStartAtTime;
  late bool _trainingIsCompleted;

  late DateTime _startAt;

  bool _processing = false;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    _editingControllerSwimmingStyle = TextEditingController(text: widget.item?.swimmingStyle ?? 'Breaststroke Style');
    _editingControllerTrainingType = TextEditingController(text: widget.item?.trainingType ?? 'Speed Improvement');
    _editingControllerTrainingTime = TextEditingController(text: '${widget.item?.trainingTime ?? ''}');
    _editingControllerDistance = TextEditingController(text: '${widget.item?.distance ?? ''}');

    _startAt = () {
      if (isEdit) return widget.item!.startAt;

      final now = DateTime.now();
      return now
          .add(Duration(hours: 1, minutes: now.minute * -1))
          .copyWith(year: widget.startAt?.year, month: widget.startAt?.month, day: widget.startAt?.day);
    }();

    _editingControllerStartAtDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(_startAt));
    _editingControllerStartAtTime = TextEditingController(text: DateFormat('HH:mm').format(_startAt));

    _trainingIsCompleted = widget.item?.completed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding / 2),
          child: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const InsertSvg(CustomIcons.back, width: 32, color: Colors.white),
            ),
            title: Text(isEdit ? 'Edit workout' : 'Add workout'),
            actions: isEdit
                ? [
                    IconButton(
                        onPressed: () async {
                          final process = await showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                content: const Text('Are you sure you want to delete the workout?'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (process) {
                            MainController().deleteTraining(widget.item!);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        icon: const InsertSvg(CustomIcons.delete, width: 34, color: Colors.white)),
                  ]
                : null,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: CustomTheme.padding),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding),
                      child: Column(
                        children: [
                          Text(
                            'Please fill in the following fields',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF9EAABA)),
                          ),
                          Text(
                            'This will help us track your progress and make your workouts even more effective',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9EAABA)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CustomTheme.padding * 2),
                    _FormBlock(
                      title: 'Start at',
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: _editingControllerStartAtDate,
                              style: CustomTheme.inputTextStyle,
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                  currentDate: _startAt,
                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                );
                                if (selectedDate != null) {
                                  if (context.mounted) {
                                    _editingControllerStartAtDate.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                                    _startAt = _startAt.copyWith(
                                        day: selectedDate.day, month: selectedDate.month, year: selectedDate.year);
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                suffixIcon: Container(
                                  width: 32,
                                  height: 32,
                                  alignment: Alignment.center,
                                  child: const InsertSvg(CustomIcons.date, width: 32, color: CustomTheme.faintColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: CustomTheme.padding),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              controller: _editingControllerStartAtTime,
                              style: CustomTheme.inputTextStyle,
                              onTap: () async {
                                final selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(_startAt),
                                  initialEntryMode: TimePickerEntryMode.inputOnly,
                                );
                                if (selectedTime != null) {
                                  if (context.mounted) {
                                    _editingControllerStartAtTime.text = selectedTime.format(context);
                                    _startAt = _startAt.copyWith(hour: selectedTime.hour, minute: selectedTime.minute);
                                  }
                                }
                              },
                              decoration: const InputDecoration(
                                suffixIcon: Icon(Icons.schedule, weight: 32, color: CustomTheme.faintColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: CustomTheme.padding * 2),
                    _FormBlock(
                      title: 'Swimming Style',
                      child: CustomSelect(
                        controller: _editingControllerSwimmingStyle,
                        values: const ['Breaststroke Style', 'Freestyle (Crawl)', 'Butterfly', 'Backstroke Style'],
                        onSelect: (value) {
                          _editingControllerSwimmingStyle.value = TextEditingValue(text: value);
                        },
                      ),
                    ),
                    const SizedBox(height: CustomTheme.padding * 2),
                    _FormBlock(
                      title: 'Training Type',
                      child: CustomSelect(
                        controller: _editingControllerTrainingType,
                        values: const [
                          'Speed Improvement',
                          'Technique Improvement',
                          'Endurance Improvement',
                          'General'
                        ],
                        onSelect: (value) {
                          _editingControllerTrainingType.value = TextEditingValue(text: value);
                        },
                      ),
                    ),
                    const SizedBox(height: CustomTheme.padding * 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _FormBlock(
                            title: 'Time',
                            padding: const EdgeInsets.only(left: CustomTheme.padding),
                            child: TextFormField(
                              style: CustomTheme.inputTextStyle,
                              decoration: const InputDecoration(hintText: "15 minutes"),
                              controller: _editingControllerTrainingTime,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final v = int.tryParse('${value?.trim()}');
                                if (v == null || v < 0 || v > 300) {
                                  return 'Incorrect value';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                        const SizedBox(width: CustomTheme.padding),
                        Expanded(
                          child: _FormBlock(
                            title: 'Distance',
                            padding: const EdgeInsets.only(right: CustomTheme.padding),
                            child: TextFormField(
                              style: CustomTheme.inputTextStyle,
                              decoration: const InputDecoration(hintText: "200 meters"),
                              controller: _editingControllerDistance,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                final v = int.tryParse('${value?.trim()}');
                                if (v == null || v < 0 || v > 30000) {
                                  return 'Incorrect value';
                                }
                                return null;
                              },
                              onChanged: (value) {},
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: CustomTheme.padding * 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding),
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return SwitchListTile(
                            inactiveTrackColor: CustomTheme.bgColor,
                            title: const Text('Completed'),
                            value: _trainingIsCompleted,
                            onChanged: (value) {
                              setState(() => _trainingIsCompleted = value);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: CustomTheme.padding * 1),
                  ],
                ),
              ),
            ),
          ),

          /////////////////

          Padding(
            padding: const EdgeInsets.all(CustomTheme.padding),
            child: StatefulBuilder(
              builder: (context, setState) {
                return OutlinedButton(
                  onPressed: _processing == false
                      ? () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() => _processing = true);

                          final model = TrainingModel(
                              id: widget.item?.id ?? const Uuid().v1(),
                              session: widget.item?.session,
                              startAt: _startAt,
                              swimmingStyle: _editingControllerSwimmingStyle.text,
                              trainingType: _editingControllerTrainingType.text,
                              completed: _trainingIsCompleted,
                              trainingTime: int.parse(_editingControllerTrainingTime.text),
                              distance: int.parse(_editingControllerDistance.text));
                          await MainController().saveTraining(model);
                          if (!context.mounted) {
                            return;
                          }

                          Navigator.of(context).pop();
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                content: isEdit
                                    ? const Text('The workout have been saved')
                                    : const Text('The workout have been added to the training calendar.'),
                                actions: [
                                  CupertinoDialogAction(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Okay'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                  child: _processing
                      ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save'),
                );
              },
            ),
          ),
          const BottomPaddingIOS(),
        ],
      ),
    );
  }
}

class _FormBlock extends StatelessWidget {
  final String title;
  final Widget child;
  final EdgeInsets? padding;
  const _FormBlock({required this.title, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: CustomTheme.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: CustomTheme.padding),
          child,
        ],
      ),
    );
  }
}
