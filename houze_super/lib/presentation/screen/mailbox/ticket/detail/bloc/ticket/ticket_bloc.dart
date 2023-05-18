import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/repo/ticket_repository.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_event.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/detail/bloc/ticket/ticket_state.dart';

class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketRepository ticketRepository = TicketRepository();

  TicketBloc() : super(TicketInitial());

  @override
  Stream<TicketState> mapEventToState(TicketEvent event) async* {
    if (event is EventGetTicketByID) {
      yield TicketLoading();

      try {
        final result = await ticketRepository.getTicketByID(event.id);
        yield GetTicketByIDSuccessfull(result: result);
      } on DioError catch (err) {
        if (err.response.statusCode == 404) {
          yield TicketFailure(error: err.response.data);
        }
      } catch (error) {
        yield TicketFailure(error: error);
      }
    }
  }
}
