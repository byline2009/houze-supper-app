class PointLimitModel {
  String id;
  String action;
  int dateLimit;
  int monthLimit;
  int weekLimit;
  int yearLimit;

  PointLimitModel({
    this.id,
    this.action,
    this.dateLimit = 0,
    this.monthLimit = 0,
    this.weekLimit = 0,
    this.yearLimit = 0,
  });

  PointLimitModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    action = json['action'];
    dateLimit = json['date_limit'] ?? this.dateLimit;
    monthLimit = json['month_limit'] ?? this.monthLimit;
    weekLimit = json['week_limit'] ?? this.weekLimit;
    yearLimit = json['year_limit'] ?? this.yearLimit;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['action'] = this.action;
    data['date_limit'] = this.dateLimit;
    data['month_limit'] = this.monthLimit;
    data['week_limit'] = this.weekLimit;
    data['year_limit'] = this.yearLimit;
    return data;
  }
}
