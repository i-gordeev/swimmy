import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class ProgressChart extends StatelessWidget {
  final Map<String, dynamic> bars;
  const ProgressChart({super.key, required this.bars});

  LinearGradient get _barsGradient => LinearGradient(
        colors: [CustomTheme.primaryColor, CustomTheme.bgColor.withOpacity(.5)],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  @override
  Widget build(BuildContext context) {
    final maxValue = () {
      int max = bars.values.reduce((a, b) => a > b ? a : b);
      while (max % 10 != 0) {
        max++;
      }
      if (max == 0) {
        max = 100;
      }
      return max;
    }();

    final titlesTextStyle = Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white54, height: 0);
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: maxValue.toDouble(),
              gridData: const FlGridData(show: true, drawVerticalLine: false),
              alignment: BarChartAlignment.spaceEvenly,
              barTouchData: BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24,
                    getTitlesWidget: (value, meta) {
                      final md = bars.length <= 7 ? 1 : 3;
                      if (value % md > 0) return const SizedBox();

                      final text = () {
                        return bars.keys.elementAtOrNull(value.toInt()) ?? '';
                      }();

                      const angle = pi / 4;
                      return SideTitleWidget(
                        angle: angle,
                        axisSide: meta.axisSide,
                        space: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, top: 10 * angle),
                          child: Text(text, style: titlesTextStyle),
                        ),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: maxValue < 500
                        ? maxValue < 100
                            ? 10
                            : 100
                        : null,
                    getTitlesWidget: (value, meta) {
                      return Padding(
                        padding: const EdgeInsets.only(right: CustomTheme.padding / 2),
                        child: Text(
                          '${value.toInt()}',
                          textAlign: TextAlign.right,
                          style: titlesTextStyle,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (int i = 0; i < bars.values.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      (bars.values.elementAt(i) > 0)
                          ? BarChartRodData(
                              width: bars.values.length <= 7 ? 15 : 7.5,
                              borderRadius: BorderRadius.circular(3),
                              toY: bars.values.elementAt(i).toDouble(),
                              gradient: _barsGradient,
                            )
                          : BarChartRodData(
                              width: bars.values.length <= 7 ? 15 : 7.5,
                              borderRadius: BorderRadius.circular(3),
                              toY: maxValue / 20,
                              color: CustomTheme.formColor,
                            ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
