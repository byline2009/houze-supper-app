import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/index.dart';

typedef void CallBackHandler();

class FirstBrandDialog extends StatelessWidget {
  final BuildingMessageModel building;
  final CallBackHandler callback;
  const FirstBrandDialog({
    @required this.building,
    @required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      elevation: 0.0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
      ),
      titlePadding: const EdgeInsets.all(0),
      actionsOverflowButtonSpacing: 0,
      scrollable: false,
      buttonPadding: const EdgeInsets.all(0),
      content: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  height: 190,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: building.company.coverThumb,
                    placeholder: (context, url) => ParkingCardSkeleton(
                      height: 190,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 190.0,
                  ),
                ),
                Positioned(
                  child: InkWell(
                    onTap: () => callback(),
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            15.0,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: SvgPicture.asset(
                            AppVectors.icClose,
                            height: 14,
                            width: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  top: 15,
                  left: 20,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 30,
              ),
              child: Text(
                building.company.welcome.toString(),
                maxLines: 3,
                textAlign: TextAlign.center,
                style: AppFonts.regular15,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: SizedBox(
                  height: 48.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocalizationsUtil.of(context).translate(
                            'automatically_close_after_with_space',
                          ),
                          style: AppFonts.regular15,
                        ),
                        MyTimer(
                          seconds: 5,
                          callback: (finish) {
                            print(finish);
                            if (finish == true) {
                              callback();
                            }
                          },
                        ),
                        Text(
                          LocalizationsUtil.of(context)
                              .translate("seconds_with_space_and_lower_case"),
                          style: AppFonts.bold16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

typedef void CallBackHandlerTimer(bool);

class MyTimer extends StatefulWidget {
  const MyTimer({
    Key key,
    @required this.seconds,
    @required this.callback,
  }) : super(key: key);
  final int seconds;
  final CallBackHandlerTimer callback;
  _MyTimerState createState() => _MyTimerState();
}

class _MyTimerState extends State<MyTimer> {
  Timer _timer;
  int _start;

  @override
  void initState() {
    super.initState();
    _start = widget.seconds;
    if (_start != null && _start > 0) startTimer();
  }

  void startTimer() {
    if (_timer != null) {
      _timer.cancel();
      _timer = null;
    } else {
      _timer = new Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => setState(
          () {
            if (_start < 1) {
              timer.cancel();
              widget.callback(true);
            } else {
              _start = _start - 1;
            }
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Text(
      _start.toString(),
      style: AppFonts.bold16,
    );
  }
}
