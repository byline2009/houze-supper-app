import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  final String refresh;
  final String access;

  TokenModel({
    required this.refresh,
    required this.access,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) => new TokenModel(
        refresh: json["refresh"],
        access: json["access"],
      );

  Map<String, dynamic> toJson() => {
        "refresh": refresh,
        "access": access,
      };

  @override
  List<Object> get props => [refresh, access];
}
