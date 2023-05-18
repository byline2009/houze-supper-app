import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/app_fonts.dart';
import 'package:houze_super/utils/localizations_util.dart';

class GradientScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;

  const GradientScaffold({
    @required this.title,
    this.subtitle,
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(74.0),
        child: AppBar(
          leading: const SizedBox.shrink(),
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 14.0),
              Text(
                LocalizationsUtil.of(context).translate(title),
                style: AppFonts.bold18.copyWith(color: Colors.white),
              ),
              SizedBox(height: 4.0),
              Text(subtitle,
                  style:
                      AppFonts.semibold13.copyWith(color: Color(0xffdac0ff))),
            ],
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: const <Color>[
                  Color(0xFF725ef6),
                  Color(0xFF6001d1),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(child: body),
    );
  }
}
