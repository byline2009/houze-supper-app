import 'dart:async';

import 'package:flutter/material.dart';

import '../../app/my_app.dart';

abstract class RouteAwareState<T extends StatefulWidget> extends State<T>
    with RouteAware {
  bool _enteredScreen = false;

	@mustCallSuper
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.endOfFrame.then((_) {
      if (mounted) {
        // get the instance of `RouteObserver` from `context`
        // subscribe for the change of route
        routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
        // execute asynchronously as soon as possible
        Timer.run(_enterScreen);
      }
    });
  }

  void _enterScreen() {
    onEnterScreen();
    _enteredScreen = true;
  }

  void _leaveScreen() {
    onLeaveScreen();
    _enteredScreen = false;
  }

	@override
  @mustCallSuper
  void dispose() {
    if (_enteredScreen) {
      _leaveScreen();
    }
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  @mustCallSuper
  void didPopNext() {
    Timer.run(_enterScreen);
  }

  @override
  @mustCallSuper
  void didPop() {
    _leaveScreen();
  }

  @override
  @mustCallSuper
  void didPushNext() {
    _leaveScreen();
  }

  /// this method will always be executed on enter this screen
  void onEnterScreen() {
		debugPrint("[Route] ${T.toString()} is showing");
	}

  /// this method will always be executed on leaving this screen
  void onLeaveScreen() {
		// empty
	}
}
