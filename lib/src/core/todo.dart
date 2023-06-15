import 'package:easy_localization/easy_localization.dart';

base class ToDo {
  String name;
  //String description;
  bool done;
  Importance importance;
  DateTime? deadline;
  bool hasDeadline;

  ToDo({
    this.name = '',
    //this.description = '',
    this.done = false,
    this.importance = Importance.no,
    this.deadline,
    this.hasDeadline = false,
  });

  factory ToDo.copyWith(ToDo toDo) {
    return ToDo(
        name: toDo.name,
        //description: toDo.description,
        done: toDo.done,
        importance: toDo.importance,
        deadline: toDo.deadline,
        hasDeadline: toDo.hasDeadline);
  }

  factory ToDo.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    //String description = json['description'];
    bool done = json['done'];
    Importance importance = importanceFromString(json['importance']);
    DateTime? deadline =
        json['deadline'] != null ? DateTime.parse(json['deadline']) : null;
    bool hasDeadline = json['hasDeadline'];
    return ToDo(
      name: name,
      //description: description,
      done: done,
      importance: importance,
      deadline: deadline,
      hasDeadline: hasDeadline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      //'description': description,
      'done': done,
      'importance': importanceToString(importance),
      'deadline': deadline?.toIso8601String(),
      'hasDeadline': hasDeadline,
    };
  }
}

enum Importance { no, low, high }

String importanceToString(Importance importance) {
  switch (importance) {
    case Importance.low:
      return 'low';
    case Importance.high:
      return 'high';
    default:
      return 'no';
  }
}

Importance importanceFromString(String value) {
  switch (value) {
    case 'low':
      return Importance.low;
    case 'high':
      return Importance.high;
    default:
      return Importance.no;
  }
}

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
