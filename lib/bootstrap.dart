import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_repository/todo_repository.dart';

void bootstrap({
  required TodoApi todoApiLocal,
  required TodoApi todoApiRemote,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await DeviceId.setId();

  final todoRepository = await TodoRepository.create(
    todoApiLocal: todoApiLocal,
    todoApiRemote: todoApiRemote,
  );

  GetIt.I.registerSingleton<TaskListService>(TaskListService(todoRepository));

  runApp(const TodoListApp());
}
