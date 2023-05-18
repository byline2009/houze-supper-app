import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee_filter/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/payment/index.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'index.dart';

class FeeGatewayBloc extends Bloc<FeeGatewayEvent, FeeGatewayState> {
  final FeeFilterBloc filterBloc;
  final PaymentBloc paymentBloc;

  FeeGatewayBloc({
    required this.filterBloc,
    required this.paymentBloc,
  }) : super(FeeGatewayState.initial()) {
    on<FeeGatewayLoadDetail>((event, emit) async {
      emit(FeeGatewayState.loading());
      String buildingID = event.buildingID;
      if (buildingID.isEmpty) {
        buildingID = Sqflite.currentBuildingID;
      }

      try {
        final feesFilter = await filterBloc.getFeesListWithType(
          buildingID: event.buildingID,
          apartmentID: event.apartmentID,
          types: event.types,
          feeRepository: FeeRepository(),
        );
        await Future.delayed(Duration.zero);
        final List<FeeGateway> feeGateways = await filterBloc.fetchData(
          fees: feesFilter,
          buildingID: buildingID,
          apartmentID: event.apartmentID,
        );
        await Future.delayed(Duration.zero);
        final paymentGateways = await paymentBloc.loadGateways(
          buildingId: event.buildingID,
        );
        await Future.delayed(Duration.zero);
        emit(FeeGatewayState.success(
          feeList: feesFilter,
          gatewayList: paymentGateways,
          feeGateways: feeGateways,
        ));
      } catch (error) {
        emit(FeeGatewayState.error(error.toString()));
      }
    });
  }
}
