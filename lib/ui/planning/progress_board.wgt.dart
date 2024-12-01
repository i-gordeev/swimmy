import 'package:flutter/material.dart';

import '../../controllers/main.ctr.dart';
import '../../theme/custom_theme.dart';

class ProgressBoard extends StatelessWidget {
  const ProgressBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final trainings = MainController().trainings;
    final completedCount = trainings.where((element) => element.completed).length;
    final speedSessions = trainings.where((e) => e.trainingType == 'Speed Improvement');
    final techniqueSessions = trainings.where((e) => e.trainingType == 'Technique Improvement');
    final enduranceSessions = trainings.where((e) => e.trainingType == 'Endurance Improvement');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CustomTheme.padding, horizontal: CustomTheme.padding / 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Progress',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: CustomTheme.padding / 2),
          Text(
            'A total of $completedCount workouts completed.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: CustomTheme.padding),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Speed
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: CustomTheme.color1,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(CustomTheme.padding),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomTheme.bgColor) ??
                          const TextStyle(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 38,
                            child: speedSessions.isEmpty
                                ? const Text('- / -')
                                : Row(
                                    children: [
                                      Text(
                                        speedSessions.where((e) => e.completed).length.toString(),
                                        style: const TextStyle(fontSize: 32, height: 0, fontWeight: FontWeight.w700),
                                      ),
                                      const Text(' / '),
                                      Text(speedSessions.length.toString()),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: CustomTheme.padding / 2),
                          const Text('sessions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                          const SizedBox(height: CustomTheme.padding / 2),
                          const Text('Speed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: CustomTheme.padding / 3),
              // Technique
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: CustomTheme.color2,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(CustomTheme.padding),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomTheme.bgColor) ??
                          const TextStyle(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 38,
                            child: techniqueSessions.isEmpty
                                ? const Text('- / -')
                                : Row(
                                    children: [
                                      Text(
                                        techniqueSessions.where((e) => e.completed).length.toString(),
                                        style: const TextStyle(fontSize: 32, height: 0, fontWeight: FontWeight.w700),
                                      ),
                                      const Text(' / '),
                                      Text(techniqueSessions.length.toString()),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: CustomTheme.padding / 2),
                          const Text('sessions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                          const SizedBox(height: CustomTheme.padding / 2),
                          const Text('Technique', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: CustomTheme.padding / 3),
              // Endurance
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: CustomTheme.color3,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(CustomTheme.padding),
                    child: DefaultTextStyle(
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CustomTheme.bgColor) ??
                          const TextStyle(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            height: 38,
                            child: enduranceSessions.isEmpty
                                ? const Text('- / -')
                                : Row(
                                    children: [
                                      Text(
                                        enduranceSessions.where((e) => e.completed).length.toString(),
                                        style: const TextStyle(fontSize: 32, height: 0, fontWeight: FontWeight.w700),
                                      ),
                                      const Text(' / '),
                                      Text(enduranceSessions.length.toString()),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: CustomTheme.padding / 2),
                          const Text('sessions', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                          const SizedBox(height: CustomTheme.padding / 2),
                          const Text('Endurance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
