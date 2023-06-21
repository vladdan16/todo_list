class TodoRepository {
  const TodoRepository({
    required TodoApi todoApi,
}) : _todoApi = todoApi;

  final TodoApi _todoApi;

  Stream<List<Todo>> getTodos() => _todoApi.getTodos();

  Future<void> saveTodo(Todo todo) => _todoApi.saveTodo(todo);

  Future<void> deleteTodo(String id) => _todoApi.deleteTodo(id);

}
