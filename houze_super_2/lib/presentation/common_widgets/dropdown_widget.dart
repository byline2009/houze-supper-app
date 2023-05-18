/*
  Widget by T7G, author: p.nguyen
*/

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/style/dropdown_style.dart';
import 'package:houze_super/utils/index.dart';

typedef VoidFunc = void Function();
typedef Int2VoidFunc = void Function(int);

enum DropDownStyle { box, line }

class DropdownWidgetController {
  FixedExtentScrollController _controller = FixedExtentScrollController();
  late VoidFunc? _callbackRefresh;

  void refresh() {
    if (_callbackRefresh != null) {
      _callbackRefresh!();
    }
  }

  FixedExtentScrollController get controller {
    return this._controller;
  }

  set controller(FixedExtentScrollController _controller) {
    this._controller = _controller;
  }
}

class DropdownWidget extends StatefulWidget {
  final String titleSheet;
  final String? labelText;
  final String? defaultHintText;
  final int initIndex;
  final bool centerText;
  final Function? buildChild;
  final Function? customDialog;
  final List<dynamic>? dataSource;
  final Int2VoidFunc? doneEvent;
  final Int2VoidFunc? cancelEvent;
  final DropdownWidgetController? controller;
  final DropDownStyle boxStyle;

  DropdownWidget({
    required this.doneEvent,
    this.controller,
    this.labelText,
    this.defaultHintText,
    this.dataSource,
    this.buildChild,
    this.customDialog,
    this.titleSheet = "",
    this.initIndex = -1,
    this.centerText = false,
    this.boxStyle = DropDownStyle.box,
    this.cancelEvent,
  });

  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  int selectedIndex = -1;
  final _dropdownController = TextEditingController();

  final StreamController<int> _dropdownStreamController =
      StreamController<int>();

  var _kPickerSheetHeight = 250.0;
  final double _kPickerTitleHeight = 44.0;

  @override
  void initState() {
    super.initState();
    widget.controller?._callbackRefresh = () {
      this.selectedIndex = -1;
      widget.controller?.controller = FixedExtentScrollController();
      _dropdownController.clear();
      _dropdownStreamController.sink.add(-1);
    };
  }

  @override
  void didUpdateWidget(DropdownWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget != widget) {
      if (widget.initIndex > -1 && widget.dataSource!.length > 0) {
        this.selectedIndex = widget.initIndex;
        widget.controller!.controller =
            FixedExtentScrollController(initialItem: this.selectedIndex);
        _dropdownController.text = widget.dataSource?[this.selectedIndex].value;
        this.onComplete();
      }
    }
  }

  void onCompleteNoRefreshDataSource() {
    widget.controller?.controller =
        FixedExtentScrollController(initialItem: this.selectedIndex);
    _dropdownController.text = widget.dataSource?[this.selectedIndex].value;
    _dropdownStreamController.sink.add(this.selectedIndex);
  }

  void onComplete() {
    this.onCompleteNoRefreshDataSource();
    if (widget.doneEvent != null) {
      widget.doneEvent!(this.selectedIndex);
    }
  }

  void setValue(KeyValueModel value) {
    _dropdownController.text = value.value;
  }

  Widget _buildBottomPicker(
    BuildContext context,
    Widget picker,
  ) {
    //Default select item
    if (this.selectedIndex == -1) this.selectedIndex = 0;

    return DecoratedBox(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(
            20.0,
          ),
        ),
        color: CupertinoColors.white,
      ),
      child: SizedBox(
        height: _kPickerSheetHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: DefaultTextStyle(
            style: const TextStyle(
              fontFamily: AppFont.font_family_display,
              color: CupertinoColors.black,
              fontSize: 22.0,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                children: <Widget>[
                  // Title Action
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(
                          20.0,
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: _kPickerTitleHeight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            height: _kPickerTitleHeight,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(0),
                              ),
                              child: Text(
                                LocalizationsUtil.of(context)
                                    .translate('cancel'),
                                style: AppFonts.medium14,
                              ),
                              onPressed: () {
                                if (widget.cancelEvent != null) {
                                  this.selectedIndex = -1;
                                  widget.controller?.controller =
                                      FixedExtentScrollController();
                                  _dropdownController.clear();
                                  _dropdownStreamController.sink.add(-1);
                                  widget.cancelEvent!(this.selectedIndex);
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: _kPickerTitleHeight,
                              child: Text(
                                widget.titleSheet,
                                style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  color: Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _kPickerTitleHeight,
                            child: TextButton(
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
                                if (widget.doneEvent != null) {
                                  this.onComplete();
                                }
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Content data source
                  Flexible(child: picker),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _kPickerSheetHeight = _screenSize.height * 40 / 100;

    return StreamBuilder(
      stream: _dropdownStreamController.stream,
      initialData: -1,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //print("draw ${snapshot.data}");

        return GestureDetector(
          onTap: () async {
            if (widget.dataSource!.length == 0) return;

            if (widget.buildChild != null) {
              await showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildBottomPicker(
                        context,
                        CupertinoPicker(
                          scrollController: widget.controller?.controller,
                          itemExtent: _kPickerTitleHeight,
                          backgroundColor: CupertinoColors.white,
                          onSelectedItemChanged: (int index) {
                            this.selectedIndex = index;
                          },
                          children: List<Widget>.generate(
                              widget.dataSource!.length, (int index) {
                            return widget.buildChild!(index);
                          }),
                        ));
                  });
            } else {
              widget.customDialog!(this);
            }
          },
          child: () {
            switch (widget.boxStyle) {
              case DropDownStyle.line:
                return DropdownStyle.dropdownLineStyle1(
                  _dropdownController,
                  centerText: widget.centerText,
                  defaultHintText: LocalizationsUtil.of(context)
                      .translate(widget.defaultHintText),
                );
              case DropDownStyle.box:
                break;
            }
            return DropdownStyle.dropdownStyle1(
              _dropdownController,
              centerText: widget.centerText,
              defaultHintText: LocalizationsUtil.of(context)
                  .translate(widget.defaultHintText),
            );
          }(),
        );
      },
    );
  }

  @override
  void dispose() {
    _dropdownStreamController.close();
    super.dispose();
  }
}
