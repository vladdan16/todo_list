import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_repository/todo_repository.dart';

final class TaskListService {
  final TodoRepository _repository;
  TaskFilter filter;
  late List<Todo> todos;

  TaskListService(TodoRepository repository)
      : _repository = repository,
        filter = TaskFilter.all {
    todos = _repository.getTodos();
  }

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  void changeVisibility() {
    filter = filter == TaskFilter.all ? TaskFilter.active : TaskFilter.all;
  }

  void removeTask(Todo task) async {
    await _repository.deleteTodo(task.id);
    todos = _repository.getTodos();
  }

  void saveTask(Todo task) async {
    await _repository.saveTodo(task);
    todos = _repository.getTodos();
  }

  int get completed {
    todos = _repository.getTodos();
    int res = 0;
    for (var e in todos) {
      if (e.done) res++;
    }
    return res;
  }
}
