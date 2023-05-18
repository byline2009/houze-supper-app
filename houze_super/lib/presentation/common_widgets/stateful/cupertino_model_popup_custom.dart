import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class CupertinoModelPopupCustom extends StatefulWidget {
  final List<dynamic> items;

  final dynamic item;

  final ValueChanged<dynamic> setItem;

  CupertinoModelPopupCustom({
    @required this.items,
    @required this.item,
    @required this.setItem,
  });

  @override
  _CupertinoModelPopupCustomState createState() =>
      _CupertinoModelPopupCustomState();
}

class _CupertinoModelPopupCustomState extends State<CupertinoModelPopupCustom> {
  dynamic item;

  @override
  void initState() {
    super.initState();

    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.all(0),
      minWidth: 0.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.toString(),
            style: AppFonts.medium
                .copyWith(color: Color(0xff6001d2)), //MEDIUM_purple6001d2,
          ),
          const SizedBox(width: 4.0),
          Icon(
            Icons.keyboard_arrow_down,
            size: 20.0,
            color: Color(0xff6001d2),
          ),
        ],
      ),
      onPressed: () {
        final FixedExtentScrollController controller =
            FixedExtentScrollController(
          initialItem: widget.items.indexOf(item),
        );
        showCupertinoModalPopup(
          context: context,
          builder: (_) {
            final double height = MediaQuery.of(context).size.height * 2 / 5;
            final bottomPadding = MediaQuery.of(context).size.height * 1 / 10;

            return Container(
              height: height,
              padding: EdgeInsets.only(bottom: bottomPadding),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        child: Text(
                          LocalizationsUtil.of(context).translate('cancel'),
                          style:
                              AppFonts.medium14.copyWith(color: Colors.black),
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());

                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text(
                          LocalizationsUtil.of(_).translate('done_1'),
                          style: AppFonts.medium14
                              .copyWith(color: Color(0xff5b00e4)),
                        ),
                        onPressed: () {
                          setState(() =>
                              item = widget.items[controller.selectedItem]);

                          FocusScope.of(context).requestFocus(FocusNode());

                          Navigator.of(context).pop(widget
                              .setItem(widget.items[controller.selectedItem]));
                        },
                      )
                    ],
                  ),
                  Flexible(
                    child: CupertinoPicker(
                      itemExtent: 40.0,
                      scrollController: controller,
                      onSelectedItemChanged: (int index) {
                        print(widget.items[index]);
                      },
                      children: widget.items
                          .map((e) => Align(child: Text(e.toString())))
                          .toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
