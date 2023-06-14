import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

final class TaskDatabase {
  static final _database = TaskDatabase._internal();

  final logger = Logger();

  final List<ToDo> _tasks = [];
  final List<ToDo> _uncompletedTasks = [];
  int _completed = 0;

  factory TaskDatabase() {
    return _database;
  }

  TaskDatabase._internal();

  void saveTask(ToDo task) {
    if (!_tasks.contains(task)) {
      _tasks.add(task);
      _uncompletedTasks.add(task);
      _saveTasks();
    }
  }

  void removeTask(ToDo task) {
    if (task.done) {
      _completed--;
    }
    _tasks.remove(task);
    if (_uncompletedTasks.contains(task)) {
      _uncompletedTasks.remove(task);
    }
    _saveTasks();
  }

  void modifyTask(
    ToDo task, {
    String? name,
    //String? description,
    bool? done,
    Importance? importance,
    DateTime? deadline,
    bool? hasDeadline,
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
    //task.description = description ?? task.description;
    task.done = done ?? task.done;
    task.importance = importance ?? task.importance;
    task.deadline = deadline ?? task.deadline;
    task.hasDeadline = hasDeadline ?? task.hasDeadline;
    _saveTasks();
  }

  void modifyTaskFromToDo(ToDo task, ToDo newTask) {
    modifyTask(
      task,
      name: newTask.name,
      //description: newTask.description,
      done: newTask.done,
      importance: newTask.importance,
      deadline: newTask.deadline,
      hasDeadline: newTask.hasDeadline,
    );
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

  Future<void> loadTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tasksJson = prefs.getString('tasks');
      if (tasksJson != null) {
        var taskData = jsonDecode(tasksJson) as List;
        for (var e in taskData) {
          ToDo task = ToDo.fromJson(e);
          _tasks.add(task);
          if (task.done) {
            _completed++;
          } else {
            _uncompletedTasks.add(task);
          }
        }
      }
    } catch (e) {
      logger.e("Error while reading file: $e");
    }
  }

  Future<void> _saveTasks() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> tasksData =
          _tasks.map((e) => e.toJson()).toList();
      String tasksJson = jsonEncode(tasksData);
      await prefs.setString('tasks', tasksJson);
    } catch (e) {
      logger.e('Failed to save tasks: $e');
    }
  }
}
