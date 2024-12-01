import 'package:flutter/material.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import '../shared_widgets/nodata_founded.wgt.dart';
import 'contest_item.wgt.dart';
import 'edit_contest.scr.dart';

class ContestsLayout extends StatelessWidget {
  const ContestsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: StreamBuilder<Object>(
                stream: MainController().contestsStream,
                builder: (context, _) {
                  final items = MainController().contests;

                  if (items.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: items
                          .map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: CustomTheme.padding),
                                child: ContestItem(item: item),
                              ))
                          .toList(),
                    );
                  }

                  return const Center(child: NoDataFounded());
                }),
          ),
          const SizedBox(height: CustomTheme.padding),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const EditContestScreen();
                },
              ));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Create new contest'),
                SizedBox(width: CustomTheme.padding),
                InsertSvg(CustomIcons.plus, width: 32, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
