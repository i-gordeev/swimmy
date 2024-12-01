import 'package:flutter/material.dart';

import '../../controllers/main.ctr.dart';
import '../../data/models/training.mdl.dart';
import '../../theme/custom_icons.dart';
import '../../theme/custom_theme.dart';
import '../shared_widgets/insertsvg.wgt.dart';
import '../shared_widgets/nodata_founded.wgt.dart';
import 'create_new_session.scr.dart';
import 'progress_board.wgt.dart';

class PlanningLayout extends StatelessWidget {
  const PlanningLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<List<TrainingModel>>(
                stream: MainController().trainingsStream,
                initialData: MainController().trainings,
                builder: (context, snapshot) {
                  final items = snapshot.data ?? [];

                  if (items.isNotEmpty) {
                    return ProgressBoard(key: UniqueKey());
                  }

                  return const Center(
                    child: NoDataFounded(),
                  );
                }),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) {
                  return const CreateNewSessionScreen();
                },
              ));
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Create new session'),
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
