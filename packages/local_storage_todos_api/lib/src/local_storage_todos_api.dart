import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_api/todo_api.dart';

const String dbPath = 'todo_database.db';
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
  late TodoProvider todoProvider;
  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  LocalStorageTodosApi._create();

  static Future<LocalStorageTodosApi> create() async {
    var api = LocalStorageTodosApi._create();
    await api._init();
    return api;
  }

  Future<void> _init() async {
    var list = await todoProvider.getAll();
    _todoStreamController.add(list);
  }

  @override
  Stream<List<Todo>> getTodoList() => _todoStreamController.asBroadcastStream();

  @override
  Future<void> saveTodo(Todo todo) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((e) => e.id == todo.id);
    if (todoIndex >= 0) {
      todos[todoIndex] = todo;
    } else {
      todos.add(todo);
    }
    _todoStreamController.add(todos);
    todoProvider.update(todo);
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = [..._todoStreamController.value];
    final todoIndex = todos.indexWhere((e) => e.id == id);
    if (todoIndex == -1) {
      throw Exception('Unable to delete non-existing todo');
    } else {
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
      todoProvider.delete(id);
    }
  }
}
