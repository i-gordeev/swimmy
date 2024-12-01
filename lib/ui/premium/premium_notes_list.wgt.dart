import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import 'edit_note.scr.dart';

class PremiumNotesList extends StatefulWidget {
  const PremiumNotesList({super.key});

  @override
  State<PremiumNotesList> createState() => _PremiumNotesListState();
}

class _PremiumNotesListState extends State<PremiumNotesList> {
  final _main = MainController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _main.notesStream.listen((_) {
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
    final items = _main.notes;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: CustomTheme.padding / 2),
        child: Text(
          'No results.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1, color: Colors.white70),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(CustomTheme.padding),
          decoration: BoxDecoration(
            color: CustomTheme.formColor,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        item.address,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700, height: 1.25),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: CustomTheme.padding),
                  Wrap(
                    children: List.generate(
                      item.rate,
                      (index) {
                        return const InsertSvg(CustomIcons.star, color: CustomTheme.accentColor, width: 24);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: CustomTheme.padding),
              DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium ?? const TextStyle(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Working hours', style: TextStyle(color: Colors.white54)),
                        const SizedBox(width: CustomTheme.padding),
                        Text(
                          '${TimeOfDay.fromDateTime(item.workingFrom).format(context)} - ${TimeOfDay.fromDateTime(item.workingTo).format(context)}',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: CustomTheme.padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pool lane length', style: TextStyle(color: Colors.white54)),
                        const SizedBox(width: CustomTheme.padding),
                        Text(
                          '${item.poolLength} meters',
                          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: CustomTheme.padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Shower', style: TextStyle(color: Colors.white54)),
                        const SizedBox(width: CustomTheme.padding),
                        Text(
                          item.showerCondition,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: () {
                                switch (item.showerCondition) {
                                  case 'Fair':
                                    return Colors.amber;
                                  case 'Poor':
                                    return Colors.red;
                                  default:
                                    return CustomTheme.accentColor;
                                }
                              }()),
                        ),
                      ],
                    ),
                    const SizedBox(height: CustomTheme.padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Locker', style: TextStyle(color: Colors.white54)),
                        const SizedBox(width: CustomTheme.padding),
                        Text(
                          item.lockerCondition,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: () {
                                switch (item.lockerCondition) {
                                  case 'Fair':
                                    return Colors.amber;
                                  case 'Poor':
                                    return Colors.red;
                                  default:
                                    return CustomTheme.accentColor;
                                }
                              }()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: CustomTheme.padding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(
                    builder: (context) {
                      const sideWith = 55.0;
                      const count = 3;
                      final images =
                          item.pictures.take(item.pictures.length > count ? count : item.pictures.length).toList();
                      while (images.length < 3) {
                        images.add('');
                      }

                      return SizedBox(
                        width: sideWith * count,
                        height: sideWith,
                        child: Stack(
                          children: [
                            for (int i = (images.length - 1); i >= 0; i--)
                              Positioned(
                                left: sideWith * .75 * i,
                                child: Container(
                                  width: sideWith,
                                  height: sideWith,
                                  decoration: BoxDecoration(
                                    image: images[i].isNotEmpty
                                        ? DecorationImage(image: FileImage(File('${_main.localPath}/${images[i]}')))
                                        : null,
                                    color: images[i].isEmpty ? CustomTheme.faintColor : null,
                                    borderRadius: BorderRadius.circular(sideWith / 2),
                                    border: Border.all(color: CustomTheme.formColor, width: 2),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: CustomTheme.padding),
                  TextButton.icon(
                    icon: const InsertSvg(CustomIcons.edit, width: 24, color: Colors.white54),
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return EditNoteScreen(item: item);
                        },
                      ));
                    },
                    label: const Text('Edit', style: TextStyle(color: Colors.white54)),
                    style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                  )
                ],
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: CustomTheme.padding),
      itemCount: items.length,
    );
  }
}
