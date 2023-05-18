import 'package:equatable/equatable.dart';
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
  const ChatDetailLoadListSuccess({required this.roomModel});

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



