import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

/// The type definition for a JSON-serializable [Map].
typedef JsonMap = Map<String, dynamic>;

@immutable
@JsonSerializable()
base class Todo extends Equatable {
  /// Unique task id
  final String id;

  /// Task description
  final String text;

  /// Task importance
  final Importance importance;

  /// Optional deadline of task
  DateTime? deadline;

  /// Marker if task is done
  bool done;

  /// Hex color of task ???
  String? color;

  /// Time when task was created
  @JsonKey(name: "created_at")
  DateTime createdAt;

  /// Time when task was modified
  @JsonKey(name: "changed_at")
  DateTime changedAt;

  /// Device id where task was modified
  @JsonKey(name: "last_updated_by")
  String lastUpdatedBy;

  Todo({
    String? id,
    required this.text,
    this.importance = Importance.basic,
    this.deadline,
    this.done = false,
    this.color,
    DateTime? createdAt,
    DateTime? changedAt,
    required this.lastUpdatedBy,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        changedAt = changedAt ?? DateTime.now();

  Todo copyWith({
    String? id,
    String? text,
    Importance? importance,
    DateTime? deadline,
    bool? done,
    String? color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Todo(
      id: id ?? this.id,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      done: done ?? this.done,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      changedAt: changedAt ?? this.changedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }

  factory Todo.fromJson(JsonMap json) {
    var deadlineStr = json['deadline'];
    var deadline = deadlineStr == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(deadlineStr as int);
    return Todo(
      id: json['id'] as String,
      text: json['text'] as String,
      importance: importanceFromString(json['importance'] as String),
      deadline: deadline,
      done: json['done'] as bool,
      color: json['color'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      changedAt: DateTime.fromMillisecondsSinceEpoch(json['changed_at'] as int),
      lastUpdatedBy: json['last_updated_by'] as String,
    );
  }

  JsonMap toJson() {
    return {
      'id': id,
      'text': text,
      'importance': importance.name,
      'deadline': deadline?.millisecondsSinceEpoch,
      'done': done,
      'color': color,
      'created_at': createdAt,
      'changed_at': changedAt,
      'last_updated_by': lastUpdatedBy,
    };
  }

  @override
  List<Object?> get props => [
        id,
        text,
        importance,
        deadline,
        done,
        color,
        createdAt,
        changedAt,
        lastUpdatedBy,
      ];
}

enum Importance { low, basic, important }

extension ImportanceX on Importance {
  String get name {
    return toString().split('.').last;
  }
}

Importance importanceFromString(String value) {
  switch (value) {
    case 'low':
      return Importance.low;
    case 'important':
      return Importance.important;
    default:
      return Importance.basic;
  }
}
