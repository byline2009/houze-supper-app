part of 'order_bloc.dart';

enum OrderStatus { initial, success, error, loading }

extension OrderStatusX on OrderStatus {
  bool get isInitial => this == OrderStatus.initial;
  bool get isSuccess => this == OrderStatus.success;
  bool get isError => this == OrderStatus.error;
  bool get isLoading => this == OrderStatus.loading;
}

class OrderState extends Equatable {
  const OrderState({
    this.status = OrderStatus.initial,
    List<FeeGroupByApartments>? feeGroupByApartments,
    List<PaymentHistoryModel>? paymentHistories,
    int? totalPaymentHistory,
  })  : feeGroupByApartments = feeGroupByApartments ?? const [],
        paymentHistories = paymentHistories ?? const [],
        totalPaymentHistory = totalPaymentHistory ?? 0;

  final List<PaymentHistoryModel> paymentHistories;
  final List<FeeGroupByApartments> feeGroupByApartments;
  final OrderStatus status;
  final int totalPaymentHistory;

  @override
  List<Object?> get props => [
        status,
        feeGroupByApartments,
        paymentHistories,
        totalPaymentHistory,
      ];

  OrderState copyWith({
    List<PaymentHistoryModel>? paymentHistories,
    List<FeeGroupByApartments>? feeGroupByApartments,
    int? totalPaymentHistory,
    OrderStatus? status,
  }) {
    return OrderState(
      status: status ?? this.status,
      feeGroupByApartments: feeGroupByApartments ?? this.feeGroupByApartments,
      paymentHistories: paymentHistories ?? this.paymentHistories,
      totalPaymentHistory: totalPaymentHistory ?? this.totalPaymentHistory,
    );
  }
}
