import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

class CupertinoModelPopupCustom extends StatefulWidget {
  final List<dynamic> items;

  final dynamic item;

  final ValueChanged<dynamic> setItem;

  CupertinoModelPopupCustom({
    required this.items,
    required this.item,
    required this.setItem,
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
    return TextButton(
      style: TextButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.padded,
        padding: const EdgeInsets.all(0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.toString(),
            style: AppFonts.medium14.copyWith(color: Color(0xff6001d2)),
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

            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
                color: Colors.white,
              ),
              child: SizedBox(
                height: height,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: Text(
                              LocalizationsUtil.of(context).translate('cancel'),
                              style: AppFonts.medium14,
                            ),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(right: 20),
                            ),
                            child: Text(
                              LocalizationsUtil.of(_).translate('done_1'),
                              style: AppFonts.medium14.copyWith(
                                color: Color(
                                  0xff5B00E4,
                                ),
                              ),
                            ),
                            onPressed: () {
                              setState(() =>
                                  item = widget.items[controller.selectedItem]);

                              FocusScope.of(context).requestFocus(FocusNode());
                              widget.setItem(item);
                              Navigator.of(context).pop();
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
                              .map(
                                (e) => Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    e.toString(),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
