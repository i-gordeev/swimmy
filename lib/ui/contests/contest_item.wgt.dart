import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/contest.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import 'edit_contest.scr.dart';

class ContestItem extends StatelessWidget {
  final ContestModel item;
  const ContestItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25), color: CustomTheme.formColor),
      padding: const EdgeInsets.all(CustomTheme.padding),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54) ?? const TextStyle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const InsertSvg(CustomIcons.date, width: 32, color: CustomTheme.faintColor),
                      const SizedBox(width: CustomTheme.padding / 2),
                      Text(DateFormat('MMM dd, yyyy').format(item.date)),
                    ],
                  ),
                ),
                const SizedBox(width: CustomTheme.padding / 2),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const InsertSvg(CustomIcons.place, width: 32, color: CustomTheme.faintColor),
                      const SizedBox(width: CustomTheme.padding / 2),
                      Expanded(
                        child: Text(item.location ?? '-', maxLines: 2, overflow: TextOverflow.fade),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: CustomTheme.padding / 2),
            Text(
              item.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              [(item.result ?? '-'), item.discipline].join(' / '),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: CustomTheme.padding / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text([
                  '${(num.tryParse('${item.time}') ?? '-')} minutes',
                  '${(num.tryParse('${item.distance}') ?? '- ')}m',
                ].join('  ·  ')),
                TextButton.icon(
                  icon: const InsertSvg(CustomIcons.edit, width: 24, color: Colors.white54),
                  onPressed: () async {
                    await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return EditContestScreen(item: item);
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
    );
  }
}
