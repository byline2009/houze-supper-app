import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/middle/repo/discussion_repo.dart';
import 'package:houze_super/utils/constant/app_constant.dart';
import 'package:houze_super/utils/sqflite.dart';
part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  bool isNext = true;
  bool isLoading = false;
  int historyPage = 1;
  DiscussionListSuccess historyResult = DiscussionListSuccess([], false);
  int historyOffset = 0;
  final repository = DiscussionRepository();
  DiscussionBloc() : super(DiscussionInitial()) {
    on<GetDiscusionList>((event, emit) async {
      if (event.page != null) {
        this.historyPage = event.page!;
      }
      //first init
      if (event.page == 0) {
        emit(historyResult);
        return;
      }

      if (this.historyPage == 1) {
        historyResult = DiscussionListSuccess([], false);
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

      emit(DiscussionLoading());

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

        List historyTemp = [historyResult.discussionList, results]
            .expand((x) => x as List<DiscussionModel>)
            .toList();
        historyResult =
            DiscussionListSuccess(historyTemp as List<DiscussionModel>, false);

        // remove blocked user's posts
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
          print(
              "============> list blocked user: " + listBlockedUser.toString());
        }
        if (results != null &&
            results.length > 0 &&
            listBlockedUser.length > 0) {
          results.removeWhere(
              (element) => listBlockedUser.contains(element.user!.id));

          emit(DiscussionListSuccess(results, true));

          if (results.length == 0) {
            isNext = false;
          } else {
            isNext = true;
          }
        } else {
          emit(DiscussionListSuccess(results ?? [], false));
        }
      } catch (e) {
        this.isLoading = false;
        emit(historyResult);
      }
    });

    on<DeleteDiscussion>((event, emit) async {
      try {
        await repository.deleteThread(id: event.id);
      } catch (e) {
        throw ("Error: " + e.toString());
      }
    });

    on<UpdateCommentQuantity>((event, emit) async {
      var results = historyResult.discussionList.where((element) {
        if (element.id == event.id) {
          element.commentCount = event.quantity;
        }
        return true;
      }).toList();

      emit(DiscussionListSuccess(results, false));
    });
  }
}
