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
  "what_i_need_todo": "Что надо сделать..."
};
static const Map<String,dynamic> en = {
  "todo_list": "ToDo List",
  "task_title": "Task title",
  "what_i_need_todo": "What I need to do..."
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ru": ru, "en": en};
}
