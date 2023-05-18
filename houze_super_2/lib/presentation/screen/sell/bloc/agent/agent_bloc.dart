import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/agent_repository.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'agent_event.dart';
import 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  AgentRepository agentRepository = AgentRepository();

  AgentBloc() : super(AgentInitial()) {
    on<AgentResellLoadList>((event, emit) async {
      emit(AgentResellLoading());
      try {
        final buildingId = Sqflite.currentBuildingID;
        final result = await agentRepository.getAgentResellList(
          buildingId: buildingId,
          page: event.page,
        );

        emit(AgentResellListSuccessful(
          results: result,
        ));
      } catch (error) {
        emit(AgentResellListFailure(
          error: error,
        ));
      }
    });

    on<AgentResellLoadDetail>((event, emit) async {
      emit(AgentResellLoading());
      print("event: AgentResellLoadDetail");
      try {
        final result =
            await agentRepository.getAgentResellDetail(detailId: event.id);

        emit(AgentResellDetailSuccessful(sell: result));
      } catch (error) {
        emit(AgentResellDetailFailure(error: error));
      }
    });

    on<AgentResellUpdate>((event, emit) async {
      try {
        final result =
            await agentRepository.hideAgentResell(id: event.params["id"]);

        emit(AgentResellUpdateSuccessful(sell: result));
      } catch (error) {
        emit(AgentResellUpdateFailure(error: error.toString()));
      }
    });
  }
}
