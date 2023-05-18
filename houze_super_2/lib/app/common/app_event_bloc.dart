import 'dart:async';

import 'package:houze_super/providers/bloc_provider.dart';

/*
 * payME: Ví điện tử PayME
 * challenge: Giải chạy
 * profile: Cá nhân
 */
enum EventName {
  invoiceDetailUpdate,
  challengeUpdateDetail,
  challengeUpdateItem,
  profileChangeAvatar,
  unknown,
}

class BlocEvent {
  final EventName _eventName;
  final dynamic _value;

  const BlocEvent(this._eventName, [this._value]);

  EventName get name => _eventName;

  dynamic get value => _value;
}

typedef AppEventBlocCallback = Function(BlocEvent handler);

class AppEventBloc extends BlocBase {
  // Singleton
  static final _instance = AppEventBloc._internal();

  factory AppEventBloc() => _instance;

  AppEventBloc._internal();

  final _eventController = StreamController<BlocEvent>.broadcast();
  // ban event
  AppEventBlocCallback get emitEvent => _eventController.sink.add;

  StreamSubscription<BlocEvent> listenEvent({
    required EventName eventName,
    required AppEventBlocCallback handler,
  }) {
    return _eventController.stream
        .where((evt) => evt.name == eventName)
        .listen(handler);
  }

  StreamSubscription<BlocEvent> listenManyEvents({
    required List<EventName> listEventName,
    required AppEventBlocCallback handler,
  }) {
    return _eventController.stream
        .where((evt) => listEventName.contains(evt.name))
        .listen(handler);
  }

  @override
  void dispose() {
    _eventController.close();
  }
}
