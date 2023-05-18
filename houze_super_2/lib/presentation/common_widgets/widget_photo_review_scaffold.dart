import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class PhotoReviewScaffold extends StatelessWidget {
  final Widget body;

  PhotoReviewScaffold({required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: SizedBox.shrink(),
        elevation: 0.0,
        title: Text(
          LocalizationsUtil.of(context).translate('photo_review'),
          style: AppFonts.bold18,
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: body),
    );
  }
}
