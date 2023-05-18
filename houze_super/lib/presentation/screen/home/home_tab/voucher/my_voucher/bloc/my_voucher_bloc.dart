import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/my_voucher/bloc/index.dart';
import 'package:houze_super/utils/index.dart';

class MyVoucherBloc extends Bloc<MyPromotionEvent, PrivatePromotionList> {
  int page = 1;
  List<PrivatePromotionModel> result = [];
  bool isNext = true;
  int offset = 0;

  MerchantRepository repo = MerchantRepository();

  MyVoucherBloc(PrivatePromotionList initialState)
      : super(PrivatePromotionList(data: [], response: 1));

  @override
  Stream<PrivatePromotionList> mapEventToState(MyPromotionEvent event) async* {
    if (event is MyPromotionLoadList) {
      if (event.page != null) {
        this.page = event.page;
      }

      //first init
      if (event.page == 0) {
        yield PrivatePromotionList(
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

      final _results = await repo.getUserCoupon(event.status,
          offset: currentOffset, limit: AppConstant.limitDefault);

      //If empty
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

      yield PrivatePromotionList(
        data: _results.results,
        count: _results.count,
        response: 0,
      );
    }
  }
  //

}
