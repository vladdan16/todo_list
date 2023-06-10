import 'todo.dart';

final class TaskDatabase {
  static final _database = TaskDatabase._internal();

  final List<ToDo> _tasks = [];
  int _completed = 0;

  factory TaskDatabase() {
    return _database;
  }

  TaskDatabase._internal();

  void addTask(ToDo task) {
    _tasks.add(task);
  }

  void modifyTask(
    int id, {
    String? name,
    String? description,
    bool? done,
    bool? importance,
    DateTime? deadline,
  }) {
    var task = _tasks[id];
    if (done != null) {
      if (done && !task.done) {
        _completed++;
      } else if (!done && task.done) {
        _completed--;
      }
    }
    task.name = name ?? task.name;
    task.description = description ?? task.description;
    task.done = done ?? task.done;
    task.importance = importance ?? task.importance;
    task.deadline = deadline ?? task.deadline;
  }

  List<ToDo> get tasks {
    return _tasks;
  }

  int get completedTasks {
    return _completed;
  }
}
