import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';

import '../sqflite.dart';

class FeeSettings {
  static final int feeDefaultTypes = 5;

  static final List<FeeModel> feeTypes = [
    FeeModel(type: 0, title: "management_fee"),
    FeeModel(type: 2, title: "water_fee"),
    FeeModel(type: 1, title: "rental_fee"),
    FeeModel(type: 6, title: "parking_fee"),
    FeeModel(type: 3, title: "electricity_fee"),
    FeeModel(type: 4, title: "service_fee"),
    FeeModel(type: 7, title: "gas_fee"),
    FeeModel(type: 5, title: "others_fee"),
  ];

  static final Map<String, PaymentGatewayModel> paymentGateways = {
    'payoo_encrypt': PaymentGatewayModel(
      order: 1,
      isCheck: true,
      gatewayIcon: "payoo",
      gatewayName: 'payoo_encrypt',
      gatewayTitle: 'local_payment_gateway',
      gatewayDesc: 'the_payment_solution_by_internet_banking_in_vn',
    ),
    'payoo_sdk_atm': PaymentGatewayModel(
      order: 1,
      isCheck: true,
      gatewayIcon: "payoo",
      gatewayName: 'payoo_sdk_atm',
      gatewayTitle: 'local_payment_gateway',
      gatewayDesc: 'the_payment_solution_by_internet_banking_in_vn',
    ),
    'momo_wallet': PaymentGatewayModel(
        order: 2,
        isCheck: true,
        gatewayIcon: "momo",
        gatewayName: 'momo_wallet',
        gatewayTitle: 'momo_e_wallet',
        gatewayDesc: 'online_payment_by_momo_e_wallet'),
    'zalo': PaymentGatewayModel(
        order: 3,
        isCheck: true,
        gatewayIcon: "zalo_pay",
        gatewayName: 'zalo',
        gatewayTitle: 'zalo_pay_title',
        gatewayDesc: 'zalo_pay_desc'),
    'bank_transfer': PaymentGatewayModel(
        order: 4,
        isCheck: true,
        gatewayIcon: "bank_transfer",
        gatewayName: 'bank_transfer',
        gatewayTitle: 'manual_bank_transfer_title',
        gatewayDesc: 'manual_bank_transfer_desc'),
    'cash': PaymentGatewayModel(
        order: 5,
        isCheck: false,
        gatewayName: 'cash',
        gatewayTitle: 'pay_in_cash',
        gatewayDesc: 'resident_pay_in_cash_desc'),
  };

// Fail sort code
//  static List<FeeMessageModel> sortFeeV2(
//      List<FeeMessageModel> fees, FinanceModel financeModel) {
//    var newList = <FeeMessageModel>[];
//    var tmpList = <int, FeeMessageModel>{};
//
//    financeModel.totalAllBuilding = 0;
//
//    int i = 0;
//
//    fees.sort((a, b) => a.type.compareTo(b.type));
//
//    fees.forEach((e) => tmpList[e.type] = e);
//
//    for (var i = 0; i < Sqflite.currentBuilding.feeDisplay.length; ++i) {
//      final indexType = Sqflite.currentBuilding.feeDisplay[i];
//      final total = tmpList[indexType]?.total ?? 0;
//      financeModel.totalAllBuilding += total;
//      newList.add(FeeMessageModel(type: indexType, total: total));
//    }
//
//    newList.forEach((e) {
//      if (e.total != 0) {
//        if (newList.indexOf(e) != i)
//          newList
//            ..remove(e)
//            ..insert(i, e);
//        i++;
//      }
//    });
//
//    return newList;
//  }

  static Future<List<FeeMessageModel>> sortFeeV2(String buildingID,
      List<FeeMessageModel> fees, FinanceModel financeModel) async {
    var newList = <FeeMessageModel>[];
    var tmpList = <int, FeeMessageModel>{};

    financeModel.totalAllBuilding = 0;

    fees.forEach((e) {
      tmpList[e.type!] = e;
    });

    BuildingMessageModel? building =
        await Sqflite.getBuildingWithId(buildingID);

    List<int> _tmpFeeDisplay = building!.feeDisplay!;
    FeeSettings.feeTypes.forEach((e) {
      for (var i = 0; i < _tmpFeeDisplay.length; ++i) {
        final indexType = _tmpFeeDisplay[i];
        final total = tmpList[indexType]?.total ?? 0;
        if (e.type == indexType) {
          newList.add(FeeMessageModel(type: indexType, total: total));
          // financeModel.totalAllBuilding += total;
          _tmpFeeDisplay.removeAt(i);
        }
      }
    });

    newList.sort((a, b) => b.total!.compareTo(a.total!));

    return newList;
  }
}
