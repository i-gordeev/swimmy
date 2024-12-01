import 'dart:io';

import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class BottomPaddingIOS extends StatelessWidget {
  const BottomPaddingIOS({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS && MediaQuery.of(context).viewInsets.bottom == 0) {
      return const SizedBox(height: CustomTheme.defaultIOSbottomPadding);
    }
    return const SizedBox();
  }
}
