import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/middle/api/poll_comment_api.dart';

class PollCommentRepository {
  PollCommentAPI _api = PollCommentAPI();

  Future<dynamic> getPollCommentList(
      {required int page, required String id, required String ordering, int? limit}) async {
    final result =
        await _api.getPollCommentList(page: page, id: id, ordering: ordering);
    return result;
  }

  Future<PollCommentModel> sendComment(String description, int displayType,
      String threadID, String? imageID) async {
    var result;
    if (imageID != null) {
      result =
          await _api.sendComment(description, displayType, threadID, imageID);
    } else {
      result = await _api.sendComment(description, displayType, threadID);
    }
    return result;
  }
}
