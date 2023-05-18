import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

typedef void CallBackOpenRegisterHandler(String type);

class RegisterButtonWidget extends StatefulWidget {
  final CallBackOpenRegisterHandler? callback;
  RegisterButtonWidget({Key? key, this.callback}) : super(key: key);
  @override
  _RegisterButtonWidgetState createState() => _RegisterButtonWidgetState(
        callback: this.callback,
      );
}

class _RegisterButtonWidgetState extends State<RegisterButtonWidget>
    with TickerProviderStateMixin {
  bool opened = false;

  CallBackOpenRegisterHandler? callback;
  _RegisterButtonWidgetState({this.callback});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: opened ? 0.8 : 0.0,
          duration: Duration(milliseconds: 200),
          // The green box must be a child of the AnimatedOpacity widget.
          child: IgnorePointer(
            ignoring: !opened,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  opened = false;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
              ),
            ),
          ),
        ),
        AnimatedPositioned(
          duration: Duration(milliseconds: 200),
          right: opened
              ? (MediaQuery.of(context).size.width / 2) + 8
              : (MediaQuery.of(context).size.width / 2) - 40,
          bottom: opened ? 80 : 0,
          child: _buildOption(
            'rent',
            Colors.purple,
          ),
        ),
        AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            left: opened
                ? (MediaQuery.of(context).size.width / 2) + 8
                : (MediaQuery.of(context).size.width / 2) - 40,
            bottom: opened ? 80 : 0,
            child: _buildOption('sell', Colors.green)),
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(child: child, scale: animation);
            },
            child: opened
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.padded,
                      padding: EdgeInsets.all(0),
                    ),
                    key: UniqueKey(),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            height: 48.0,
                            width: 48.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xff6001d1),
                                      Color(0xff725ef6)
                                    ],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius:
                                        8.0, // has the effect of softening the shadow
                                    spreadRadius:
                                        0.0, // has the effect of extending the shadow
                                    offset: Offset(
                                      1.0, // horizontal, move right 10
                                      10.0, // vertical, move down 10
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(24.0),
                                color: Colors.blue),
                            child: Center(
                                child:
                                    Icon(Icons.close, color: Colors.white)))),
                    onPressed: () {
                      setState(() {
                        opened = false;
                      });
                    })
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      tapTargetSize: MaterialTapTargetSize.padded,
                      padding: EdgeInsets.all(0),
                    ),
                    key: UniqueKey(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 48,
                        width: 180,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xff6001d1), Color(0xff725ef6)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius:
                                    8.0, // has the effect of softening the shadow
                                spreadRadius:
                                    0.0, // has the effect of extending the shadow
                                offset: Offset(
                                  1.0, // horizontal, move right 10
                                  10.0, // vertical, move down 10
                                ),
                              )
                            ],
                            borderRadius: BorderRadius.circular(30.0),
                            color: Colors.blue),
                        child: Center(
                          child: Text(
                            LocalizationsUtil.of(context).translate('post'),
                            style: AppFonts.bold16.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        opened = true;
                      });
                    }),
          ),
        )
      ],
    );
  }

  Widget _buildOption(String type, Color iconColor) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.padded,
          padding: EdgeInsets.all(0),
        ),
        key: UniqueKey(),
        child: opened
            ? SvgPicture.asset("assets/svg/sell/$type.svg",
                width: MediaQuery.of(context).size.width * 0.4)
            : SizedBox.shrink(),
        onPressed: () {
          setState(() {
            opened = false;
          });
          if (callback != null) callback!(type);
        },
      ),
    );
  }
}
