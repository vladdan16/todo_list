base class ToDo {
  String name;
  String description;
  bool done;
  Importance importance;
  DateTime? deadline;

  ToDo({
    this.name = '',
    this.description = '',
    this.done = false,
    this.importance = Importance.no,
    this.deadline,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String description = json['description'];
    bool done = json['done'];
    Importance importance = json['importance'];
    DateTime deadline = json['deadline'];
    return ToDo(
      name: name,
      description: description,
      done: done,
      importance: importance,
      deadline: deadline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'done': done,
      'importance': importance,
      'deadline': deadline,
    };
  }
}

enum Importance { no, low, high }

extension Parser on Importance {
  String get name {
    return toString().split('.').last;
  }
}