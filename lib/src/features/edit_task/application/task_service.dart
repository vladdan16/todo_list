import 'package:logger/logger.dart';

import '../../../core/task_database.dart';
import '../../../core/todo.dart';

final class TaskService {
  final _database = TaskDatabase();
  final ToDo task;
  final bool newTask;
  late final ToDo curTask;
  var logger = Logger();

  TaskService(this.task, this.newTask) {
    if (newTask) {
      curTask = task;
    } else {
      curTask = ToDo.copyWith(task);
    }
  }

  bool saveTaskText(String text) {
    curTask.name = text;
    if (!newTask) _database.modifyTaskFromToDo(task, curTask);
    return task.name == '';
  }

  void saveTask() {
    _database.saveTask(task);
  }

  void removeTask() {
    _database.removeTask(task);
  }
}
