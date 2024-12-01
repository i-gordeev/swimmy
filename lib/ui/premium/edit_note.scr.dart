import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/main.ctr.dart';
import '../../data/models/notes.mdl.dart';
import '../../data/services/image_service.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/bottom_padding_ios.wgt.dart';
import '../shared_widgets/custom_select.wgt.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class EditNoteScreen extends StatefulWidget {
  final NoteModel? item;
  const EditNoteScreen({super.key, this.item});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _editingControllerAddress;
  late final TextEditingController _editingControllerPoolLength;
  late final TextEditingController _editingControllerShowerCondition;
  late final TextEditingController _editingControllerLockerCondition;

  DateTime? _workingFrom;
  DateTime? _workingTo;
  int? _rate;
  List<String> _pictures = [];

  bool _processing = false;

  bool get isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    _editingControllerAddress = TextEditingController(text: widget.item?.address ?? '');
    _editingControllerPoolLength = TextEditingController(text: '${widget.item?.poolLength ?? ''}');
    _editingControllerShowerCondition = TextEditingController(text: widget.item?.showerCondition ?? 'Good');
    _editingControllerLockerCondition = TextEditingController(text: widget.item?.lockerCondition ?? 'Good');

    _workingFrom = widget.item?.workingFrom;
    _workingTo = widget.item?.workingTo;
    _rate = widget.item?.rate ?? 4;
    _pictures = widget.item?.pictures ?? [];
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
            title: Text(isEdit ? 'Edit note' : 'Add new note'),
            actions: isEdit
                ? [
                    IconButton(
                      onPressed: () async {
                        final process = await showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              content: const Text('Are you sure you want to delete the note?'),
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
                          MainController().deleteNote(widget.item!);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      icon: const InsertSvg(CustomIcons.delete, width: 34, color: Colors.white),
                    ),
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
                        title: 'Address',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "Enter address"),
                          controller: _editingControllerAddress,
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
                      StatefulBuilder(
                        builder: (context, setState) {
                          return _FormBlock(
                            key: ValueKey('$_workingFrom$_workingTo'),
                            title: 'Working hours',
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    style: CustomTheme.inputTextStyle,
                                    initialValue: _workingFrom != null
                                        ? TimeOfDay.fromDateTime(_workingFrom!).format(context)
                                        : null,
                                    validator: (value) {
                                      final v = value?.trim();
                                      if (v == null || v.isEmpty) {
                                        return 'Incorrect value';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      final selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime: _workingFrom != null
                                            ? TimeOfDay.fromDateTime(_workingFrom!)
                                            : const TimeOfDay(hour: 9, minute: 0),
                                        initialEntryMode: TimePickerEntryMode.inputOnly,
                                      );
                                      if (selectedTime != null) {
                                        if (context.mounted) {
                                          _workingFrom = DateTime(2000, 1, 1)
                                              .copyWith(hour: selectedTime.hour, minute: selectedTime.minute);
                                        }
                                        setState(() {});
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'From',
                                      suffixIcon: Icon(Icons.schedule, weight: 32, color: CustomTheme.faintColor),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: CustomTheme.padding),
                                Expanded(
                                  child: TextFormField(
                                    readOnly: true,
                                    style: CustomTheme.inputTextStyle,
                                    initialValue:
                                        _workingTo != null ? TimeOfDay.fromDateTime(_workingTo!).format(context) : null,
                                    validator: (value) {
                                      final v = value?.trim();
                                      if (v == null || v.isEmpty) {
                                        return 'Incorrect value';
                                      }
                                      return null;
                                    },
                                    onTap: () async {
                                      final selectedTime = await showTimePicker(
                                        context: context,
                                        initialTime: _workingTo != null
                                            ? TimeOfDay.fromDateTime(_workingTo!)
                                            : const TimeOfDay(hour: 21, minute: 0),
                                        initialEntryMode: TimePickerEntryMode.inputOnly,
                                      );
                                      if (selectedTime != null) {
                                        if (context.mounted) {
                                          _workingTo = DateTime(2000, 1, 1)
                                              .copyWith(hour: selectedTime.hour, minute: selectedTime.minute);
                                        }
                                        setState(() {});
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      hintText: 'To',
                                      suffixIcon: Icon(Icons.schedule, weight: 32, color: CustomTheme.faintColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Pool lane length',
                        child: TextFormField(
                          style: CustomTheme.inputTextStyle,
                          decoration: const InputDecoration(hintText: "Enter length"),
                          controller: _editingControllerPoolLength,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            final v = int.tryParse('${value?.trim()}');
                            if (v == null || v < 0 || v > 10000) {
                              return 'Incorrect value';
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Shower condition',
                        child: CustomSelect(
                          controller: _editingControllerShowerCondition,
                          values: const ['Great', 'Good', 'Fair', 'Poor'],
                          onSelect: (value) {
                            _editingControllerShowerCondition.value = TextEditingValue(text: value);
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Locker condition',
                        child: CustomSelect(
                          controller: _editingControllerLockerCondition,
                          values: const ['Great', 'Good', 'Fair', 'Poor'],
                          onSelect: (value) {
                            _editingControllerLockerCondition.value = TextEditingValue(text: value);
                          },
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Pictures',
                        child: _Pictures(
                            initialPictures: widget.item?.pictures ?? [],
                            onUpdated: (pictures) => _pictures = pictures),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                      _FormBlock(
                        title: 'Rate',
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: _RateStars(
                            value: _rate ?? 5,
                            onChange: (value) {
                              _rate = value;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: CustomTheme.padding),
                    ],
                  )),
            ),
          ), /////////////////

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

                          final model = NoteModel(
                            id: widget.item?.id ?? const Uuid().v1(),
                            address: _editingControllerAddress.text,
                            workingFrom: _workingFrom ?? DateTime.now(),
                            workingTo: _workingTo ?? DateTime.now(),
                            poolLength: int.tryParse(_editingControllerPoolLength.text) ?? 0,
                            showerCondition: _editingControllerShowerCondition.text,
                            lockerCondition: _editingControllerLockerCondition.text,
                            pictures: _pictures,
                            rate: _rate ?? 4,
                          );

                          await MainController().saveNote(model);

                          if (!context.mounted) {
                            return;
                          }

                          Navigator.of(context).pop();
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                content: isEdit
                                    ? const Text('The note have been saved')
                                    : const Text('The note have been added'),
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
  const _FormBlock({required this.title, required this.child, super.key});

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

class _RateStars extends StatefulWidget {
  final int value;
  final void Function(int value) onChange;
  const _RateStars({required this.value, required this.onChange});

  @override
  State<_RateStars> createState() => __RateStarsState();
}

class __RateStarsState extends State<_RateStars> {
  static const _iconSize = 32.0;
  static const _iconPadding = CustomTheme.padding / 3;
  int? _rate;

  void _tapHandler(double x) {
    const size = _iconSize + _iconPadding * 2;

    int rate = (x / size).ceil();

    if (rate < 1) {
      rate = 1;
    }
    if (rate > 5) {
      rate = 5;
    }

    if (_rate != rate) {
      _rate = rate;
      widget.onChange(rate);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _rate = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _tapHandler(details.localPosition.dx);
      },
      onHorizontalDragUpdate: (details) {
        _tapHandler(details.localPosition.dx);
      },
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(5, (i) {
          return Padding(
            padding: EdgeInsets.only(left: i > 0 ? _iconPadding * 2 : 0),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: ((_rate ?? 0) >= (i + 1)) ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              firstChild: const InsertSvg(
                CustomIcons.star,
                width: _iconSize,
                height: _iconSize,
                color: CustomTheme.accentColor,
              ),
              secondChild: const InsertSvg(
                CustomIcons.star,
                width: _iconSize,
                height: _iconSize,
                color: CustomTheme.faintColor,
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _Pictures extends StatefulWidget {
  final List<String> initialPictures;
  final void Function(List<String> pictures) onUpdated;
  const _Pictures({required this.initialPictures, required this.onUpdated});

  @override
  State<_Pictures> createState() => __PicturesState();
}

class __PicturesState extends State<_Pictures> {
  final _main = MainController();
  late final List<String> _pictures;

  @override
  void initState() {
    super.initState();
    _pictures = widget.initialPictures;
  }

  @override
  Widget build(BuildContext context) {
    final picWidth =
        ((MediaQuery.of(context).size.width - CustomTheme.padding * 2 - CustomTheme.padding * 2) / 3).floorToDouble();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_pictures.isNotEmpty) ...[
          Wrap(
            spacing: CustomTheme.padding,
            runSpacing: CustomTheme.padding,
            children: _pictures
                .map(
                  (item) => Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: FileImage(File('${_main.localPath}/$item'))),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    width: picWidth,
                    height: picWidth,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          _pictures.removeWhere((e) => item == e);
                          widget.onUpdated(_pictures);
                          setState(() {});
                        },
                        icon: const InsertSvg(CustomIcons.delete, width: 24, color: Colors.white),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: CustomTheme.padding),
        ],
        Material(
          clipBehavior: Clip.antiAlias,
          color: CustomTheme.formColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: () async {
              final files = await ImageService.pickFromGallery(limit: 10);
              final futures = <Future<String?>>[];
              for (final file in files) {
                futures.add(ImageService.cropAndCompressImage(file: file, sideWidth: 512).then(
                  (bytes) async {
                    if (bytes != null) {
                      final filePath = 'photo-${const Uuid().v1()}.jpg';
                      final success = await _main.savePicture(fileName: filePath, bytes: List<int>.from(bytes));
                      if (success) {
                        return filePath;
                      }
                    }
                    return null;
                  },
                ));
              }
              final results = await Future.wait(futures);
              results.removeWhere((e) => e == null);
              _pictures.addAll(List<String>.from(results));

              widget.onUpdated(_pictures);
              setState(() {});
            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(CustomTheme.padding),
                child: Column(
                  children: [
                    InsertSvg(CustomIcons.picture, width: 32, color: CustomTheme.faintColor),
                    Text(
                      'Upload from Gallery',
                      style: TextStyle(color: CustomTheme.faintColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
