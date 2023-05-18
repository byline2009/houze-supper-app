import 'dart:io';

import 'package:houze_super/common/blocs/app_event_bloc.dart';
import 'package:houze_super/middle/api/profile_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';

class ProfileRepository {
  ProfileAPI profileAPI;
  ProfileRepository() {
    profileAPI = ProfileAPI();
  }
  Future<ProfileModel> getProfile() async {
    ProfileModel result;
    try {
      final rs = await profileAPI.getProfile();
      if (rs != null) {
        await Storage.saveUser(rs);
      }
      result = rs;
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<ImageModel> uploadProfile(File file) async {
    try {
      final ImageModel rs = await profileAPI.uploadProfile(file);
      await Storage.saveAvatar(
        rs.imageThumb,
      );
      AppEventBloc().emitEvent(
        BlocEvent(
          EventName.profileChangeAvatar,
          rs,
        ),
      );

      return rs;
    } catch (e) {
      rethrow;
    }
  }
}
