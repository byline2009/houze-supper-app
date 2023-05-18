// class FeeV1State extends Equatable {
//   final bool isLoading;
//   final List<FeeGroupByApartments> feeGroupByApartments;

//   FeeV1State({this.isLoading, this.feeGroupByApartments});
//   @override
//   List<Object?> get props => [
//         isLoading ?? '',
//         feeGroupByApartments ?? '',
//       ];
//   @override
//   String toString() {
//     return 'FeeV1State: isLoading: $isLoading feeGroupByApartments: ${feeGroupByApartments?.map((e) => e.toJson()).toList()}';
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';

enum FeeV1Status { initial, success, error, loading }

extension FeeV1StatusX on FeeV1Status {
  bool get isInitial => this == FeeV1Status.initial;
  bool get isSuccess => this == FeeV1Status.success;
  bool get isError => this == FeeV1Status.error;
  bool get isLoading => this == FeeV1Status.loading;
}

class FeeV1State extends Equatable {
  const FeeV1State({
    this.status = FeeV1Status.initial,
    List<FeeGroupByApartments>? feeGroupByApartments,
    String? categoryName,
  }) : feeGroupByApartments = feeGroupByApartments ?? const [];

  final List<FeeGroupByApartments> feeGroupByApartments;
  final FeeV1Status status;

  @override
  List<Object?> get props => [
        status,
        feeGroupByApartments,
      ];

  FeeV1State copyWith({
    List<FeeGroupByApartments>? feeGroupByApartments,
    FeeV1Status? status,
    String? categoryName,
  }) {
    return FeeV1State(
      feeGroupByApartments: feeGroupByApartments ?? this.feeGroupByApartments,
      status: status ?? this.status,
    );
  }
}
