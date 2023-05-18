import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class EventDescriptionLineWidget extends StatelessWidget {
  final String description;
  final TextStyle style;
  final int maxline;
  const EventDescriptionLineWidget(
      {Key key, @required this.description, this.style, this.maxline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(AppVectors.icPoint),
          SizedBox(width: 10),
          Expanded(
            child: Text(description,
                maxLines: maxline ?? 1,
                overflow: TextOverflow.ellipsis,
                style: style ?? AppFonts.bold.copyWith(fontSize: 18)),
          )
        ]);
  }
}
