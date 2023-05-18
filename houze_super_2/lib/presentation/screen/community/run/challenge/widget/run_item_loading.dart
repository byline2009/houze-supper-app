import 'package:flutter/cupertino.dart';

class RunItemLoading extends StatelessWidget {
  RunItemLoading();
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width - 40;
    return Container(
      width: _width,
      height: 140,
      padding: const EdgeInsets.only(top: 30),
      child: const CupertinoActivityIndicator(),
    );
  }
}
