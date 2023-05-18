import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'index.dart';

class TabbarTitleBloc extends Bloc<TabbarTitleEvent, String> {
  String? service;
  TabbarTitleBloc({this.service}) : super("") {
    on<GetTabbarTitle>((event, emit) async {
      service = await ServiceConverter.convertTypeService(
          "building", event.service ?? "");
      emit(service ?? "");
    });
  }
}
