import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:houze_super/presentation/screen/base/bloc/index.dart';

typedef ResultFunc = Future<dynamic> Function(dynamic params);

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  ResultFunc resultFunc;
  ResultFunc requestFunc;

  BaseBloc({this.resultFunc, this.requestFunc}) : super(BaseInitial());

  BaseState get initialState => BaseInitial();

  @override
  Stream<BaseState> mapEventToState(BaseEvent event) async* {
    if (event is BaseLoadList) {
      yield BaseLoading();

      try {
        var result = await resultFunc(event.params);
        yield BaseListSuccessful(result: result);
      } catch (error) {
        yield BaseFailure(error: error);
      }
    }

    if (event is BaseRequest) {
      yield BaseLoading();

      try {
        var result = await requestFunc(event.params);
        yield BaseRequestSuccessful(result: result);
      } catch (error) {
        yield BaseFailure(error: error.toString());
      }
    }
  }
}
