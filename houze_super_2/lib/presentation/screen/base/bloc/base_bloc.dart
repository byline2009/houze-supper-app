import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:houze_super/presentation/screen/base/bloc/index.dart';

typedef ResultFunc = Future<dynamic> Function(dynamic params);

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  ResultFunc? resultFunc;
  ResultFunc? requestFunc;

  BaseBloc({this.resultFunc, this.requestFunc}) : super(BaseInitial()) {
    on<BaseLoadList>((event, emit) async {
      emit(BaseLoading());

      try {
        var result = await resultFunc!(event.params);
        emit(BaseListSuccessful(result: result));
      } catch (error) {
        emit(BaseFailure(error: error));
      }
    });

    on<BaseRequest>((event, emit) async {
      emit(BaseLoading());

      try {
        var result = await requestFunc!(event.params);
        emit(BaseRequestSuccessful(result: result));
      } catch (error) {
        emit(BaseFailure(error: error.toString()));
      }
    });
  }

}
