import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/poll_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_repo.dart';
import 'package:houze_super/utils/constants/app_constants.dart';
import 'poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  PollBloc() : super(PollInitial());
  bool isNext = true;
  bool isLoading = false;
  int historyPage = 1;
  PollListSuccess historyResult = PollListSuccess([]);
  int historyOffset = 0;
  final repository = PollRepository();

  @override
  Stream<PollState> mapEventToState(PollEvent event) async* {
    if (event is GetPollsEvent) {
      if (event.page != null) {
        this.historyPage = event.page;
      }
      //first init
      if (event.page == 0) {
        yield historyResult;
        return;
      }

      if (this.historyPage == 1) {
        historyResult = PollListSuccess([]);
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

      yield PollLoading();

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

        var historyTemp =
            [historyResult.pollList, results].expand((x) => x).toList();
        historyResult = PollListSuccess(historyTemp);
        yield PollListSuccess(results);
      } catch (e) {
        this.isLoading = false;
        yield historyResult;
      }
    }

    if (event is UpdateTotalComment) {
      var results = historyResult.pollList.where((element) {
        if (element.id == event.id) {
          element.commentCount = event.total;
        }
        return true;
      }).toList();

      yield PollListSuccess(results);
    }

    if (event is UpdatePollChoices) {
      var results = historyResult.pollList.where((element) {
        if (element.id == event.id) {
          element.poll = event.model;
        }
        return true;
      }).toList();

      yield PollListSuccess(results);
    }
  }
}
