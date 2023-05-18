import 'package:equatable/equatable.dart';

abstract class FeeGatewayEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeeGatewayLoadDetail extends FeeGatewayEvent {
  final String buildingID;
  final String apartmentID;
  final List<int> types;
  FeeGatewayLoadDetail({
    required this.buildingID,
    required this.apartmentID,
    required this.types,
  });

  @override
  List<Object> get props => [
        buildingID,
        apartmentID,
        types,
      ];

  @override
  String toString() {
    return 'FeeGatewayLoadDetail types=${types.toList()} buildingID=$buildingID apartmentID=$apartmentID';
  }
}
