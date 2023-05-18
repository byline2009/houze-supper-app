import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  ReportState([List props = const []]);
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {
  @override
  String toString() => 'ReportInitial';
}

class ReportLoading extends ReportState {
  @override
  String toString() => 'ReportLoading';
}

class ReportSuccessful extends ReportState {
  ReportSuccessful();

  @override
  String toString() => 'ReportSuccessful';
}

class ReportFailure extends ReportState {
  final String error;

  ReportFailure({required this.error}) : super([error]);
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'ReportFailure { error: ${error.toString()} }';
}

class ReportUserLoading extends ReportState {
  @override
  String toString() => 'ReportUserLoading';
}
