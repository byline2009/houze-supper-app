import 'package:houze_super/middle/api/comment_api.dart';
import 'package:houze_super/middle/model/comment_model.dart';
import 'package:houze_super/middle/model/image_model.dart';

class CommentRepository {
  final commentAPI = CommentAPI();

  CommentRepository();

  Future<dynamic> getComments(String id,
      {int offset = 0, int limit = 5}) async {
    //Call Dio API
    final response =
        await commentAPI.getComment(id, limit: limit, offset: offset);
    return response;
  }

  Future<dynamic> getCommentListByPage(String id, int page) async {
    //Call Dio API
    final response = await commentAPI.getCommentByPage(id, page);
    return response;
  }

  Future<CommentModel> sendComment(
      String id, String content, CommentImageModel? image) async {
    var rs;
    if (image != null) {
      rs = await commentAPI.sendComment(id, content, image);
    } else {
      rs = await commentAPI.sendComment(id, content);
    }

    return rs;
  }
}
