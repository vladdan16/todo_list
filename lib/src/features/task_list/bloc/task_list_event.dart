part of 'task_list_bloc.dart';

sealed class TaskListEvent extends Equatable {
  const TaskListEvent();

  @override
  List<Object> get props => [];
}

final class TaskListSubscriptionRequested extends TaskListEvent {
  const TaskListSubscriptionRequested();
}

final class TaskListTodoCompletionToggled extends TaskListEvent {
  final Todo todo;
  final bool isCompleted;

  const TaskListTodoCompletionToggled({
    required this.todo,
    required this.isCompleted,
  });

  @override
  List<Object> get props => [todo, isCompleted];
}

final class TaskListDeletionRequested extends TaskListEvent {
  final Todo todo;

  const TaskListDeletionRequested(this.todo);

  @override
  List<Object> get props => [todo];
}

final class TaskListCancelDeletion extends TaskListEvent {
  const TaskListCancelDeletion();
}

class TaskListVisibilityChanged extends TaskListEvent {
  final TaskFilter filter;

  const TaskListVisibilityChanged(this.filter);

  @override
  List<Object> get props => [filter];
}
