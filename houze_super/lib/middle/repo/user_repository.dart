import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/middle/api/feed_api.dart';
import 'package:houze_super/middle/api/login_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:meta/meta.dart';

class UserRepository {
  final loginAPI = LoginAPI();
  final feedAPI = FeedAPI();

  Future<TokenModel> authenticate({
    @required String phone,
    @required String password,
    String phoneDial,
  }) async {
    TokenModel token;

    try {
      //Call Dio API
      final rs = await loginAPI.login(
        phone: phone,
        password: password,
        phoneDial: phoneDial,
      );

      if (rs != null) {
        token = rs;
        await Storage.saveToken(token);
      }
    } catch (e) {
      return throw (e.toString());
    } finally {
      const platform = const MethodChannel('com.house.citizen');
      final deviceToken = await platform.invokeMethod('device_token') ?? "";
      await Storage.saveDeviceToken(deviceToken);
      await feedAPI.registerDeviceToken(token);
    }

    return token;
  }

  Future<void> deleteToken() async {
    await Future.wait([
      feedAPI.unRegisterDeviceToken(),
      Storage.removeToken(),
    ]);
    return;
  }

  Future<bool> hasToken() async {
    final TokenModel token = Storage.getToken();
    return token != null;
  }
}
