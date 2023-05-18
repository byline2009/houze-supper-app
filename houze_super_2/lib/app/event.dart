import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/app/blocs/bloc_registry.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/feed_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:uni_links/uni_links.dart';
import 'blocs/overlay/index.dart';

/* Handle deep link for payment method (payoo, momo, zalo) */

const notificationReceiveStream =
    const EventChannel('com.house.citizen/receive_notification');
const EventChannel eventChannel = EventChannel('flutter.native/eventPayOrder');
enum UniLinksType { string, uri }
const String kSuccess = 'success';
const String kFailed = 'failed';
const String kPayooEncrypt = 'payoo_encrypt';

class EventController {
  UniLinksType _type = UniLinksType.uri;
  late final StreamSubscription _deepLinkSub;

  EventController() {
    notificationReceiveStream.receiveBroadcastStream().listen((value) {
      if (value != null) {
        redirect(value);
      }
    });
    if (Platform.isIOS) {
      eventChannel.receiveBroadcastStream().listen((event) {
        _onEvent(event);
      }, onError: _onError);
    }
    initDeepLinkPlatformState();
  }

  Future<void> initDeepLinkPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  Future<void> initPlatformStateForStringUniLinks() async {
    _deepLinkSub =
        linkStream.listen((String? link) {}, onError: (Object err) {});
  }

