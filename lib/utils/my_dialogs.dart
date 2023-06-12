import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyDialogs {
  void showInfoDialog({
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
}
