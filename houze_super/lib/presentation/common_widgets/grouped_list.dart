library grouped_list;

import 'dart:async';
import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';

/// A groupable list of widgets similar to [ListView], execpt that the
/// items can be sectioned into groups.
///
/// See [ListView.builder]
class GroupedListView<T, E> extends StatefulWidget {
  final Key key;

  /// Items of which [itemBuilder] or [indexedItemBuilder] produce the list.
  final List<T> elements;

  /// Defines which elements are grouped together.
  ///
  /// Function is called for each element in the list, when equal for two
  /// elements, those two belong to the same group.
  final E Function(T element) groupBy;

  /// Can be used to define a custom sorting for the groups.
  ///
  /// If not set groups will be sorted with their natural sorting order or their
  /// specific [Comparable] implementation.
  final int Function(E value1, E value2) groupComparator;

  /// Can be used to define a custom sorting for the elements inside each group.
  ///
  /// If not set elements will be sorted with their natural sorting order or
  /// their specific [Comparable] implementation.
  final int Function(T element1, T element2) itemComparator;

  /// Called to build group separators for each group.
  /// Value is always the groupBy result from the first element of the group.
  ///
  /// Will be ignored if [groupHeaderBuilder] is used.
  final Widget Function(E value) groupSeparatorBuilder;

  /// Same as [groupSeparatorBuilder], will be called to build group separators
  /// for each group.
  /// The passed element is always the first element of the group.
  ///
  /// If defined [groupSeparatorBuilder] wont be used.
  final Widget Function(T element) groupHeaderBuilder;

  /// Called to build children for the list with
  /// 0 <= element < elements.length.
  final Widget Function(BuildContext context, T element) itemBuilder;

  /// Called to build children for the list with
  /// 0 <= element, index < elements.length
  final Widget Function(BuildContext context, T element, int index)
      indexedItemBuilder;

  /// Whether the order of the list is ascending or descending.
  ///
  /// Defaults to ASC.
  final GroupedListOrder order;

  /// Whether the elements will be sorted or not. If not it must be done
  ///  manually.
  ///
  /// Defauts to true.
  final bool sort;

  /// When set to true the group header of the current visible group will stick
  ///  on top.
  final bool useStickyGroupSeparators;

  /// Called to build separators for between each item in the list.
  final Widget separator;

  /// Whether the group headers float over the list or occupy their own space.
  final bool floatingHeader;

  /// Background color of the sticky header.
  /// Only used if [floatingHeader] is false.
  final Color stickyHeaderBackgroundColor;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// See [ScrollView.controller]
  final ScrollController controller;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// See [ScrollView.primary]
  final bool primary;

  /// How the scroll view should respond to user input.
  ///
  /// See [ScrollView.physics].
  final ScrollPhysics physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// See [ScrollView.shrinkWrap]
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry padding;

  /// Whether to wrap each child in an [AutomaticKeepAlive].
  ///
  /// See [SliverChildBuilderDelegate.addAutomaticKeepAlives].
  final bool addAutomaticKeepAlives;

  /// Whether to wrap each child in a [RepaintBoundary].
  ///
  /// See [SliverChildBuilderDelegate.addRepaintBoundaries].
  final bool addRepaintBoundaries;

  /// Whether to wrap each child in an [IndexedSemantics].
  ///
  /// See [SliverChildBuilderDelegate.addSemanticIndexes].
  final bool addSemanticIndexes;

  /// Creates a scrollable, linear array of widgets that are created on demand.
  ///
  /// See [ScrollView.cacheExtent]
  final double cacheExtent;

