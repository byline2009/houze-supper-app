import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class TabbarTitleEvent extends Equatable {
  TabbarTitleEvent() : super();
}

class GetTabbarTitle extends TabbarTitleEvent {
  final String? service;
  GetTabbarTitle({this.service});
  @override
  String toString() => 'GetTabbarTitle service=$service';

  @override
  List<Object> get props => [
        service ?? '',
      ];
}
