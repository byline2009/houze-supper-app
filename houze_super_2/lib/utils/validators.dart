class Validators {
  static isValidPassword(String password) {
    return password.length >= 6 && !password.contains(' ');
  }

  static isValidPhoneNumber(String phone) {
    // RegExp regExp = _phoneRedExp();
    return !(phone.length < 9);
  }
}
