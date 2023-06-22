// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> ru = {
    "todo_list": "Мои дела",
    "task_title": "Имя задачи",
    "task_description": "Что надо сделать...",
    "save": "Сохранить",
    "importance": "Важность",
    "no": "Нет",
    "low": "Низкая",
    "high": "Высокая",
    "deadline": "Сделать до",
    "delete": "Удалить",
    "empty_title": "Пустое имя",
    "empty_title_description":
        "Имя задачи не может быть пустым. Пожалуйста, добавьте имя задачи.",
    "confirm": "Подтвердить",
    "cancel": "Отмена",
    "confirm_delete": "Подтверждение удаления",
    "confirm_delete_description": "Вы собираетесь удалить задачу. Вы уверены?",
    "completed": "Выполнено",
    "new": "Новая задача"
  };
  static const Map<String, dynamic> en = {
    "todo_list": "ToDo List",
    "task_title": "Task title",
    "task_description": "What I need to do...",
    "save": "Save",
    "importance": "Importance",
    "no": "No",
    "low": "Low",
    "high": "High",
    "deadline": "Deadline",
    "delete": "Delete",
    "empty_title": "Empty title",
    "empty_title_description":
        "Title field cannot be empty. Please, add name to your task.",
    "confirm": "Confirm",
    "cancel": "Cancel",
    "confirm_delete": "Confirm deletion",
    "confirm_delete_description":
        "You are about to delete your task. Are you sure?",
    "completed": "Completed",
    "new": "New task"
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "ru": ru,
    "en": en
  };
}
