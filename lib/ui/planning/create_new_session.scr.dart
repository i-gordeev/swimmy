import 'dart:async';
import 'dart:io';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../controllers/main.ctr.dart';
import '../../data/models/session.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_pictures.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/bottom_padding_ios.wgt.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class CreateNewSessionScreen extends StatefulWidget {
  const CreateNewSessionScreen({super.key});

  @override
  State<CreateNewSessionScreen> createState() => _CreateNewSessionScreenState();
}

class _CreateNewSessionScreenState extends State<CreateNewSessionScreen> {
  late final PageController _pageViewController;
  final _pagesStreamController = StreamController<int>();
  final _formKey = GlobalKey<FormState>();
  bool _processing = false;
  int _page = 0;
  String _swimmingStyle = 'Breaststroke Style';
  String _trainingType = 'Speed Improvement';
  String _sessionsPerWeek = '';
  String _skillLevel = 'Intermediate';
  String _numberOfWeeks = '';
  DateTime _startDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _startTime = TimeOfDay.fromDateTime(DateTime.now().subtract(Duration(minutes: DateTime.now().minute)));

  bool get _pageIsFirst => _page == 0;
  bool get _pageIsLast => _page == 2;

  void _pageHandler() {
    final v = (_pageViewController.page ?? 0).floor();
    if (_page != v) {
      _page = v;
      _pagesStreamController.add(_page);
    }
  }

  @override
  void initState() {
    super.initState();

    _pageViewController = PageController();
    _pageViewController.addListener(_pageHandler);
  }

