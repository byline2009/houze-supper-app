import 'package:equatable/equatable.dart';

class ResponeJoinGroupCodeError extends Equatable {
  final String? error;
  final String? errorDetail;

  const ResponeJoinGroupCodeError({
    this.error,
    this.errorDetail,
  });

  factory ResponeJoinGroupCodeError.fromJson(Map<String, dynamic> json) =>
      ResponeJoinGroupCodeError(
        error: json["error"] == null ? null : json["error"],
        errorDetail: json["error_detail"] == null ? null : json["error_detail"],
      );

  Map<String, dynamic> toJson() => {
        "error": error == null ? null : error,
        "error_detail": errorDetail == null ? null : errorDetail,
      };

  @override
  List<Object> get props => [
        error ?? '',
        errorDetail ?? '',
      ];
}
