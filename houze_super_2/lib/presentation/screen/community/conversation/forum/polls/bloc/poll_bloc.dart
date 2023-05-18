import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/api/poll_repo.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/poll_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import '../../../../../../index.dart';
import 'poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  bool isNext = true;
  bool isLoading = false;
  int historyPage = 1;
  PollListSuccess historyResult = PollListSuccess([], false);
  int historyOffset = 0;
  final repository = PollRepository();
  PollBloc() : super(PollInitial()) {
    on<GetPollsEvent>((event, emit) async {
      if (event.page != null) {
        this.historyPage = event.page!;
      }
      //first init
      if (event.page == 0) {
        emit(historyResult);
        return;
      }

      if (this.historyPage == 1) {
        historyResult = PollListSuccess([], false);
      }

      var currentOffset =
          (this.historyPage * AppConstant.limitDefault) + historyOffset;
      if (historyResult.pollList.length <= AppConstant.limitDefault) {
        currentOffset = historyResult.pollList.length;
      }

      if (event.page == 0) {
        historyOffset = 0;
        currentOffset = 0;
      }

      emit(PollLoading());

      try {
        this.isLoading = true;
        var results = await repository.getPolls(
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

        List historyTemp = [historyResult.pollList, results]
            .expand((x) => x as List<PollModel>)
            .toList();
        historyResult = PollListSuccess(historyTemp as List<PollModel>, false);

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
          print(
              "============> list blocked user: " + listBlockedUser.toString());
        }
        if (results != null &&
            results.length > 0 &&
            listBlockedUser.length > 0) {
          results.removeWhere(
              (element) => listBlockedUser.contains(element.user!.id));

          emit(PollListSuccess(results, true));

          if (results.length == 0) {
            isNext = false;
          } else {
            isNext = true;
          }
        } else {
          emit(PollListSuccess(results ?? [], false));
        }
      } catch (e) {
        this.isLoading = false;
        emit(historyResult);
      }
    });

    on<UpdateTotalComment>((event, emit) async {
      var results = historyResult.pollList.where((element) {
        if (element.id == event.id) {
          element.commentCount = event.total;
        }
        return true;
      }).toList();

      emit(PollListSuccess(results, false));
    });

    on<UpdatePollChoices>((event, emit) async {
      var results = historyResult.pollList.where((element) {
        if (element.id == event.id) {
          element.poll = event.model;
        }
        return true;
      }).toList();

      emit(PollListSuccess(results, false));
    });
  }
}
