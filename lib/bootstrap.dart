import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
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

  var connectivity = Connectivity();
  final todoRepository = await TodoRepository.create(
    todoApiLocal: todoApiLocal,
    todoApiRemote: todoApiRemote,
    connectivity: connectivity,
  );

  GetIt.I.registerSingleton<TodoRepository>(todoRepository);

  runApp(const TodoListApp());
}
