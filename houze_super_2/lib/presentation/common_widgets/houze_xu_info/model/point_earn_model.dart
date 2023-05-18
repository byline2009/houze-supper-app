// "fee_bank_transfer_award": 1500
// "run_award": 1000
// "ticket_created_award": 1000
// "ticket_rating_award": 1000

class PointEarnModel {
  int? feeBankTransferAward;
  int? runAward;
  int? ticketCreatedAward;
  int? ticketRatingAward;

  PointEarnModel({
    this.feeBankTransferAward = 0,
    this.runAward = 0,
    this.ticketCreatedAward = 0,
    this.ticketRatingAward = 0,
  });

  PointEarnModel.fromJson(Map<String, dynamic> json) {
    feeBankTransferAward =
        json['fee_bank_transfer_award'] ?? this.feeBankTransferAward;
    runAward = json['run_award'] ?? this.runAward;
    ticketCreatedAward =
        json['ticket_created_award'] ?? this.ticketCreatedAward;
    ticketRatingAward = json['ticket_rating_award'] ?? this.ticketRatingAward;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fee_bank_transfer_award'] = this.feeBankTransferAward;
    data['run_award'] = this.runAward;
    data['ticket_created_award'] = this.ticketCreatedAward;
    data['ticket_rating_award'] = this.ticketRatingAward;
    return data;
  }
}
