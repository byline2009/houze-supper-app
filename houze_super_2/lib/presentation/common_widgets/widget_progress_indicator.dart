import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:houze_super/utils/index.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final Stream<bool> isProgressing;

  const ProgressIndicatorWidget(this.isProgressing);

  @override
  Widget build(BuildContext context) {
    return Align(
      child: StreamBuilder(
        stream: isProgressing,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data!)
            return Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: const Color(0xff7a1dff),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitFadingCircle(size: 50.0, color: Colors.white),
                  SizedBox(height: 16.0),
                  Text(
                    LocalizationsUtil.of(context).translate('loading_3_dot'),
                    style: TextStyle(
                      fontFamily: AppFont.font_family_display,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );

          return SizedBox.shrink();
        },
      ),
    );
  }
}
