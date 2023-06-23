part of 'task_list_bloc.dart';

enum TaskListStatus { initial, loading, success, failure }

final class TaskListState extends Equatable {
  final TaskListStatus status;
  final List<Todo> todos;
  final TaskFilter filter;

  const TaskListState({
    this.status = TaskListStatus.initial,
    this.todos = const [],
    this.filter = TaskFilter.all,
  });

  Iterable<Todo> get filteredTodos => filter.applyAll(todos);

  TaskListState copyWith({
    TaskListStatus Function()? status,
    List<Todo> Function()? todos,
    TaskFilter Function()? filter,
  }) {
    return TaskListState(
      status: status != null ? status() : this.status,
      todos: todos != null ? todos() : this.todos,
      filter: filter != null ? filter() : this.filter,
    );
  }

  @override
  List<Object?> get props => [status, todos, filter];
}
