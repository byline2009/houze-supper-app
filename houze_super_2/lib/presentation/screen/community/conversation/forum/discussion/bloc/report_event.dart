import 'package:equatable/equatable.dart';

abstract class ReportEvent extends Equatable {
  ReportEvent([List props = const []]);
  @override
  List<Object> get props => [];
}

class ReportPostSend extends ReportEvent {
  final String postId;
  final String desc;
  ReportPostSend({required this.postId, required this.desc});
  @override
  List<Object> get props => [
        desc,
        postId,
      ];
  @override
  String toString() => 'ReportSend {}';
}

class ReportCommentSend extends ReportEvent {
	final String commentId;
	final String description;

	ReportCommentSend(this.commentId, {this.description = ""});

	@override
  List<Object> get props => [
        commentId,
        description,
      ];
  @override
  String toString() => 'ReportCommentSend: #$commentId - $description';
}
