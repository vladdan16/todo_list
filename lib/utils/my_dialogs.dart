import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyDialogs {
  static void showInfoDialog({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    final dialog = AlertDialog(
      title: Text(title).tr(),
      content: Text(description).tr(),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
  }

  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String description,
    required Function onConfirmed,
    Function? onCancel,
  }) async {
    var res = false;
    final confirmButton = TextButton(
      onPressed: () {
        onConfirmed();
        res = true;
        Navigator.of(context).pop();
      },
      child: const Text('confirm').tr(),
    );
    final cancelButton = TextButton(
      onPressed: () {
        if (onCancel != null) {
          onCancel();
        }
        Navigator.of(context).pop();
      },
      child: const Text('cancel').tr(),
    );
    final dialog = AlertDialog(
      title: Text(title).tr(),
      content: Text(description).tr(),
      actions: <Widget>[
        confirmButton,
        cancelButton,
      ],
    );
    await showDialog(
      context: context,
      builder: (context) {
        return dialog;
      },
    );
    return res;
  }
}
