import 'package:todo_api/todo_api.dart';

/// The interface for an API tht provides access to list of Todo instances
abstract interface class TodoApi {
  const TodoApi();

  /// Provides [Stream] of all Todo instances
  Stream<List<Todo>> getTodoList();

  /// Saves a [Todo] or replace todo with same id
  Future<void> saveTodo(Todo todo);

  /// Deletes `todo` with given id
  Future<void> deleteTodo(String id);
}
