import 'package:rxdart/rxdart.dart';
import 'package:todo_api/todo_api.dart';

class TodoRepository {
  final TodoApi _todoApiLocal;
  final TodoApi _todoApiRemote;
  late int _revision;

  final _todoStreamController = BehaviorSubject<List<Todo>>.seeded(const []);

  TodoRepository._({
    required TodoApi todoApiLocal,
    required TodoApi todoApiRemote,
  })  : _todoApiLocal = todoApiLocal,
        _todoApiRemote = todoApiRemote;

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
    var (localList, localRevision) = await _todoApiLocal.getTodoList();
    var (remoteList, remoteRevision) = await _todoApiRemote.getTodoList();

    if (localRevision < remoteRevision) {
      (localList, localRevision) =
          await _todoApiLocal.patchList(remoteList, remoteRevision);
      _revision = localRevision;
      _todoStreamController.add(localList);
    } else {
      (remoteList, remoteRevision) =
          await _todoApiRemote.patchList(localList, localRevision);
      _revision = remoteRevision;
      _todoStreamController.add(remoteList);
    }
  }

  Stream<List<Todo>> getTodos() => _todoStreamController.asBroadcastStream();

  Future<void> saveTodo(Todo todo) async {
    try {
      _revision = await _todoApiRemote.saveTodo(todo, _revision);
      _revision = await _todoApiLocal.saveTodo(todo, _revision);

      final todos = [..._todoStreamController.value];
      final todoIndex = todos.indexWhere((e) => e.id == todo.id);
      if (todoIndex >= 0) {
        todos[todoIndex] = todo;
      } else {
        todos.add(todo);
      }

      _todoStreamController.add(todos);
    } on NotFoundException {
      tryFix();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      var (_, revision) = await _todoApiRemote.deleteTodo(id, _revision);
      _revision = revision;
      (_, revision) = await _todoApiLocal.deleteTodo(id, _revision);
      _revision = revision;

      final todos = [..._todoStreamController.value];
      final todoIndex = todos.indexWhere((e) => e.id == id);
      todos.removeAt(todoIndex);
      _todoStreamController.add(todos);
    } on NotFoundException {
      await tryFix();
    }
  }

  Future<void> tryFix() async {}
}
