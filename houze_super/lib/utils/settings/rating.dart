import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/utils/index.dart';

class RatingSettings {
  static final List<TicketRatingTitleModel> listRating1Star = [
    TicketRatingTitleModel(image: AppVectors.ic_late, title: "Bắt chờ đợi lâu"),
    TicketRatingTitleModel(
        image: AppVectors.ic_impolite, title: "Thái độ bất lịch sự"),
    TicketRatingTitleModel(
        image: AppVectors.ic_bad_service, title: "Sửa chữa rất lâu"),
    TicketRatingTitleModel(
        image: AppVectors.ic_banned, title: "Không muốn gặp lại"),
  ];

  static final List<TicketRatingTitleModel> listRating2Star = [
    TicketRatingTitleModel(image: AppVectors.ic_late, title: "Bắt chờ đợi lâu"),
    TicketRatingTitleModel(
        image: AppVectors.ic_impolite, title: "Thái độ bất lịch sự"),
    TicketRatingTitleModel(
        image: AppVectors.ic_bad_service, title: "Sửa chữa rất lâu"),
  ];

  static final List<TicketRatingTitleModel> listRating3Star = [
    TicketRatingTitleModel(
        image: AppVectors.ic_normal, title: "Tay nghề tạm ổn"),
    TicketRatingTitleModel(image: AppVectors.ic_late, title: "Bắt chờ đợi lâu"),
  ];

  static final List<TicketRatingTitleModel> listRating4Star = [
    TicketRatingTitleModel(
        image: AppVectors.ic_on_time, title: "Siêu nhân đúng giờ"),
    TicketRatingTitleModel(
        image: AppVectors.ic_planet, title: "Kỹ tính nhất hành tinh"),
    TicketRatingTitleModel(
        image: AppVectors.ic_flash, title: "Nhanh như tia chớp"),
  ];

  static final List<TicketRatingTitleModel> listRating5Star = [
    TicketRatingTitleModel(
        image: AppVectors.ic_on_time, title: "Siêu nhân đúng giờ"),
    TicketRatingTitleModel(
        image: AppVectors.ic_planet, title: "Kỹ tính nhất hành tinh"),
    TicketRatingTitleModel(
        image: AppVectors.ic_flash, title: "Nhanh như tia chớp"),
    TicketRatingTitleModel(
        image: AppVectors.ic_super, title: "Tay nghề bậc thầy"),
  ];
}
