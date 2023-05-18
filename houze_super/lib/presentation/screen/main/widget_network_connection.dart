import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class CheckNetworkConnectionPage extends StatelessWidget {
  final bool isConnected;
  final double height;
  const CheckNetworkConnectionPage({@required this.isConnected, this.height});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SafeArea(
          maintainBottomViewPadding: false,
          bottom: false,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0,
                child: Container(
                  height: height ?? 50,
                  color: isConnected ? Colors.green : Color(0xFFEE4400),
                  padding: const EdgeInsets.all(10),
                  child: Center(
                    child: Text(
                      LocalizationsUtil.of(context).translate(
                          "${isConnected ? 'network_connected' : 'there_is_no_network'}"),
                      style: AppFonts.bold15.copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
