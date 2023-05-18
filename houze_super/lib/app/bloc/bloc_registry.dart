class BlocRegistry {
  static Map<String, dynamic> values = <String, dynamic>{};

  static set(String name, dynamic value) {
    BlocRegistry.values[name] = value;
  }

  static dynamic get(String name) {
    return BlocRegistry.values[name];
  }
}
