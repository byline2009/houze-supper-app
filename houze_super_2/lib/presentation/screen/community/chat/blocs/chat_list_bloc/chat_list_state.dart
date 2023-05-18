import 'package:equatable/equatable.dart';
import 'package:houze_super/presentation/screen/community/chat/models/last_message_model.dart';

// abstract class ChatListState extends Equatable {
//   const ChatListState();

//   @override
//   List<Object> get props => [];
// }

// class ChatListInitialState extends ChatListState {}

// class ChatListOnLoadingState extends ChatListState {}

// class GetListChatSuccessState extends ChatListState {
//   final List<LastMessageModel>? elementListModel;

//   const GetListChatSuccessState({
//     required this.elementListModel,
//   });

//   @override
//   List<Object> get props => [elementListModel ?? []];
//   @override
//   String toString() {
//     return 'GetListChatSuccessState  { ${elementListModel?.map((e) => print(e.toJson()))}}';
//   }
// }

// class GetListChatFailureState extends ChatListState {
//   final dynamic error;

//   const GetListChatFailureState({
//     required this.error,
//   });

//   @override
//   List<Object> get props => [
//         error,
//       ];

//   @override
//   String toString() => 'GetListChatFailureState Error=${error.toString()}';
// }

enum ChatListStatus {
  initial,
  loading,
  success,
  failure,
}

class ChatListState extends Equatable {
  const ChatListState({
    this.status = ChatListStatus.initial,
    this.result = const [],
  });

  final ChatListStatus status;
  final List<LastMessageModel> result;

  ChatListState copyWith({
    ChatListStatus? status,
    List<LastMessageModel>? result,
  }) {
    return ChatListState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  List<Object> get props => [
        status,
        result,
      ];
}
