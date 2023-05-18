import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/merchant/index.dart';

class MerchantBloc extends Bloc<MerchantEvent, MerchantState> {
  final merchantRepository = MerchantRepository();

  MerchantBloc(initialState) : super(initialState);
  MerchantState get initialState => MerchantInitial();

  @override
  Stream<MerchantState> mapEventToState(MerchantEvent event) async* {
    if (event is MerchantGetShopDetailByID) {
      yield MerchantShopLoading();
      try {
        final result = await merchantRepository.getMerchantShopByID(event.id);
        yield MerchantDetailSuccessful(result: result);
      } catch (error) {
        yield MerchantShopFailure(error: error);
      }
    }
  }
}
