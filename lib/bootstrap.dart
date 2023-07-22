import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/app.dart';
import 'package:todo_list/src/core/core.dart';
import 'package:todo_repository/todo_repository.dart';

void bootstrap() async {
  await DeviceId.setId();

  var prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  final todoApiLocal = LocalStorageTodosApi(prefs);

  var client = BackendClient();
  final todoApiRemote = RemoteStorageTodosApi(client);

  var connectivity = Connectivity();
  final todoRepository = await TodoRepository.create(
    todoApiLocal: todoApiLocal,
    todoApiRemote: todoApiRemote,
    connectivity: connectivity,
  );

  GetIt.I.registerSingleton<TodoRepository>(todoRepository);

  final remoteConfig = await setUpRemoteConfig();
  GetIt.I.registerSingleton<FirebaseRemoteConfig>(remoteConfig);

  final logger = GetIt.I<AnalyticsLogger>();
  NavigationManager.init(logger);

  runApp(const TodoListApp());
}

Future<FirebaseRemoteConfig> setUpRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 1),
  ));
  await remoteConfig.setDefaults(const {
    "importance_color": '#FF453A',
  });
  try {
    await remoteConfig.fetchAndActivate();
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
    });
  } catch (_) {
    log('Unable to fetch remote config. Using defaults values');
  }
  return remoteConfig;
}
