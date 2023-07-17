import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class AnalyticsLogger {
  final bool prod;
  final Logger? logger;

  AnalyticsLogger({this.logger, this.prod = false}) {
    assert(logger != null || prod);
  }

  void logAddTask() async {
    if (prod) {
      await FirebaseAnalytics.instance.logEvent(
        name: 'add_task',
      );
    } else {
      logger!.i('User added task');
    }
  }

  void logRemoveTask() async {
    if (prod) {
      await FirebaseAnalytics.instance.logEvent(
        name: 'remove_task',
      );
    } else {
      logger!.i('User removed task');
    }
  }

  void logToggleTask() async {
    if (prod) {
      await FirebaseAnalytics.instance.logEvent(
        name: 'toggle_task',
      );
    } else {
      logger!.i('User toggled task');
    }
  }

  void logGoToEditTaskPage() async {
    if (prod) {
      await FirebaseAnalytics.instance.logEvent(
        name: 'go_to_edit_task_page',
      );
    } else {
      logger!.i('User opened edit task page');
    }
  }

  void logCloseEditTaskPage() async {
    if (prod) {
      await FirebaseAnalytics.instance.logEvent(
        name: 'close_edit_task_page',
      );
    } else {
      logger!.i('User closed edit task page');
    }
  }
}
