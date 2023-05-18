import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class EKYCEvent extends Equatable {
  EKYCEvent([List props = const []]) : super();
}

class EKYCLoad extends EKYCEvent {
  @override
  String toString() => 'EKYCLoad';

  @override
  List<Object> get props => [];
}
