// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: non_constant_identifier_names

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Todo _$$_TodoFromJson(Map<String, dynamic> json) => _$_Todo(
      id: json['id'] as String,
      text: json['text'] as String,
      importance:
          $enumDecodeNullable(_$ImportanceEnumMap, json['importance']) ??
              Importance.basic,
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      done: json['done'] as bool? ?? false,
      color: json['color'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      changedAt: DateTime.parse(json['changedAt'] as String),
      lastUpdatedBy: json['lastUpdatedBy'] as String,
    );

Map<String, dynamic> _$$_TodoToJson(_$_Todo instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'importance': _$ImportanceEnumMap[instance.importance]!,
      'deadline': instance.deadline?.toIso8601String(),
      'done': instance.done,
      'color': instance.color,
      'createdAt': instance.createdAt.toIso8601String(),
      'changedAt': instance.changedAt.toIso8601String(),
      'lastUpdatedBy': instance.lastUpdatedBy,
    };

const _$ImportanceEnumMap = {
  Importance.low: 'low',
  Importance.basic: 'basic',
  Importance.important: 'important',
};
