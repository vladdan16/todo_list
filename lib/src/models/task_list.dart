import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_repository/todo_repository.dart';

class TaskListModel extends ChangeNotifier {
  final TodoRepository _repository;
  final AnalyticsLogger _logger;
  TaskFilter filter;
  late List<Todo> _todos;

  TaskListModel(TodoRepository repository, AnalyticsLogger logger)
      : _repository = repository,
        _logger = logger,
        filter = TaskFilter.all {
    _todos = repository.getTodos();
  }

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(
        filter.applyAll(_todos),
      );

  int get completed {
    int res = 0;
    for (var e in _todos) {
      if (e.done) res++;
    }
    return res;
  }

  Todo? getTodo(String id) {
    return _repository.getTodo(id);
  }

  void changeVisibility() {
    filter = filter == TaskFilter.all ? TaskFilter.active : TaskFilter.all;
    log('TaskListModel: visibility changed');
    notifyListeners();
  }

  void removeTask(Todo task) async {
    _todos.remove(task);
    _logger.logRemoveTask();
    notifyListeners();
    await _repository.deleteTodo(task.id);
    log('TaskListModel: Task ${task.text} has been removed');
  }

  void toggleDone(Todo task) {
    final index = _todos.indexWhere((e) => e.id == task.id);
    _todos[index] = task.copyWith(done: !task.done);
    _logger.logToggleTask();
    notifyListeners();
    saveTask(_todos[index]);
  }

  void saveTask(Todo task) async {
    var isNew = await _repository.saveTodo(task);
    if (isNew) _logger.logAddTask();
    _todos = _repository.getTodos();
    log('TaskListModel: Task ${task.text} has been saved');
    notifyListeners();
  }

  Future<void> refresh() async {
    await _repository.syncDataToServer();
    _todos = _repository.getTodos();
    notifyListeners();
    log('TaskListModel: task list was refreshed');
  }
}
