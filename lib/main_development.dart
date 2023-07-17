import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:todo_list/bootstrap.dart';
import 'package:todo_list/firebase_options.dart';
import 'package:todo_list/src/core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final logger = Logger();
  final analyticsLogger = AnalyticsLogger(logger: logger);
  GetIt.I.registerSingleton<AnalyticsLogger>(analyticsLogger);

  bootstrap();
}
