import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_api/todo_api.dart';

class LocalStorageTodosApi implements TodoApi {
  final SharedPreferences prefs;

  LocalStorageTodosApi(this.prefs);

  @override
  Future<(List<Todo>, int)> getTodoList() async {
    var listJson = prefs.getString('todos');
    var list = (listJson == null ? <Todo>[] : jsonDecode(listJson))
        .map<Todo>((todoJson) => Todo.fromJson(todoJson))
        .toList() as List<Todo>;
    var revision = prefs.getInt('revision') ?? 0;
    return (list, revision);
  }

  @override
  Future<(Todo, int)> getTodo(String id) async {
    try {
      var (list, revision) = await getTodoList();
      var todo = list.firstWhere((todo) => todo.id == id);
      return (todo, revision);
    } on StateError {
      throw NotFoundException();
    }
  }

  @override
  Future<int> saveTodo(Todo todo, int revision) async {
    var (list, _) = await getTodoList();
    var index = list.indexWhere((oldTodo) => oldTodo.id == todo.id);
    if (index == -1) {
      list.add(todo);
    } else {
      list[index] = todo;
    }
    await _saveTodoList(list, revision);
    return revision;
  }

  @override
  Future<(Todo, int)> deleteTodo(String id, int revision) async {
    var (list, _) = await getTodoList();
    var index = list.indexWhere((oldTodo) => oldTodo.id == id);
    if (index == -1) {
      throw NotFoundException();
    } else {
      var deletedTodo = list.removeAt(index);
      await _saveTodoList(list, revision);
      return (deletedTodo, revision);
    }
  }

  @override
  Future<(List<Todo>, int)> patchList(List<Todo> list, int revision) async {
    await _saveTodoList(list, revision);
    List<Todo> todos;
    (todos, revision) = await getTodoList();
    return (todos, revision);
  }

  Future<void> _saveTodoList(List<Todo> list, int revision) async {
    await prefs.setString('todos', json.encode(list.map((todo) => todo.toJson()).toList()));
    await prefs.setInt('revision', revision);
  }
}
