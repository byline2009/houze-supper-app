import 'package:equatable/equatable.dart';

abstract class BaseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BaseLoadList extends BaseEvent {
  final dynamic params;

  BaseLoadList({this.params});

  @override
  List<Object> get props => [params];
}

class BaseRequest extends BaseEvent {
  final dynamic params;

  BaseRequest({this.params});
  @override
  List<Object> get props => [params];
}
