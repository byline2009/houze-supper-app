import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class FlatButtonCustom extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onPressed;

  FlatButtonCustom({
    this.buttonText = 'done_0',
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xfff2e8ff),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
          height: 48.0,
          width: double.infinity,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              LocalizationsUtil.of(context).translate(buttonText),
              style: AppFont.BOLD_PURPLE_7a1dff_16,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class ElevatedButtonCustom extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onPressed;

  ElevatedButtonCustom({this.buttonText, required this.onPressed});

  @override
  Container build(BuildContext context) {
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
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled))
              return Color(0xFFd1d6de);
            return null; // Defer to the widget's default.
          }),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
            style: AppFonts.bold16.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class RaisedStadiumButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onPressed;

  RaisedStadiumButton({
    this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Color(0xfff2e8ff),
        borderRadius: BorderRadius.circular(5.0),
        // gradient: LinearGradient(
        //   begin: FractionalOffset.bottomCenter,
        //   end: FractionalOffset.topCenter,
        //   colors: <Color>[
        //     Color(0xFF6001d1),
        //     Color(0xFF725ef6),
        //   ],
        // ),
      ),
      child: SizedBox(
        height: 48.0,
        child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled))
                return Color(0xFFd1d6de);
              return null; // Defer to the widget's default.
            }),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
            ),
            shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder()),
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
              style: AppFonts.bold16.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class FlatStadiumButton extends StatelessWidget {
  final String? buttonText;
  final VoidCallback onPressed;

  FlatStadiumButton({
    this.buttonText,
    required this.onPressed,
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
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled))
                return Color(0xFFd1d6de);
              return null;
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) return Colors.white;
              return null;
            }),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.symmetric(vertical: 12.0, horizontal: 40.0),
            ),
            visualDensity: VisualDensity.compact,
            shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder())),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            LocalizationsUtil.of(context).translate(buttonText ?? 'done_0'),
            style: AppFonts.bold16
                .copyWith(
                  color: Colors.white,
                )
                .copyWith(color: buttonTextColor),
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

  RunPauseButton(this.onStop, this.mapValue);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(54.0),
        color: const Color(0xffffefc6),
      ),
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled))
                return Color(0xffffefc6);
              return null;
            }),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: MaterialStateProperty.all<EdgeInsets>(
              EdgeInsets.zero,
            ),
            visualDensity: VisualDensity.compact,
            shape: MaterialStateProperty.all<StadiumBorder>(StadiumBorder())),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pause,
              color: Color(0xffd68100),
            ),
            SizedBox(width: 8.0),
            Text(
              LocalizationsUtil.of(context).translate('pause'),
              style: AppFont.BOLD_d68100_18,
            ),
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
