import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/agent_repository.dart';
import 'package:houze_super/utils/sqflite.dart';

import 'agent_event.dart';
import 'agent_state.dart';

class AgentBloc extends Bloc<AgentEvent, AgentState> {
  AgentRepository agentRepository = AgentRepository();

  AgentBloc() : super(AgentInitial());

  @override
  Stream<AgentState> mapEventToState(AgentEvent event) async* {
    if (event is AgentResellLoadList) {
      yield AgentResellLoading();
      try {
        final buildingId = Sqflite.currentBuildingID;
        final result = await agentRepository.getAgentResellList(
          buildingId: buildingId,
          page: event.page,
        );

        yield AgentResellListSuccessful(
          results: result,
        );
      } catch (error) {
        yield AgentResellListFailure(
          error: error,
        );
      }
    }

    if (event is AgentResellLoadDetail) {
      yield AgentResellLoading();
      print("event: AgentResellLoadDetail");
      try {
        final result =
            await agentRepository.getAgentResellDetail(detailId: event.id);

        yield AgentResellDetailSuccessful(sell: result);
      } catch (error) {
        yield AgentResellDetailFailure(error: error);
      }
    }

    if (event is AgentResellUpdate) {
      try {
        final result =
            await agentRepository.hideAgentResell(id: event.params["id"]);

        yield AgentResellUpdateSuccessful(sell: result);
      } catch (error) {
        yield AgentResellUpdateFailure(error: error.toString());
      }
    }
  }
}
