import 'package:bloc/bloc.dart';
import 'package:houze_super/domain/facility/index.dart';
import 'package:houze_super/domain/facility_list/facility_list_event.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/model/facility/facility_page_model.dart';
import 'package:houze_super/middle/repo/facility_repository.dart';
import 'package:houze_super/utils/index.dart';

/*
  Facility history
*/
class FacilityHistoryBloc
    extends Bloc<FacilityEvent, List<FacilityHistoryModel>> {
  //History facility pager
  int historyPage = 1;
  List<FacilityHistoryModel> historyResult = [];
  bool isNext = true;
  int historyOffset = 0;
  dynamic historyStatus;
  String? facilityId;
  bool isLoading = false;

  final repo = FacilityRepository();

  FacilityHistoryBloc({this.isLoading = false}) : super([]) {
    on<FacilityGetHistoryPager>((event, emit) async {
      this.historyPage = event.page!;

      this.historyStatus = event.status;

      this.facilityId = event.facilityId;

      if (event.status == -1) {
        this.historyStatus = null;
      }

      //first init
      if (event.page == 0) {
        emit(historyResult);
        return;
      }

      if (this.historyPage == 1) {
        historyResult = [];
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

      var results = await repo.getHistories(event.facilityId,
          status: historyStatus,
          offset: currentOffset,
          limit: AppConstant.limitDefault);

      //If empty
      if (results?.length == 0) {
        isNext = false;
      } else {
        isNext = true;
      }

      if ((results?.length ?? 0) > 0) {
        this.historyPage++;
      }

      results?.insertAll(0, historyResult);
      historyResult = results ?? [];

      emit(results ?? []);
    });
  }
}

/*
  Facility load list
 */
class FacilityListBloc extends Bloc<FacilityListEvent, FacilityPageModel?> {
  FacilityRepository facilityRepository = FacilityRepository();
  bool isLoading = false;

  List<FacilityModel> previouseResult = [];

  int total = 0;
  int page = 1;
  int offset = 0;
  int limitInit = 10;
  bool isNext = true;

  FacilityListBloc({this.isLoading = false})
      : super(FacilityPageModel(total: 0, facility: [])) {
    on<FacilityHistoryLoadList>((event, emit) async {
      this.isLoading = false;

      this.page = event.page ?? 1;

      try {
        if (page == 1) {
          previouseResult = [];
        }

        var currentOffset = (page * limitInit) + offset;
        if (previouseResult.length <= limitInit) {
          currentOffset = previouseResult.length;
        }

        if (event.page == 0) {
          offset = 0;
          currentOffset = 0;
        }

        //print("${page} , ${limitInit} - ${currentOffset}");
        final result = await facilityRepository.getFacilities(
            limit: limitInit, offset: currentOffset);

        var results = (result.results as List).map((i) {
          return FacilityModel.fromJson(i);
        }).toList();
        //If empty
        if (results.length == 0) {
          isNext = false;
        } else {
          isNext = true;
        }

        if (results.length > 0) {
          this.page++;
        }

        results.insertAll(0, previouseResult);
        previouseResult = results;
        total = results.length;

        emit(FacilityPageModel(
          total: total,
          facility: results,
        ));
      } catch (error) {
        emit(null);
      }
    });
  }
}
