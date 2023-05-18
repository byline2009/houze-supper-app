import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/screen/payment/blocs/payment/payment_event.dart';

class PaymentHistoryBloc extends Bloc<PaymentEvent, PaymentHistoryPageModel> {
  final PaymentRepository _repo;
  bool isLoading = false;

  List<PaymentHistoryModel> previouseResult = <PaymentHistoryModel>[];

  int total = 0;
  int page = 1;
  int offset = 0;
  int limitInit = 10;
  bool isNext = true;

  PaymentHistoryBloc(
      {this.isLoading = false, required PaymentRepository paymentRepository})
      : _repo = paymentRepository,
        super(
          PaymentHistoryPageModel(
            total: 0,
            transactions: <PaymentHistoryModel>[],
          ),
        ) {
    on<TransactionLoadList>((event, emit) async {
      this.isLoading = false;

      if (event.page != null) {
        this.page = event.page!;
      }

      try {
        if (page == 1) {
          previouseResult = <PaymentHistoryModel>[];
        }

        var currentOffset = (page * limitInit) + offset;
        if (previouseResult.length <= limitInit) {
          currentOffset = previouseResult.length;
        }

        if (event.page == 0) {
          offset = 0;
          currentOffset = 0;
        }

        var result = await _repo.getPaymentHistory(
            apartmentId: event.apartmentId,
            status: event.status == -1 ? null : event.status,
            // page: 0,
            limit: limitInit,
            offset: currentOffset);

        var results = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        //If empty
        if (result.results?.length == 0) {
          isNext = false;
        } else {
          isNext = true;
        }

        if (results.length > 0) {
          this.page++;
        }

        results.insertAll(0, previouseResult);
        previouseResult = results;
        total = result.count!;

        emit(
          PaymentHistoryPageModel(
            total: total,
            transactions: results,
            isNext: isNext,
          ),
        );
      } catch (err) {
        emit(PaymentHistoryPageModel(
          total: -2,
          transactions: <PaymentHistoryModel>[],
          isLoading: false,
          isNext: false,
        ));
        rethrow;
      }
    });

    on<GetTransactionByStatus>((event, emit) async {
      emit(PaymentHistoryPageModel(isLoading: true, total: 0));
      //this.isLoading = false;
      if (event.page != null) {
        this.page = event.page!;
      }

      try {
        if (page == 1) {
          previouseResult = [];
        }

        var currentOffset = (page * limitInit) + offset;
        if (previouseResult.length <= limitInit) {
          currentOffset = previouseResult.length;
        }

        if (event.page == 0) {
          offset = 0;
          currentOffset = 0;
        }

        var result = await _repo.getPaymentHistory(
            // page: event.page ?? 0,
            apartmentId: event.apartmentId,
            status: event.status == -1 ? null : event.status,
            limit: limitInit,
            offset: currentOffset);

        var results = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        //If empty
        if (result.results?.length == 0) {
          isNext = false;
        } else {
          isNext = true;
        }

        if (results.length > 0) {
          this.page++;
        }

        results.insertAll(0, previouseResult);
        previouseResult = results;
        total = result.count!;

        emit(PaymentHistoryPageModel(
            total: total,
            transactions: results,
            isNext: isNext,
            isLoading: false));
      } catch (err) {
        emit(PaymentHistoryPageModel(
          total: -2,
          transactions: <PaymentHistoryModel>[],
          isLoading: false,
          isNext: false,
        ));
        rethrow;
      }
    });
  }
}
