import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'index.dart';

class FeeFilterBloc extends Bloc<FeeFilterEvent, FeeFilterState> {
  final FeeRepository feeRepository;

  FeeFilterBloc({
    required this.feeRepository,
  }) : super(FeeFilterInitial()) {
    on<FeeFilter>((event, emit) async {
      emit(FeeFilterLoading());

      try {
        final result = await getFeesListWithType(
          buildingID: event.building,
          apartmentID: event.apartment,
          types: event.types,
          feeRepository: feeRepository,
        );
        emit(FeeFilterSuccessful(results: result));
      } catch (error) {
        emit(FeeFilterFailure(error: error));
      }
    });
  }

  Future<List<FeeMessageModel>> getFeesListWithType({
    required String buildingID,
    required String apartmentID,
    required List<int> types,
    required FeeRepository feeRepository,
  }) async {
    return await feeRepository.getFeesListWithType(
      building: buildingID,
      apartment: apartmentID,
      status: 1,
      types: types,
    );
  }

  Future<List<FeeDetailMessageModel>> getFees({
    required String buildingID,
    required String apartmentID,
    required int type,
  }) async {
    try {
      return await feeRepository.getAllFees(
        building: buildingID,
        apartment: apartmentID,
        status: 1,
        type: type.toString(),
      );
    } catch (e) {
      throw e;
    }
  }

  Future<List<FeeGateway>> fetchData({
    required List<FeeMessageModel> fees,
    required String buildingID,
    required String apartmentID,
  }) async {
    List<FeeGateway> results = [];
    List<Future<List<FeeDetailMessageModel>>> _futures = [];
    // add all futures in future's list
    fees.forEach((FeeMessageModel feeItem) {
      _futures.add(getFees(
        apartmentID: apartmentID,
        buildingID: buildingID,
        type: feeItem.type ?? 0,
      ));
    });
    // fetch all data in one go
    final response = await Future.wait(_futures);

    for (int i = 0; i < response.length; ++i) {
      FeeGateway feeGateway = FeeGateway(fee: fees[i], feeDetailList: []);
      feeGateway.feeDetailList.addAll(response[i]);
      results.add(feeGateway);
    }

    return results;
  }
}

class FeeGateway {
  final FeeMessageModel fee;
  final List<FeeDetailMessageModel> feeDetailList;
  const FeeGateway({
    required this.fee,
    required this.feeDetailList,
  });
}
