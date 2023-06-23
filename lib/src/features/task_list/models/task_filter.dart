import 'package:todo_api/todo_api.dart';

enum TaskFilter { all, active }

extension TaskFilterX on TaskFilter {
  bool apply(Todo todo) {
    switch (this) {
      case TaskFilter.all:
        return true;
      case TaskFilter.active:
        return !todo.done;
    }
  }

  Iterable<Todo> applyAll(Iterable<Todo> todos) {
    return todos.where(apply);
  }
}