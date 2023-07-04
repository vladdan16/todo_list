import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:todo_api/todo_api.dart';

class RemoteStorageTodosApi implements TodoApi {
  final BackendClient _backendClient;

  RemoteStorageTodosApi(BackendClient client) : _backendClient = client;

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
      var (_, newRevision) = await _backendClient.updateTodo(todo, revision);
      return newRevision;
    } on NotFoundException catch (_, __) {
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