  //zalo_pay
  void _onEvent(Map<String, dynamic> event) {
    var res = Map<String, dynamic>.from(event);
    if (res["errorCode"] == 1) {
      Navigator.of(Storage.scaffoldKey.currentContext!).popUntil((route) {
        if (!Navigator.of(Storage.scaffoldKey.currentContext!).canPop()) {
          return true;
        }

        if (route.settings.name == AppRouter.ROOT) {
          return true;
        }
        return false;
      });

      AppDialog.showContentDialog(
          context: Storage.scaffoldKey.currentContext!,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/svg/404/graphic-paid.svg",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          LocalizationsUtil.of(
                                  Storage.scaffoldKey.currentContext!)
                              .translate(
                            "congratulation_you_have_paid_successfully",
                          ),
                          textAlign: TextAlign.center,
                          style: AppFonts.regular14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          closeShow: true,
          barrierDismissible: true);
    } else if (res["errorCode"] == 4) {
    } else {
      Navigator.of(Storage.scaffoldKey.currentContext!).popUntil((route) {
        if (!Navigator.of(Storage.scaffoldKey.currentContext!).canPop()) {
          return true;
        }

        if (route.settings.name == AppRouter.ROOT) {
          return true;
        }
        return false;
      });

      AppDialog.showContentDialog(
          context: Storage.scaffoldKey.currentContext!,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/svg/404/graphic-fail-payment.svg",
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          LocalizationsUtil.of(
                                  Storage.scaffoldKey.currentContext!)
                              .translate(
                            "payment_unsuccessful_please_try_again_later",
                          ),
                          maxLines: 2,
                          // textAlign: TextAlign.center,
                          style: AppFonts.regular14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          closeShow: true,
          barrierDismissible: true);
    }
  }

  void _onError(Object error) {
    print("_onError: '$error'.");
  }
  //zalo_pay end

  Future<void> initPlatformStateForUriUniLinks() async {
    _deepLinkSub = uriLinkStream.listen((Uri? uri) {
      var status = "";
      var statusOk = "";
      switch (uri?.host) {
        case 'momo':
          status = "errorCode";
          statusOk = "0";
          break;
        case 'payoo':
          status = "status";
          statusOk = "1";
          break;
        case 'zalo':
          status = "code";
          statusOk = "1";
          break;
      }
      if (uri == null) return;
      if (!uri.queryParameters.containsKey(status)) {
        return;
      }
      AppController().updateOrderPage();
      if (uri.queryParameters[status]! == statusOk) {
        showPaidSuccessfullyPopup(
          isShowButtonBackToRoot: true,
        );
      } else {
        final String text =
            LocalizationsUtil.of(Storage.scaffoldKey.currentContext!).translate(
                  "payment_unsuccessful_please_try_again_later",
                ) +
                "\nCode: ${uri.queryParameters[status]}";
        showFailurePayooPopup(
          content: text,
        );
      }

      (BlocRegistry.get("overlay_bloc") as OverlayBloc).add(BuildingPicked());
    }, onError: (Object err) {});
  }

  void redirect(String payload) {
    if (payload.isEmpty) return;
    if (Platform.isIOS) {
      Map<String, dynamic> jsonNotification = json.decode(payload);
      Map<String, dynamic> jsonNotificationData =
          json.decode(jsonNotification["aps"]["data"]);
      final List<KeyValueModel> optionsData =
          (jsonNotificationData["options_data"] as Map)
              .entries
              .map(
                (e) => KeyValueModel(
                  key: e.key,
                  value: e.value.toString(),
                ),
              )
              .toList();
      // if (jsonNotificationData["type"] == '')
      AppRouter.navigateToDetailFeed(
          context: Storage.scaffoldKey.currentContext!,
          feed: FeedMessageModel(
            id: jsonNotificationData["ID"],
            type: jsonNotificationData["type"],
            refID: jsonNotificationData["ref_id"],
            options: optionsData,
            title: "redirect push notification",
          ));
    } else if (Platform.isAndroid) {
      Map<String, dynamic> jsonNotificationData = json.decode(payload);

      final List<KeyValueModel> optionsData =
          (jsonNotificationData["options_data"] as Map)
              .entries
              .map(
                (e) => KeyValueModel(
                  key: e.key,
                  value: e.value.toString(),
                ),
              )
              .toList();

      AppRouter.navigateToDetailFeed(
          context: Storage.scaffoldKey.currentContext!,
          feed: FeedMessageModel(
            id: jsonNotificationData["ID"],
            type: jsonNotificationData["type"],
            refID: jsonNotificationData["ref_id"],
            options: optionsData,
            title: "redirect push notification",
          ));
    }
  }

  static void showPaidSuccessfullyPopup({
    bool isShowButtonBackToRoot = false,
    VoidCallback? callback,
  }) {
    AppDialog.showContentDialog(
      context: Storage.scaffoldKey.currentContext!,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: 30,
                top: isShowButtonBackToRoot == true ? 30.0 : 0.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/svg/404/graphic-paid.svg",
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      LocalizationsUtil.of(Storage.scaffoldKey.currentContext!)
                          .translate(
                        "congratulation_you_have_paid_successfully",
                      ),
                      textAlign: TextAlign.center,
                      style: AppFonts.regular14,
                    ),
                  ),
                  (isShowButtonBackToRoot)
                      ? Padding(
                          padding: const EdgeInsets.only(
                            top: 30,
                            left: 20,
                            right: 20,
                          ),
                          child: FlatButtonCustom(
                            buttonText: LocalizationsUtil.of(
                                    Storage.scaffoldKey.currentContext!)
                                .translate('back_to_payment_screen'),
                            onPressed: () {
                              if (callback != null) {
                                callback();
                              } else {
                                if (Storage.scaffoldKey.currentContext ==
                                    null) {
                                  return;
                                }
                                Navigator.of(
                                        Storage.scaffoldKey.currentContext!)
                                    .popUntil(
                                  (route) {
                                    print(
                                        '===> EventController showPaidSuccessfullyPopup: router name: ' +
                                            (route.settings.name ?? ''));
                                    if (route.settings.name == AppRouter.ROOT) {
                                      return true;
                                    }
                                    return false;
                                  },
                                );
                              }
                            },
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
      closeShow: !isShowButtonBackToRoot,
      barrierDismissible: !isShowButtonBackToRoot,
    );
  }

  static void showFailurePayooPopup({
    String? content,
    bool isShowButtonBackToRoot = false,
    VoidCallback? callback,
  }) {
    AppDialog.showContentDialog(
        context: Storage.scaffoldKey.currentContext!,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  bottom: 30,
                  top: isShowButtonBackToRoot == true ? 30.0 : 0.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/svg/404/graphic-fail-payment.svg",
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        content ??
                            LocalizationsUtil.of(
                                    Storage.scaffoldKey.currentContext!)
                                .translate(
                              "payment_unsuccessful_please_try_again_later",
                            ),
                        maxLines: 3,
                        style: AppFonts.regular14,
                      ),
                    ),
                    (isShowButtonBackToRoot)
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                              left: 20,
                              right: 20,
                            ),
                            child: FlatButtonCustom(
                              buttonText: LocalizationsUtil.of(
                                      Storage.scaffoldKey.currentContext!)
                                  .translate('back_to_payment_screen'),
                              onPressed: () {
                                if (callback != null) {
                                  callback();
                                } else {
                                  Navigator.of(
                                          Storage.scaffoldKey.currentContext!)
                                      .popUntil(
                                    (route) {
                                      print(
                                          '===> EventController showFailurePayooPopup: router name: ' +
                                              (route.settings.name ?? ''));
                                      if (route.settings.name ==
                                          AppRouter.ROOT) {
                                        return true;
                                      }
                                      return false;
                                    },
                                  );
                                  // Navigator.of(
                                  //         Storage.scaffoldKey.currentContext!)
                                  //     .popUntil((route) {
                                  //   if (Navigator.of(Storage
                                  //               .scaffoldKey.currentContext!)
                                  //           .canPop() ==
                                  //       false) {
                                  //     return true;
                                  //   }

                                  //   return (route.settings.name ==
                                  //       AppRouter.ROOT);
                                  // });
                                }
                              },
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
        closeShow: !isShowButtonBackToRoot,
        barrierDismissible: !isShowButtonBackToRoot);
  }
}
