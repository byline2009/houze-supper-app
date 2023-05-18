import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/report_state.dart';
import 'package:houze_super/middle/repo/discussion_repo.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final DiscussionRepository repo = DiscussionRepository();
  ReportBloc() : super(ReportInitial()) {
    on<ReportPostSend>((event, emit) async {
      emit(ReportLoading());
      try {
        await repo.reportPost(id: event.postId, desc: event.desc);
        emit(ReportSuccessful());
      } catch (error) {
        emit(ReportFailure(error: error.toString()));
      }
    });

    on<ReportCommentSend>((event, emit) async {
      emit(ReportLoading());
      try {
        await repo.reportComment(commentId: event.commentId, desc: event.description);
        emit(ReportSuccessful());
      } catch (error) {
        emit(ReportFailure(error: error.toString()));
      }
    });
  }
}
