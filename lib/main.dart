import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:remote_storage_todos_api/remote_storage_todos_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  var prefs = await SharedPreferences.getInstance();

  final todoApiLocal = LocalStorageTodosApi(prefs);
  final todoApiRemote = RemoteStorageTodosApi();

  bootstrap(todoApiLocal: todoApiLocal, todoApiRemote: todoApiRemote);
}
