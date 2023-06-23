import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:todo_api/todo_api.dart';

class RemoteStorageTodosApi implements TodoApi {
  final _backendClient = BackendClient();

  RemoteStorageTodosApi();

  @override
  Future<(List<Todo>, int)> getTodoList() {
    return _backendClient.getAll();
  }

  @override
  Future<(Todo, int)> getTodo(String id) {
    return _backendClient.getTodo(id);
  }

  @override
  Future<int> saveTodo(Todo todo, int revision) async {
    try {
      var (_, _) = await _backendClient.getTodo(todo.id);
      var (_, newRevision) = await _backendClient.updateTodo(todo);
      return newRevision;
    } on NotFoundException catch (_, e) {
      var (_, newRevision) = await _backendClient.insert(todo, revision);
      return newRevision;
    }
  }

  @override
  Future<(Todo, int)> deleteTodo(String id, int revision) {
    return _backendClient.deleteTodo(id, revision);
  }

  @override
  Future<(List<Todo>, int)> patchList(List<Todo> list, int revision) {
    return _backendClient.updateAll(list, revision);
  }
}
