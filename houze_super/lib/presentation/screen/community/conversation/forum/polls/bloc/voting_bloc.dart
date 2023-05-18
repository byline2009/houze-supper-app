import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/voting_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_repo.dart';
import 'package:houze_super/utils/constants/app_constants.dart';

class VotingBloc extends Bloc<VotingEvent, List<VotingModel>> {
  bool isNext = true;
  bool isLoading = false;
  int historyPage = 1;
  List<VotingModel> historyResult = [];
  int historyOffset = 0;
  final repository = PollRepository();
  VotingBloc({this.isLoading = false}) : super(List<VotingModel>());

  @override
  Stream<List<VotingModel>> mapEventToState(VotingEvent event) async* {
    if (event is GetUserChoiceEvent) {
      if (event.page != null) {
        this.historyPage = event.page;
      }

      //first init
      if (event.page == 0) {
        yield historyResult;
        return;
      }

      if (this.historyPage == 1) {
        historyResult = List<VotingModel>();
      }

      var currentOffset =
          (this.historyPage * AppConstant.limitDefault) + historyOffset;
      if (historyResult.length <= AppConstant.limitDefault) {
        currentOffset = historyResult.length;
      }

      if (event.page == 0) {
        historyOffset = 0;
        currentOffset = 0;
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

      results.insertAll(0, historyResult);
      historyResult = results;

      yield results;
    }
  }
}
