import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/header_events.dart';

enum HighlightHeaderAlignment {
  bottom,
  center,
  top,
}

typedef Widget AppbarHandler(double opacity);

class FadingStretchy extends StatefulWidget {
  ///Header Widget that will be stretched, it will appear at the top of the page
  final Widget header;

  ///Height of your header widget
  final double headerHeight;

  ///highlight header that will be placed on the header,  this widget always be visible without blurring effect
  final Widget highlightHeader;

  ///alignment for the highlight header
  final HighlightHeaderAlignment highlightHeaderAlignment;

  ///Body Widget it will appear below the header
  final Widget body;

  ///The color of the blur, white by default
  final Color blurColor;

  ///Background Color of all of the content
  final Color backgroundColor;

  ///If you want to blur the content when scroll. True by default
  final bool blurContent;

  final AppbarHandler appbarHandler;

  final List<Widget> headerActions;
  final double headerActionsSize;

  const FadingStretchy(
      {Key key,
      @required this.header,
      @required this.body,
      @required this.headerHeight,
      this.highlightHeader,
      this.blurContent = true,
      this.highlightHeaderAlignment = HighlightHeaderAlignment.bottom,
      this.blurColor,
      this.backgroundColor,
      this.appbarHandler,
      this.headerActions,
      this.headerActionsSize})
      : assert(header != null),
        assert(body != null),
        assert(highlightHeaderAlignment != null),
        assert(headerHeight != null && headerHeight >= 0.0),
        super(key: key);

  @override
  _FadingStretchyState createState() => _FadingStretchyState();
}

const duration = const Duration(milliseconds: 500);

class _FadingStretchyState extends State<FadingStretchy> {
  ScrollController _scrollController;
  GlobalKey _keyHighlightHeader = GlobalKey();

  final StreamController<HeaderEvent> headerStream =
      new StreamController<HeaderEvent>.broadcast();
  final StreamController<HeaderEvent> appbarStream =
      new StreamController<HeaderEvent>.broadcast();

  double _offset = 0.0;
  double _headerSize = 0.0;
  double _highlightHeaderSize = 0.0;

  void _onLayoutDone(_) {
    final RenderBox renderBox =
        _keyHighlightHeader.currentContext.findRenderObject();
    _highlightHeaderSize = renderBox.size.height;
    headerStream.sink.add(
      HeaderEvent(
        offset: _offset,
        highlightHeaderSize: _highlightHeaderSize,
      ),
    );
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _headerSize = widget.headerHeight;
    if (widget.highlightHeader != null) {
      WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    headerStream.close();
    appbarStream.close();
    super.dispose();
  }

  //Calc
  double getHighlightPosition() {
    double highlightPosition = 0.0;
    if (widget.highlightHeaderAlignment == HighlightHeaderAlignment.top) {
      highlightPosition = (_offset >= 0.0 ? -_offset : 0.0);
    } else if (widget.highlightHeaderAlignment ==
        HighlightHeaderAlignment.center) {
      highlightPosition = _headerSize / 2 -
          (_offset >= 0.0 ? _offset : _offset / 2) -
          _highlightHeaderSize / 2;
    } else if (widget.highlightHeaderAlignment ==
        HighlightHeaderAlignment.bottom) {
      highlightPosition = _headerSize - _offset - _highlightHeaderSize;
    }
    return highlightPosition;
  }

  double getOpacityHeader(double highlightPosition) {
    double _opacityHeader =
        highlightPosition / (_headerSize - _highlightHeaderSize);
    //double _opacityHeader = _headerSize;
    if (_opacityHeader > 1.0) {
      _opacityHeader = 1.0;
    } else if (_opacityHeader < 0.0) {
      _opacityHeader = 0.0;
    }

    return _opacityHeader;
  }

  double getOpacityAppbar(double opacityHeader) {
    double _opacityAppbar = 1.0 - opacityHeader;
    if (_opacityAppbar > 1.0) {
      _opacityAppbar = 1.0;
    } else if (opacityHeader < 0.0) {
      _opacityAppbar = 0.0;
    }
    return _opacityAppbar;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return StreamBuilder(
      stream: headerStream.stream,
      initialData: HeaderEvent(
        offset: 0,
      ),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //First init
        double highlightPosition = getHighlightPosition();
        double _opacityHeader = getOpacityHeader(highlightPosition);
        double _opacityAppbar = getOpacityAppbar(_opacityHeader);

        //Height intro
        final heightIntro = _scrollController.hasClients &&
                _scrollController.position.extentAfter == 0.0
            ? _headerSize
            : _offset <= _headerSize
                ? _headerSize - _offset
                : 0.0;

        return MaterialApp(
          theme: ThemeData(
            primarySwatch: Colors.blue,
            bottomAppBarColor: Color(0xff7A1DFF),
            primaryColorBrightness:
                _opacityAppbar < 0.5 ? Brightness.dark : Brightness.light,
          ),
          home: Scaffold(
            body: Container(
              color: widget.backgroundColor,
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    child: ClipRect(
                      clipper: HeaderClipper(_headerSize - _offset),
                      child: AnimatedOpacity(
                        opacity: _opacityHeader,
                        duration: duration,
                        child: widget.header,
                      ),
                    ),
                    height: heightIntro,
                    width: screenSize.width,
                  ),
                  IgnorePointer(
                    child: widget.blurContent
                        ? ClipRect(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                  sigmaX:
                                      _offset < 0.0 ? _offset.abs() * 0.1 : 0.0,
                                  sigmaY: _offset < 0.0
                                      ? _offset.abs() * 0.1
                                      : 0.0),
                              child: Container(
                                height: _offset <= _headerSize
                                    ? _headerSize - _offset
                                    : 0.0,
                                decoration: BoxDecoration(
                                    color: (widget.blurColor ??
                                            Colors.grey.shade200)
                                        .withOpacity(
                                            _offset < 0.0 ? 0.15 : 0.0)),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is ScrollUpdateNotification) {
                        _offset = notification.metrics.pixels;
                        headerStream.sink.add(HeaderEvent(
                            offset: _offset,
                            highlightHeaderSize: _highlightHeaderSize));
                      }
                      return true;
                    },
                    child: ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(0),
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          SizedBox(
                            height: _headerSize,
                          ),
                          widget.body
                        ]),
                  ),
                  widget.headerActions != null
                      ? Positioned(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: widget.headerActions,
                          ),
                          right: screenSize.width * 0.05,
                          top:
                              getHighlightPosition() - widget.headerActionsSize)
                      : const SizedBox.shrink(),
                  widget.highlightHeader != null
                      ? Positioned(
                          key: _keyHighlightHeader,
                          left: 0,
                          right: 0,
                          top: highlightPosition - widget.headerActionsSize,
                          child: widget.highlightHeader,
                        )
                      : const SizedBox.shrink(),
                  Positioned(
                      top: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: widget.appbarHandler(_opacityAppbar))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HeaderClipper extends CustomClipper<Rect> {
  final double height;

  const HeaderClipper(this.height);

  @override
  getClip(Size size) => Rect.fromLTRB(0.0, 0.0, size.width, this.height);

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
