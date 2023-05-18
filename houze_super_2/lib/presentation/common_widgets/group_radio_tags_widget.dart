import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler(dynamic value);

class GroupRadioTags extends Equatable {
  final dynamic id;
  final String title;
  final Widget icon;

  GroupRadioTags({
    this.id,
    required this.title,
    required this.icon,
  });

  @override
  List<Object> get props => [
        id,
        title,
        icon,
      ];
}

class GroupRadioTagsWidget extends StatefulWidget {
  final List<GroupRadioTags>? tags;
  final CallBackHandler? callback;
  final CallBackHandler? callBackIndex;
  final int? defaultIndex;

  const GroupRadioTagsWidget({
    this.callback,
    this.callBackIndex,
    this.tags,
    this.defaultIndex,
  });

  @override
  State<StatefulWidget> createState() => GroupRadioTagsWidgetState();
}

class GroupRadioTagsWidgetState extends State<GroupRadioTagsWidget> {
  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.defaultIndex;
  }

  Widget buttonIcon({
    index,
    id,
    title,
    icon,
    isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(8),
          backgroundColor: isSelected ? AppColor.purple_f2e8ff : Colors.white,
          primary: isSelected ? AppColor.purple_f2e8ff : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              side: BorderSide(
                  color: isSelected
                      ? AppColor.purple_f2e8ff
                      : AppColor.gray_dcdcdc)),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
          if (widget.callback != null) widget.callback!(id);
          if (widget.callBackIndex != null) widget.callBackIndex!(index);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(LocalizationsUtil.of(context).translate(title),
                style: isSelected
                    ? AppFonts.medium14.copyWith(
                        color: Color(
                          0xff5B00E4,
                        ),
                      )
                    : AppFonts.medium14),
            SizedBox(width: 5),
            SizedBox(child: icon, width: 20, height: 20)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => true,
      child: SizedBox(
        height: 73,
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 15, bottom: 20),
          physics: const BouncingScrollPhysics(),
          itemCount: widget.tags?.length,
          itemBuilder: (BuildContext context, int index) {
            return buttonIcon(
              id: widget.tags?[index].id,
              index: index,
              title: widget.tags?[index].title,
              icon: widget.tags?[index].icon,
              isSelected: index == _currentIndex,
            );
          },
        ),
      ),
    );
  }
}
