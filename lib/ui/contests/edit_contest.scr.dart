import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/main.ctr.dart';
import '../../data/models/contest.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/bottom_padding_ios.wgt.dart';
import '../shared_widgets/custom_select.wgt.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class EditContestScreen extends StatefulWidget {
  final ContestModel? item;
  const EditContestScreen({super.key, this.item});

  @override
  State<EditContestScreen> createState() => _EditContestScreenState();
}

class _EditContestScreenState extends State<EditContestScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _editingControllerTitle;
  late final TextEditingController _editingControllerLocation;
  late final TextEditingController _editingControllerResult;
  late final TextEditingController _editingControllerDiscipline;
  late final TextEditingController _editingControllerDate;
  late final TextEditingController _editingControllerTime;
  late final TextEditingController _editingControllerDistance;
  late DateTime _date;
  bool _processing = false;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    _editingControllerTitle = TextEditingController(text: widget.item?.title ?? '');
    _editingControllerLocation = TextEditingController(text: widget.item?.location ?? '');
    _editingControllerResult = TextEditingController(text: widget.item?.result ?? '');
    _editingControllerDiscipline = TextEditingController(text: widget.item?.discipline ?? 'Breaststroke Style');
    _editingControllerTime = TextEditingController(text: '${widget.item?.time ?? ''}');
    _editingControllerDistance = TextEditingController(text: '${widget.item?.distance ?? ''}');

    _date = widget.item?.date ?? DateTime.now();
    _editingControllerDate = TextEditingController(text: DateFormat('dd/MM/yyyy').format(_date));
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
            title: Text(isEdit ? 'Edit contest' : 'Create contest'),
            actions: isEdit
                ? [
                    IconButton(
                        onPressed: () async {
                          final process = await showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                content: const Text('Are you sure you want to delete the contest?'),
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
                            MainController().deleteContest(widget.item!);
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
                      _FormBlock(
                        title: 'Title',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "Enter title"),
                          controller: _editingControllerTitle,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final v = value?.trim();
                            if (v == null || v.isEmpty) {
                              return 'Please input correct value';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Date',
                        child: TextFormField(
                          readOnly: true,
                          controller: _editingControllerDate,
                          style: CustomTheme.inputTextStyle,
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              currentDate: _date,
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                            );
                            if (selectedDate != null) {
                              if (context.mounted) {
                                _date = _date.copyWith(
                                  day: selectedDate.day,
                                  month: selectedDate.month,
                                  year: selectedDate.year,
                                  hour: 0,
                                  minute: 0,
                                  second: 0,
                                  microsecond: 0,
                                  millisecond: 0,
                                );
                                _editingControllerDate.text = DateFormat('dd/MM/yyyy').format(_date);
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
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Location',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "Enter location"),
                          controller: _editingControllerLocation,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Result',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "1st place"),
                          controller: _editingControllerResult,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Discipline',
                        child: CustomSelect(
                          controller: _editingControllerDiscipline,
                          values: const ['Breaststroke Style', 'Freestyle (Crawl)', 'Butterfly', 'Backstroke Style'],
                          onSelect: (value) {
                            _editingControllerDiscipline.value = TextEditingValue(text: value);
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Time',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "00"),
                          controller: _editingControllerTime,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value?.isNotEmpty == true) {
                              final v = double.tryParse('${value?.trim()}');
                              if (v == null || v < 0 || v > 1000) {
                                return 'Please input correct value';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Distance',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "00"),
                          controller: _editingControllerDistance,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value?.isNotEmpty == true) {
                              final v = int.tryParse('${value?.trim()}');
                              if (v == null || v < 0 || v > 100000) {
                                return 'Please input correct value';
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                    ],
                  )),
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

                          final model = ContestModel(
                            id: widget.item?.id ?? const Uuid().v1(),
                            title: _editingControllerTitle.text,
                            date: _date,
                            location:
                                _editingControllerLocation.text.isNotEmpty ? _editingControllerLocation.text : null,
                            result: _editingControllerResult.text.isNotEmpty ? _editingControllerResult.text : null,
                            discipline: _editingControllerDiscipline.text,
                            time: double.tryParse(_editingControllerTime.text),
                            distance: int.tryParse(_editingControllerDistance.text),
                          );

                          await MainController().saveContest(model);

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.of(context).pop();
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                content: const Text('The contest have been saved'),
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
  const _FormBlock({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding),
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
