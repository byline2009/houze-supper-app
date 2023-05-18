class FeeUtils {
  static String? getFeeByMonthStr(int type) {
    switch (type) {
      case 0:
        return 'management_fee_of_month';
      case 1:
        return 'rental_fee_of_month';
      case 2:
        return 'water_fee_of_month';
      case 3:
        return 'electricity_fee_of_month';
      case 4:
        return 'service_fee_of_month';
      case 5:
        return 'others_fee_of_month';
      case 6:
        return 'parking_fee_of_month';
      case 7:
        return 'gas_fee_of_month';
      default:
        return null;
    }
  }
}
