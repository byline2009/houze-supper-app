import 'package:equatable/equatable.dart';

class PagingModel<T> extends Equatable {
  final int count;
  final dynamic next;
  final dynamic previous;
  final List<T> results;

  PagingModel({
    this.count,
    this.next,
    this.previous,
    this.results,
  });

  @override
  List<Object> get props => [count, next, previous, results];
}
