// Ignore this since I don't see any other options to set json key for field
// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum Importance { low, basic, important }

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String text,
    @Default(Importance.basic) Importance importance,
    @JsonKey(includeIfNull: false) int? deadline,
    @Default(false) bool done,
    @JsonKey(includeIfNull: false) String? color,
    @JsonKey(name: 'created_at') required int createdAt,
    @JsonKey(name: 'changed_at') required int changedAt,
    @JsonKey(name: 'last_updated_by') required String lastUpdatedBy,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

extension TodoX on Todo {
  DateTime? getDeadline() {
    if (deadline == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(deadline!);
  }

  DateTime getCreatedAt() {
    return DateTime.fromMillisecondsSinceEpoch(createdAt);
  }

  DateTime getChangedAt() {
    return DateTime.fromMillisecondsSinceEpoch(changedAt);
  }
}

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
