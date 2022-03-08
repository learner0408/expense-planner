import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextButton extends StatelessWidget {
  //const AdaptiveTextButton({ Key? key }) : super(key: key);
  final String text;
  final Function datePicker;
  AdaptiveTextButton(this.text, this.datePicker);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: () {
              datePicker();
            },
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
        : TextButton(
            style:
                TextButton.styleFrom(primary: Theme.of(context).primaryColor),
            onPressed: () {
              datePicker();
            },
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
  }
}
