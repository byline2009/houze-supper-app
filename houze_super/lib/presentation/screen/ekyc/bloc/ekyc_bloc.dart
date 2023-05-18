import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/repo/ekyc_repo.dart';

import 'ekyc_event.dart';
import 'ekyc_state.dart';

class EKYCBloc extends Bloc<EKYCEvent, EKYCState> {
  EKYCRepository repo = EKYCRepository();

  EKYCBloc() : super(EKYCInitial());

  @override
  Stream<EKYCState> mapEventToState(EKYCEvent event) async* {
    if (event is EKYCLoad) {
      yield EKYCGetting();
      print("event: EKYCGetList");

      try {
        final result = await repo.getEKYC();

        yield EKYCGetSuccessful(eKYC: result);
      } catch (error) {
        yield EKYCGetFailure(error: error.toString());
      }
    }
  }
}
