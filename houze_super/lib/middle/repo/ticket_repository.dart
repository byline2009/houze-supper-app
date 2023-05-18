import 'package:houze_super/middle/api/ticket_api.dart';
import 'package:houze_super/middle/model/ticket_model.dart';

class TicketRepository {
  final ticketAPI = TicketAPI();

  TicketRepository();

  Future<bool> sendTicket(TicketModel ticket) async {
    //Call Dio API
    final rs = await ticketAPI.sendTicket(ticket);
    if (rs != null) {
      return true;
    }
    return false;
  }

  Future<bool> sendRatingReview(RatingModel rating) async {
    //Call Dio API
    final rs = await ticketAPI.sendRatingReview(rating);
    if (rs != null) {
      return true;
    }
    return false;
  }

  Future<TicketDetailModel> getTicketByID(String id) async {
    //Call Dio API
    final rs = await ticketAPI.getTicketByID(id);
    if (rs != null) {
      return rs;
    }
    return null;
  }
}
