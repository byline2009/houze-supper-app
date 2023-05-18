import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_earn_model.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/networking/repository/point_earn_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'houze_xu_event.dart';
part 'houze_xu_state.dart';

class HouzeXuBloc extends Bloc<HouzeXuEvent, HouzeXuState> {
  final PointEarnRepository rpXu = PointEarnRepository();

  HouzeXuBloc() : super(HouzeXuInitial()) {
    on<GetHouzeXu>((event, emit) async {
      emit(HouzeXuLoading());

      try {
        final result = await rpXu.getXuEarnInfo(event.buildingId);

        emit(HouzeXuSuccessful(houzeXu: result));
      } catch (error) {
        emit(HouzeXuFailure());
      }
    });
  }
}
