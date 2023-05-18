import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'announcement_event.dart';
part 'announcement_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState> {
  final FeedRepository _feedAPI;

  AnnouncementBloc({
    required FeedRepository feedAPI,
  })  : _feedAPI = feedAPI,
        super(const AnnouncementState()) {
    on<AnnouncementFetched>(
      _onAnnouncementFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onAnnouncementFetched(
      AnnouncementFetched event, Emitter<AnnouncementState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading));

    try {
      final _feeds = await _fetchAnnouncement(
        event.page,
        event.type,
        event.buildingID,
        event.tag,
        event.time,
        event.isRead,
      );
      await Future.delayed(
          Duration(
            milliseconds: 300,
          ), () {
        emit(
          state.copyWith(
            status: FeedStatus.success,
            feeds: _feeds,
          ),
        );
      });
    } catch (e) {
      emit(state.copyWith(
        status: FeedStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<List<FeedMessageModel>> _fetchAnnouncement(
    int page,
    String type,
    String id,
    String tag,
    String time,
    bool? isRead,
  ) async {
    return await _feedAPI.getFeeds(
      page,
      type: type,
      buildingID: id,
      tags: tag,
      date: time,
      isRead: isRead,
    );
  }
}
