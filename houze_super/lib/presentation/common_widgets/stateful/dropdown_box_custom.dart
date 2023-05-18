import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class DropdownBoxCustom extends StatefulWidget {
  final EdgeInsetsGeometry margin;

  final String title;

  final List<dynamic> items;

  final dynamic item;

  final ValueChanged<dynamic> setItem;

  DropdownBoxCustom({
    @required this.margin,
    @required this.title,
    @required this.item,
    @required this.items,
    @required this.setItem,
  });

  @override
  _DropdownBoxCustomState createState() => _DropdownBoxCustomState();
}

class _DropdownBoxCustomState extends State<DropdownBoxCustom> {
  dynamic item;

  @override
  void initState() {
    super.initState();

    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:const EdgeInsets.all(16.0).copyWith(bottom: 20.0),
      margin: widget.margin,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        shadows: <BoxShadow>[
          BoxShadow(
            offset: Offset(0, 2.0),
            blurRadius: 10.0,
            color: Color.fromRGBO(0, 0, 0, 0.1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate(widget.title),
            style: AppFonts.medium,
          ),
          const SizedBox(height: 8.0),
          Container(
            height: 28.0,
            child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: AppFonts.medium,
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 28.0,
                    ),
                  ],
                ),
                shape: UnderlineInputBorder(),
                onPressed: () {
                  final FixedExtentScrollController controller =
                      FixedExtentScrollController(
                    initialItem: widget.items.indexOf(item),
                  );
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) {
                      final double height =
                          MediaQuery.of(context).size.height * 2 / 5;
                      final bottomPadding =
                          MediaQuery.of(context).size.height * 1 / 10;

                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.white,
                        ),
                        height: height,
                        padding: EdgeInsets.only(bottom: bottomPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  child: Text(
                                    LocalizationsUtil.of(context)
                                        .translate('cancel'),
                                    style: AppFonts.medium14
                                        .copyWith(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text(
                                    LocalizationsUtil.of(context)
                                        .translate('done_1'),
                                    style: AppFonts.medium14
                                        .copyWith(color: Color(0xff5b00e4)),
                                  ),
                                  onPressed: () {
                                    setState(() => item =
                                        widget.items[controller.selectedItem]);

                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    Navigator.of(context).pop(widget.setItem(
                                        widget.items[controller.selectedItem]));
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
                                    .map((e) => Align(child: Text(e.name)))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