  @override
  void dispose() {
    _pageViewController.removeListener(_pageHandler);
    _pageViewController.dispose();
    super.dispose();
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
                if (_pageIsFirst) {
                  Navigator.of(context).pop();
                } else {
                  _pageViewController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.linear);
                }
              },
              icon: const InsertSvg(CustomIcons.back, width: 32, color: Colors.white),
            ),
            title: const Text('Create new session'),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CustomTheme.padding),
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                MediaQuery.of(context).viewInsets.bottom -
                kToolbarHeight -
                CustomTheme.padding * 4 -
                (Platform.isIOS ? CustomTheme.defaultIOSbottomPadding : 0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Set Your Parameters',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF9EAABA)),
                  ),
                  Text(
                    'Help us to get to know you and your goals',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9EAABA)),
                  ),
                  const SizedBox(height: CustomTheme.padding * 2),
                  ExpandablePageView.builder(
                    controller: _pageViewController,
                    itemCount: 3,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      // Step 1
                      if (index == 0) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Swimming Style',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: CustomTheme.padding),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    SelectLabel(
                                      isSelected: _swimmingStyle == 'Breaststroke Style',
                                      title: 'Breaststroke Style',
                                      iconPath: CustomPictures.styleBreaststroke,
                                      onTap: (value) {
                                        setState(() => _swimmingStyle = value);
                                      },
                                    ),
                                    const SizedBox(height: CustomTheme.padding),
                                    SelectLabel(
                                      isSelected: _swimmingStyle == 'Freestyle (Crawl)',
                                      title: 'Freestyle (Crawl)',
                                      iconPath: CustomPictures.styleFreestyle,
                                      onTap: (value) {
                                        setState(() => _swimmingStyle = value);
                                      },
                                    ),
                                    const SizedBox(height: CustomTheme.padding),
                                    SelectLabel(
                                      isSelected: _swimmingStyle == 'Butterfly',
                                      title: 'Butterfly',
                                      iconPath: CustomPictures.styleButterfly,
                                      onTap: (value) {
                                        setState(() => _swimmingStyle = value);
                                      },
                                    ),
                                    const SizedBox(height: CustomTheme.padding),
                                    SelectLabel(
                                      isSelected: _swimmingStyle == 'Backstroke Style',
                                      title: 'Backstroke Style',
                                      iconPath: CustomPictures.styleBackstroke,
                                      onTap: (value) {
                                        setState(() => _swimmingStyle = value);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }

                      // Step 2
                      else if (index == 1) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Training Type',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: CustomTheme.padding),
                            StatefulBuilder(
                              builder: (context, setState) {
                                return Column(
                                  children: [
                                    SelectLabel(
                                      isSelected: _trainingType == 'Speed Improvement',
                                      title: 'Speed Improvement',
                                      iconPath: CustomPictures.typeSpeed,
                                      onTap: (value) {
                                        setState(() => _trainingType = value);
                                      },
                                    ),
                                    const SizedBox(height: CustomTheme.padding),
                                    SelectLabel(
                                      isSelected: _trainingType == 'Technique Improvement',
                                      title: 'Technique Improvement',
                                      iconPath: CustomPictures.typeTech,
                                      onTap: (value) {
                                        setState(() => _trainingType = value);
                                      },
                                    ),
                                    const SizedBox(height: CustomTheme.padding),
                                    SelectLabel(
                                      isSelected: _trainingType == 'Endurance Improvement',
                                      title: 'Endurance Improvement',
                                      iconPath: CustomPictures.typeEdurance,
                                      onTap: (value) {
                                        setState(() => _trainingType = value);
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      }

                      // Step 3
                      else if (index == 2) {
                        return Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Training Sessions per Week',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: CustomTheme.padding),
                              TextFormField(
                                style: CustomTheme.inputTextStyle,
                                decoration: const InputDecoration(hintText: "1-7"),
                                initialValue: _sessionsPerWeek,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  final v = int.tryParse('${value?.trim()}');
                                  if (v == null || v < 0 || v > 7) {
                                    return 'Please enter correct value';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _sessionsPerWeek = value;
                                },
                              ),
                              const SizedBox(height: CustomTheme.padding * 2),
                              Text(
                                'Skill Level',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: CustomTheme.padding),
                              StatefulBuilder(
                                builder: (context, setState) {
                                  final values = <double>[0.0, 1.0, 2.0];
                                  final double value = () {
                                    if (_skillLevel == 'Intermediate') return 1.0;
                                    if (_skillLevel == 'Advanced') return 2.0;
                                    return 0.0;
                                  }();

                                  return Slider(
                                    min: 0,
                                    max: values.length - 1,
                                    divisions: values.length - 1,
                                    value: value,
                                    onChanged: (value) {
                                      switch (value.toInt()) {
                                        case 1:
                                          _skillLevel = 'Intermediate';
                                          break;
                                        case 2:
                                          _skillLevel = 'Advanced';
                                          break;
                                        default:
                                          _skillLevel = 'Beginner';
                                      }

                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                              const SizedBox(height: CustomTheme.padding),
                              const DefaultTextStyle(
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Beginner'),
                                    Text('Intermediate'),
                                    Text('Advanced'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: CustomTheme.padding * 2),
                              Text(
                                'Number of Weeks',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: CustomTheme.padding),
                              TextFormField(
                                style: CustomTheme.inputTextStyle,
                                decoration: const InputDecoration(hintText: "1-12"),
                                initialValue: _numberOfWeeks,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  final v = int.tryParse('${value?.trim()}');
                                  if (v == null || v < 1 || v > 12) {
                                    return 'Please enter correct value';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  _numberOfWeeks = value;
                                },
                              ),
                              const SizedBox(height: CustomTheme.padding * 2),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Begin date',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: CustomTheme.padding),
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return TextFormField(
                                              key: ValueKey(_startDate),
                                              readOnly: true,
                                              style: CustomTheme.inputTextStyle,
                                              initialValue: DateFormat('dd/MM/yyyy').format(_startDate),
                                              onTap: () async {
                                                final selectedDate = await showDatePicker(
                                                  context: context,
                                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                                  currentDate: _startDate,
                                                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                                                );
                                                if (selectedDate != null) {
                                                  if (context.mounted) {
                                                    _startDate = selectedDate;
                                                    setState(() {});
                                                    FocusScope.of(context).unfocus();
                                                  }
                                                }
                                              },
                                              decoration: InputDecoration(
                                                suffixIcon: Container(
                                                  width: 32,
                                                  height: 32,
                                                  alignment: Alignment.center,
                                                  child: const InsertSvg(CustomIcons.date,
                                                      width: 32, color: CustomTheme.faintColor),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: CustomTheme.padding),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Default time',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(fontWeight: FontWeight.w700),
                                        ),
                                        const SizedBox(height: CustomTheme.padding),
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return TextFormField(
                                              key: ValueKey(_startTime),
                                              readOnly: true,
                                              initialValue: _startTime.format(context),
                                              style: CustomTheme.inputTextStyle,
                                              onTap: () async {
                                                final selectedTime = await showTimePicker(
                                                  context: context,
                                                  initialTime: _startTime,
                                                  initialEntryMode: TimePickerEntryMode.inputOnly,
                                                );
                                                if (selectedTime != null) {
                                                  if (context.mounted) {
                                                    _startTime = selectedTime;
                                                    setState(() {});
                                                  }
                                                }
                                              },
                                              decoration: const InputDecoration(
                                                suffixIcon:
                                                    Icon(Icons.schedule, weight: 32, color: CustomTheme.faintColor),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: CustomTheme.padding * 2),
                            ],
                          ),
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                ],
              ),
              StreamBuilder<int>(
                initialData: _page,
                stream: _pagesStreamController.stream,
                builder: (context, _) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OutlinedButton(
                            onPressed: _processing == false
                                ? () async {
                                    if (_pageIsLast) {
                                      if (!_formKey.currentState!.validate()) {
                                        return;
                                      }

                                      setState(() => _processing = true);
                                      final model = SessionModel(
                                        swimmingStyle: _swimmingStyle,
                                        trainingType: _trainingType,
                                        sessionsPerWeek: int.parse(_sessionsPerWeek),
                                        skillLevel: _skillLevel,
                                        numberOfWeeks: int.parse(_numberOfWeeks),
                                        startAt: _startDate.copyWith(
                                          hour: _startTime.hour,
                                          minute: _startTime.minute,
                                          second: 0,
                                          millisecond: 0,
                                          microsecond: 0,
                                        ),
                                      );
                                      await MainController().generateTrainingSessions(model);
                                      if (!context.mounted) {
                                        return;
                                      }

                                      Navigator.of(context).pop();
                                      showCupertinoDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            content:
                                                const Text('The sessions have been added to the training calendar.'),
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
                                    } else {
                                      _pageViewController.nextPage(
                                          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
                                    }
                                  }
                                : null,
                            child: _processing
                                ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
                                : _pageIsLast
                                    ? const Text('Save')
                                    : const Text('Next'),
                          ),
                          const BottomPaddingIOS(),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectLabel extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final void Function(String value) onTap;
  const SelectLabel({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(title),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding, vertical: CustomTheme.padding / 2),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(isSelected ? 1 : .25)),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
              height: 52,
              width: 52,
              child: InsertSvg(iconPath),
            ),
            const SizedBox(width: CustomTheme.padding),
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.white.withOpacity(isSelected ? 1 : .35))),
          ],
        ),
      ),
    );
  }
}
