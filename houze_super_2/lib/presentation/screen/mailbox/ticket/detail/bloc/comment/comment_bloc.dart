import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/middle/repo/comment_repository.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/comment/index.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repo = CommentRepository();

  CommentBloc() : super(CommentInitial()) {
    on<EventGetCommentByID>((event, emit) async {
      emit(CommentLoading());

      try {
        final result = await repo.getComments(event.id);
        final rs = (result.results as List).map((i) {
          return CommentModel.fromJson(i);
        }).toList();

        emit(GetCommentByIDSuccessful(result: rs, totalCount: result.count));
      } catch (error) {
        emit(CommentFailure(error: error.toString()));
      }
    });

    on<EventGetCommentList>((event, emit) async {
      emit(CommentLoading());

      try {
        final result = await repo.getCommentListByPage(event.id, event.page);
        final rs = (result.results as List).map((i) {
          return CommentModel.fromJson(i);
        }).toList();
        emit(GetCommentByIDSuccessful(result: rs, totalCount: result.count));
      } catch (error) {
        emit(CommentFailure(error: error.toString()));
      }
    });

    on<EventSendCommentByID>((event, emit) async {
      emit(CommentLoading());

      try {
        final result =
            await repo.sendComment(event.id, event.content, event.image);
        emit(SendCommentSuccessful(result: result));
      } catch (error) {
        emit(CommentFailure(error: error.toString()));
      }
    });
  }
}
