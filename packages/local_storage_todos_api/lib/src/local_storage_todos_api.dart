import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_api/todo_api.dart';

const String dbPath = 'todo_database.db';
const String tableRevision = 'revision';
const String columnRevision = 'col_revision';
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

  LocalStorageTodosApi._create();

  static Future<LocalStorageTodosApi> create() async {
    var api = LocalStorageTodosApi._create();
    await api._init();
    return api;
  }

  Future<void> _init() async {
    todoProvider = await TodoProvider.create();
  }

  @override
  Future<(List<Todo>, int)> getTodoList() async {
    var list = await todoProvider.getAll();
    var revision = await todoProvider.getRevision();
    return (list, revision);
  }

  @override
  Future<(Todo, int)> getTodo(String id) async {
    var todo = await todoProvider.getTodo(id);
    if (todo == null) {
      throw NotFoundException();
    } else {
      var revision = await todoProvider.getRevision();
      return (todo, revision);
    }
  }

  @override
  Future<int> saveTodo(Todo todo, int revision) async {
    var check = await todoProvider.getTodo(todo.id);
    if (check == null) {
      todoProvider.insert(todo);
    } else {
      todoProvider.update(todo);
    }
    todoProvider.setRevision(revision);
    return revision;
  }

  @override
  Future<(Todo, int)> deleteTodo(String id, int revision) async {
    var check = await todoProvider.getTodo(id);
    if (check == null) {
      throw NotFoundException();
    } else {
      todoProvider.delete(id);
      todoProvider.setRevision(revision);
      return (check, revision);
    }
  }

  @override
  Future<(List<Todo>, int)> patchList(List<Todo> list, int revision) async{
    todoProvider.updateAll(list);
    todoProvider.setRevision(revision);
    var todos = await todoProvider.getAll();
    return (todos, revision);
  }
}
