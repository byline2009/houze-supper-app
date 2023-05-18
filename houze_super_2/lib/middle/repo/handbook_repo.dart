import 'package:houze_super/middle/api/handbook_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/handbook_model.dart';

class HandbookRepo {
  final handbookAPI = HandbookAPI();

  HandbookRepo();

  Future<PageModel> getHandbooks(int page) async {
    //Call Dio API
    final rs = await handbookAPI.getHandbooks(page);

    return rs;
  }

  Future<Handbook> getHandbookByID(String id) async {
    final rs = await handbookAPI.getHandbook(id);

    return rs;
  }
}
