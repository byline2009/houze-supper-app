import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee_filter/fee_filter_bloc.dart';

class FeeGatewayState extends Equatable {
  final bool? isLoading;
  final List<FeeMessageModel> feeList;
  final List<PaymentGatewayModel> gatewayList;
  final List<FeeGateway> feeGateways;
  final String? error;

  const FeeGatewayState({
    this.isLoading = false,
    required this.gatewayList,
    required this.feeList,
    required this.feeGateways,
    this.error,
  });
  @override
  List<Object> get props => [
        isLoading ?? '',
        error ?? '',
        gatewayList,
        feeList,
      ];

  factory FeeGatewayState.initial() {
    return FeeGatewayState(
      gatewayList: [],
      feeList: [],
      feeGateways: [],
      isLoading: false,
      error: null,
    );
  }

  factory FeeGatewayState.loading() {
    return FeeGatewayState(
      gatewayList: [],
      feeList: [],
      feeGateways: [],
      isLoading: true,
      error: null,
    );
  }

  factory FeeGatewayState.success({
    required List<FeeMessageModel> feeList,
    required List<PaymentGatewayModel> gatewayList,
    required List<FeeGateway> feeGateways,
  }) {
    return FeeGatewayState(
      feeList: feeList,
      gatewayList: gatewayList,
      isLoading: false,
      feeGateways: feeGateways,
      error: null,
    );
  }

  factory FeeGatewayState.error(String code) {
    return FeeGatewayState(
      gatewayList: [],
      feeList: [],
      feeGateways: [],
      isLoading: false,
      error: code,
    );
  }

  bool get hasLoading => isLoading ?? false;

  bool get hasData =>
      isLoading == false &&
      error == null &&
      gatewayList.length >= 0 &&
      feeGateways.length >= 0 &&
      feeList.length >= 0;

  bool get isInitial =>
      isLoading == false &&
      error == null &&
      gatewayList == [] &&
      feeList == [] &&
      feeGateways.length == 0;

  bool get hasError => isLoading == false && error != null;
  @override
  String toString() {
    if (isInitial) {
      return 'FeeGatewayState initial';
    }
    if (hasData) {
      return 'FeeGatewayState gatewayList: ${gatewayList.map((e) => e.gatewayTitle)} \t feeList: ${feeList.map((e) => e.toJson())} ';
    }
    if (hasLoading) {
      return 'FeeGatewayState is loading';
    }

    if (hasError) {
      return 'FeeGatewayState has error $error';
    }

    return '';
  }
}
