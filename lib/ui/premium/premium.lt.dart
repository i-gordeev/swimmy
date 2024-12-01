import 'package:flutter/material.dart';

import '../../theme/custom_theme.dart';
import 'edit_note.scr.dart';
import 'premium_notes_list.wgt.dart';
import 'premium_nutrition.wgt.dart';
import 'trauma_prevention.wgt.dart';

class PremiumLayout extends StatelessWidget {
  const PremiumLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Notes',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: CustomTheme.padding),
        const PremiumNotesList(),
        const SizedBox(height: CustomTheme.padding),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const EditNoteScreen();
              },
            ));
          },
          child: const Text('Add new note'),
        ),
        const SizedBox(height: CustomTheme.padding * 2),
        Text(
          'Nutrition',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: CustomTheme.padding),
        const PremiumNutrition(),
        const SizedBox(height: CustomTheme.padding * 2),
        Text(
          'Trauma prevention',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: CustomTheme.padding),
        const TraumaPrevention(),
      ],
    );
  }
}
