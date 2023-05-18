import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc({
    required PaymentRepository paymentRepository,
  })  : _repo = paymentRepository,
        super(const FilterState()) {
    on<FilterStatusSelected>(_onFetched, transformer: droppable());

    on<FilterLoadAllStatus>((event, emit) async {
      emit(state.copyWith(
        status: HistoryStatus.loading,
        filter: StatusViewFilter.all,
        idSelected: -1,
      ));
      try {
        final result = await _repo.getPaymentHistory(
          apartmentId: null,
          status: null,
          page: 0,
        );
        final _histories = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        await Future.delayed(
            Duration(
              milliseconds: 100,
            ), () {
          emit(
            state.copyWith(
              status: HistoryStatus.success,
              histories: _histories,
              idSelected: -1,
              filter: StatusViewFilter.all,
            ),
          );
        });
      } catch (e) {
        emit(state.copyWith(
          status: HistoryStatus.failure,
        ));
      }
    });
  }
  final PaymentRepository _repo;

  Future<void> _onFetched(
      FilterStatusSelected event, Emitter<FilterState> emit) async {
    emit(state.copyWith(status: HistoryStatus.loading));
    try {
      StatusViewFilter filter = StatusViewFilter.all;
      switch (event.idSelected) {
        case -1:
          filter = StatusViewFilter.all;
          break;
        case 0:
          filter = StatusViewFilter.pending;
          break;
        case 1:
          filter = StatusViewFilter.completed;
          break;
        case 2:
          filter = StatusViewFilter.failed;
          break;
      }

      final result = await _repo.getPaymentHistory(
        apartmentId: null,
        page: event.page,
        status: event.idSelected == -1 ? null : event.idSelected,
      );
      final _histories = (result.results as List).map((i) {
        return PaymentHistoryModel.fromJson(i);
      }).toList();

      await Future.delayed(
          Duration(
            milliseconds: 200,
          ), () {
        emit(
          state.copyWith(
              status: HistoryStatus.success,
              histories: _histories,
              idSelected: event.idSelected,
              filter: filter),
        );
      });
    } catch (e) {
      emit(state.copyWith(
        status: HistoryStatus.failure,
      ));
    }
  }
}
