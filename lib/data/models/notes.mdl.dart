class NoteModel {
  final String id;
  final String address;
  final DateTime workingFrom;
  final DateTime workingTo;
  final int poolLength;
  final String showerCondition;
  final String lockerCondition;
  final List<String> pictures;
  final int rate;

  const NoteModel({
    required this.id,
    required this.address,
    required this.workingFrom,
    required this.workingTo,
    required this.poolLength,
    required this.showerCondition,
    required this.lockerCondition,
    required this.pictures,
    required this.rate,
  });

  Map<String, dynamic> get asMap => {
        'id': id,
        'address': address,
        'workingFrom': workingFrom.toIso8601String(),
        'workingTo': workingTo.toIso8601String(),
        'poolLength': poolLength,
        'showerCondition': showerCondition,
        'lockerCondition': lockerCondition,
        'pictures': pictures,
        'rate': rate,
      };

  NoteModel.fromMap(Map<String, dynamic> item)
      : id = item['id'],
        address = item['address'],
        workingFrom = DateTime.parse(item['workingFrom']),
        workingTo = DateTime.parse(item['workingTo']),
        poolLength = item['poolLength'],
        showerCondition = item['showerCondition'],
        lockerCondition = item['lockerCondition'],
        pictures = List<String>.from(item['pictures'] ?? []),
        rate = item['rate'];
}
