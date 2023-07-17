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
      deadline: json['deadline'] as int?,
      done: json['done'] as bool? ?? false,
      color: json['color'] as String?,
      createdAt: json['created_at'] as int,
      changedAt: json['changed_at'] as int,
      lastUpdatedBy: json['last_updated_by'] as String,
    );

Map<String, dynamic> _$$_TodoToJson(_$_Todo instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'text': instance.text,
    'importance': _$ImportanceEnumMap[instance.importance]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('deadline', instance.deadline);
  val['done'] = instance.done;
  writeNotNull('color', instance.color);
  val['created_at'] = instance.createdAt;
  val['changed_at'] = instance.changedAt;
  val['last_updated_by'] = instance.lastUpdatedBy;
  return val;
}

const _$ImportanceEnumMap = {
  Importance.low: 'low',
  Importance.basic: 'basic',
  Importance.important: 'important',
};
