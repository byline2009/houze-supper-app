import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../models/index.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatOnLoadingState extends ChatState {}

class ChatDetailLoadListSuccess extends ChatState {
  final RoomModel roomModel;
  const ChatDetailLoadListSuccess({this.roomModel});

  @override
  List<Object> get props => [roomModel];
}

class ChatDetailLoadListFailure extends ChatState {
  final dynamic error;
  const ChatDetailLoadListFailure({this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return '[ChatDetailLoadListFailure] Error: ${error.toString()}';
  }
}

class GetListChatSuccessState extends ChatState {
  final List<LastMessageModel> elementListModel;

  const GetListChatSuccessState({@required this.elementListModel});

  @override
  List<Object> get props => [elementListModel];
  @override
  String toString() {
    return 'GetListChatSuccessState  \n{ ${elementListModel.map((e) => print(e.toJson()))}}';
  }
}

class GetListChatFailureState extends ChatState {
  final dynamic error;

  const GetListChatFailureState({@required this.error});

  @override
  List<Object> get props => [error];

  @override
  String toString() {
    return '[GetListChatFailureState] Error: ${error.toString()}';
  }
}
