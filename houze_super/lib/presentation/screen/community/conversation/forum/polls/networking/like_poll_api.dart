import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/utils/constants/constants.dart';

class LikeModel {
  LikeModel({
    this.likeCount,
    this.hasLike,
  });

  int likeCount;
  bool hasLike;

  factory LikeModel.fromJson(Map<String, dynamic> json) => LikeModel(
        likeCount: json["like_count"],
        hasLike: json["has_like"],
      );

  Map<String, dynamic> toJson() => {
        "like_count": likeCount,
        "has_like": hasLike,
      };
}

class LikePollAPI extends OauthAPI {
  LikePollAPI() : super(PollPath.getThread);

  Future<LikeModel> likePoll({String threadId}) async {
    try {
      final response =
          await this.post(PollPath.getThread + threadId + "/like/");
      return LikeModel.fromJson(response.data);
    } catch (error) {
      errorLog('likePoll', error.toString());
      return error;
    }
  }

  void errorLog(String functionName, String content) {
    print('[*** LikePollApi] $functionName \t $content');
  }
}
