import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';

typedef void CallBackHandler();

class FloatingButtonWidget extends StatelessWidget {
  final CallBackHandler callback;
  FloatingButtonWidget({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: MailboxStyle.floatingDecoration,
            child: Icon(Icons.add, size: 40)),
        onPressed: () {
          callback();
        });
  }
}
