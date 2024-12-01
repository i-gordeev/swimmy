import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  const OnboardingPage({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CustomTheme.padding * 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: CustomTheme.padding / 2),
          Text(subtitle, style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
