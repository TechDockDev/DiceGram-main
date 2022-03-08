// ignore_for_file: deprecated_member_use, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final title; // title and content of dialog
  final content;
  final VoidCallback callback; // Reset function and reset text
  final actionText;

  CustomDialog(this.title, this.content, this.callback,
      [this.actionText = "Reset"]);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
         FlatButton(
          onPressed: callback,
          color: Colors.white,
          child: Text(actionText),
        )
      ],
    );
  }
}