import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/payment/payment_event.dart';
import 'package:houze_super/presentation/screen/payment/blocs/payment/payment_state.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:collection/collection.dart'; 

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repo;

  PaymentBloc({required PaymentRepository paymentRepository})
      : _repo = paymentRepository,
        super(PaymentInitial()) {
    on<PaymentLoadGateway>(
      (event, emit) async {
        emit(PaymentLoading());

        try {
          // final gateWayData =
          //     await paymentRepository.getGateway(event.buildingId!);

          // final building = (await Sqflite.getBuildingList())
          //     .firstWhere((element) => element.id == event.buildingId);
          // print(building);

          // final List<PaymentGatewayModel> results = <PaymentGatewayModel>[];

          // building.gateways!.forEach((element) {
          //   final paymentGateway = FeeSettings.paymentGateways[element];
          //   if (paymentGateway != null && paymentGateway.isCheck!) {
          //     var getway =
          //         gateWayData.firstWhere((item) => item.gatewayName == element);
          //     if (getway.gatewayTitle != null)
          //       paymentGateway.gatewayTitle = getway.gatewayTitle;
          //     if (getway.gatewayDesc != null)
          //       paymentGateway.gatewayDesc = getway.gatewayDesc;
          //     results.add(paymentGateway);
          //   }
          // });

          final List<PaymentGatewayModel> results = await loadGateways(
            buildingId: event.buildingId!,
          );
          emit(PaymentLoadGatewaySuccessful(result: results));
        } catch (error) {
          emit(PaymentFailure(error: error));
        }
      },
    );

    on<PaymentLoadHistory>((event, emit) async {
      emit(PaymentLoading());

      try {
        final result = await paymentRepository.getPaymentHistory(
          page: 0,
          apartmentId: event.apartmentId,
          limit: event.limit,
          status: event.status,
        );

        final results = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        emit(
            PaymentLoadHistorySuccessful(result: results, total: result.count));
      } on DioError catch (error) {
        emit(PaymentFailure(error: error));
      }
    });

    on<PaymentGetDetail>((event, emit) async {
      try {
        final result =
            await paymentRepository.getPaymentTransactionDetail(event.id!);
        emit(PaymentGetDetailSuccessful(result: result));
      } catch (error) {
        emit(PaymentFailure(error: error));
      }
    });
    on<PaymentBankTransferEvent>((event, emit) async {
      try {
        emit(PaymentLoading());

        final banks = await paymentRepository.getBanks(event.buildingId);

        final paymentInfo = await paymentRepository.getPaymentInfo(event.id);

        if (paymentInfo != null) {
          emit(PaymentBankTransferSuccessful(
            banks: banks,
            paymentInfo: paymentInfo,
          ));
        } else {
          emit(PaymentFailure(error: 'error'));
        }
      } catch (error) {
        emit(PaymentFailure(error: error.toString()));
      }
    });
  }

  Future<List<PaymentGatewayModel>> loadGateways({
    required String buildingId,
  }) async {
    final gateWayData = await _repo.getGateway(buildingId);
    if (gateWayData.length == 0) return [];
    final building = (await Sqflite.getBuildingList())
        .firstWhere((element) => element.id == buildingId);

    final List<PaymentGatewayModel> results = <PaymentGatewayModel>[];
    if (building.gateways == null || building.gateways?.length == 0) {
      return [];
    }
    building.gateways!.forEach((element) {
      final paymentGateway = FeeSettings.paymentGateways[element];
      if (paymentGateway != null && paymentGateway.isCheck!) {
        var getway =
            gateWayData.firstWhereOrNull((item) => item.gatewayName == element);
        if (getway?.gatewayTitle != null)
          paymentGateway.gatewayTitle = getway?.gatewayTitle;
        if (getway?.gatewayDesc != null)
          paymentGateway.gatewayDesc = getway?.gatewayDesc;
        results.add(paymentGateway);
      }
    });
    return results;
  }
}
