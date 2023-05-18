import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'constants/constants.dart';

class ProgressHUD extends StatefulWidget {
  final Color backgroundColor;
  final Color color;
  final Color containerColor;
  final double borderRadius;
  String text;
  final bool loading;
  _ProgressHUDState state;

  ProgressHUD(
      {Key key,
      this.backgroundColor = Colors.black54,
      this.color = Colors.white,
      this.containerColor = Colors.transparent,
      this.borderRadius = 10.0,
      this.text,
      this.loading = false})
      : super(key: key);

  @override
  _ProgressHUDState createState() {
    state = _ProgressHUDState();

    return state;
  }
}

class _ProgressHUDState extends State<ProgressHUD> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    _visible = widget.loading;
  }

  void dismiss() {
    if (mounted)
      setState(() {
        this._visible = false;
      });
  }

  void show() {
    if (mounted)
      setState(() {
        this._visible = true;
      });
  }

  void clear() {
    widget.text = "loading_3_dot";
  }

  void update(double percent) {
    if (widget.text != null) {
      setState(() {
        widget.text = "${percent.ceil()} %";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_visible) {
      return Scaffold(
          backgroundColor: widget.backgroundColor.withOpacity(0.5),
          body: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                      color: widget.containerColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(widget.borderRadius))),
                ),
              ),
              Center(
                child: _getCenterContent(context),
              )
            ],
          ));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _getCenterContent(BuildContext context) {
    if (widget.text == null || widget.text.isEmpty) {
      return _getCircularProgress();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _getCircularProgress(),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
            child: Text(
              LocalizationsUtil.of(context).translate(widget.text),
              style: TextStyle(
                fontFamily: AppFonts.font_family_display,
                color: widget.color,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCircularProgress() {
    return SpinKitFadingCircle(
      color: Colors.white,
      size: 50.0,
    );
  }
}

class Progress {
  static ProgressHUD instance = ProgressHUD(
    backgroundColor: Colors.black12,
    color: Colors.white,
    containerColor: Color(0xff7A1DFF),
    borderRadius: 20.0,
    text: 'loading_3_dot',
  );

  static ProgressHUD instanceCreate() {
    return ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Color(0xff7A1DFF),
      borderRadius: 20.0,
      text: 'loading_3_dot',
    );
  }

  static ProgressHUD instanceCreateWithNormal() {
    return ProgressHUD(
      backgroundColor: Colors.black.withOpacity(0.30),
      color: Colors.white,
      containerColor: Colors.transparent,
      borderRadius: 5.0,
    );
  }

  static ProgressHUD instanceCreateCirle() {
    return ProgressHUD(
      backgroundColor: Colors.white,
      color: Colors.black,
      containerColor: Colors.white,
      borderRadius: 5.0,
    );
  }
}
