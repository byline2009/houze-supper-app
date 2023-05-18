import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/middle/repo/comment_repository.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/comment/index.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repo = CommentRepository();

  CommentBloc() : super(CommentInitial());

  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if (event is EventGetCommentByID) {
      yield CommentLoading();

      try {
        final result = await repo.getComments(event.id);
        final rs = (result.results as List).map((i) {
          return CommentModel.fromJson(i);
        }).toList();

        yield GetCommentByIDSuccessful(result: rs, totalCount: result.count);
      } catch (error) {
        yield CommentFailure(error: error.toString());
      }
    }

    if (event is EventGetCommentList) {
      yield CommentLoading();

      try {
        final result = await repo.getCommentListByPage(event.id, event.page);
        final rs = (result.results as List).map((i) {
          return CommentModel.fromJson(i);
        }).toList();
        yield GetCommentByIDSuccessful(result: rs, totalCount: result.count);
      } catch (error) {
        yield CommentFailure(error: error.toString());
      }
    }
    if (event is EventSendCommentByID) {
      yield CommentLoading();

      try {
        final result =
            await repo.sendComment(event.id, event.content, event.image);
        yield SendCommentSuccessful(result: result);
      } catch (error) {
        yield CommentFailure(error: error.toString());
      }
    }
  }
}
