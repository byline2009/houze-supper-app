import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/api/poll_repo.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/voting_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';

import '../../../../../../index.dart';

class VotingBloc extends Bloc<VotingEvent, List<VotingModel>> {
  bool isNext = true;
  bool isLoading = false;
  int historyPage = 1;
  List<VotingModel> historyResult = [];
  int historyOffset = 0;
  final repository = PollRepository();
  VotingBloc() : super([]) {
    on<GetUserChoiceEvent>((event, emit) async {
      this.historyPage = event.page;

      if (this.historyPage == 1) {
        historyResult = [];
      }

      var currentOffset =
          (this.historyPage * AppConstant.limitDefault) + historyOffset;
      if (historyResult.length <= AppConstant.limitDefault) {
        currentOffset = historyResult.length;
      }

      var results = await repository.getVoting(
        id: event.id,
        offset: currentOffset,
        limit: AppConstant.limitDefault,
      );

      //If empty
      if (results != null && results.length == 0) {
        isNext = false;
      } else {
        isNext = true;
      }

      if (results != null && results.length > 0) {
        this.historyPage++;
      }

      results?.insertAll(0, historyResult);
      historyResult = results!;

      emit(results);
    });
  }
}
