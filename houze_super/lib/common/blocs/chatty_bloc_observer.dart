import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A chatty observer that prints info about BLOCs.
class ChattyBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {
    super.onCreate(cubit);
    debugPrint('🌵 ${cubit.runtimeType}.onCreate');
  }

  @override
  void onChange(Cubit cubit, Change change) {
    super.onChange(cubit, change);
    debugPrint('🌵 ${cubit.runtimeType}.onChange change=$change');
  }

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    debugPrint('${bloc.runtimeType}.onEvent event=$event');
  }

  @override
  void onClose(Cubit cubit) {
    super.onClose(cubit);
    debugPrint('🌵 ${cubit.runtimeType}.onClose');
  }
}
