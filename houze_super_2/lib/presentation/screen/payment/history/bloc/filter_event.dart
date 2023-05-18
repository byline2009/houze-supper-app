part of 'filter_bloc.dart';

class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class FilterStatusSelected extends FilterEvent {
  FilterStatusSelected({
    required this.idSelected,
    required this.page,
  });
  final int idSelected;
  final int page;
  @override
  List<Object> get props => [
        idSelected,
        page,
      ];

  @override
  String toString() {
    return 'FilterStatusSelected: status: $idSelected page: $page';
  }
}

class FilterLoadAllStatus extends FilterEvent {
  FilterLoadAllStatus();
}
