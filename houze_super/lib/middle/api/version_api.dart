import 'dart:convert';
import 'dart:io';

import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/version_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class VersionAPI extends BaseApi {
  VersionAPI() : super(BasePath.gateway);

  Future<VersionModel> getVersion() async {
    final String url = BasePath.gateway + 'version';
    try {
      final response = await dio.get(url);
      VersionModel version = VersionModel.fromJson(response.data);
      if (Platform.isAndroid) {
        await Storage.saveVersionCode(version.citizenAndroid);
      } else if (Platform.isIOS) {
        await Storage.saveVersionCode(version.citizenIos);
      }

      return version;
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return VersionModel.fromJson(data);
      }
      return err;
    }
  }
}
