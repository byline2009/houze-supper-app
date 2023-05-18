import 'package:bloc/bloc.dart';
import 'package:houze_super/presentation/screen/community/chat/models/last_message_model.dart';
import 'package:houze_super/presentation/screen/community/chat/networking/chat_repo.dart';
import 'index.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final ChatRepository _repo;

  ChatListBloc({
    required ChatRepository repo,
  })  : _repo = repo,
        super(const ChatListState()) {
    on<ChatLoadLastMessageList>((event, emit) async {
      emit(state.copyWith(
        status: ChatListStatus.loading,
      ));

      try {
        final List<LastMessageModel>? result = await _repo.getLastMessages(
          page: event.page,
          buildingID: event.buildingID,
        );
        emit(state.copyWith(
          status: ChatListStatus.success,
          result: result,
        ));
      } catch (e) {
        emit(state.copyWith(
          status: ChatListStatus.failure,
        ));
      }
    });
  }
}
