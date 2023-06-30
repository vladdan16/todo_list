import 'package:todo_api/todo_api.dart';

/// The interface for an API tht provides access to list of Todo instances
abstract interface class TodoApi {
  const TodoApi();

  /// Provides [List] of all Todo instances
  Future<(List<Todo>, int)> getTodoList();

  /// Provides [Todo] with requested id
  Future<(Todo, int)> getTodo(String id);

  /// Saves a [Todo] or updates todo with same id
  Future<int> saveTodo(Todo todo, int revision);

  /// Deletes [Todo] with given id
  Future<(Todo, int)> deleteTodo(String id, int revision);

  ///Patches [List] of [Todo]
  Future<(List<Todo>, int)> patchList(List<Todo> list, int revision);
}
