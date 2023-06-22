import 'package:todo_api/todo_api.dart';

const String tableTodo = 'todo';
const String columnId = '_id';
const String columnText = 'text';
const String columnImportance = 'importance';
const String columnDeadline = 'deadline';
const String columnDone = 'done';
const String columnColor = 'color';
const String columnCreatedAt = 'created_at';
const String columnChangedAt = 'changed_at';
const String columnLastUpdatedBy = 'last_updated_by';

class LocalStorageTodosApi implements TodoApi {
  const LocalStorageTodosApi();

  @override
  Future<void> deleteTodo(String id) {
    // TODO: implement deleteTodo
    throw UnimplementedError();
  }

  @override
  Stream<List<Todo>> getTodoList() {
    // TODO: implement getTodoList
    throw UnimplementedError();
  }

  @override
  Future<void> saveTodo(Todo todo) {
    // TODO: implement saveTodo
    throw UnimplementedError();
  }
}
