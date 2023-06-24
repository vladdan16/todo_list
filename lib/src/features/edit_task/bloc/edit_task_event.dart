part of 'edit_task_bloc.dart';

sealed class EditTaskEvent extends Equatable {
  const EditTaskEvent();

  @override
  List<Object?> get props => [];
}

final class EditTaskTextChanged extends EditTaskEvent {
  final String text;

  const EditTaskTextChanged(this.text);

  @override
  List<Object> get props => [text];
}

final class EditTaskImportanceChanged extends EditTaskEvent {
  final Importance importance;

  const EditTaskImportanceChanged(this.importance);

  @override
  List<Object> get props => [importance];
}

final class EditTaskDeadlineChanged extends EditTaskEvent {
  final DateTime? deadline;

  const EditTaskDeadlineChanged(this.deadline);

  @override
  List<Object?> get props => [deadline];
}

final class EditTaskSubmitted extends EditTaskEvent {
  const EditTaskSubmitted();
}

final class EditTaskDeletionRequested extends EditTaskEvent {
  const EditTaskDeletionRequested();
}
