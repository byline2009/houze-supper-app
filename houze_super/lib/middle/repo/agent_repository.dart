import 'package:houze_super/middle/api/agent_api.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/common_widgets/stateful/picker_image.dart';

class AgentRepository {
  AgentAPI api = AgentAPI();
  AgentRepository();

  Future<PageModel> getAgentResellList(
      {String buildingId = "", int page}) async {
    final rs = await api.getResellList(
      buildingId: buildingId,
      page: page,
    );
    return rs;
  }

  Future<SellModel> getAgentResellDetail({String detailId = ""}) async {
    final rs = await api.getResellDetail(
      detailId: detailId,
    );
    return rs;
  }

  Future hideAgentResell({String id}) async {
    await api.hideAgentResell(id: id);
  }

  Future<ImageModel> uploadImage(FilePick file) async {
    //Call Dio API
    final rs = await api.uploadImage(file.file);
    if (rs != null) {
      return rs;
    }
    return null;
  }

  Future<ImageModel> uploadAuthenticationImage(FilePick file) async {
    //Call Dio API
    final rs = await api.uploadAuthenticationImage(file.file);
    if (rs != null) {
      return rs;
    }
    return null;
  }

  Future<bool> updateAgentResell({String id, SellTicketModel ticket}) async {
    //Call Dio API
    final rs = await api.updateTicket(id, ticket);
    if (rs != null) {
      return true;
    }
    return false;
  }

  Future<bool> sendAgentResell(SellTicketModel ticket) async {
    //Call Dio API
    final rs = await api.sendTicket(ticket);
    if (rs != null) {
      return true;
    }
    return false;
  }
}
