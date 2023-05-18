import 'package:equatable/equatable.dart';

abstract class MyPromotionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class MyPromotionLoadList extends MyPromotionEvent {
  final int? page;
  final bool? status; //can_use

  MyPromotionLoadList({this.page, this.status});

  @override
  String toString() => 'MyPromotionLoadList { page: $page, status: $status }';

  @override
  List<Object> get props => [page ?? '', status ?? ''];
}
