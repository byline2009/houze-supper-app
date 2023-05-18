import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Sqflite {
  static Database db;
  static const int version = 1;
  static const String database_name = "houze.citizen.db";
  static String currentBuildingID = "";

  static BuildingMessageModel currentBuilding;

  static Future init() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, database_name);

    try {
      print("Sqflite init in path: $path");
      db = await openDatabase(
        path,
        version: version,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE IF NOT EXISTS user_setting (key TEXT, value TEXT)');
          await db.execute(
              'CREATE TABLE IF NOT EXISTS responses (path TEXT PRIMARY KEY, data TEXT)');
          await db.execute(
              'CREATE TABLE IF NOT EXISTS payme (key TEXT, value TEXT)');
        },
        // onUpgrade: (Database db, int oldVersion, int newVersion) async {
        //   await db.execute(
        //       'CREATE TABLE IF NOT EXISTS responses (path TEXT PRIMARY KEY, data TEXT)');
        // },
      );
    } catch (e) {
      print("Error $e");
    }
  }

  static Future<void> insertResponse(Response response) async {
    // Get a reference to the database.

    final String pathWithParams =
        response.request.path + getParamsPath(response.request.queryParameters);

    final Map<String, dynamic> instance = {
      "path": pathWithParams,
      "data": json.encode(response.data),
    };

    await db.insert(
      'responses',
      instance,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String> getCachingResponse(DioError error) async {
    // Get a reference to the database.

    final String pathWithParams =
        error.request.path + getParamsPath(error.request.queryParameters);

    try {
      final Map<String, dynamic> cachingResponse = (await db.rawQuery(
        'SELECT data FROM responses WHERE path = "$pathWithParams" LIMIT 1',
      ))
          .single;

      return cachingResponse['data'];
    } on StateError {
      if (!error.request.queryParameters.containsKey('offset') ||
          <dynamic>[0, null].any((e) =>
              e ==
              error.request.queryParameters.entries
                  .firstWhere((e) => e.key == 'offset')
                  .value))
        throw NoDataException();
      else {
        throw NoDataToLoadMoreException();
      }
    }
  }

  static Future<void> flush() async {
    await db.rawUpdate('DELETE FROM user_setting');
    await db.rawUpdate('DELETE FROM responses');
  }

  static Future<String> getCurrentBuildingID() async {
    if (Sqflite.currentBuildingID == "") {
      final checkIndex = await db.rawQuery(
          'SELECT * FROM user_setting WHERE key = "building_id_select" LIMIT 1');
      if (checkIndex.length > 0) {
        Sqflite.currentBuildingID = checkIndex[0]["value"];
        return checkIndex[0]["value"];
      }
      return null;
    }
    return Sqflite.currentBuildingID;
  }

  static Future<BuildingMessageModel> getCurrentBuilding() async {
    if (Sqflite.currentBuilding == null) {
      final checkIndex = await db.rawQuery(
          'SELECT * FROM user_setting WHERE key = "building_select_json" LIMIT 1');
      if (checkIndex.length > 0) {
        Map buildingModelMap = jsonDecode(checkIndex[0]["value"]);
        Sqflite.currentBuilding =
            BuildingMessageModel.fromJson(buildingModelMap);
        return Sqflite.currentBuilding;
      }
      return null;
    }
    return Sqflite.currentBuilding;
  }

  static Future<String> pickBuildingID({String id}) async {
    await db.rawUpdate(
        'UPDATE user_setting SET value = ? WHERE key = "building_id_select"',
        [id]);
    Sqflite.currentBuildingID = id;
    return id;
  }

  static Future<List<BuildingMessageModel>> getBuildingList() async {
    final checkIndex = await db
        .rawQuery('SELECT * FROM user_setting WHERE key = "building_list"');
    if (checkIndex.length > 0) {
      final buildings = json.decode(checkIndex[0]["value"]).toList();

      return (buildings as List).map((obj) {
        return BuildingMessageModel.fromJson(obj);
      }).toList();
    }
    return null;
  }

  static Future<BuildingMessageModel> getBuildingWithId(String id) async {
    List<BuildingMessageModel> _listBuilding = await Sqflite.getBuildingList();
    if (_listBuilding.length > 0) {
      final BuildingMessageModel building =
          _listBuilding.singleWhere((f) => f.id == id);

      return building;
    }
    return null;
  }

  static Future<BuildingMessageModel> setCurrentBuildingWithId(
      String id) async {
    List<BuildingMessageModel> _listBuilding = await Sqflite.getBuildingList();
    if (_listBuilding.length > 0) {
      final BuildingMessageModel building =
          _listBuilding.singleWhere((f) => f.id == id);

      Sqflite.currentBuilding = building;

      return building;
    }
    return null;
  }

  static Future<BuildingMessageModel> updateCurrentBuildings(
      {List<BuildingMessageModel> buildings, int indexSelected = 0}) async {
    // Info only lived one building => store current building
    if (buildings.length > 0) {
      final checkIndex = await db.rawQuery(
          'SELECT * FROM user_setting WHERE key = "building_id_select" LIMIT 1');

      if (checkIndex.length == 0) {
        await db.transaction((txn) async {
          await txn.rawInsert(
              'INSERT INTO user_setting(key, value) VALUES("building_id_select", ?)',
              [buildings[0].id]);
          await txn.rawInsert(
              'INSERT INTO user_setting(key, value) VALUES("building_select_json", ?)',
              [json.encode(buildings[0])]);
          await txn.rawInsert(
              'INSERT INTO user_setting(key, value) VALUES("building_list", ?)',
              [json.encode(buildings)]);
          Sqflite.currentBuildingID = buildings[0].id;
          Sqflite.currentBuilding = buildings[0];
        });
      } else {
        //Get select with id
        final building = buildings.firstWhere(
            (l) => l.id == checkIndex[0]["value"],
            orElse: () => buildings.first);

        await db.rawUpdate(
            'UPDATE user_setting SET value = ? WHERE key = "building_select_json"',
            [json.encode(building.toJson())]);

        await db.rawUpdate(
            'UPDATE user_setting SET value = ? WHERE key = "building_list"',
            [json.encode(buildings)]);

        Sqflite.currentBuilding = building;

        await Sqflite.getCurrentBuildingID();
        await Sqflite.getCurrentBuilding();

        return building;
      }

      return buildings[0];
    }
    return null;
  }

  static String getParamsPath(Map<String, dynamic> queryParameters) {
    String params = '';

    final temp = <dynamic>[];

    queryParameters.entries.forEach((e) {
      if (e.value != null && e.value.toString().isNotEmpty)
        temp.add([e.key, e.value.toString()]);
    });

    if (temp.isNotEmpty) {
      params = '?';

      temp.forEach(
          (e) => params += '${e.first}=${e.last}${e == temp.last ? '' : '&'}');
    }

    print('params: $params');

    return params;
  }
}
