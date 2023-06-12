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
    for (int i = 0; i < 20; i++) {
      _tasks.add(ToDo(
        name: 'Task $i',
        description: "kahedbrgljkaw kgb ijnbag;LWJH GKJLJR<WIUG WK<J BK<JH KG <HKGJH SJBGKJNBRB KJ<WBG KJ BK<GGKJ<I SGR MNGS< KL BKHEFB S< GBKR BGKRS GKSJNBB KJR;U R<KJ KJBG K;JSN RG;KJNG SE;JEN<G;BGE;<B G;JBN GEK<J< ;GKJBG SEKJBGKJ",
      ));
    }
  }

  void addTask(ToDo task) {
    _tasks.add(task);
    _uncompletedTasks.add(task);
  }

  void removeTask(ToDo task) {
    _tasks.remove(task);
    if (_uncompletedTasks.contains(task)) {
      _uncompletedTasks.remove(task);
    }
  }

  void modifyTask(
    ToDo task, {
    String? name,
    String? description,
    bool? done,
    Importance? importance,
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
