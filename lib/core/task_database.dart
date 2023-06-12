import 'dart:convert';
import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'todo.dart';

final class TaskDatabase {
  static final _database = TaskDatabase._internal();

  final logger = Logger();
  static const _dataFileName = 'data.json';

  final List<ToDo> _tasks = [];
  final List<ToDo> _uncompletedTasks = [];
  int _completed = 0;

  factory TaskDatabase() {
    return _database;
  }

  TaskDatabase._internal();

  // TaskDatabase._internal() {
  //   for (int i = 0; i < 20; i++) {
  //     var task = ToDo(
  //       name: 'Task $i',
  //       description: "kahedbrgljkaw kgb ijnbag;LWJH GKJLJR<WIUG WK<J BK<JH KG <HKGJH SJBGKJNBRB KJ<WBG KJ BK<GGKJ<I SGR MNGS< KL BKHEFB S< GBKR BGKRS GKSJNBB KJR;U R<KJ KJBG K;JSN RG;KJNG SE;JEN<G;BGE;<B G;JBN GEK<J< ;GKJBG SEKJBGKJ",
  //     );
  //     _tasks.add(task);
  //     _uncompletedTasks.add(task);
  //   }
  // }

  void addTask(ToDo task) {
    _tasks.add(task);
    _uncompletedTasks.add(task);
    _saveTasks();
  }

  void removeTask(ToDo task) {
    _tasks.remove(task);
    if (_uncompletedTasks.contains(task)) {
      _uncompletedTasks.remove(task);
    }
    _saveTasks();
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
    _saveTasks();
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
