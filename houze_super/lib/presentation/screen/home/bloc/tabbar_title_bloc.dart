import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'index.dart';

class TabbarTitleBloc extends Bloc<TabbarTitleEvent, String> {
  String service;
  TabbarTitleBloc({this.service}) : super("");

  @override
  Stream<String> mapEventToState(TabbarTitleEvent event) async* {
    String service;
    if (event is GetTabbarTitle) {
      service = await ServiceConverter.convertTypeService(
          "building", event.service);
      yield service;
    }
  }
}
