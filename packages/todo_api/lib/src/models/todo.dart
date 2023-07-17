import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

enum Importance { low, basic, important }

@freezed
class Todo with _$Todo {

  const factory Todo({
    required String id,
    required String text,
    @Default(Importance.basic)Importance importance,
    DateTime? deadline,
    @Default(false) bool done,
    String? color,
    required DateTime createdAt,
    required DateTime changedAt,
    required String lastUpdatedBy,
  }) = _Todo;


  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
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
