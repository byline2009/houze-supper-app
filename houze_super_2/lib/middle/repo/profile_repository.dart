import 'dart:io';

import 'package:houze_super/middle/api/profile_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/utils/index.dart';

class ProfileRepository {
  final profileAPI = ProfileAPI();

  Future<ProfileModel> getProfile() async {
    final rs = await profileAPI.getProfile();
    await Storage.saveUser(rs);
    return rs;
  }

  Future<ImageModel> uploadProfile(File file) async {
    try {
      final rs = await profileAPI.uploadProfile(file);
      AppController().updateAvatarUser(
        image: rs,
      );
      return rs;
    } catch (e) {
      return throw (e.toString());
    }
  }
}
