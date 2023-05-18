part of 'filter_bloc.dart';

enum StatusViewFilter { all, pending, completed, failed }
enum HistoryStatus { initial, loading, success, failure }

class FilterState extends Equatable {
  const FilterState({
    this.filter = StatusViewFilter.all,
    this.idSelected = -1,
    this.status = HistoryStatus.initial,
    this.histories = const <PaymentHistoryModel>[],
  });

  final StatusViewFilter filter;
  final int idSelected;
  final HistoryStatus status;
  final List<PaymentHistoryModel> histories;

  FilterState copyWith({
    StatusViewFilter? filter,
    int? idSelected,
    HistoryStatus? status,
    List<PaymentHistoryModel>? histories,
  }) {
    return FilterState(
      status: status ?? this.status,
      filter: filter ?? this.filter,
      idSelected: idSelected ?? this.idSelected,
      histories: histories ?? this.histories,
    );
  }

  @override
  List<Object?> get props => [
        filter,
        idSelected,
        status,
        histories,
      ];
}
