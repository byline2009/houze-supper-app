import 'package:equatable/equatable.dart';
import 'index.dart';

class DataListModel extends Equatable {
  DataListModel({
    this.list,
  });

  final List<LastMessageModel>? list;

  factory DataListModel.fromJson(Map<String, dynamic> json) => DataListModel(
        list: json["list"] == null
            ? null
            : List<LastMessageModel>.from(
                json["list"].map((x) => LastMessageModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? null
            : List<LastMessageModel>.from(list!.map((x) => x.toJson())),
      };
  @override
  List<Object> get props => [list!];
}
