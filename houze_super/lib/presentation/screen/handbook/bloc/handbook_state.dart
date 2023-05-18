import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/handbook_model.dart';

abstract class HandbookState extends Equatable {
  HandbookState([List props = const []]) : super();
}

class HandbookInitial extends HandbookState {
  @override
  String toString() => 'HandbookInitial';
  @override
  List<Object> get props => [];
}

class HandbookListGetSuccessful extends HandbookState {
  final dynamic handbooks;

  HandbookListGetSuccessful({@required this.handbooks});
  @override
  List<Object> get props => [handbooks];
  @override
  String toString() => 'HandbookListGetSuccessful { handbooks: $handbooks }';
}

class HandbookDetailGetSuccessful extends HandbookState {
  final Handbook handbook;

  HandbookDetailGetSuccessful({@required this.handbook});
  @override
  List<Object> get props => [handbook];
  @override
  String toString() => 'HandbookDetailGetSuccessful { handbook: $handbook }';
}

class HandbookGetLoading extends HandbookState {
  @override
  String toString() => 'HandbookGetLoading';
  @override
  List<Object> get props => [];
}

class HandbookGetFailure extends HandbookState {
  final dynamic error;

  HandbookGetFailure({@required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'HandbookGetFailure { error: $error }';
}
