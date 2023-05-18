class CheckPhoneModel {
  CheckPhoneModel({
    this.isFirstLogin = false,
  });

  final bool? isFirstLogin;

  factory CheckPhoneModel.fromJson(Map<String, dynamic> json) =>
      CheckPhoneModel(
        isFirstLogin:
            json["is_first_login"] == null ? null : json["is_first_login"],
      );

  Map<String, dynamic> toJson() => {
        "is_first_login": isFirstLogin == null ? null : isFirstLogin,
      };
}
