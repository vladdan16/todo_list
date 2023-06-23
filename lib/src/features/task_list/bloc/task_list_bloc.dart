import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/features/task_list/models/models.dart';
import 'package:todo_repository/todo_repository.dart';

part 'task_list_event.dart';

part 'task_list_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final TodoRepository _repository;

  TaskListBloc({
    required TodoRepository repository,
  })  : _repository = repository,
        super(const TaskListState()) {
    on<TaskListSubscriptionRequested>(_onSubscriptionRequested);
    on<TaskListTodoCompletionToggled>(_onTodoCompletionToggled);
    on<TaskListDeletionRequested>(_onDeletionRequested);
    on<TaskListVisibilityChanged>(_onVisibilityChanged);
  }

  Future<void> _onSubscriptionRequested(
    TaskListSubscriptionRequested event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(status: () => TaskListStatus.loading));

    await emit.forEach<List<Todo>>(
      _repository.getTodos(),
      onData: (todos) => state.copyWith(
        status: () => TaskListStatus.success,
        todos: () => todos,
      ),
      onError: (_, __) => state.copyWith(
        status: () => TaskListStatus.failure,
      ),
    );
  }

  Future<void> _onTodoCompletionToggled(
    TaskListTodoCompletionToggled event,
    Emitter<TaskListState> emit,
  ) async {
    final newTodo = event.todo.copyWith(done: event.isCompleted);
    await _repository.saveTodo(newTodo);
  }

  Future<void> _onDeletionRequested(
    TaskListDeletionRequested event,
    Emitter<TaskListState> emit,
  ) async {
    await _repository.deleteTodo(event.todo.id);
  }

  Future<void> _onVisibilityChanged(
    TaskListVisibilityChanged event,
    Emitter<TaskListState> emit,
  ) async {
    emit(state.copyWith(filter: () => event.filter));
  }
}
