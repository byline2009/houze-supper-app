class SignInType {
  String phoneNumber;
  String? intCode;
  String password;

  SignInType({required this.phoneNumber, this.intCode, required this.password});

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "password": password,
        "intl_code": intCode != null ? intCode : "+84"
      };
}

class CreatePasswordType {
  String phoneNumber;
  String? intCode;
  String password;
  String access;

  CreatePasswordType(
      {required this.phoneNumber,
      required this.password,
      required this.access,
      this.intCode});

  Map<String, dynamic> toJson() => {
        "phone_number": phoneNumber,
        "password": password,
        "access": access,
        "intl_code": intCode != null ? intCode : "+84"
      };
}

class ChangePasswordType {
  String? oldPassword;
  String? newPassword;

  ChangePasswordType({required this.oldPassword, required this.newPassword});

  ChangePasswordType.fromJson(Map<String, dynamic> json) {
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() => {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      };
}
