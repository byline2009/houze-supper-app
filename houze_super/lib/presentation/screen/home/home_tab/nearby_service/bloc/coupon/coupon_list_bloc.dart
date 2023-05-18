import 'package:bloc/bloc.dart';

import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/coupon/index.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/sqflite.dart';

class CouponListBloc extends Bloc<CouponEvent, CouponListModel> {
  int page = 1;
  var result = <CouponModel>[];
  bool isNext = true;
  int offset = 0;

  MerchantRepository merchantRepository = MerchantRepository();

  CouponListBloc(CouponListModel initialState) : super(CouponListModel());

  CouponListModel get initialState => CouponListModel(
        data: result,
        response: 1,
      );

  @override
  Stream<CouponListModel> mapEventToState(CouponEvent event) async* {
    if (event is CouponLoadList) {
      BuildingMessageModel building = await Sqflite.getCurrentBuilding();
      String point = building.lat.toString() + "," + building.long.toString();

      if (event.page != null) {
        this.page = event.page;
      }

      //first init
      if (event.page == 0) {
        yield CouponListModel(
          data: result,
          count: 0,
          response: 0,
        );
        return;
      }

      var currentOffset = (this.page * AppConstant.limitDefault) + this.offset;
      if (result.length <= AppConstant.limitDefault) {
        currentOffset = result.length;
      }

      //for refresh drag
      if (event.page == -1) {
        currentOffset = offset = this.page = 0;
        this.result = [];
      }

      var _results = await merchantRepository.getAllCoupon(point,
          offset: currentOffset,
          limit: AppConstant.limitDefault,
          type: event.type);

      //If empty
      if (_results == null) {
        _results = PagingCouponModel(results: List<CouponModel>(), count: 0);
      }

      if (_results.results.length == 0) {
        this.isNext = false;
      } else {
        this.isNext = true;
      }

      if (_results.results.length > 0) {
        this.page++;
      }

      _results.results.insertAll(0, this.result);
      result = _results.results;

      yield CouponListModel(
        data: _results.results,
        count: _results.count,
        response: 0,
      );
    }
  }
}
