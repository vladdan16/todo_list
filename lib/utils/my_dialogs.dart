import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

final class MyDialogs {
  static void showAddTaskDialog({required BuildContext context}) {
    final titleTextController = TextEditingController();
    final descriptionTextController = TextEditingController();
    var dialog = Dialog.fullscreen(
      child: Center(
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleTextController,
              decoration: InputDecoration(
                hintText: 'task_title'.tr(),
                border: InputBorder.none,
              ),
              // expands: true,
              // maxLines: null,
              // minLines: null,
            ),
          ],
        ),
      ),
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }
}
