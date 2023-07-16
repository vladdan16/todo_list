import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/bootstrap.dart';
import 'package:todo_list/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  var prefs = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(prefs);

  final todoApiLocal = LocalStorageTodosApi(prefs);

  var client = BackendClient();
  final todoApiRemote = RemoteStorageTodosApi(client);

  bootstrap(todoApiLocal: todoApiLocal, todoApiRemote: todoApiRemote);
}
