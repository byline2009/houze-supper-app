class VersionModel {
  bool? forceUpdate;
  String? citizenAndroid;
  String? citizenIos;
  String? citizenAndroidStore;
  String? citizenIosStore;
  String? staffAndroid;
  String? staffIos;
  String? staffAndroidStore;
  String? staffIosStore;

  VersionModel(
      {this.forceUpdate,
      this.citizenAndroid,
      this.citizenIos,
      this.citizenAndroidStore,
      this.citizenIosStore,
      this.staffAndroid,
      this.staffIos,
      this.staffAndroidStore,
      this.staffIosStore});

  VersionModel.fromJson(Map<String, dynamic> json) {
    forceUpdate = json['force_update'];
    citizenAndroid = json['citizen_android'];
    citizenIos = json['citizen_ios'];
    citizenAndroidStore = json['citizen_android_store'];
    citizenIosStore = json['citizen_ios_store'];
    staffAndroid = json['staff_android'];
    staffIos = json['staff_ios'];
    staffAndroidStore = json['staff_android_store'];
    staffIosStore = json['staff_ios_store'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['force_update'] = this.forceUpdate;
    data['citizen_android'] = this.citizenAndroid;
    data['citizen_ios'] = this.citizenIos;
    data['citizen_android_store'] = this.citizenAndroidStore;
    data['citizen_ios_store'] = this.citizenIosStore;
    data['staff_android'] = this.staffAndroid;
    data['staff_ios'] = this.staffIos;
    data['staff_android_store'] = this.staffAndroidStore;
    data['staff_ios_store'] = this.staffIosStore;
    return data;
  }
}
