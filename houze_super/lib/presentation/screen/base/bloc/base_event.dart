import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  BaseEvent([List props = const []]) : super();
}

class BaseLoadList extends BaseEvent {
  final dynamic params;

  BaseLoadList({this.params}) : super([]);

  @override
  List<Object> get props => [params];
}

class BaseRequest extends BaseEvent {
  final dynamic params;

  BaseRequest({this.params}) : super([]);
  @override
  List<Object> get props => [params];
}
