class ContestModel {
  final String id;
  final String title;
  final DateTime date;
  final String? location;
  final String? result;
  final String discipline;
  final double? time;
  final int? distance;

  const ContestModel({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.result,
    required this.discipline,
    required this.time,
    required this.distance,
  });

  Map<String, dynamic> get asMap => {
        'id': id,
        'title': title,
        'date': date.toIso8601String(),
        'location': location,
        'result': result,
        'discipline': discipline,
        'time': time,
        'distance': distance,
      };

  ContestModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        title = item['title'],
        date = DateTime.parse(item['date']),
        location = item['location'],
        result = item['result'],
        discipline = item['discipline'],
        time = item['time'],
        distance = item['distance'];
}
