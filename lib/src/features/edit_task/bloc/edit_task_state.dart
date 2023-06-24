part of 'edit_task_bloc.dart';

enum EditTaskStatus { initial, loading, success, failure }

extension EditTaskStatusX on EditTaskStatus {
  bool get isLoadingOrSuccess => [
        EditTaskStatus.loading,
        EditTaskStatus.success,
      ].contains(this);
}

final class EditTaskState extends Equatable {
  final EditTaskStatus status;
  final Todo? initialTask;
  final String text;
  final Importance importance;
  final DateTime? deadline;

  const EditTaskState({
    this.status = EditTaskStatus.initial,
    this.initialTask,
    this.text = '',
    this.importance = Importance.basic,
    this.deadline,
  });

  bool get isNewTask => initialTask == null;

  EditTaskState copyWith({
    EditTaskStatus? status,
    Todo? initialTask,
    String? text,
    Importance? importance,
    DateTime? deadline,
  }) {
    return EditTaskState(
      status: status ?? this.status,
      initialTask: initialTask ?? this.initialTask,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
    );
  }

  @override
  List<Object?> get props => [status, initialTask, text, importance, deadline];
}
