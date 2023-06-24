import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_api/todo_api.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_repository/todo_repository.dart';

import 'bloc_observer.dart';

void bootstrap({
  required TodoApi todoApiLocal,
  required TodoApi todoApiRemote,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  await DeviceId.setId();

  Bloc.observer = AppBlocObserver();

  final todoRepository = await TodoRepository.create(
    todoApiLocal: todoApiLocal,
    todoApiRemote: todoApiRemote,
  );

  runZonedGuarded(
    () => runApp(TodoListApp(todoRepository: todoRepository)),
    (error, stack) => log(error.toString(), stackTrace: stack),
  );
}
