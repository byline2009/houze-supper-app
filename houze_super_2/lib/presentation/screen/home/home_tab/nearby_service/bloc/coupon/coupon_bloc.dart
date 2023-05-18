import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/coupon/index.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final merchantRepository = MerchantRepository();

  CouponBloc(CouponState initialState) : super(CouponInitial()) {
    on<MerchantLoadCouponsByShop>((event, emit) async {
      emit(CouponsLoading());
      try {
        final result = await merchantRepository.getCouponsByShop(
            shopID: event.shopId, page: event.page);
        emit(MerchantLoadCouponsByShopSuccessful(result: result));
      } catch (error) {
        emit(MerchantLoadCouponsShopFailure(error: error.toString()));
      }
    });
  }
}
