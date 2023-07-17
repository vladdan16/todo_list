import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_list/src/core/core.dart';

class NavigationManager {
  static late AnalyticsLogger _logger;

  static void init(AnalyticsLogger logger) {
    _logger = logger;
  }

  static void openTaskById(BuildContext context, String id) {
    _logger.logGoToEditTaskPage();
    context.push('/task/$id');
  }

  static void openNewTask(BuildContext context) {
    _logger.logGoToEditTaskPage();
    context.push('/task/new');
  }

  static void closeEditTaskPage(BuildContext context) {
    _logger.logCloseEditTaskPage();
    context.pop();
  }
}
