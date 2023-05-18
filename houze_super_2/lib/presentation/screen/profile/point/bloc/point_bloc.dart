import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/middle/repo/point_transaction_repository.dart';
import 'package:houze_super/presentation/screen/profile/point/bloc/point_event.dart';
import 'package:houze_super/utils/constant/index.dart';

class PointHistoryBloc
    extends Bloc<PointEvent, List<PointTransationHistoryModel>> {
  bool isNext = true;
  String? action;
  String? buildingId;
  bool isLoading = false;
  int historyPage = 1;
  List<PointTransationHistoryModel> historyResult = [];
  int historyOffset = 0;
  String? date;

  final repo = PointTransationRepository();
  PointHistoryBloc({this.isLoading = false})
      : super(<PointTransationHistoryModel>[]) {
    on<GetPointHistory>((event, emit) async {
      if (event.page != null) {
        this.historyPage = event.page!;
      }
      if (event.buildingId != null) {
        this.buildingId = event.buildingId;
      }
      if (event.action != null) {
        this.action = event.action;
      }
      if (event.date != null) {
        this.date = event.date;
      } else {
        this.date = null;
      }

      //first init
      if (event.page == 0) {
        emit(historyResult);
        return;
      }

      if (this.historyPage == 1) {
        historyResult = <PointTransationHistoryModel>[];
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

      var results = await repo.getPointTransactionHistory(
          action: this.action,
          offset: currentOffset,
          limit: AppConstant.limitDefault,
          date: this.date);

      //If empty
      if (results!.length == 0) {
        isNext = false;
      } else {
        isNext = true;
      }

      if (results.length > 0) {
        this.historyPage++;
      }

      results.insertAll(0, historyResult);
      historyResult = results;

      emit(results);
    });
  }
}