  /// Creates a [GroupedListView]
  GroupedListView({
    @required this.elements,
    @required this.groupBy,
    this.groupComparator,
    this.groupSeparatorBuilder,
    this.groupHeaderBuilder,
    this.itemBuilder,
    this.indexedItemBuilder,
    this.itemComparator,
    this.order = GroupedListOrder.ASC,
    this.sort = true,
    this.useStickyGroupSeparators = false,
    this.separator = const SizedBox.shrink(),
    this.floatingHeader = false,
    this.stickyHeaderBackgroundColor = const Color(0xffF7F7F7),
    this.key,
    this.scrollDirection = Axis.vertical,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.cacheExtent,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GroupedListViewState<T, E>();
}

class _GroupedListViewState<T, E> extends State<GroupedListView<T, E>> {
  StreamController<int> _streamController = StreamController<int>();
  ScrollController _controller;
  Map<String, GlobalKey> _keys = LinkedHashMap<String, GlobalKey>();
  GlobalKey _groupHeaderKey;
  List<T> _sortedElements = [];
  GlobalKey _key = GlobalKey();
  int _topElementIndex = 0;
  RenderBox _headerBox;
  RenderBox _listBox;

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._sortedElements = _sortElements();

    //TODO: Sticky header disable
//    Stack(
//        key: _key,
//        alignment: Alignment.topCenter,
//        children: <Widget>[
//          StreamBuilder<int>(
//            stream: _streamController.stream,
//            initialData: _topElementIndex,
//            builder: (context, snapshot) => _showFixedGroupHeader(snapshot.data),
//          ),
//        ],
//      )

    return ListView.builder(
      key: widget.key,
      scrollDirection: widget.scrollDirection,
      controller: _getController(),
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemCount: _sortedElements.length * 2,
      addAutomaticKeepAlives: widget.addAutomaticKeepAlives,
      addRepaintBoundaries: widget.addRepaintBoundaries,
      addSemanticIndexes: widget.addSemanticIndexes,
      cacheExtent: widget.cacheExtent,
      itemBuilder: (context, index) {
        int actualIndex = index ~/ 2;
        if (index == 0) {
          return AnimatedOpacity(
            duration: duration,
            opacity: widget.useStickyGroupSeparators ? 0 : 1,
            child: _buildGroupSeparator(_sortedElements[actualIndex]),
          );
        }
        if (index.isEven) {
          E curr = widget.groupBy(_sortedElements[actualIndex]);
          E prev = widget.groupBy(_sortedElements[actualIndex - 1]);
          if (prev != curr) {
            return _buildGroupSeparator(_sortedElements[actualIndex]);
          }
          return widget.separator;
        }
        return _buildItem(context, actualIndex);
      },
    );
  }

  Container _buildItem(context, int actualIndex) {
    GlobalKey key = GlobalKey();
    _keys['$actualIndex'] = key;
    return Container(
        key: key,
        child: widget.indexedItemBuilder == null
            ? widget.itemBuilder(context, _sortedElements[actualIndex])
            : widget.indexedItemBuilder(
                context, _sortedElements[actualIndex], actualIndex));
  }

  ScrollController _getController() {
    _controller =
        widget.controller == null ? ScrollController() : widget.controller;
    if (widget.useStickyGroupSeparators) {
      _controller.addListener(_scrollListener);
    }
    return _controller;
  }

  _scrollListener() {
    _listBox ??= _key?.currentContext?.findRenderObject();
    double listPos = _listBox?.localToGlobal(Offset.zero)?.dy ?? 0;
    _headerBox ??= _groupHeaderKey?.currentContext?.findRenderObject();
    double headerHeight = _headerBox?.size?.height ?? 0;
    double max = double.negativeInfinity;
    String topItemKey = '0';
    for (var entry in _keys.entries) {
      var key = entry.value;
      if (_isListItemRendered(key)) {
        RenderBox itemBox = key.currentContext.findRenderObject();
        double y =
            itemBox.localToGlobal(Offset(0, -listPos - 2 * headerHeight)).dy;
        if (y <= 0 && y > max) {
          topItemKey = entry.key;
          max = y;
        }
      }
    }
    var index = int.parse(topItemKey);
    if (index != _topElementIndex) {
      E curr = widget.groupBy(_sortedElements[index]);
      E prev = widget.groupBy(_sortedElements[_topElementIndex]);
      if (prev != curr) {
        _topElementIndex = index;
        _streamController.add(_topElementIndex);
      }
    }
  }

  List<T> _sortElements() {
    List<T> elements = widget.elements;
    if (widget.sort && elements.isNotEmpty) {
      elements.sort((e1, e2) {
        var compareResult;
        // compare groups
        if (widget.groupComparator != null) {
          compareResult =
              widget.groupComparator(widget.groupBy(e1), widget.groupBy(e2));
        } else if (widget.groupBy(e1) is Comparable) {
          compareResult = (widget.groupBy(e1) as Comparable)
              .compareTo(widget.groupBy(e2) as Comparable);
        }
        // compare elements inside group
        if ((compareResult == null || compareResult == 0)) {
          if (widget.itemComparator != null) {
            compareResult = widget.itemComparator(e1, e2);
          } else if (e1 is Comparable) {
            compareResult = e1.compareTo(e2);
          }
        }
        return compareResult;
      });
      if (widget.order == GroupedListOrder.DESC) {
        elements = elements.reversed.toList();
      }
    }
    return elements;
  }

  // Widget _showFixedGroupHeader(int topElementIndex) {
  //   _groupHeaderKey = GlobalKey();
  //   if (widget.useStickyGroupSeparators && widget.elements.length > 0) {
  //     return Container(
  //       key: _groupHeaderKey,
  //       color:
  //           widget.floatingHeader ? null : widget.stickyHeaderBackgroundColor,
  //       width: widget.floatingHeader ? null : MediaQuery.of(context).size.width,
  //       child: _buildGroupSeparator(_sortedElements[topElementIndex]),
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }

  bool _isListItemRendered(GlobalKey<State<StatefulWidget>> key) {
    return key.currentContext != null &&
        key.currentContext.findRenderObject() != null;
  }

  Widget _buildGroupSeparator(T element) {
    if (widget.groupHeaderBuilder == null) {
      return widget.groupSeparatorBuilder(widget.groupBy(element));
    }
    return widget.groupHeaderBuilder(element);
  }
}

/// Used to define the order of a [GroupedListView].
enum GroupedListOrder { ASC, DESC }
