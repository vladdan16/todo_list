import 'package:todo_api/todo_api.dart';

class TodoRepository {
  final TodoApi _todoApiLocal;
  final TodoApi _todoApiRemote;
  late int _revision;

  List<Todo> _curList;

  TodoRepository._({
    required TodoApi todoApiLocal,
    required TodoApi todoApiRemote,
  })  : _todoApiLocal = todoApiLocal,
        _todoApiRemote = todoApiRemote,
        _curList = const [];

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
      _curList = localList;
    } else {
      (remoteList, remoteRevision) =
          await _todoApiRemote.patchList(localList, localRevision);
      _revision = remoteRevision;
      _curList = remoteList;
    }
  }

  List<Todo> getTodos() => _curList;

  Todo getTodo(String id) {
    return _curList.firstWhere((element) => element.id == id);
  }

  Future<void> saveTodo(Todo todo) async {
    try {
      final todos = [..._curList];
      final todoIndex = todos.indexWhere((e) => e.id == todo.id);
      if (todoIndex >= 0) {
        todos[todoIndex] = todo;
      } else {
        todos.add(todo);
      }

      _curList = todos;

      _revision = await _todoApiRemote.saveTodo(todo, _revision);
      _revision = await _todoApiLocal.saveTodo(todo, _revision);
    } on NotFoundException {
      tryFix();
    }
  }

  Future<void> deleteTodo(String id) async {
    try {
      final todos = [..._curList];
      final todoIndex = todos.indexWhere((e) => e.id == id);
      todos.removeAt(todoIndex);
      _curList = todos;

      var (_, revision) = await _todoApiRemote.deleteTodo(id, _revision);
      _revision = revision;
      (_, revision) = await _todoApiLocal.deleteTodo(id, _revision);
      _revision = revision;
    } on NotFoundException {
      await tryFix();
    }
  }

  Future<void> tryFix() async {}
}
