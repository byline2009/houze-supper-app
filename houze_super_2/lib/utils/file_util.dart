import 'dart:io';

import 'package:path_provider/path_provider.dart';

/* File management (mostly used for houze run) */
class FileUtil {
  static final FileUtil singleton = FileUtil._internal();

  FileUtil._internal();

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    final dir = Directory("$path/run_log");

    if (!dir.existsSync()) dir.createSync();

    return File("$path/run_log/${DateTime.now()}.gpx");
  }

  // Future<File> getFile(String path) async {
  //   final rootPath = await _localPath;
  //
  //   final file = File("$rootPath/$path");
  //
  //   return file;
  // }

  Future<String> readFile(File file) async {
    try {
      final String contents = await file.readAsString();

      return contents;
    } catch (e) {
      throw e;
    }
  }

  Future<File> writeFile(String fileStr) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(fileStr);
  }

  Future<List<FileSystemEntity>?> showListFile(String path) async {
    final rootPath = await _localPath;
    final dir = Directory('$rootPath/$path');

    if (dir.existsSync()) {
      print('ttt: ${dir.listSync().first.path}');

      final fileSystemEntities = dir.listSync()
        ..sort(
          (a, b) => DateTime.parse(a.path.split('/').last.split('.').first)
              .compareTo(
                  DateTime.parse(b.path.split('/').last.split('.').first)),
        );

      print(fileSystemEntities.toString());

      return fileSystemEntities;
    }

    return null;
  }

  Future<File?> getFile(String path) async {
    File? file;

    try {
      await singleton.showListFile(path).then(
        (List<FileSystemEntity>? value) async {
          if (value == null) return;
          if (value.isNotEmpty) file = (value.last as File);
        },
      );
    } catch (err) {
      rethrow;
    }

    return file;
  }

  Future<void> deleteDirectory(String dirName) async {
    final rootPath = await _localPath;
    final dir = Directory('$rootPath/$dirName');

    dir.deleteSync(recursive: true);
  }
}
