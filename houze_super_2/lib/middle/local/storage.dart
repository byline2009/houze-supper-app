import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/language_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/constant/share_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* This file contains methods used for local storage (share references) */

class Storage {
  static int timeoutResetCode = 60;
  static SharedPreferences? prefs;

  static GlobalKey<NavigatorState> scaffoldKey =
      new GlobalKey<NavigatorState>();

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    Storage.scaffoldKey = new GlobalKey<NavigatorState>();
  }

  static void saveChatToken(String token) {
    Storage.prefs?.setString(ShareKeys.kChatToken, token);
  }

  static String getChatToken() {
    final prefs = Storage.prefs;
    return prefs?.getString(ShareKeys.kChatToken) ?? '';
  }

  static Future<void> clear() async {
    // removeLanguage();
    await removeUser();
    await removeRefreshToken();
    await removeSignIn();
    await removeToken();
    await removeWelcome();
    // prefs.clear();
  }

  static Future<void> saveUserName(String username) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kFullName, username);
  }

  static String? getUserName() {
    final prefs = Storage.prefs;
    return prefs?.getString(ShareKeys.kFullName);
  }

  static Future<void> saveAvatar(String url) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kAvatar, url);
  }

  static String? getAvatar() {
    final prefs = Storage.prefs;
    return prefs?.getString(ShareKeys.kAvatar);
  }

  static Future<void> saveUserID(String id) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kUserID, id);
  }

  static Future<void> savePhoneNumber(int? phone) async {
    final prefs = Storage.prefs;
    if (phone != null) await prefs?.setInt(ShareKeys.kPhoneNumber, phone);
  }

  static Future<void> saveUser(ProfileModel user) async {
    await saveAvatar(user.imageThumb ?? '');
    await saveUserName(user.fullname ?? '');
    await saveUserID(user.id ?? '');
    await savePhoneNumber(user.phoneNumber);
  }

  static Future<void> removeUser() async {
    final prefs = Storage.prefs;
    await prefs?.remove(ShareKeys.kAvatar);
    await prefs?.remove(ShareKeys.kFullName);
    await prefs?.remove(ShareKeys.kUserID);
    await prefs?.remove(ShareKeys.kPhoneNumber);
  }

  static String? getUserID() {
    final prefs = Storage.prefs;
    return prefs?.getString(ShareKeys.kUserID);
  }

  static int? getPhoneNumber() {
    final prefs = Storage.prefs;
    return prefs?.getInt(ShareKeys.kPhoneNumber);
  }

  /// Phone dial
  static Future<void> savePhoneDial(String phoneDial) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kPhoneDial, phoneDial);
  }

  static Future<String?> getPhoneDial() async {
    final prefs = Storage.prefs;
    String? strSignIn = prefs?.getString(ShareKeys.kPhoneDial);
    if (strSignIn!.isEmpty) {
      return null;
    }
    return strSignIn.replaceAll(new RegExp(r'\+'), '');
  }

  /// Version code
  static Future<void> saveVersionCode(String version) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kAppVersion, version);
  }

  static String? getVersionCode() {
    final prefs = Storage.prefs;
    String? strSignIn = prefs?.getString(ShareKeys.kAppVersion);
    if (strSignIn!.isEmpty) {
      return null;
    }
    return strSignIn;
  }

  /// Device Token
  static Future<void> saveDeviceToken(String deviceToken) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kDeviceToken, deviceToken);
  }

  static Future<String> getDeviceToken() async {
    final prefs = Storage.prefs;
    return prefs?.getString(ShareKeys.kDeviceToken) ?? '';
  }

  static Future<bool> saveWelcome(String str) async {
    final prefs = Storage.prefs;
    return (await prefs?.setString(ShareKeys.kWelcome, str)) ?? false;
  }

  static Future<bool> removeWelcome() {
    final prefs = Storage.prefs;
    return prefs!.remove(ShareKeys.kWelcome);
  }

  static String getWelcome() {
    final prefs = Storage.prefs;
    return prefs?.getString(ShareKeys.kWelcome) ?? '';
  }

  // Token
  static Future<bool?> saveToken(TokenModel token) async {
    final prefs = Storage.prefs;
    return prefs?.setString(ShareKeys.kAPIToken, json.encode(token));
  }

  static Future<bool>? removeToken() {
    final prefs = Storage.prefs;
    return prefs?.remove(ShareKeys.kAPIToken);
  }

  static TokenModel? getToken() {
    final prefs = Storage.prefs;
    String? token = prefs?.getString(ShareKeys.kAPIToken);
    if (token?.isEmpty == true) {
      return null;
    }

    try {
      var decoded = json.decode(token ?? "");
      TokenModel _result = TokenModel.fromJson(decoded);
      return _result;
    } catch (err) {
      print("Get token Error=> ${err.toString()}");
      return null;
    }
  }

  //Refresh Token
  static Future<void> saveRefreshToken(String refreshToken) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kUserRefreshToken, refreshToken);
  }

  static Future<void> removeChatToken() async {
    final prefs = Storage.prefs;
    await prefs?.remove(ShareKeys.kChatToken);
  }

  static Future<void> removeRefreshToken() async {
    final prefs = Storage.prefs;
    await prefs?.remove(ShareKeys.kUserRefreshToken);
  }

  static Future<String?> getRefreshToken() async {
    String? strSignIn = prefs?.getString(ShareKeys.kUserRefreshToken);

    if (strSignIn?.isEmpty == true) {
      return null;
    }

    return strSignIn;
  }

  /// Save sign in object.
  static Future<void> saveSignIn(Map<String, dynamic> bjson) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kSignIn, json.encode(bjson));
  }

  // Get Signin
  static Future<Map<String, dynamic>?> getSignIn() async {
    final prefs = Storage.prefs;
    String? strSignIn = prefs?.getString(ShareKeys.kSignIn);
    if (strSignIn!.isEmpty) {
      return null;
    }
    return json.decode(strSignIn);
  }

  /// Remove sign in object.
  static Future<void> removeSignIn() async {
    final prefs = Storage.prefs;
    await prefs?.remove(ShareKeys.kSignIn);
  }

  /// Save language
  static Future<void> saveLanguage(LanguageModel item) async {
    final prefs = Storage.prefs;
    await prefs?.setString(ShareKeys.kLanguage, json.encode(item));
  }

  //Remove
  static Future<void> removeLanguage() async {
    final prefs = Storage.prefs;
    await prefs?.remove(ShareKeys.kLanguage);
  }

  // Get language
  static LanguageModel getLanguage() {
    final prefs = Storage.prefs;
    String? strLanguage = prefs?.getString(ShareKeys.kLanguage) ?? '';
    LanguageModel item;

    if (strLanguage.isEmpty == true) {
      item = AppConstant.languages[0];
    } else {
      item = LanguageModel.fromJson(json.decode(strLanguage));
    }
    return item;
  }
}
