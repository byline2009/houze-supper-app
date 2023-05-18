import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/payment_bank_transfer_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:meta/meta.dart';

abstract class PaymentState extends Equatable {
  PaymentState([List props = const []]) : super();
}

class PaymentInitial extends PaymentState {
  @override
  String toString() => 'PaymentInitial';

  @override
  List<Object> get props => [];
}

class PaymentLoading extends PaymentState {
  @override
  String toString() => 'PaymentLoadLoading';
  @override
  List<Object> get props => [];
}

class PaymentLoadGatewaySuccessful extends PaymentState {
  final List<PaymentGatewayModel> result;
  PaymentLoadGatewaySuccessful({
    @required this.result,
  });
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'PaymentLoadGatewaySuccessful { result: $result }';
}

class PaymentLoadHistorySuccessful extends PaymentState {
  final List<PaymentHistoryModel> result;
  final int total;

  PaymentLoadHistorySuccessful({@required this.result, this.total});
  @override
  List<Object> get props => [result, total];
  @override
  String toString() =>
      'PaymentLoadHistorySuccessful { result: $result, total: $total }';
}

class PaymentGetDetailSuccessful extends PaymentState {
  final PaymentHistoryModel result;

  PaymentGetDetailSuccessful({@required this.result});
  @override
  List<Object> get props => [result];
  @override
  String toString() => 'PaymentGetDetailSuccessful { result: $result }';
}

class PaymentBankTransferSuccessful extends PaymentState {
  final List<PaymentBankTransfer> banks;
  final PaymentInfoModel paymentInfo;

  PaymentBankTransferSuccessful({
    @required this.banks,
    @required this.paymentInfo,
  });

  @override
  List<Object> get props => [banks, paymentInfo];

  @override
  String toString() =>
      'PaymentBankTransferSuccessful { banks: $banks, paymentInfo: $paymentInfo }';
}

class PaymentFailure extends PaymentState {
  final dynamic error;

  PaymentFailure({@required this.error});
  @override
  List<Object> get props => [error];
  @override
  String toString() => 'PaymentFailure { error: $error }';
}
