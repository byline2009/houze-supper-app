import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/handbook_repo.dart';

import 'handbook_event.dart';
import 'handbook_state.dart';

class HandbookBloc extends Bloc<HandbookEvent, HandbookState> {
  final HandbookRepo _repo = HandbookRepo();

  HandbookBloc() : super(HandbookInitial());

  @override
  Stream<HandbookState> mapEventToState(HandbookEvent event) async* {
    if (event is HandbookGetList) {
      yield HandbookGetLoading();

      try {
        final result = await _repo.getHandbooks(event.page);

        yield HandbookListGetSuccessful(handbooks: result);
      } catch (error) {
        yield HandbookGetFailure(error: error);
      }
    }
  }
}
