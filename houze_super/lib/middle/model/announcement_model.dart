class AnnouncementModel {
  String id;
  String file;
  String title;
  String description;
  String created;
  int priority;

  AnnouncementModel(
      {this.id,
      this.file,
      this.title,
      this.description,
      this.created,
      this.priority});

  AnnouncementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    file = json['file'];
    title = json['title'];
    description = json['description'];
    created = json['created'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['file'] = this.file;
    data['title'] = this.title;
    data['description'] = this.description;
    data['created'] = this.created;
    data['priority'] = this.priority;
    return data;
  }
}
