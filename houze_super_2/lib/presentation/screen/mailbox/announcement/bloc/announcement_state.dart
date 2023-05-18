part of 'announcement_bloc.dart';

enum FeedStatus { initial, loading, success, failure }

class AnnouncementState extends Equatable {
  const AnnouncementState({
    this.status = FeedStatus.initial,
    this.feeds = const <FeedMessageModel>[],
    this.error = '',
  });
  final List<FeedMessageModel> feeds;
  final FeedStatus status;
  final String error;
  AnnouncementState copyWith({
    FeedStatus? status,
    List<FeedMessageModel>? feeds,
    String? error,
  }) {
    return AnnouncementState(
      status: status ?? this.status,
      feeds: feeds ?? this.feeds,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''AnnouncementState { status: $status,  feeds: ${feeds.length} error: $error}''';
  }

  @override
  List<Object> get props => [
        status,
        feeds,
        error,
      ];
}
