import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/coupon/index.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final merchantRepository = MerchantRepository();

  CouponBloc(CouponState initialState) : super(initialState);

  CouponState get initialState => CouponInitial();

  @override
  Stream<CouponState> mapEventToState(CouponEvent event) async* {
    if (event is MerchantLoadCouponsByShop) {
      yield CouponsLoading();
      try {
        final result = await merchantRepository.getCouponsByShop(
            shopID: event.shopId, page: event.page);
        yield MerchantLoadCouponsByShopSuccessful(result: result);
      } catch (error) {
        yield MerchantLoadCouponsShopFailure(error: error.toString());
      }
    }
  }
}
