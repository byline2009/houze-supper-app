import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/merchant/index.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  final merchantRepository = MerchantRepository();

  MerchantBloc(initialState) : super(MerchantInitial()) {
    on<MerchantGetShopDetailByID>((event, emit) async {
      emit(MerchantShopLoading());
      try {
        final result = await merchantRepository.getMerchantShopByID(event.id);
        emit(MerchantDetailSuccessful(result: result));
      } catch (error) {
        emit(MerchantShopFailure(error: error));
      }
    });
  }
}
