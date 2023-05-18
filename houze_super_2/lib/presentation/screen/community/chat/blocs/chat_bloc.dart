import 'package:bloc/bloc.dart';
import 'index.dart';
import '../models/index.dart';

class ChatDetailBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository repo;

  ChatDetailBloc({
    required this.repo,
  }) : super(ChatInitialState()) {
    on<EventChatDetailLoadMessages>((event, emit) async {
      emit(ChatOnLoadingState());
      try {
        final RoomModel? result = await repo.getMessagesOnRoom(
          roomID: event.roomID,
          page: event.page,
        );
        emit(ChatDetailLoadListSuccess(
          roomModel: result!,
        ));
      } catch (e) {
        emit(ChatDetailLoadListFailure(
          error: e,
        ));
      }
    });
  }
}
