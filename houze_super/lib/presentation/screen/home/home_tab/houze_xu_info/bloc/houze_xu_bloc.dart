import 'dart:async';
import 'package:meta/meta.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:houze_super/middle/model/houze_point/point_earn_model.dart';
import 'package:houze_super/middle/repo/point_earn_repo.dart';

part 'houze_xu_event.dart';
part 'houze_xu_state.dart';

class HouzeXuBloc extends Bloc<HouzeXuEvent, HouzeXuState> {
  final PointEarnRepository rpXu = PointEarnRepository();

  HouzeXuBloc() : super(HouzeXuInitial());

  @override
  Stream<HouzeXuState> mapEventToState(
    HouzeXuEvent event,
  ) async* {
    if (event is GetHouzeXu) {
      yield HouzeXuLoading();

      try {
        final result = await rpXu.getXuEarnInfo(event.buildingId);

        yield HouzeXuSuccessful(houzeXu: result);
      } catch (error) {
        yield HouzeXuFailure();
      }
    }
  }
}
