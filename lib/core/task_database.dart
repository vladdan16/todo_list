import 'todo.dart';

final class TaskDatabase {
  static final _database = TaskDatabase._internal();

  final List<ToDo> _tasks = [];
  final List<ToDo> _uncompletedTasks = [];
  int _completed = 0;

  factory TaskDatabase() {
    return _database;
  }

  TaskDatabase._internal() {
    for (int i = 0; i < 30; i++) {
      _tasks.add(ToDo(name: 'Task $i'));
    }
  }

  void addTask(ToDo task) {
    _tasks.add(task);
    _uncompletedTasks.add(task);
  }

  void modifyTask(
    ToDo task, {
    String? name,
    String? description,
    bool? done,
    bool? importance,
    DateTime? deadline,
  }) {
    if (done != null) {
      if (done && !task.done) {
        _completed++;
        uncompletedTasks.remove(task);
      } else if (!done && task.done) {
        _completed--;
        uncompletedTasks.add(task);
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

  List<ToDo> get uncompletedTasks {
    return _uncompletedTasks;
  }

  int get completed {
    return _completed;
  }
}
