import 'dart:io';

import 'package:encrypt/encrypt.dart';
import 'package:gpx/gpx.dart';
import 'package:houze_super/middle/model/houze_location.dart';
import 'package:houze_super/presentation/index.dart';

import 'file_util.dart';

/* This file contains functions that load, manipulate, and save GPS data in GPX format (Houze run) */

class GpxUtil {
  static final iv = IV.fromLength(16);

  static final encrypter = Encrypter(
    AES(
      Key.fromUtf8(AppConstant.runLogKey),
      mode: AESMode.ecb,
    ),
  );

  static Future<File> encryptRouteFile(List<HouzeRoute> houzeRoutes) async {
    final gpx = Gpx();

    gpx.rtes.addAll(
      houzeRoutes.map(
        (e) => Rte(
          name: 'Route ${houzeRoutes.indexOf(e) + 1}',
          rtepts: e.locations!
              .map(
                (location) => Wpt(
                  lat: location.latitude,
                  lon: location.longitude,
                  ele: location.altitude,
                  time: DateTime.fromMillisecondsSinceEpoch(
                      location.time!.toInt()),
                ),
              )
              .toList(),
        ),
      ),
    );

    final String gpxStr = GpxWriter().asString(gpx, pretty: true);

    // final encryptedGpxStr = encrypter.encrypt(gpxStr, iv: iv).base64;

    return await FileUtil.singleton.writeFile(gpxStr);

    // await FileUtil.singleton.writeFile(encryptedGpxStr);
  }

  static Future<List<HouzeRoute>> decryptRouteFile(File file) async {
    final String encryptedGpxStr = await FileUtil.singleton.readFile(file);

    final String gpxStr = encrypter.decrypt64(encryptedGpxStr);

    final Gpx gpx = GpxReader().fromString(gpxStr);

    final houzeRoutes = <HouzeRoute>[];

    houzeRoutes.addAll(
      gpx.rtes.map(
        (e) => HouzeRoute(
          locations: e.rtepts
              .map(
                (i) => HouzeLocation(
                  latitude: i.lat ?? 0.0,
                  longitude: i.lon ?? 0.0,
                  altitude: i.ele,
                  time: i.time!.millisecondsSinceEpoch.toDouble(),
                ),
              )
              .toList(),
        ),
      ),
    );

    return houzeRoutes;
  }
}
