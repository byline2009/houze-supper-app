import 'package:equatable/equatable.dart';

class RunEvent extends Equatable {
  final String buildingID;

  const RunEvent({
    required this.buildingID,
  });

  @override
  List<Object> get props => [
        buildingID,
      ];

  @override
  String toString() => 'RunEvent { buildingID: $buildingID  }';
}
