import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/utils/index.dart';

class DropdownBox extends StatefulWidget {
  final String title;
  final List<ApartmentMessageModel> datasource;
  final int initialIndex;
  final ValueChanged<int> callback;

  DropdownBox({
    required this.title,
    this.initialIndex = 0,
    required this.datasource,
    required this.callback,
  });

  @override
  _DropdownBoxState createState() => _DropdownBoxState();
}

class _DropdownBoxState extends State<DropdownBox> {
  late final FixedExtentScrollController? _controller;
  late final List<ApartmentMessageModel> _listApartment;
  late int _currentIndex;
  @override
  void initState() {
    super.initState();
    _listApartment = widget.datasource;
    _currentIndex = widget.initialIndex;
    _controller = FixedExtentScrollController(
      initialItem: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationsUtil.of(context).translate(widget.title),
              style: AppFonts.medium,
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 28.0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(0)),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _listApartment[_currentIndex].name!,
                          style: AppFonts.medium,
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 28.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) {
                          final double height =
                              MediaQuery.of(context).size.height * 2 / 5;
                          final bottomPadding =
                              MediaQuery.of(context).size.height * 1 / 10;
                          WidgetsBinding.instance!.addPostFrameCallback(
                            (_) => _controller?.jumpToItem(
                              _currentIndex,
                            ),
                          );
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            child: Text(
                                              LocalizationsUtil.of(context)
                                                  .translate('cancel'),
                                              style: AppFonts.medium14,
                                            ),
                                            onPressed: () {
                                              _currentIndex =
                                                  widget.initialIndex;
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.only(
                                                  right: 0),
                                            ),
                                            child: Text(
                                              LocalizationsUtil.of(context)
                                                  .translate('done_1'),
                                              style: AppFonts.medium14.copyWith(
                                                  color: Color(0xff5b00e4)),
                                            ),
                                            onPressed: () {
                                              widget.callback(_currentIndex);
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                    Flexible(
                                      child: CupertinoPicker.builder(
                                        itemExtent: 40,
                                        scrollController: _controller,
                                        // FixedExtentScrollController(
                                        //     initialItem: _currentIndex),
                                        onSelectedItemChanged: (index) {
                                          _currentIndex = index;
                                          // print(_listApartment[index].name);
                                        },
                                        childCount: _listApartment.length,
                                        itemBuilder: (_, int index) {
                                          return Align(
                                            child: Text(
                                              _listApartment[index].name ?? '',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_controller != null) _controller?.dispose();
    super.dispose();
  }
}
