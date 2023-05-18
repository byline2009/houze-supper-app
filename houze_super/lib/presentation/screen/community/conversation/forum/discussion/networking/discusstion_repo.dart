import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'discussion_api.dart';

class DiscussionRepository {
  DiscussionApi _api = DiscussionApi();
  Future<List<DiscussionModel>> getThreads(
      {int offset = 0, int limit = 5}) async {
    final result = await _api.getThreads(offset: offset, limit: limit);
    if (result != null) {
      return (result.results as List)
          .map((e) => DiscussionModel.fromJson(e))
          .toList();
    }
    return null;
  }

  Future<dynamic> deleteThread({String id}) async {
    final result = await _api.deleteThread(id: id);
    if (result != null) {
      return null;
    }
    return null;
  }

  Future postThread({DiscussionUpdateModel data}) async {
    await _api.postThread(data: data);
  }
}
