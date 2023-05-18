import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/bloc/poll_comment_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/bloc/poll_comment_state.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/middle/repo/poll_comment_repo.dart';
import 'package:houze_super/utils/sqflite.dart';

class PollCommentBloc extends Bloc<PollCommentEvent, PollCommentState> {
  final PollCommentRepository repo = PollCommentRepository();

  PollCommentBloc() : super(PollCommentInitial()) {
    on<EventGetPollCommentList>((event, emit) async {
      emit(PollCommentLoading());

      try {
        final result = await repo.getPollCommentList(
            id: event.id, page: event.page, ordering: event.ordering ?? "");
        final rs = (result.results as List).map((i) {
          return PollCommentModel.fromJson(i);
        }).toList();

        // remove blocked user's polls
        final list = await Sqflite.getBlackListUser();
        String? currentUserId = Storage.getUserID();
        List<String> listBlockedUser = [];
        if (list.isNotEmpty) {
          for (int i = 0; i < list.length; ++i) {
            if (currentUserId! == list[i].myId) {
              listBlockedUser.add(list[i].userId);
            }
          }
          listBlockedUser = listBlockedUser.toSet().toList();
        }

        final filteredBlockComments = rs
            .where((model) => !listBlockedUser.contains(model.userId))
            .toList();

        emit(GetPollCommentListSuccessful(
            result: filteredBlockComments, totalCount: filteredBlockComments.length));
      } catch (error) {
        emit(PollCommentFailure(error: error.toString()));
      }
    });

    on<EventSendPollComment>((event, emit) async {
      emit(PollCommentLoading());

      try {
        final result = await repo.sendComment(event.description,
            event.displayType, event.threadID, event.imageID ?? "");
        emit(SendPollCommentSuccessful(result: result));
      } catch (error) {
        emit(PollCommentFailure(error: error.toString()));
      }
    });
  }
}
