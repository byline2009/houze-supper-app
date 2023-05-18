import 'package:houze_super/middle/api/version_api.dart';
import 'package:houze_super/middle/model/version_model.dart';

class VersionRepository {
  final versionAPI = VersionAPI();

  VersionRepository();

  Future<VersionModel> getVersion() async {
    final rs = await versionAPI.getVersion();
    return rs;
  }
}
