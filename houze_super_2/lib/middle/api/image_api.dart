import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/image_meta_model.dart';
import 'package:houze_super/utils/constant/index.dart';

import 'oauth_api.dart';
import 'profile_api.dart';

class ImageAPI extends OauthAPI {
  ImageAPI() : super(BasePath.citizen);
  final profileAPI = ProfileAPI();
  Future<dynamic> uploadImage(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split('/').last,
        )
      });

      await profileAPI.getProfile(); //refresh token
      final String url = APIConstant.postParkingVehicleImage;

      final response = await this.post(
        url,
        data: formData,
      );

      final rs = ImageMetaModel.fromJson(response.data);
      return rs;
    } on DioError catch (e) {
      print(e);
      return throw e;
    }
  }
}
