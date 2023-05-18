import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/language_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/constants/share_keys.dart';
import 'package:houze_super/utils/string_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences prefs;

  static GlobalKey<NavigatorState> scaffoldKey =
      new GlobalKey<NavigatorState>();

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    Storage.scaffoldKey = new GlobalKey<NavigatorState>();
  }

  static Future<void> saveChatToken(String token) async {
    await prefs.setString(ShareKeys.kChatToken, token);
  }

  static String getChatToken() {
    return prefs.getString(ShareKeys.kChatToken) ?? '';
  }

  static Future<void> savePayMEToken(
    String token,
  ) async {
    await prefs.setString(
      ShareKeys.kPayMEToken,
      token,
    );
  }

  static Future<bool> removePayMEToken() async {
    return await prefs.remove(ShareKeys.kPayMEToken);
  }

  static String getPayMEToken() {
    return prefs.getString(ShareKeys.kPayMEToken);
  }

  static Future<void> saveStatePayME(
    String token,
  ) async {
    await prefs.setString(
      ShareKeys.kStatePayME,
      token,
    );
  }

  static Future<bool> removeStatePayME() async {
    return await prefs.remove(ShareKeys.kStatePayME);
  }

  static String getStatePayME() {
    return prefs.getString(ShareKeys.kStatePayME);
  }

  static Future<void> saveUserName(String username) async {
    await prefs.setString(ShareKeys.kFullName, username);
  }

  static String getUserName() {
    final prefs = Storage.prefs;
    return prefs.getString(ShareKeys.kFullName);
  }

  static Future<void> saveAvatar(String url) async {
    final prefs = Storage.prefs;
    await prefs.setString(ShareKeys.kAvatar, url);
  }

  static String getAvatar() {
    final prefs = Storage.prefs;
    return prefs.getString(ShareKeys.kAvatar);
  }

  static Future<void> saveUserID(String id) async {
    final prefs = Storage.prefs;
    await prefs.setString(ShareKeys.kUserID, id);
  }

  static Future<void> savePhoneNumber(int phone) async {
    final prefs = Storage.prefs;
    await prefs.setInt(ShareKeys.kPhoneNumber, phone);
  }

  static Future<void> saveUser(ProfileModel user) async {
    await saveAvatar(user.imageThumb);
    await saveUserName(user.fullname);
    await saveUserID(user.id);
    await savePhoneNumber(user.phoneNumber);
  }

  static Future<void> removeUser() async {
    await Future.wait([
      prefs.remove(ShareKeys.kAvatar),
      prefs.remove(ShareKeys.kFullName),
      prefs.remove(ShareKeys.kUserID),
      prefs.remove(ShareKeys.kPhoneNumber),
    ]);
  }

  static String getUserID() {
    return prefs.getString(ShareKeys.kUserID);
  }

  static int getPhoneNumber() {
    return prefs.getInt(ShareKeys.kPhoneNumber);
  }

  /// Phone dial
  static Future<void> savePhoneDial(String phoneDial) async {
    await prefs.setString(ShareKeys.kPhoneDial, phoneDial);
  }

  static String getPhoneDial() {
    String strSignIn = prefs.getString(ShareKeys.kPhoneDial);
    if (strSignIn.isEmpty) {
      return null;
    }
    return strSignIn.replaceAll(new RegExp(r'\+'), '');
  }

  /// Version code
  static Future<void> saveVersionCode(String version) async {
    await prefs.setString(ShareKeys.kAppVersion, version);
  }

  static String getVersionCode() {
    String strSignIn = prefs.getString(ShareKeys.kAppVersion);
    if (strSignIn.isEmpty) {
      return null;
    }
    return strSignIn;
  }

  /// Device Token
  static Future<void> saveDeviceToken(String deviceToken) async {
    await prefs.setString(ShareKeys.kDeviceToken, deviceToken);
  }

  static String getDeviceToken() {
    String strSignIn = prefs.getString(ShareKeys.kDeviceToken);
    if (strSignIn.isEmpty) {
      return null;
    }
    return strSignIn;
  }

  static Future<bool> saveWelcome(String str) async {
    return await prefs.setString(ShareKeys.kWelcome, str);
  }

  static Future<bool> removeWelcome() async {
    return await prefs.remove(ShareKeys.kWelcome);
  }

  static String getWelcome() {
    return prefs.getString(ShareKeys.kWelcome);
  }

  // Token
  static Future<bool> saveToken(TokenModel token) async {
    return await prefs.setString(ShareKeys.kAPIToken, json.encode(token));
  }

  static Future<bool> removeToken() async {
    return await prefs.remove(ShareKeys.kAPIToken);
  }

  static TokenModel getToken() {
    String token = prefs.getString(ShareKeys.kAPIToken);
    if (StringUtil.isEmpty(token)) {
      return null;
    }

    try {
      var decoded = json.decode(token);
      TokenModel _result = TokenModel.fromJson(decoded);
      return _result;
    } catch (err) {
      print("Get token Error=> ${err.toString()}");
      return null;
    }
  }

  //Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    await prefs.setString(ShareKeys.kUserRefreshToken, refreshToken);
  }

  static Future<void> removeChatToken() async {
    await prefs.remove(ShareKeys.kChatToken);
  }

  static Future<void> removeRefreshToken() async {
    await prefs.remove(ShareKeys.kUserRefreshToken);
  }

  static Future<String> getRefreshToken() async {
    final String strSignIn = prefs.getString(ShareKeys.kUserRefreshToken);
    if (StringUtil.isEmpty(strSignIn)) {
      return null;
    }
    return strSignIn;
  }

  /// Save sign in object.
  static Future<void> saveSignIn(Map<String, dynamic> bjson) async {
    await prefs.setString(ShareKeys.kSignIn, json.encode(bjson));
  }

  // Get Signin
  static Future<Map<String, dynamic>> getSignIn() async {
    final prefs = Storage.prefs;
    String strSignIn = prefs.getString(ShareKeys.kSignIn);
    if (strSignIn.isEmpty) {
      return null;
    }
    return json.decode(strSignIn);
  }

  /// Remove sign in object.
  static Future<void> removeSignIn() async {
    final prefs = Storage.prefs;
    await prefs.remove(ShareKeys.kSignIn);
  }

  /// Save language
  static Future<void> saveLanguage(LanguageModel item) async {
    final prefs = Storage.prefs;
    await prefs.setString(ShareKeys.kLanguage, json.encode(item));
  }

  //Remove
  static Future<void> removeLanguage() async {
    await prefs.remove(ShareKeys.kLanguage);
  }

  // Get language
  static LanguageModel getLanguage() {
    final prefs = Storage.prefs;
    String strLanguage = prefs.getString(ShareKeys.kLanguage);
    LanguageModel item;
    if (StringUtil.isEmpty(strLanguage)) {
      item = AppConstant.languages[0];
    } else {
      item = LanguageModel.fromJson(json.decode(strLanguage));
    }
    return item;
  }

  static Future<void> dispose() async {
    await Future.wait([
      prefs.remove(ShareKeys.kPhoneDial),
      removeUser(),
      removeRefreshToken(),
      removeSignIn(),
      removeToken(),
      removeWelcome(),
      removePayMEToken(),
    ]);
  }
}
