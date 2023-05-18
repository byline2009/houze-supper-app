import 'package:flutter/services.dart';
import 'package:houze_super/middle/api/feed_api.dart';
import 'package:houze_super/middle/api/login_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/token_model.dart';

class UserRepository {
  final loginAPI = LoginAPI();
  final feedAPI = FeedAPI();

  UserRepository() {
    print('UserRepository init');
  }

  Future<TokenModel> authenticate({
    required String phone,
    required String password,
    String? phoneDial,
  }) async {
    TokenModel? token;

    try {
      //Call Dio API
      final rs = await loginAPI.login(
        phone: phone,
        password: password,
        phoneDial: phoneDial,
      );

      token = rs;
      await Storage.saveToken(token);
    } catch (e) {
      return throw (e.toString());
    } finally {
      const platform = const MethodChannel('com.house.citizen');
      final String deviceToken =
          await platform.invokeMethod('device_token') ?? "";
      if (deviceToken.isNotEmpty) {
        await Storage.saveDeviceToken(deviceToken);
        if (token != null) await feedAPI.registerDeviceToken(token);
      }
    }

    return token;
  }

  Future<void> deleteToken() async {
    await feedAPI.unRegisterDeviceToken();
    await Storage.removeToken();
  }

  Future<bool> hasToken() async {
    TokenModel? token = Storage.getToken();
    return token != null;
  }
}
