import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import '../api/discussion_api.dart';

class DiscussionRepository {
  DiscussionApi _api = DiscussionApi();
  Future<List<DiscussionModel>?> getThreads(
      {int offset = 0, int limit = 5}) async {
    final result = await _api.getThreads(offset: offset, limit: limit);
    if (result != null) {
      return (result.results as List)
          .map((e) => DiscussionModel.fromJson(e))
          .toList();
    }
    return null;
  }

  Future<dynamic> deleteThread({required String id}) async {
    final result = await _api.deleteThread(id: id);
    if (result != null) {
      return null;
    }
    return null;
  }

  Future postThread({required DiscussionUpdateModel data}) async {
    await _api.postThread(data: data);
  }

  Future<bool> reportPost({required String id, required String desc}) async {
    final result = await _api.reportPost(id: id, desc: desc);
    if (result != null) {
      return true;
    }
    return false;
  }

	Future<bool> reportComment({required String commentId, required String desc}) async {
    final result = await _api.reportComment(commentId, desc: desc);
    if (result != null) {
      return true;
    }
    return false;
  }
}
