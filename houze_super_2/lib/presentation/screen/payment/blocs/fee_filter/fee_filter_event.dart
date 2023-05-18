import 'package:equatable/equatable.dart';

abstract class FeeFilterEvent extends Equatable {
  FeeFilterEvent([List props = const []]);
  @override
  List<Object?> get props => [];
}

class FeeFilter extends FeeFilterEvent {
  final List<int> types;
  final String building;
  final String apartment;

  FeeFilter({
    required this.building,
    required this.apartment,
    required this.types,
  });

  @override
  String toString() {
    return 'FeeFilter types=${types.toList()} building=$building apartment=$apartment';
  }
}

class FeeDetailLoad extends FeeFilterEvent {
  final String building;
  final String apartment;
  final String type;

  FeeDetailLoad({
    required this.building,
    required this.apartment,
    required this.type,
  });

  @override
  String toString() {
    return 'FeeDetailLoad { type=$type building=$building apartment=$apartment}';
  }

  @override
  List<Object> get props => [
        type,
        apartment,
        building,
      ];
}
