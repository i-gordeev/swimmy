import 'package:flutter/material.dart';

import '../../theme/custom_pictures.dart';
import '../../theme/custom_theme.dart';
import 'insertsvg.wgt.dart';

class NoDataFounded extends StatelessWidget {
  const NoDataFounded({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width / 2.5;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InsertSvg(CustomPictures.noDataFounded, width: width),
        Text(
          'No data founded',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w700, color: CustomTheme.faintColor),
        ),
      ],
    );
  }
}
