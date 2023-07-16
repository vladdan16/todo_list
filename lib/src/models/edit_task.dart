import 'package:flutter/material.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/src/core/core.dart';

class EditTaskModel extends ChangeNotifier {
  final Todo _task;
  final bool newTask;
  late String text;
  late Importance _importance;
  late DateTime? _deadline;
  late bool _hasDeadline;

  Todo get task => _task;
  DateTime? get deadline => _deadline;
  Importance get importance => _importance;
  bool get hasDeadline => _hasDeadline;

  set deadline(DateTime? date) {
    _deadline = date;
    _hasDeadline = date != null;
    notifyListeners();
  }

  set importance(Importance i) {
    _importance = i;
    notifyListeners();
  }

  set hasDeadline(bool val) {
    _hasDeadline = val;
    notifyListeners();
  }

  EditTaskModel(Todo? task)
      : _task = task ?? Todo(text: '', lastUpdatedBy: DeviceId.deviceId),
        newTask = task == null {
    text = _task.text;
    importance = _task.importance;
    deadline = _task.deadline;
    hasDeadline = _task.deadline != null;
  }

  void saveTask({
    required String text,
    required Function(Todo task) onSaved,
    required Function() onTextEmpty,
  }) {
    if (text == '') {
      onTextEmpty();
    } else {
      var task = _task.copyWith(
        text: text,
        importance: importance,
        deadline: deadline,
      );
      onSaved(task);
    }
  }
}
