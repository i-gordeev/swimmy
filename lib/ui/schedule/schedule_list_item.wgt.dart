import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/training.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_pictures.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import 'edit_training.scr.dart';

class ScheduleListItem extends StatelessWidget {
  final TrainingModel item;
  const ScheduleListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final picture = () {
      switch (item.swimmingStyle) {
        case 'Breaststroke Style':
          return CustomPictures.styleBreaststroke;
        case 'Backstroke Style':
          return CustomPictures.styleBackstroke;
        case 'Butterfly':
          return CustomPictures.styleButterfly;
      }
      return CustomPictures.styleFreestyle;
    }();
    return Container(
      padding: const EdgeInsets.all(CustomTheme.padding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: CustomTheme.formColor),
      child: Column(
        children: [
          Row(
            children: [
              InsertSvg(picture, width: 64),
              const SizedBox(width: CustomTheme.padding * 2),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.swimmingStyle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: CustomTheme.padding / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd MMM. yyyy, HH:mm').format(item.startAt),
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(width: CustomTheme.padding / 2),
                        Builder(
                          builder: (context) {
                            String? label;
                            Color? color;

                            if (item.isPlaned == false) {
                              color = item.completed ? CustomTheme.successColor : CustomTheme.warningColor;
                              label = item.completed ? 'Completed' : 'Missed';
                            } else {
                              color = Colors.white54;
                              label = 'Planed';
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding / 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: color,
                              ),
                              child: Text(
                                label,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: CustomTheme.padding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Builder(
                          builder: (context) {
                            Color? color;
                            String? label;

                            switch (item.trainingType) {
                              case 'Speed Improvement':
                                {
                                  color = CustomTheme.color1;
                                  label = 'Speed';
                                }
                                break;
                              case 'Technique Improvement':
                                {
                                  color = CustomTheme.color2;
                                  label = 'Technique';
                                }
                                break;
                              case 'Endurance Improvement':
                                {
                                  color = CustomTheme.color3;
                                  label = 'Endurance';
                                }
                                break;
                              default:
                                {
                                  color = CustomTheme.color4;
                                  label = item.trainingType;
                                }
                            }
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(color: color),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: CustomTheme.padding, vertical: CustomTheme.padding / 2),
                              child: Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
                            );
                          },
                        ),
                        const SizedBox(width: CustomTheme.padding / 2),
                        TextButton.icon(
                          icon: const InsertSvg(CustomIcons.edit, width: 24, color: Colors.white54),
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return EditTrainingScreen(item: item);
                              },
                            ));
                          },
                          label: const Text('Edit', style: TextStyle(color: Colors.white54)),
                          style: TextButton.styleFrom(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
