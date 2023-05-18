import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'app_dialog.dart';

class DropdownCustom extends StatefulWidget {
  final String? hintText;

  final List<dynamic> items;

  final dynamic item;

  final ValueChanged<dynamic> setItem;

  DropdownCustom({
    this.hintText,
    required this.item,
    required this.items,
    required this.setItem,
  });

  @override
  _DropdownCustomState createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
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
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.only(left: 20.0, right: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
          side: BorderSide(
            width: 0.7,
            color: item != null ? Colors.black : Color(0xFFd0d0d0),
          ),
        ),
      ),
      child: SizedBox(
        height: 48.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            item != null
                ? Text(
                    LocalizationsUtil.of(context).translate(item.name ?? ""),
                    style: AppFonts.medium14,
                  )
                : Text(
                    LocalizationsUtil.of(context).translate(widget.hintText),
                    style: AppFonts.regular14.copyWith(
                      color: Color(
                        0xff808080,
                      ),
                    ),
                  ),
            Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
          ],
        ),
      ),
      onPressed: () {
        if (widget.items.length == 0) {
          AppDialog.showAlertDialog(
            context,
            null,
            LocalizationsUtil.of(context).translate('k_no_data'),
          );
        } else {
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
                  color: CupertinoColors.white,
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
                                LocalizationsUtil.of(context)
                                    .translate('cancel'),
                                style: AppFonts.medium14,
                              ),
                              onPressed: () {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());

                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.only(right: 20),
                              ),
                              child: Text(
                                LocalizationsUtil.of(context)
                                    .translate('done_1'),
                                style: AppFonts.medium14.copyWith(
                                  color: Color(
                                    0xff5B00E4,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                setState(() => item =
                                    widget.items[controller.selectedItem]);

                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                widget.setItem(
                                    widget.items[controller.selectedItem]);
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
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate(e.name),
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
        }
      },
    );
  }
}
