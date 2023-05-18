import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/ticket_repository.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_event.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository = TicketRepository();

  TicketBloc() : super(TicketInitial()) {
    on<EventGetTicketByID>((event, emit) async {
      emit(TicketLoading());

      try {
        final result = await ticketRepository.getTicketByID(event.id);
        emit(GetTicketByIDSuccessfull(result: result));
      } catch (error) {
        emit(TicketFailure(error: error));
      }
    });
  }
}
