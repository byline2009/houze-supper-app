import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/payment_event.dart';

class PaymentHistoryBloc extends Bloc<PaymentEvent, PaymentHistoryPageModel> {
  PaymentRepository paymentRepository = new PaymentRepository();
  bool isLoading = false;

  List<PaymentHistoryModel> previouseResult = new List<PaymentHistoryModel>();

  int total = 0;
  int page = 1;
  int offset = 0;
  int limitInit = 10;
  bool isNext = true;

  PaymentHistoryBloc({this.isLoading = false})
      : super(PaymentHistoryPageModel(
            total: 0, transactions: new List<PaymentHistoryModel>()));

  @override
  Stream<PaymentHistoryPageModel> mapEventToState(PaymentEvent event) async* {
    if (event is TransactionLoadList) {
      this.isLoading = false;

      if (event.page != null) {
        this.page = event.page;
      }

      try {
        if (page == 1) {
          previouseResult = new List<PaymentHistoryModel>();
        }

        var currentOffset = (page * limitInit) + offset;
        if (previouseResult.length <= limitInit) {
          currentOffset = previouseResult.length;
        }

        if (event.page == 0) {
          offset = 0;
          currentOffset = 0;
        }

        var result = await paymentRepository.getPaymentHistory(
            apartmentId: event.apartmentId,
            status: event.status == -1 ? null : event.status,
            limit: limitInit,
            offset: currentOffset);

        var results = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        //If empty
        if (result?.results?.length == 0) {
          isNext = false;
        } else {
          isNext = true;
        }

        if (results.length > 0) {
          this.page++;
        }

        results.insertAll(0, previouseResult);
        previouseResult = results;
        total = result.count;

        yield PaymentHistoryPageModel(
            total: total,
            transactions: results,
            isNext: isNext,
            isLoading: false);
      } catch (err) {
        // if (err is String) {
        //   if (err.contains('NoDataException'))
        //     // NoDataException
        //     yield PaymentHistoryPageModel(
        //       total: -2,
        //       transactions: <PaymentHistoryModel>[],
        //     );
        //   // NoDataToLoadMoreException
        //   else if (err.contains('NoDataToLoadMoreException'))
        //     yield PaymentHistoryPageModel(
        //       total: -3,
        //       transactions: <PaymentHistoryModel>[],
        //     );
        // } else

        yield PaymentHistoryPageModel(
          total: -2,
          transactions: <PaymentHistoryModel>[],
          isLoading: false,
        );
        rethrow;
      }
    }

    if (event is GetTransactionByStatus) {
      yield PaymentHistoryPageModel(isLoading: true);

      if (event.page != null) {
        this.page = event.page;
      }

      try {
        if (page == 1) {
          previouseResult = new List<PaymentHistoryModel>();
        }

        var currentOffset = (page * limitInit) + offset;
        if (previouseResult.length <= limitInit) {
          currentOffset = previouseResult.length;
        }

        if (event.page == 0) {
          offset = 0;
          currentOffset = 0;
        }

        var result = await paymentRepository.getPaymentHistory(
            apartmentId: event.apartmentId,
            status: event.status == -1 ? null : event.status,
            limit: limitInit,
            offset: currentOffset);

        var results = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        //If empty
        if (result?.results?.length == 0) {
          isNext = false;
        } else {
          isNext = true;
        }

        if (results.length > 0) {
          this.page++;
        }

        results.insertAll(0, previouseResult);
        previouseResult = results;
        total = result.count;

        yield PaymentHistoryPageModel(
            total: total,
            transactions: results,
            isNext: isNext,
            isLoading: false);
      } catch (err) {
        yield PaymentHistoryPageModel(
          total: -2,
          transactions: <PaymentHistoryModel>[],
          isLoading: false,
        );
        rethrow;
      }
    }
  }
}
