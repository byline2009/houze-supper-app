import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/presentation/common_widgets/group_radio_tags_widget.dart';
import 'package:houze_super/utils/constants/constants.dart';

typedef void CallBackHandlerGroupRadio(int index, dynamic value);

class GroupRadioCircleWidget extends StatefulWidget {
  final List<GroupRadioTags> tags;
  final CallBackHandlerGroupRadio callback;
  final int defaultIndex;

  const GroupRadioCircleWidget({
    this.callback,
    this.tags,
    this.defaultIndex,
  });
  @override
  State<StatefulWidget> createState() => GroupRadioCircleWidgetState();
}

class GroupRadioCircleWidgetState extends State<GroupRadioCircleWidget> {
  int _currentIndex;
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.defaultIndex;
  }

  Widget buttonIcon({index, id, title, icon, isSelected = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FlatButton(
            color: isSelected ? Color(0xfff2e8ff) : Color(0xfff5f5f5),
            onPressed: () {
              setState(() {
                _currentIndex = index;
              });
              if (widget.callback != null) widget.callback(index, id);
            },
            shape: CircleBorder(),
            child: SizedBox(
                child: icon != null ? icon : const SizedBox.shrink(),
                width: 32,
                height: 32),
            padding: const EdgeInsets.all(14)),
        SizedBox(height: 6),
        Text(title,
            style: isSelected
                ? AppFonts.semibold13.copyWith(color: Color(0xff7A1DFF))
                : AppFonts.semibold13.copyWith(color: Color(0xff9c9c9c)))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 10),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.tags.length,
        itemBuilder: (BuildContext context, int index) {
          return buttonIcon(
            id: widget.tags[index].id,
            index: index,
            title: widget.tags[index].title,
            icon: widget.tags[index].icon,
            isSelected: index == _currentIndex,
          );
        },
      ),
    );
  }
}
