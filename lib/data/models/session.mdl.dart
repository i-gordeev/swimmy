class SessionModel {
  final String swimmingStyle;
  final String trainingType;
  final int sessionsPerWeek;
  final String skillLevel;
  final int numberOfWeeks;
  final DateTime startAt;

  const SessionModel({
    required this.swimmingStyle,
    required this.trainingType,
    required this.sessionsPerWeek,
    required this.skillLevel,
    required this.numberOfWeeks,
    required this.startAt,
  });

  Map<String, dynamic> get asMap => {
        'swimmingStyle': swimmingStyle,
        'trainingType': trainingType,
        'sessionsPerWeek': sessionsPerWeek,
        'skillLevel': skillLevel,
        'numberOfWeeks': numberOfWeeks,
        'startAt': startAt.toIso8601String(),
      };

  SessionModel.fromMap(Map<String, dynamic> item)
      : swimmingStyle = item['swimmingStyle'],
        trainingType = item['trainingType'],
        sessionsPerWeek = item['sessionsPerWeek'],
        skillLevel = item['skillLevel'],
        numberOfWeeks = item['numberOfWeeks'],
        startAt = DateTime.parse(item['startAt']);
}
