import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/providers/log_provider.dart';

/// A chatty observer that prints info about BLOCs.
class AppBlocObserver extends BlocObserver {
  static LogProvider get logger => const LogProvider('🔥 ');

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    logger.log('${bloc.runtimeType}.onCreate');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    logger.log('${bloc.runtimeType}.onChange change=$change');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    logger.log('${bloc.runtimeType}.onEvent event=$event');
  }
  // @override
  // void onTransition(Bloc bloc, Transition transition) {
  //   super.onTransition(bloc, transition);
  //   logger.log('${bloc.runtimeType}.onTransition transition=$transition');
  // }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    logger.log('${bloc.runtimeType}.onClose');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    logger.log(
        '${bloc.runtimeType}.onError error=${error.toString()} stackTrace=${stackTrace.toString()}');
  }
}
