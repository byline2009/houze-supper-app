import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/networking/discusstion_repo.dart';
import 'package:houze_super/utils/constants/app_constants.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  DiscussionBloc() : super(DiscussionInitial());
  bool isNext = true;
  bool isLoading = false;
  int historyPage = 1;
  DiscussionListSuccess historyResult = DiscussionListSuccess([]);
  int historyOffset = 0;
  final repository = DiscussionRepository();

  @override
  Stream<DiscussionState> mapEventToState(DiscussionEvent event) async* {
    if (event is GetDiscusionList) {
      if (event.page != null) {
        this.historyPage = event.page;
      }
      //first init
      if (event.page == 0) {
        yield historyResult;
        return;
      }

      if (this.historyPage == 1) {
        historyResult = DiscussionListSuccess([]);
      }

      var currentOffset =
          (this.historyPage * AppConstant.limitDefault) + historyOffset;
      if (historyResult.discussionList.length <= AppConstant.limitDefault) {
        currentOffset = historyResult.discussionList.length;
      }

      if (event.page == 0) {
        historyOffset = 0;
        currentOffset = 0;
      }

      yield DiscussionLoading();

      try {
        this.isLoading = true;
        var results = await repository.getThreads(
          offset: currentOffset,
          limit: AppConstant.limitDefault,
        );

        this.isLoading = false;

        //If empty
        if (results != null && results.length == 0) {
          isNext = false;
        } else {
          isNext = true;
        }

        if (results != null && results.length > 0) {
          this.historyPage++;
        }

        //results.insertAll(0, historyResult.discussionList);

        var historyTemp =
            [historyResult.discussionList, results].expand((x) => x).toList();
        historyResult = DiscussionListSuccess(historyTemp);
        yield DiscussionListSuccess(results);
      } catch (e) {
        this.isLoading = false;
        yield historyResult;
      }
    }

    if (event is DeleteDiscussion) {
      try {
        await repository.deleteThread(id: event.id);

        var results = historyResult.discussionList
            .where((element) => element.id != event.id)
            .toList();

        yield DiscussionListSuccess(results);
      } catch (e) {
        throw ("Error: " + e.toString());
      }
    }

    if (event is UpdateCommentQuantity) {
      var results = historyResult.discussionList.where((element) {
        if (element.id == event.id) {
          element.commentCount = event.quantity;
        }
        return true;
      }).toList();

      yield DiscussionListSuccess(results);
    }
  }
}
