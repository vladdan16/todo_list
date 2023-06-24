import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_repository/todo_repository.dart';
import 'package:uuid/uuid.dart';

part 'edit_task_event.dart';

part 'edit_task_state.dart';

class EditTaskBloc extends Bloc<EditTaskEvent, EditTaskState> {
  final TodoRepository _repository;

  EditTaskBloc({
    required TodoRepository repository,
    required Todo? initialTask,
  })  : _repository = repository,
        super(
          EditTaskState(
            initialTask: initialTask,
            text: initialTask?.text ?? '',
            importance: initialTask?.importance ?? Importance.basic,
            deadline: initialTask?.deadline,
          ),
        ) {
    on<EditTaskTextChanged>(_onTextChanged);
    on<EditTaskImportanceChanged>(_onImportanceChanged);
    on<EditTaskDeadlineChanged>(_onDeadlineChanged);
    on<EditTaskSubmitted>(_onSubmitted);
    on<EditTaskDeletionRequested>(_onDeletionRequested);
  }

  void _onTextChanged(
    EditTaskTextChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(text: event.text));
  }

  void _onImportanceChanged(
    EditTaskImportanceChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(importance: event.importance));
  }

  void _onDeadlineChanged(
    EditTaskDeadlineChanged event,
    Emitter<EditTaskState> emit,
  ) {
    emit(state.copyWith(deadline: event.deadline));
  }

  Future<void> _onSubmitted(
    EditTaskSubmitted event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(status: EditTaskStatus.loading));
    var deviceId = await getId() ?? const Uuid().v4();
    final todo = (state.initialTask ??
            Todo(
              text: '',
              lastUpdatedBy: deviceId,
            ))
        .copyWith(
      text: state.text,
      importance: state.importance,
      deadline: state.deadline,
    );

    try {
      await _repository.saveTodo(todo);
      emit(state.copyWith(status: EditTaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTaskStatus.failure));
    }
  }

  Future<void> _onDeletionRequested(
    EditTaskDeletionRequested event,
    Emitter<EditTaskState> emit,
  ) async {
    emit(state.copyWith(status: EditTaskStatus.loading));
    try {
      await _repository.deleteTodo(state.initialTask!.id);
      emit(state.copyWith(status: EditTaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTaskStatus.failure));
    }
  }
}
