import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:todo_api/todo_api.dart';

class TodoRepository {
  final TodoApi _todoApiLocal;
  final TodoApi _todoApiRemote;
  late int _revision;
  final Connectivity connectivity;

  List<Todo> _curList;

  TodoRepository._({
    required TodoApi todoApiLocal,
    required TodoApi todoApiRemote,
  })  : _todoApiLocal = todoApiLocal,
        _todoApiRemote = todoApiRemote,
        _curList = const [],
        connectivity = Connectivity();

  static Future<TodoRepository> create({
    required TodoApi todoApiLocal,
    required TodoApi todoApiRemote,
  }) async {
    var repo = TodoRepository._(
      todoApiLocal: todoApiLocal,
      todoApiRemote: todoApiRemote,
    );
    await repo._init();
    return repo;
  }

  Future<void> _init() async {
    await syncDataToServer();
    connectivity.onConnectivityChanged.listen((event) {
      if (event != ConnectivityResult.none) {
        syncDataToServer();
      }
    });
    log('Repository: Initialization complete');
  }

  List<Todo> getTodos() => _curList;

  Todo getTodo(String id) {
    return _curList.firstWhere((element) => element.id == id);
  }

  Future<void> saveTodo(Todo todo) async {
    try {
      final todos = [..._curList];
      final todoIndex = todos.indexWhere((e) => e.id == todo.id);
      if (todoIndex >= 0) {
        todos[todoIndex] = todo;
      } else {
        todos.add(todo);
      }

      _curList = todos;

      _revision = await _todoApiRemote.saveTodo(todo, _revision);
      _revision = await _todoApiLocal.saveTodo(todo, _revision);

      log('Repository: task has been saved');
    } on SocketException {
      log('Repository: Unable to save task, using local data, Socket exception');
      _revision = await _todoApiLocal.saveTodo(todo, _revision);
    } on TimeoutException {
      log('Repository: Unable to save task, using local data, Server timeout');
      _revision = await _todoApiLocal.saveTodo(todo, _revision);
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final todos = [..._curList];
      final todoIndex = todos.indexWhere((e) => e.id == id);
      todos.removeAt(todoIndex);
      _curList = todos;

      var (_, revision) = await _todoApiRemote.deleteTodo(id, _revision);
      _revision = revision;
      (_, revision) = await _todoApiLocal.deleteTodo(id, _revision);
      _revision = revision;

      log('Repository: task has been deleted');
    } on SocketException {
      log('Repository: Unable to delete task, using local data, Socket exception');
      var (_, revision) = await _todoApiLocal.deleteTodo(id, _revision);
      _revision = revision;
    } on TimeoutException {
      log('Repository: Unable to delete task, using local data, Timeout exception');
      var (_, revision) = await _todoApiLocal.deleteTodo(id, _revision);
      _revision = revision;
    }
  }

  Future<void> syncDataToServer() async {
    try {
      var (localList, localRevision) = await _todoApiLocal.getTodoList();
      var (remoteList, remoteRevision) =
          await _todoApiRemote.patchList(localList, localRevision);
      (localList, localRevision) =
          await _todoApiLocal.patchList(remoteList, remoteRevision);

      _curList = localList;
      _revision = localRevision;

      log('Repository: all data was synced to server');
    } on SocketException {
      log('Repository: Failed to sync data with server, using local data, Socket exception');
      var (localList, localRevision) = await _todoApiLocal.getTodoList();
      _curList = localList;
      _revision = localRevision;
    } on TimeoutException {
      log('Repository: Failed to sync data with server, using local data, Timeout exception');
      var (localList, localRevision) = await _todoApiLocal.getTodoList();
      _curList = localList;
      _revision = localRevision;
    }
  }
}
