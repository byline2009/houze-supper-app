import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler(dynamic value);

class GroupRadioTags extends Equatable {
  final dynamic id;
  final String title;
  final Widget icon;

  GroupRadioTags({
    this.id,
    this.title,
    this.icon,
  });

  @override
  List<Object> get props => [
        id,
        title,
        icon,
      ];
}

class GroupRadioTagsWidget extends StatefulWidget {
  final List<GroupRadioTags> tags;
  final CallBackHandler callback;
  final CallBackHandler callBackIndex;
  final int defaultIndex;

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
  int _currentIndex;

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
      child: FlatButton(
        padding: const EdgeInsets.all(8),
        color: isSelected ? Color(0xfff2e8ff) : Colors.white,
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
          if (widget.callback != null) widget.callback(id);
          if (widget.callBackIndex != null) widget.callBackIndex(index);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            side: BorderSide(
                color: isSelected ? Color(0xfff2e8ff) : Color(0xffdcdcdc))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(LocalizationsUtil.of(context).translate(title),
                style: isSelected
                    ? AppFonts.medium14.copyWith(color: Color(0xff5b00e4))
                    : AppFonts.medium14.copyWith(color: Colors.black)),
            const SizedBox(width: 5),
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
      ),
    );
  }
}
