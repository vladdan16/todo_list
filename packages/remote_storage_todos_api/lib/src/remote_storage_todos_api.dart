import 'package:rxdart/rxdart.dart';
import 'package:todo_api/todo_api.dart';

class RemoteStorageTodosApi implements TodoApi {
  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  RemoteStorageTodosApi();

  @override
  Stream<List<Todo>> getTodoList() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) async {

  }

  @override
  Future<void> deleteTodo(String id) {
    // TODO: implement deleteTodo
    throw UnimplementedError();
  }
}
