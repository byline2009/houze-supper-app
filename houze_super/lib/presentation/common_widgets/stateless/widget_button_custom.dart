import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class FlatButtonCustom extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const FlatButtonCustom({
    this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      width: double.infinity,
      child: FlatButton(
        color: Color(0xfff2e8ff),
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
            style: AppFonts.bold16.copyWith(color: Color(0xff7A1DFF)),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed ?? () => Navigator.of(context).pop(),
      ),
    );
  }
}

class RaisedButtonCustom extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const RaisedButtonCustom({this.buttonText, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: <Color>[
            Color(0xFF6001d1),
            Color(0xFF725ef6),
          ],
        ),
      ),
      child: FlatButton(
        disabledColor: Color(0xFFd1d6de),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
            style: AppFonts.bold16.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class RaisedStadiumButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  RaisedStadiumButton({this.buttonText, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(54.0),
        gradient: LinearGradient(
          begin: FractionalOffset.bottomCenter,
          end: FractionalOffset.topCenter,
          colors: <Color>[
            Color(0xFF6001d1),
            Color(0xFF725ef6),
          ],
        ),
      ),
      child: FlatButton(
        disabledColor: Color(0xFFd1d6de),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding:const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        shape: StadiumBorder(),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
            style: AppFonts.bold16.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class FlatStadiumButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const FlatStadiumButton({
    this.buttonText,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isContinueButton = buttonText == 'continue';

    final Color buttonTextColor =
        isContinueButton ? Color(0xff6001d2) : Color(0xffc50000);
    final Color buttonColor =
        isContinueButton ? Color(0xfff2e8ff) : Color(0xffffe7e7);

    return Container(
      height: 48.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(54.0),
        color: buttonColor,
      ),
      child: FlatButton(
        disabledColor: Color(0xFFd1d6de),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding:const EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
        visualDensity: VisualDensity.compact,
        shape: StadiumBorder(),
        disabledTextColor: Colors.white,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
            style: AppFonts.bold16.copyWith(color: buttonTextColor),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class RunPauseButton extends StatelessWidget {
  final Function onStop;
  final Map<String, dynamic> mapValue;

  const RunPauseButton(this.onStop, this.mapValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      padding:const EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(54.0),
        color: const Color(0xffffefc6),
      ),
      child: FlatButton(
        disabledColor: const Color(0xffffefc6),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.all(0),
        visualDensity: VisualDensity.compact,
        shape: StadiumBorder(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pause,
              color: Color(0xffd68100),
            ),
            const SizedBox(width: 8.0),
            Text(LocalizationsUtil.of(context).translate('pause'),
                style: AppFonts.bold18.copyWith(color: Color(0xffd68100))),
          ],
        ),
        onPressed: () async {
          await onStop();
          Navigator.of(context).pop(mapValue);
        },
      ),
    );
  }
}
