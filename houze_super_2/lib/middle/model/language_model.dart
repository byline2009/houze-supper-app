class LanguageModel {
  String? name;
  String? flag;
  String? locale;

  LanguageModel({
    required this.name,
    this.flag,
    required this.locale,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      name: json['name'],
      flag: json['flag'],
      locale: json['locale'],
    );
  }

  LanguageModel.map(dynamic obj) {
    this.name = obj['name'];
    this.flag = obj['flag'];
    this.locale = obj['locale'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'flag': flag,
        'locale': locale,
      };
}
