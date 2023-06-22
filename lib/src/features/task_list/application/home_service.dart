import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/task_database.dart';
import '../../../core/todo.dart';

final class HomeService {
  final _database = TaskDatabase();
  final logger = Logger();
  final SharedPreferences prefs;
  late bool showCompleteTasks;
  late List<ToDo> tasks;

  HomeService(this.prefs) {
    showCompleteTasks = prefs.getBool('show_completed_tasks') ?? true;
    tasks = showCompleteTasks ? _database.tasks : _database.uncompletedTasks;
  }

  void changeVisibility() {
    showCompleteTasks = !showCompleteTasks;
    tasks = showCompleteTasks ? _database.tasks : _database.uncompletedTasks;
    logger.i(
        "Toggle visibility button. Show completed tasks: $showCompleteTasks");
  }

  void removeTask(ToDo task) {
    _database.removeTask(task);
  }

  void modifyTask(
    ToDo task, {
    String? name,
    bool? done,
    Importance? importance,
    DateTime? deadline,
    bool? hasDeadline,
  }) {
    _database.modifyTask(
      task,
      name: name,
      done: done,
      importance: importance,
      deadline: deadline,
      hasDeadline: hasDeadline,
    );
  }

  int get completed {
    return _database.completed;
  }
}
