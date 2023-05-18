//Create a Model class to hold key-value pair data
class KeyValueModel {
  final String key;
  final String value;

  KeyValueModel({
    required this.key,
    required this.value,
  });

  factory KeyValueModel.fromJson(KeyValueModel json) {
    return KeyValueModel(
      key: json.key,
      value: json.value,
    );
  }
}
