class FeeTotalModel {
  double? total;

  FeeTotalModel({this.total});

  FeeTotalModel.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = this.total ?? 0;
    return data;
  }
}

class FeeMessageModel {
  int? type;
  int? total;

  FeeMessageModel({this.type, this.total});

  factory FeeMessageModel.fromJson(Map<String, dynamic> json) {
    return FeeMessageModel(
      type: json['type'],
      total: json['total'],
    );
  }

  FeeMessageModel.map(dynamic obj) {
    this.type = obj['type'];
    this.total = obj['total'];
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'total': total,
      };
}

class FeeModel {
  int? order;
  int? type;
  String? title;
  FeeModel({this.order, this.type, this.title});

  FeeModel.map(dynamic obj) {
    this.order = obj['order'];
    this.type = obj['type'];
    this.title = obj['title'];
  }
}

class FinanceModel {
  double totalAll = 0.0;
  double totalAllBuilding = 0.0;
}

class FeeDetailMessageModel {
  final String? id;
  final int? month;
  final int? year;
  final int? type;
  final int? status;
  final String? totalFee;
  final String? description;
  final String? sentAt;
  final String? receiptAt;

  FeeDetailMessageModel({
    this.id,
    this.month,
    this.type,
    this.status,
    this.totalFee,
    this.description,
    this.year,
    this.sentAt,
    this.receiptAt = "",
  });

  factory FeeDetailMessageModel.fromJson(Map<String, dynamic> json) {
    return FeeDetailMessageModel(
      id: json['id'],
      month: json['month'],
      year: json['year'],
      type: json['type'],
      status: json['status'],
      totalFee: json['total_fee'],
      description: json['description'],
      sentAt: json['sent_at'],
      receiptAt: json['receipt_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'month': month,
        'type': type,
        'status': status,
        'total_fee': totalFee,
        'description': description,
        'year': year,
        'sent_at': sentAt,
        'receipt_at': receiptAt,
      };
}

class FeeByMonth {
  final double? totalFee;
  final int? month;
  final int? year;

  FeeByMonth({this.totalFee, this.month, this.year});

  factory FeeByMonth.fromJson(Map<String, dynamic> json) => FeeByMonth(
        totalFee: json['total_fee'],
        month: json['month'],
        year: json['year'],
      );

  Map<String, dynamic> toJson() => {
        'total_fee': totalFee,
        'month': month,
        'year': year,
      };
}
