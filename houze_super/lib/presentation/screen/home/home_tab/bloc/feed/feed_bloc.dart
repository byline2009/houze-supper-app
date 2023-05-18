import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/index.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final feedRepository = FeedRepository();

  FeedBloc() : super(FeedInitial());

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async* {
    if (event is FeedLoadList) {
      yield FeedLoading();

      try {
        final result = await feedRepository.getFeeds(
          event.page,
          tags: event.tags,
          type: event.type,
          date: event.date,
          limit: event.limit,
        );

        yield MailboxLoadAnnoucementsSuccessful(result: result);
      } catch (error) {
        yield FeedFailure(error: error);
      }
    }

    if (event is FeedLoadTicketList) {
      yield FeedLoading();

      try {
        final result = await feedRepository.getFeeds(event.page,
            type: 'ticket', ticketStatus: event.status);

        yield MailboxLoadTicketsSuccessful(result: result);
      } catch (error) {
        if (error.error is String) {
          final Map<String, dynamic> data = json.decode(error.error);

          yield MailboxLoadTicketsSuccessful(
            result: (data['feed_json'] as List)
                .map((e) => FeedMessageModel.fromJson(e))
                .toList(),
          );
        } else
          yield FeedFailure(error: error);
      }
    }
    if (event is FeedReloadData) {
      yield FeedLoading();

      if (event.status == null) {
        yield FeedInitial();
        return;
      }

      try {
        final result =
            await feedRepository.getFeeds(0, ticketStatus: event.status);

        yield MailboxLoadTicketsSuccessful(result: result);
      } catch (error) {
        yield FeedFailure(error: error.toString());
      }
    }
  }
}
