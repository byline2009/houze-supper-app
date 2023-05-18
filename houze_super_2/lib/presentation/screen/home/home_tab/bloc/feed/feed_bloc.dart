import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/repo/feed_repository.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/index.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final feedRepository = FeedRepository();

  FeedBloc() : super(FeedInitial()) {
    on<FeedLoadList>((event, emit) async {
      emit(FeedLoading());
      try {
        final result = await feedRepository.getFeeds(
          event.page,
          tags: event.tags,
          type: event.type,
          date: event.date,
          limit: event.limit,
        );

        emit(MailboxLoadAnnoucementsSuccessful(result: result));
      } catch (error) {
        emit(FeedFailure(error: error));
      }
    });
    on<FeedLoadTicketList>((event, emit) async {
      emit(FeedLoading());
      try {
        final result = await feedRepository.getFeeds(event.page,
            type: 'ticket', ticketStatus: event.status);

        emit(MailboxLoadTicketsSuccessful(result: result));
      } on DioError catch (error) {
        if (error.error is String) {
          final Map<String, dynamic> data = json.decode(error.error);

          emit(MailboxLoadTicketsSuccessful(
            result: (data['feed_json'] as List)
                .map((e) => FeedMessageModel.fromJson(e))
                .toList(),
          ));
        } else
          emit(FeedFailure(error: error));
      }
    });

    on<FeedReloadData>((event, emit) async {
      emit(FeedLoading());
      if (event.status == null) {
        emit(FeedInitial());
        return;
      }

      try {
        final result =
            await feedRepository.getFeeds(0, ticketStatus: event.status);

        emit(MailboxLoadTicketsSuccessful(result: result));
      } catch (error) {
        emit(FeedFailure(error: error.toString()));
      }
    });
  }
}
