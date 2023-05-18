import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/ekyc_api.dart';
import 'package:houze_super/middle/model/ekyc_model.dart';

class EKYCRepository {
  final api = EKYCAPI();

  Future<EKYCModel> getEKYC() async {
    final rs = await api.getEKYC();

    return rs;
  }

  Future<EKYCModel> postEKYC({@required Map<String, dynamic> instance}) async {
    final FormData formData = FormData.fromMap(
      instance
        ..update(
          'card_front_image',
          (value) => MultipartFile.fromFileSync(
            instance['card_front_image'],
            filename: 'card_front_image.jpg',
          ),
        )
        ..update(
          'card_back_image',
          (value) => MultipartFile.fromFileSync(
            instance['card_back_image'],
            filename: 'card_back_image.jpg',
          ),
        )
        ..update(
          'portrait_image',
          (value) => MultipartFile.fromFileSync(
            instance['portrait_image'],
            filename: 'portrait_image.jpg',
          ),
        ),
    );

    final rs = await api.postEKYC(formData: formData);

    return rs;
  }
}
