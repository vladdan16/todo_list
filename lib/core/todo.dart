import 'package:easy_localization/easy_localization.dart';

base class ToDo {
  String name;
  String description;
  bool done;
  Importance importance;
  DateTime? deadline;
  bool hasDeadline;

  ToDo({
    this.name = '',
    this.description = '',
    this.done = false,
    this.importance = Importance.no,
    this.deadline,
    this.hasDeadline = false,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String description = json['description'];
    bool done = json['done'];
    Importance importance = json['importance'];
    DateTime deadline = json['deadline'];
    bool hasDeadline = json['hasDeadline'];
    return ToDo(
      name: name,
      description: description,
      done: done,
      importance: importance,
      deadline: deadline,
      hasDeadline: hasDeadline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'done': done,
      'importance': importance,
      'deadline': deadline,
      'hasDeadline': hasDeadline,
    };
  }
}

enum Importance { no, low, high }

extension Parser on Importance {
  String get name {
    return toString().split('.').last;
  }
}

extension DateToText on DateTime {
  String get date {
    var formatter = DateFormat('d MMMM yyyy');
    return formatter.format(this);
  }
}