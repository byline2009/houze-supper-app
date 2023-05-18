import 'package:flutter/material.dart';

class LinearProgressBar extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final double? value;
  final double height;

  const LinearProgressBar({
    Key? key,
    required this.backgroundColor,
    required this.foregroundColor,
    this.value = 1.0,
    required this.height,
  }) : super(key: key);

  @override
  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Tween<double> valueTween;
  late Animation<double> curve;
  late ColorTween foregroundColorTween = ColorTween(
    begin: widget.foregroundColor,
    end: widget.foregroundColor,
  );

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    this.curve = CurvedAnimation(
      parent: this._controller,
      curve: Curves.easeInOut,
    );

    this.valueTween = Tween<double>(
      begin: 0,
      end: this.widget.value?.toDouble(),
    );
    this._controller.forward();
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LinearProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.value != oldWidget.value) {
      double beginValue = this.valueTween.evaluate(this._controller);

      // Update the value tween.
      this.valueTween = Tween<double>(
        begin: beginValue,
        end: this.widget.value,
      );
      this.foregroundColorTween = ColorTween(
        begin: oldWidget.foregroundColor,
        end: this.widget.foregroundColor,
      );
      this._controller
        ..value = 0
        ..forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.widget.backgroundColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
            animation: this.curve,
            child: const SizedBox.shrink(),
            builder: (context, child) {
              final foregroundColor =
                  this.foregroundColorTween.evaluate(this.curve) ??
                      this.widget.foregroundColor;
              return LinearProgressIndicator(
                value: this
                    .valueTween
                    .evaluate(this._controller), // percent filled
                valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                backgroundColor: backgroundColor,
              );
            }),
      ),
    );
  }
}
