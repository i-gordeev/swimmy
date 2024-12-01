import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';
import 'progress_chart_block_distance.wgt.dart';
import 'progress_chart_block_time.wgt.dart';

class ProgressLayout extends StatelessWidget {
  const ProgressLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ProgressChartBlockDistance(),
        SizedBox(height: CustomTheme.padding * 3),
        ProgressChartBlockTime(),
      ],
    );
  }
}
