import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/services/services_event.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/sqflite.dart';

class ServicesNearByListBloc extends Bloc<ServicesEvent, MerchantList> {
  int page = 1;
  var result = <ShopModel>[];
  bool isNext = true;
  int offset = 0;

  MerchantRepository repo = MerchantRepository();

  ServicesNearByListBloc(MerchantList initialState)
      : super(MerchantList(
          data: [],
          response: 1,
        ));

  @override
  Stream<MerchantList> mapEventToState(ServicesEvent event) async* {
    if (event is MerchantLoadShopsByType) {
      BuildingMessageModel building = await Sqflite.getCurrentBuilding();
      String point = building.lat.toString() + "," + building.long.toString();

      if (event.page != null) {
        this.page = event.page;
      }

      //first init
      if (event.page == 0) {
        yield MerchantList(
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

      var _results = await repo.getShopsByType(
        point,
        offset: currentOffset,
        limit: AppConstant.limitDefault,
        type: event.type,
      );
      List<ShopModel> list = [];
      (_results.results as List)
          .map((e) => list.add(ShopModel.fromJson(e)))
          .toList();
      //If empty
      if (list.length == 0) {
        this.isNext = false;
      } else {
        this.isNext = true;
      }

      if (list.length > 0) {
        this.page++;
      }

      list.insertAll(0, this.result);
      result = list;

      yield MerchantList(
        data: list,
        count: _results.count,
        response: 0,
      );
    }
  }
}
