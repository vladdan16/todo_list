import 'dart:collection';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_repository/todo_repository.dart';

class TaskListModel extends ChangeNotifier {
  final TodoRepository _repository;
  TaskFilter filter;
  late List<Todo> _todos;

  TaskListModel(TodoRepository repository)
      : _repository = repository,
        filter = TaskFilter.all {
    _todos = repository.getTodos();
  }

  UnmodifiableListView<Todo> get todos => UnmodifiableListView(
        filter.applyAll(_todos),
      );

  int get completed {
    // _todos = _repository.getTodos();
    int res = 0;
    for (var e in _todos) {
      if (e.done) res++;
    }
    return res;
  }

  Todo getTodo(String id) {
    return _repository.getTodo(id);
  }

  void changeVisibility() {
    filter = filter == TaskFilter.all ? TaskFilter.active : TaskFilter.all;
    log('TaskListModel: visibility changed');
    notifyListeners();
  }

  void removeTask(Todo task) async {
    _todos.remove(task);
    notifyListeners();
    await _repository.deleteTodo(task.id);
    log('TaskListModel: Task ${task.text} has been removed');
  }

  void toggleDone(Todo task) {
    final index = _todos.indexWhere((e) => e.id == task.id);
    _todos[index] = task.copyWith(done: !task.done);
    notifyListeners();
    saveTask(_todos[index]);
  }

  void saveTask(Todo task) async {
    await _repository.saveTodo(task);
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
