import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../constants.dart';
import '../data/models/contest.mdl.dart';
import '../data/models/notes.mdl.dart';
import '../data/models/session.mdl.dart';
import '../data/models/training.mdl.dart';
import '../data/services/aphud_service.dart';
import '../data/services/notification_service.dart';
import '../data/services/shared_preferences_service.dart';

class MainController {
  static final MainController _instance = MainController._internal();
  factory MainController() => _instance;
  MainController._internal();

  late String localPath;

  final _trainingsStreamController = StreamController<List<TrainingModel>>.broadcast();
  final _contestsStreamController = StreamController<List<ContestModel>>.broadcast();
  final _notesStreamController = StreamController<List<NoteModel>>.broadcast();
  final trainings = <TrainingModel>[];
  final contests = <ContestModel>[];
  final notes = <NoteModel>[];

  bool? _premiumBuyed;

  Stream<List<TrainingModel>> get trainingsStream => _trainingsStreamController.stream;
  Stream<List<ContestModel>> get contestsStream => _contestsStreamController.stream;
  Stream<List<NoteModel>> get notesStream => _notesStreamController.stream;

  bool get isPremiumUser => _premiumBuyed == true;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    localPath = directory.path;

    await AphudService.init(apiKey: apphudApiKey);

    bool isPremium = SharedPreferencesService.getBool('isPremium') ?? false;
    if (isPremium == false) {
      isPremium = await AphudService.userHasProduct(apphudProductId);
      if (isPremium) {
        SharedPreferencesService.setBool('isPremium', true);
      }
    }
    _premiumBuyed = isPremium;

