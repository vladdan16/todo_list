// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> ru = {
  "todo_list": "Мои дела",
  "task_title": "Имя задачи",
  "task_description": "Что надо сделать...",
  "save": "Сохранить",
  "importance": "Важность",
  "no": "Нет",
  "low": "Низкая",
  "high": "Высокая"
};
static const Map<String,dynamic> en = {
  "todo_list": "ToDo List",
  "task_title": "Task title",
  "task_description": "What I need to do...",
  "save": "Save",
  "importance": "Importance",
  "no": "No",
  "low": "Low",
  "high": "High"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ru": ru, "en": en};
}
