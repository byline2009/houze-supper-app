import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/bloc/poll_comment_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/bloc/poll_comment_state.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/networking/poll_comment_repo.dart';

class PollCommentBloc extends Bloc<PollCommentEvent, PollCommentState> {
  final PollCommentRepository repo = PollCommentRepository();

  PollCommentBloc() : super(PollCommentInitial());

  @override
  Stream<PollCommentState> mapEventToState(PollCommentEvent event) async* {
    if (event is EventGetPollCommentList) {
      yield PollCommentLoading();

      try {
        final result = await repo.getPollCommentList(
            id: event.id, page: event.page, ordering: event?.ordering);
        final rs = (result.results as List).map((i) {
          return PollCommentModel.fromJson(i);
        }).toList();

        yield GetPollCommentListSuccessful(
            result: rs, totalCount: result.count);
      } catch (error) {
        yield PollCommentFailure(error: error.toString());
      }
    }

    if (event is EventSendPollComment) {
      yield PollCommentLoading();

      try {
        final result = await repo.sendComment(event.description,
            event.displayType, event.threadID, event.imageID);
        yield SendPollCommentSuccessful(result: result);
      } catch (error) {
        yield PollCommentFailure(error: error.toString());
      }
    }
  }
}
