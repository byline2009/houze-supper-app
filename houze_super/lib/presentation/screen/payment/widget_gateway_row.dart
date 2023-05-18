import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/common/blocs/app_event_bloc.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';

import 'package:houze_super/presentation/common_widgets/stateless/widget_text.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
import 'package:houze_super/utils/constants/share_keys.dart';

typedef void CallBackHandler(
  int id,
);

class RadioSubmitEvent {
  int value;

  RadioSubmitEvent(int value) {
    this.value = value;
  }
}

class WidgetGatewayRow extends StatefulWidget {
  final int id;
  final int gatewaySelected;
  final PaymentGatewayModel model;
  final CallBackHandler callback;
  final StreamController<RadioSubmitEvent> controller;
  final ProgressHUD progressToolkit;

  const WidgetGatewayRow({
    Key key,
    this.id,
    this.gatewaySelected,
    this.model,
    this.callback,
    this.controller,
    @required this.progressToolkit,
  }) : super(key: key);

  @override
  WidgetGatewayRowState createState() => new WidgetGatewayRowState();
}

class WidgetGatewayRowState extends State<WidgetGatewayRow> {
  StreamSubscription<BlocEvent> _subPayMEChangeState;

  @override
  void initState() {
    super.initState();
    if (widget.model.gatewayName == ShareKeys.kPayME) {
      _subPayMEChangeState = AppEventBloc().listenEvent(
        eventName: EventName.payMEUpdateBalance,
        handler: _handleStatePayME,
      );
    }
  }

  void _handleStatePayME(BlocEvent evt) {
    final value = evt.value;

    if (mounted && value is String && !StringUtil.isEmpty(value)) {
      context.read<ProfileBloc>().add(ProfileLoadEvent());
      print("[PayME][_handleStatePayME] WidgetGatewayRow stateAccount: $value");
    }
  }

  void onTap() {
    if (widget.model.gatewayIcon == null) {
      return;
    }

    if (widget.callback != null) {
      widget.callback(
        widget.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      title: Row(
        children: [
          SizedBox(
            width: 22,
            child: widget.model.gatewayIcon != null
                ? StreamBuilder(
                    stream: widget.controller.stream,
                    initialData: RadioSubmitEvent(widget.gatewaySelected),
                    builder: (BuildContext context,
                        AsyncSnapshot<RadioSubmitEvent> snapshot) {
                      return Radio(
                        value: widget.id,
                        activeColor: Color(0xff6001d2),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        //groupValue: item.key,
                        groupValue: int.parse(snapshot.data.value.toString()),
                        hoverColor: Color(0xff6001d2),
                        focusColor: Color(0xff6001d2),
                        onChanged: (dynamic value) {
                          onTap();
                        },
                      );
                    })
                : const SizedBox(width: 20),
          ),
          const SizedBox(width: 15),
          !StringUtil.isEmpty(widget.model.gatewayIcon)
              ? Image.asset(
                  "assets/images/payment/ic-pay-${widget.model.gatewayIcon}.jpg",
                  width: 40,
                  height: 40)
              : SvgPicture.asset(
                  "assets/images/payment/ic-pay-real.svg",
                  width: 40,
                  height: 40,
                ),
          const SizedBox(width: 18),
          widget.model.gatewayName == ShareKeys.kPayME
              ? Builder(builder: (
                  context,
                ) {
                  return _buildPayMEWidget();
                })
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          LocalizationsUtil.of(context)
                              .translate(widget.model.gatewayTitle),
                          style: AppFonts.medium14
                              .copyWith(color: Colors.black)
                              .copyWith(
                                  fontFamily: AppFonts.font_family_display)),
                      SizedBox(height: 4),
                      TextWidget(
                        LocalizationsUtil.of(context)
                            .translate(widget.model.gatewayDesc),
                        maxLines: 2,
                        style: AppFonts.regular13.copyWith(
                          color: Color(0xff838383),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _buildPayMEWidget() {
    return const SizedBox.shrink();
    // return BlocProvider(
    //   create: (context) => ProfileBloc(
    //     profileRepo: ProfileRepository(),
    //   ),
    //   child: BlocBuilder<ProfileBloc, ProfileState>(
    //     builder: (contex, state) {
    //       if (state.isInitial) {
    //         contex.read<ProfileBloc>().add(ProfileLoadEvent());
    //       }

    //       if (state.hasError) {
    //         return Center(
    //           child: Text(
    //             state.error.toString(),
    //             style: AppFonts.semibold13.copyWith(
    //               color: Colors.white,
    //             ),
    //           ),
    //         );
    //       }

    //       if (state.hasData) {
    //         final ProfileModel result = state.profile;
    //         return FutureBuilder<String>(
    //           future: PayMERepository().init(
    //             token: result.paymeToken,
    //           ),
    //           builder: (context, snapshot) {
    //             if (snapshot.hasError) {
    //               return Center(
    //                 child: Text(
    //                   LocalizationsUtil.of(context).translate(
    //                       "there_is_an_issue_please_try_again_later_0"),
    //                   style: AppFonts.medium12.copyWith(
    //                     color: Colors.white,
    //                   ),
    //                 ),
    //               );
    //             }

    //             if (snapshot.connectionState == ConnectionState.done) {
    //               print('PayMEInitializer: state ${snapshot.data}');
    //               switch (snapshot.data) {
    //                 case ShareKeys.kAccountNotActivated:
    //                 case ShareKeys.kNotActivated:
    //                   return GatewayHouzePayment(
    //                     gatewayTitle: widget.model.gatewayTitle,
    //                   );
    //                   break;

    //                 case ShareKeys.kKycApproved:
    //                   return BlocProvider<PayMEGetWalletBloc>(
    //                     create: (BuildContext context) =>
    //                         PayMEGetWalletBloc(repo: PayMERepository()),
    //                     child: GatewayPayMeKYC(
    //                       model: widget.model,
    //                     ),
    //                   );

    //                   break;

    //                 default:
    //                   return const SizedBox.shrink();
    //               }
    //             }
    //             return Center(
    //               child: CupertinoActivityIndicator(),
    //             );
    //           },
    //         );
    //       }
    //       if (state.isLoading)
    //         return Center(
    //           child: CupertinoActivityIndicator(),
    //         );

    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );
  }

  @override
  void dispose() {
    if (_subPayMEChangeState != null) _subPayMEChangeState.cancel();
    super.dispose();
  }
}
