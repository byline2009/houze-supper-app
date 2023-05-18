import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/app/event.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/index.dart';

import 'community/view/sc_community.dart';

//MainScreen -> HomeScreen
class MainScreen extends StatefulWidget {
  final int currentTab;

  const MainScreen({
    Key? key,
    this.currentTab = 0,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends RouteAwareState<MainScreen> with WidgetsBindingObserver {
  final _overlayBloc = OverlayBloc();

  final List<Widget> screens = [
    HomePage(),
    CommunityPage(),
    PaymentPage(),
    MailboxPage(),
    ProfileScreen(),
  ];
  List<NaviagationBottom> navigationButtons = <NaviagationBottom>[];
  int _currentTab = 0;
  //Global Bloc
  bool _showHasNetworkContainer = false;
  final _connectivity = Connectivity();
  late final StreamSubscription<ConnectivityResult>
      _connectedNetworkSubscription;
  bool _connectedNetwork = true;

  @override
  void initState() {
    super.initState();

    _initVariable();
    _initConnectivity();
    _initSubscriptionListener();
    EventController();
  }

  void _initVariable() {
    WidgetsBinding.instance?.addObserver(this);
    BlocRegistry.set("overlay_bloc", _overlayBloc);
    _showHasNetworkContainer = false;
    _currentTab = widget.currentTab;
  }

  void _initSubscriptionListener() {
    _connectedNetworkSubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _connectedNetworkSubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      return _updateConnectionStatus(result);
    } on PlatformException catch (e) {
      print(e.toString());
    }

    if (!mounted) {
      return Future.value(null);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    final oldResult = _connectedNetwork;

    setState(() {
      _connectedNetwork = result != ConnectivityResult.none;
      if (oldResult == false && _connectedNetwork)
        _showHasNetworkContainer = _connectedNetwork;
    });
    //Hiển thị có mạng sau 3s thì ẩn container đi
    if (result != ConnectivityResult.none) {
      await Future.delayed(
          const Duration(
            seconds: 3,
          ), () {
        if (this.mounted) {
          setState(() {
            _showHasNetworkContainer = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (navigationButtons.length == 0)
      navigationButtons = NavigationBottomList.makeBottom(
        context: context,
      );

    return BlocProvider<OverlayBloc>(
      create: (BuildContext context) => _overlayBloc,
      child: WillPopScope(
        onWillPop: () async => false,
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: BlocProvider.of<AuthenticationBloc>(context),
          listenWhen: (previous, current) {
            if (previous is LogOutButtonTapLoading &&
                current is AuthenticationUnauthenticated) {
              return false;
            } else {
              return true;
            }
          },
          listener: (BuildContext context, authState) {
            if (authState is AuthenticationUnauthenticated) {
              _navigateToLoginScreen();
            }
          },
          child: Scaffold(
            key: Storage.scaffoldKey,
            backgroundColor: Colors.white,
            body: _buildBody(context),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 0.0,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentTab,
              onTap: (int index) {
                bottomTapped(index);
              },
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xff5b00e4),
              unselectedItemColor: Color(0xffb5b5b5),
              selectedLabelStyle:
                  AppFonts.semibold13.copyWith(color: Color(0xff5b00e4)),
              items: this.navigationButtons.map((f) => f.barItem).toList(),
            ),
          ),
        ),
      ),
    );
  }

  void bottomTapped(int index) {
    HapticFeedback.heavyImpact();

    if (_currentTab == index) return;
    setState(() {
      _currentTab = index;
    });
    _overlayBloc.pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    if (_currentTab == index) return;
    setState(() {
      _currentTab = index;
    });
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        PageView.builder(
          controller: _overlayBloc.pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            onPageChanged(index);
          },
          itemBuilder: (c, i) => screens[i],
          itemCount: navigationButtons.length,
        ),
        _buildBottomCheckNetwork(),
      ],
    );
  }

  Widget _buildBottomCheckNetwork() {
    if (_connectedNetwork == false) {
      return CheckNetworkConnectionPage(
        isConnected: false,
      );
    }
    if (_showHasNetworkContainer) {
      return CheckNetworkConnectionPage(
        isConnected: true,
      );
    }
    return const SizedBox.shrink();
  }

  void _navigateToLoginScreen() => AppRouter.pushAndRemoveUntil(
        Storage.scaffoldKey.currentContext!,
        AppRouter.LOGIN,
      );
}
