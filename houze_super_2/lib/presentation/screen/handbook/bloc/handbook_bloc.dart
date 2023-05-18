import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/handbook_repo.dart';
import 'handbook_event.dart';
import 'handbook_state.dart';

class HandbookBloc extends Bloc<HandbookEvent, HandbookState> {
  final HandbookRepo _repo = HandbookRepo();

  HandbookBloc() : super(HandbookInitial()) {
    on<HandbookGetList>((event, emit) async {
      emit(HandbookGetLoading());

      try {
        final result = await _repo.getHandbooks(event.page);

        emit(HandbookListGetSuccessful(handbooks: result));
      } catch (error) {
        emit(HandbookGetFailure(error: error));
      }
    });
  }
}
