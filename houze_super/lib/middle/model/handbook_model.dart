class Handbook {
  String id;
  String title;
  String created;
  dynamic file;
  String description;

  Handbook({
    this.id,
    this.title,
    this.created,
    this.file,
    this.description,
  });

  factory Handbook.fromJson(Map<String, dynamic> json) => Handbook(
        id: json["id"],
        title: json["title"],
        created: json["created"],
        file: json["file"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "created": created,
        "file": file,
        "description": description,
      };
}
