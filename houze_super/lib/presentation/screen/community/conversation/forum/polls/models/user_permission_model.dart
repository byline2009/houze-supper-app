class UserPermission {
  UserPermission({
    this.userId,
    this.canAccess,
    this.canPost,
    this.canCommentPoll,
  });

  String userId;
  bool canAccess;
  bool canPost;
  bool canCommentPoll;

  factory UserPermission.fromJson(Map<String, dynamic> json) => UserPermission(
        userId: json["user_id"],
        canAccess: json["can_access"],
        canPost: json["can_post"],
        canCommentPoll: json["can_comment_poll"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "can_access": canAccess,
        "can_post": canPost,
        "can_comment_poll": canCommentPoll,
      };
}
