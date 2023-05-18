import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_bloc.dart';
import 'package:houze_super/app/bloc/authentication/authentication_event.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/constants/share_keys.dart';
import 'package:houze_super/utils/index.dart';

class ProfileAPI extends OauthAPI {
  ProfileAPI() : super(AuthPath.profile);

  Future<ProfileModel> getProfile() async {
    try {
      final Response response = await this.get(
        this.baseUrl,
      );
      if (response.statusCode == 200) {
        print(
            '***********PayME_Token: ${response.data[ShareKeys.kPayMEToken]}');
        if (response.data != null &&
            response.data[ShareKeys.kPayMEToken] != Storage.getPayMEToken()) {
          await Storage.savePayMEToken(response.data[ShareKeys.kPayMEToken]);
        }
      }
      return ProfileModel.fromJson(
        response.data,
      );
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        return ProfileModel.fromJson(data);
      }
      return error;
    }
  }

  Future<ImageModel> uploadProfile(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromFileSync(image.path, filename: "profile.jpg")
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      final response = await this.put(
        AuthPath.profileImage,
        data: formData,
        options: options,
      );

      final rs = ImageModel.fromJson(response.data);
      print("Image with id: ${rs.id}");
      return rs;
    } on DioError catch (e) {
      print("Image error: ${e.toString()}");

      rethrow;
    }
  }

  Future<Response> changePassword({
    @required String oldPassword,
    @required String newPassword,
    @required BuildContext context,
  }) async {
    try {
      final response = await this.put(
        AuthPath.changePassword,
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      DialogCustom.showSuccessDialog(
          context: context,
          title: 'changed_password',
          svgPath: AppVectors.graphicShield,
          content: 'password_has_changed_please_sign_in_again',
          buttonText: 'sign_in_again',
          onPressed: () async {
            BlocProvider.of<AuthenticationBloc>(
                    Storage.scaffoldKey.currentContext)
                .add(LoggedOut());
            Navigator.of(context).pop();
          });

      return response;
    } on DioError catch (err) {
      if (<DioErrorType>[
        DioErrorType.DEFAULT,
        DioErrorType.CONNECT_TIMEOUT,
        DioErrorType.RECEIVE_TIMEOUT,
      ].contains(err.type))
        DialogCustom.showErrorDialog(
          context: context,
          title: 'there_is_no_network',
          errMsg: 'please_check_your_network_and_try_connect_again',
          callback: () => Navigator.pop(context),
        );
      else
        DialogCustom.showErrorDialog(
          context: context,
          title: 'change_password_failed',
          errMsg: 'your_password_is_not_correct_please_try_again',
          callback: () => Navigator.pop(context),
        );

      print('Change Password Error: $err');
      return err.response;
    }
  }
}
