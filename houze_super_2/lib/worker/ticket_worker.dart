import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_meta_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/screen/community/chat/models/chat_image_model.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

/* 
This file contains top functions for worker_manager
(worker_manager - a library for running CPU intensive functions inside a separate dart isolate) 
*/

class ArgUpload {
  String? oauthUrl;
  String? url;
  String? token;
  File? file;
  bool? isMicro;
  SharedPreferences? storageShared;
  ArgUpload({
    this.file,
    this.oauthUrl,
    this.url,
    this.token,
    this.storageShared,
    this.isMicro,
  });
}

class TicketRequest extends OauthAPI {
  TicketRequest(oauthUrl, baseUrl, storageShared) : super('') {
    BasePath.oauth = oauthUrl;
    Storage.prefs = storageShared;
    OauthAPI.init();
  }

  Future<ImageModel> createImage(String url, String token, File image,
      {bool isMicro: false}) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: "ticket.jpg",
        )
      });

      final options = Options(
          headers: {}, sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      if (isMicro) {
        options.headers?["api-version"] = 'v2';
      }
      final response = await this.post(
        url,
        data: formData,
        options: options,
      );

      final rs = ImageModel.fromJson(
        response.data,
      );
      return rs;
    } catch (e) {
      throw e;
    }
  }

  Future<ImageMetaModel> createPakingImage(String url, String token, File image,
      {bool isMicro: false}) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          image.path,
          filename: "ticket.jpg",
        )
      });

      final options = Options(
          headers: {}, sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      if (isMicro) {
        options.headers?["api-version"] = 'v2';
      }
      final response = await this.post(
        url,
        data: formData,
        options: options,
      );

      final rs = ImageMetaModel.fromJson(
        response.data,
      );
      return rs;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> createCommentImage(String url, String token, File image,
      {bool isMicro: false}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last)
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      if (isMicro) {
        options.headers?["api-version"] = 'v2';
      }
      final response = await this.post(url, data: formData, options: options);

      final rs = CommentImageModel.fromJson(response.data);
      return rs;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> createSocialCommentImage(
      String? url, String? token, File? image,
      {bool isMicro: false}) async {
    try {
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image?.path ?? "",
            filename: image?.path.split('/').last)
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      if (isMicro) {
        options.headers?["api-version"] = 'v2';
      }
      final response =
          await this.post(url ?? "", data: formData, options: options);

      final rs = ImageModel.fromJson(response.data);
      return rs;
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> createVideo(String url, String token, File video,
      {bool isMicro: false}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(video.path,
            filename: video.path.split('/').last)
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      if (isMicro) {
        options.headers?["api-version"] = 'v2';
      }
      final response = await this.post(url, data: formData, options: options);

      print("Response: " + response.data['video']);
      return response.data['video'];
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> createImageChat(String url, String token, File image,
      {bool isMicro: false}) async {
    try {
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image.path,
            filename: image.path.split('/').last)
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);
      if (isMicro) {
        options.headers?["api-version"] = 'v2';
      }
      final response = await this.post(url, data: formData, options: options);

      final rs = ChatImageModel.fromJson(response.data);
      return rs;
    } catch (e) {
      throw e;
    }
  }
  // Future<ChatImageModel> createImageChat(String url, String token, File image,
  //     {bool isMicro: false}) async {
  //   try {

  //     FormData formData = FormData.fromMap(
  //       {
  //         "service": "chat",
  //         "file": await MultipartFile.fromFile(image.path,
  //             filename: image.path.split('/').last)
  //       },
  //     );
  //     final options = Options(
  //       sendTimeout: 30 * 1000,
  //       receiveTimeout: 30 * 1000,
  //     );
  //     if (isMicro) {
  //       options.headers!["api-version"] = 'v2';
  //     }
  //     final response = await this.post(url, data: formData, options: options);

  //     final rs = ChatImageModel.fromJson(response.data);
  //     return rs;
  //   } catch (e) {
  //     print(e.toString());
  //     throw e;
  //   }
  // }
}

//Top level function
Future<ImageModel> uploadTicketImageWorker(ArgUpload arg) async {
  //Update ticket image
  final ticketRequest = TicketRequest(arg.oauthUrl, arg.url, arg.storageShared);
  final result = await ticketRequest.createImage(
    arg.url!,
    arg.token!,
    arg.file!,
    isMicro: arg.isMicro!,
  );
  return result;
}

//Top level function
Future<ImageMetaModel> uploadTicketParkingImageWorker(ArgUpload arg) async {
  //Update ticket image
  final ticketRequest = TicketRequest(arg.oauthUrl, arg.url, arg.storageShared);
  final result = await ticketRequest.createPakingImage(
    arg.url!,
    arg.token!,
    arg.file!,
    isMicro: arg.isMicro!,
  );
  return result;
}

//Top level function
Future<dynamic> uploadTicketVideoWorker(ArgUpload arg) async {
  //Update ticket video
  final ticketRequest = TicketRequest(arg.oauthUrl, arg.url, arg.storageShared);
  final result = await ticketRequest.createVideo(
    arg.url!,
    arg.token!,
    arg.file!,
    isMicro: arg.isMicro!,
  );
  return result;
}

//Top level function
Future<dynamic> uploadCommentImageWorker(ArgUpload arg) async {
  //Update ticket image
  final ticketRequest = TicketRequest(
    arg.oauthUrl,
    arg.url,
    arg.storageShared,
  );
  final result = await ticketRequest.createCommentImage(
    arg.url!,
    arg.token!,
    arg.file!,
    isMicro: arg.isMicro!,
  );
  return result;
}

Future<ChatImageModel> uploadChatImageWorker(ArgUpload arg) async {
  //Update ticket image
  final ticketRequest = TicketRequest(
    arg.oauthUrl,
    arg.url,
    arg.storageShared,
  );
  final result = await ticketRequest.createImageChat(
    arg.url!,
    arg.token!,
    arg.file!,
    isMicro: arg.isMicro!,
  );
  return result;
}

Future<dynamic> uploadSocialCommentImageWorker(ArgUpload arg) async {
  //Update ticket image
  final ticketRequest = TicketRequest(
    arg.oauthUrl,
    arg.url,
    arg.storageShared,
  );
  final result = await ticketRequest.createSocialCommentImage(
    arg.url,
    arg.token,
    arg.file,
    isMicro: arg.isMicro!,
  );
  return result;
}
