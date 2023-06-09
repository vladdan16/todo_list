base class ToDo {
  String name;
  String description;
  bool done;
  bool importance;
  DateTime? deadline;

  ToDo({
    required this.name,
    this.description = '',
    this.done = false,
    this.importance = false,
    this.deadline,
  });

  factory ToDo.fromJson(Map<String, dynamic> json) {
    String name = json['name'];
    String description = json['description'];
    bool done = json['done'];
    bool importance = json['importance'];
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
