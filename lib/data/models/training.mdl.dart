import 'session.mdl.dart';

class TrainingModel {
  final String id;
  final SessionModel? session;
  final DateTime startAt;
  final String swimmingStyle;
  final String trainingType;
  final bool completed;
  final int trainingTime;
  final int distance;

  const TrainingModel({
    required this.id,
    required this.session,
    required this.startAt,
    required this.swimmingStyle,
    required this.trainingType,
    required this.completed,
    required this.trainingTime,
    required this.distance,
  });

  bool get isPlaned => startAt.isAfter(DateTime.now());

  Map<String, dynamic> get asMap => {
        'id': id,
        'session': session?.asMap,
        'startAt': startAt.toIso8601String(),
        'swimmingStyle': swimmingStyle,
        'trainingType': trainingType,
        'completed': completed,
        'trainingTime': trainingTime,
        'distance': distance,
      };

  TrainingModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        session = item['session'] != null ? SessionModel.fromMap(item['session']) : null,
        startAt = DateTime.parse(item['startAt']),
        swimmingStyle = item['swimmingStyle'],
        trainingType = item['trainingType'],
        completed = item['completed'],
        trainingTime = item['trainingTime'],
        distance = item['distance'];
}
