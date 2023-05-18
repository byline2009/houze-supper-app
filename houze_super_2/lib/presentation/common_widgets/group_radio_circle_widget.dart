import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/group_radio_tags_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandlerGroupRadio(int index, dynamic value);

class GroupRadioCircleWidget extends StatefulWidget {
  final List<GroupRadioTags>? tags;
  final CallBackHandlerGroupRadio? callback;
  final int? defaultIndex;

  const GroupRadioCircleWidget({
    this.callback,
    this.tags,
    this.defaultIndex,
  });
  @override
  State<StatefulWidget> createState() => GroupRadioCircleWidgetState();
}

class GroupRadioCircleWidgetState extends State<GroupRadioCircleWidget> {
  int? _currentIndex;
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
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(14),
            shape: CircleBorder(side: BorderSide.none),
            primary: isSelected ? Color(0xfff2e8ff) : AppColor.gray_f5f5f5,
            backgroundColor:
                isSelected ? Color(0xfff2e8ff) : AppColor.gray_f5f5f5,
          ),
          onPressed: () {
            setState(() {
              _currentIndex = index;
            });
            if (widget.callback != null) widget.callback!(index, id);
          },
          child: SizedBox(
              child: icon != null ? icon : Center(), width: 32, height: 32),
        ),
        SizedBox(height: 6),
        Text(
          title,
          style: isSelected
              ? AppFonts.semibold13.copyWith(
                  color: Color(0xff7a1dff),
                )
              : AppFonts.semibold13.copyWith(
                  color: Color(0xff9c9c9c),
                ),
        )
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
        padding: const EdgeInsets.only(top: 10, left: 15.0, right: 20.0),
        physics: const BouncingScrollPhysics(),
        itemCount: widget.tags?.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: index != widget.tags!.length - 1
                ? const EdgeInsets.only(right: 15.0)
                : const EdgeInsets.only(right: 0.0),
            child: buttonIcon(
              id: widget.tags?[index].id,
              index: index,
              title: widget.tags?[index].title,
              icon: widget.tags?[index].icon,
              isSelected: index == _currentIndex,
            ),
          );
        },
      ),
    );
  }
}
