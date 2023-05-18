import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/utils/sqflite.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderFetched, OrderState> {
  OrderBloc({required PaymentRepository paymentRepository})
      : _paymentRepository = paymentRepository,
        super(const OrderState()) {
    on<OrderFetched>(
      (event, emit) async {
        emit(state.copyWith(status: OrderStatus.loading));

        try {
          List<FeeGroupByApartments> feeGroupByApartments =
              await getFeeGroupByApartment();
          final resultHistories = await getPaymentHistory();

          final paymentHistories = (resultHistories.results as List).map((i) {
            return PaymentHistoryModel.fromJson(i);
          }).toList();

          await Future.delayed(Duration(milliseconds: 100));
          emit(
            state.copyWith(
              status: OrderStatus.success,
              feeGroupByApartments: feeGroupByApartments,
              paymentHistories: paymentHistories,
              totalPaymentHistory: resultHistories.count,
            ),
          );
        } catch (e) {
          emit(state.copyWith(status: OrderStatus.error));
        }
      },
      transformer: concurrent(),
    );
  }

  Future<PageModel> getPaymentHistory() async {
    try {
      final resultPaymetHistories = await _paymentRepository.getPaymentHistory(
        apartmentId: '',
        limit: 5,
        status: 0,
      );

      return resultPaymetHistories;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<FeeGroupByApartments>> getFeeGroupByApartment() async {
    try {
      final results = await _paymentRepository.getFeeGroupByApartment();
      results.forEach((element) async {
        final availableFee =
            await Sqflite.getBuildingWithId(element.buildingId!);
        element.feeAvailable = availableFee!.feeDisplay;
      });

      return results;
    } catch (e) {
      rethrow;
    }
  }

  final PaymentRepository _paymentRepository;
}