    await Future.wait([
      _loadDataTrainings(),
      _loadDataContests(),
      _loadDataNotes(),
    ]);
  }

  Future<bool> buyPremium() async {
    final result = await AphudService.purchase(productId: apphudProductId);
    _premiumBuyed = result;
    return result;
  }

  Future<bool> restorePremium() async {
    final restoredIds = await AphudService.restorePurchases();
    if (restoredIds.contains(apphudProductId)) {
      _premiumBuyed = true;
      return true;
    }
    return false;
  }

  Future<void> clearAllData() async {
    try {
      final items = Directory(localPath).listSync();
      for (final item in items) {
        item.delete(recursive: true);
      }
    } catch (_) {}

    trainings.clear();
    contests.clear();
    notes.clear();

    _trainingsStreamController.add(trainings);
    _contestsStreamController.add(contests);
    _notesStreamController.add(notes);

    await Future.wait([
      SharedPreferencesService.remove('isPremium'),
      SharedPreferencesService.remove('onboarding'),
      SharedPreferencesService.remove('notify_before'),
    ]);
  }

  Future<void> generateTrainingSessions(SessionModel model) async {
    final trainingDates = <DateTime>[];
    DateTime currentDate = model.startAt;

    List<int> daysOfWeek = () {
      switch (currentDate.weekday) {
        case 1:
          {
            switch (model.sessionsPerWeek) {
              case 1:
                return [1];
              case 2:
                return [1, 4];
              case 3:
                return [1, 3, 5];
              case 4:
                return [1, 2, 4, 5];
              case 5:
                return [1, 2, 3, 4, 5];
              case 6:
                return [1, 2, 3, 4, 5, 6];
              default:
                return [1, 2, 3, 4, 5, 6, 7];
            }
          }
        case 2:
          {
            switch (model.sessionsPerWeek) {
              case 1:
                return [2];
              case 2:
                return [2, 5];
              case 3:
                return [2, 4, 6];
              case 4:
                return [2, 3, 5, 6];
              case 5:
                return [2, 3, 4, 5, 6];
              case 6:
                return [1, 2, 3, 4, 5, 6];
              default:
                return [2, 3, 4, 5, 6, 7, 1];
            }
          }
        case 3:
          {
            switch (model.sessionsPerWeek) {
              case 1:
                return [3];
              case 2:
                return [3, 5];
              case 3:
                return [3, 5, 1];
              case 4:
                return [4, 5, 1, 2];
              case 5:
                return [3, 4, 5, 1, 2];
              case 6:
                return [3, 4, 5, 6, 1, 2];
              default:
                return [3, 4, 5, 6, 7, 1, 2];
            }
          }
        case 4:
          {
            switch (model.sessionsPerWeek) {
              case 1:
                return [4];
              case 2:
                return [4, 2];
              case 3:
                return [4, 6, 2];
              case 4:
                return [4, 5, 1, 2];
              case 5:
                return [4, 5, 1, 2, 3];
              case 6:
                return [4, 5, 6, 1, 2, 3];
              default:
                return [4, 5, 6, 7, 1, 2, 3];
            }
          }
        case 5:
          {
            switch (model.sessionsPerWeek) {
              case 1:
                return [5];
              case 2:
                return [5, 2];
              case 3:
                return [5, 1, 3];
              case 4:
                return [5, 1, 2, 4];
              case 5:
                return [5, 1, 2, 3, 4];
              case 6:
                return [5, 6, 1, 2, 3, 4];
              default:
                return [5, 6, 7, 1, 2, 3, 4];
            }
          }
        case 6:
          {
            switch (model.sessionsPerWeek) {
              case 1:
                return [6];
              case 2:
                return [6, 3];
              case 3:
                return [6, 2, 4];
              case 4:
                return [6, 1, 2, 4];
              case 5:
                return [6, 1, 2, 3, 4];
              case 6:
                return [6, 7, 1, 2, 3, 4];
              default:
                return [6, 7, 1, 2, 3, 4, 5];
            }
          }
        case 7:
          switch (model.sessionsPerWeek) {
            case 1:
              return [7];
            case 2:
              return [7, 3];
            case 3:
              return [7, 2, 4];
            case 4:
              return [7, 1, 4, 5];
            case 5:
              return [7, 1, 2, 4, 5];
            case 6:
              return [7, 1, 2, 3, 4, 5];
            default:
              return [7, 1, 2, 3, 4, 5, 6];
          }
      }
      return [1, 2, 3, 4, 5, 6, 7];
    }();

    // Генерация тренировочных дней
    final weeks = model.numberOfWeeks;
    final trainingDaysPerWeek = model.sessionsPerWeek;
    for (int i = 0; i < weeks; i++) {
      // Для каждой недели
      for (int j = 0; j < trainingDaysPerWeek; j++) {
        // Находим ближайший день недели из daysOfWeek
        int targetDay = daysOfWeek[j % daysOfWeek.length];
        DateTime nextTrainingDay = currentDate;

        // Находим следующее вхождение нужного дня недели
        while (nextTrainingDay.weekday != targetDay) {
          nextTrainingDay = nextTrainingDay.add(const Duration(days: 1));
        }

        // Добавляем дату тренировки
        trainingDates.add(nextTrainingDay);

        // Переводим currentDate на следующий день после тренировки
        currentDate = nextTrainingDay.add(const Duration(days: 1));
      }
    }

    final trainingDuration = () {
      if (model.skillLevel == 'Intermediate') return 45;
      if (model.skillLevel == 'Advanced') return 60;
      return 30;
    }();

    final distance = () {
      if (model.skillLevel == 'Intermediate') return 1000;
      if (model.skillLevel == 'Advanced') return 3000;
      return 300;
    }();

    for (final date in trainingDates) {
      final item = TrainingModel(
        id: const Uuid().v1(),
        session: model,
        startAt: date,
        swimmingStyle: model.swimmingStyle,
        trainingType: model.trainingType,
        completed: false,
        trainingTime: trainingDuration,
        distance: distance,
      );
      trainings.add(item);
    }
    _trainingsStreamController.sink.add(trainings);
    await _saveDataTrainings();
  }

  Future<void> _loadDataTrainings() async {
    final file = File('$localPath/trainings.json');
    if (file.existsSync()) {
      try {
        final data = await file.readAsString();
        final json = jsonDecode(data);
        for (final jsonItem in json) {
          final item = TrainingModel.fromMap(jsonItem);
          trainings.add(item);
        }
      } catch (_) {}
    }
  }

  Future<void> _saveDataTrainings() async {
    try {
      final file = File('$localPath/trainings.json');
      await file.writeAsString(jsonEncode(trainings.map((e) => e.asMap).toList()));
    } catch (_) {}
  }

  Future<void> saveTraining(TrainingModel model) async {
    final index = trainings.indexWhere((element) => element.id == model.id);
    if (index > -1) {
      trainings[index] = model;
    } else {
      trainings.add(model);
    }

    _trainingsStreamController.sink.add(trainings);
    await _saveDataTrainings();
    createNotifications();
  }

  Future<void> deleteTraining(TrainingModel model) async {
    trainings.removeWhere((element) => element.id == model.id);

    _trainingsStreamController.sink.add(trainings);
    await _saveDataTrainings();
  }

  /////////////////////////////

  Future<void> _loadDataContests() async {
    final file = File('$localPath/contests.json');
    if (file.existsSync()) {
      try {
        final data = await file.readAsString();
        final json = jsonDecode(data);
        for (final jsonItem in json) {
          final item = ContestModel.fromMap(jsonItem);
          contests.add(item);
        }
      } catch (_) {}
    }
  }

  Future<void> _saveDataContests() async {
    try {
      final file = File('$localPath/contests.json');
      await file.writeAsString(jsonEncode(contests.map((e) => e.asMap).toList()));
    } catch (_) {}
  }

  Future<void> saveContest(ContestModel model) async {
    final index = contests.indexWhere((element) => element.id == model.id);
    if (index > -1) {
      contests[index] = model;
    } else {
      contests.add(model);
    }

    _contestsStreamController.sink.add(contests);
    await _saveDataContests();
  }

  Future<void> deleteContest(ContestModel model) async {
    contests.removeWhere((element) => element.id == model.id);

    _contestsStreamController.sink.add(contests);
    await _saveDataContests();
  }

  /////////////////////////////

  Future<void> _loadDataNotes() async {
    final file = File('$localPath/notes.json');
    if (file.existsSync()) {
      try {
        final data = await file.readAsString();
        final json = jsonDecode(data);
        for (final jsonItem in json) {
          final item = NoteModel.fromMap(jsonItem);
          notes.add(item);
        }
      } catch (_) {}
    }
  }

  Future<void> _saveDataNotes() async {
    try {
      final file = File('$localPath/notes.json');
      await file.writeAsString(jsonEncode(notes.map((e) => e.asMap).toList()));
    } catch (_) {}
  }

  Future<void> saveNote(NoteModel model) async {
    final index = notes.indexWhere((element) => element.id == model.id);
    if (index > -1) {
      notes[index] = model;
    } else {
      notes.add(model);
    }

    _notesStreamController.sink.add(notes);
    await _saveDataNotes();
  }

  Future<void> deleteNote(NoteModel model) async {
    notes.removeWhere((element) => element.id == model.id);

    _notesStreamController.sink.add(notes);
    await _saveDataNotes();
  }

  Future<bool> savePicture({required String fileName, required List<int> bytes}) async {
    try {
      await File('$localPath/$fileName').writeAsBytes(bytes);
      return true;
    } catch (_) {}
    return false;
  }

  Future<bool> createNotifications() async {
    final beforeAtMinutes = SharedPreferencesService.getInt('notify_before');
    if ((beforeAtMinutes ?? 0) == 0) {
      return false;
    }

    final permission = await NotificationService.requestPermissions();
    if (permission != true) {
      return false;
    }

    await NotificationService.deleteAllScheduledNotification();

    final now = DateTime.now();
    final items = trainings.where((item) {
      if (item.isPlaned == false || item.completed == true) {
        return false;
      }

      if (item.startAt.subtract(Duration(minutes: beforeAtMinutes! + 5)).isAfter(now)) {
        return true;
      }
      return false;
    }).toList();

    if (items.isNotEmpty) {
      items.sort((a, b) {
        if (a.startAt == b.startAt) return 0;
        return a.startAt.isAfter(b.startAt) ? 1 : -1;
      });

      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        NotificationService.createScheduledNotification(
          id: item.id.hashCode,
          title: 'Swimmy notifies',
          body: 'You have a training session in $beforeAtMinutes minutes.',
          showAt: item.startAt.subtract(Duration(minutes: beforeAtMinutes!)),
        );
        if (i > 30) break;
      }
    }

    return true;
  }
}
