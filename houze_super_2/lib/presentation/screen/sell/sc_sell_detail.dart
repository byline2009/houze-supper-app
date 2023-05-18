import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/repo/agent_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/widget_progress_indicator.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

class SellDetailPage extends StatefulWidget {
  final SellModel item;

  const SellDetailPage({required this.item});

  @override
  _SellDetailPageState createState() => _SellDetailPageState();
}

class _SellDetailPageState extends RouteAwareState<SellDetailPage> {
  final _agentBloc = AgentBloc();

  final _isProgressingSubject = StreamController<bool>.broadcast();

  Stream<bool> get isProgressing => _isProgressingSubject.stream;

  Future<void> _hidePost(BuildContext context) async {
    final _repo = AgentRepository();

    _isProgressingSubject.add(true);

    try {
      await _repo.hideAgentResell(id: widget.item.id!);
      DialogCustom.showSuccessDialog(
        buttonText: "ok",
        context: context,
        title: 'the_post_was_hidden',
        content: 'thank_you_for_trusting_houze_agent',
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();

          _agentBloc.add(AgentResellLoadDetail(id: widget.item.id!));
        },
      );
    } on DioError catch (err) {
      if (<DioErrorType>[
        DioErrorType.other,
        DioErrorType.connectTimeout,
        DioErrorType.receiveTimeout,
      ].contains(err.type))
        DialogCustom.showErrorDialog(
          buttonText: "ok",
          context: context,
          title: 'there_is_no_network',
          errMsg: 'please_check_your_network_and_try_connect_again',
        );
      else
        DialogCustom.showErrorDialog(
          buttonText: "ok",
          context: context,
          title: 'there_is_an_issue_please_try_again_later_1',
          errMsg: err.toString(),
        );
    } finally {
      _isProgressingSubject.add(false);
    }
  }

  @override
  void dispose() {
    _isProgressingSubject.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: LocalizationsUtil.of(context)
          .translate(widget.item.type == 0 ? 'sell_property' : 'for_lease'),
      actions: widget.item.statusPosted == 0
          ? <IconButton>[
              IconButton(
                icon: Icon(
                  Icons.tune,
                  color: Colors.black,
                ),
                onPressed: () => showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width, 100, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: TextButton(
                          child: Text(
                            LocalizationsUtil.of(context)
                                .translate('update_information'),
                            style: AppFonts.medium16,
                          ),
                          onPressed: () {
                            AppRouter.push(
                                context, AppRouter.SELL_UPDATE, widget.item.id);

                            _agentBloc.add(
                                AgentResellLoadDetail(id: widget.item.id!));
                          }),
                    ),
                    PopupMenuItem(
                      child: TextButton(
                        child: Text(
                          LocalizationsUtil.of(context)
                              .translate('offline_your_property'),
                          style: AppFonts.medium16
                              .copyWith(color: Color(0xFFec1c23)),
                        ),
                        onPressed: () {
                          DialogCustom.showAlertDialog(
                            context: context,
                            buttonText: 'hide_the_post',
                            title: 'confirm_to_hide_the_post',
                            content:
                                'when_the_post_is_hidden_houze_agent_will_not_contact_this_post_any_more',
                            onPressed: () {
                              Navigator.of(context).pop();
                              _hidePost(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ]
          : null,
      child: BlocProvider<AgentBloc>(
          create: (_) => _agentBloc,
          child: BlocBuilder<AgentBloc, AgentState>(
              builder: (_, AgentState state) {
            if (state is AgentInitial)
              _agentBloc.add(AgentResellLoadDetail(id: widget.item.id!));

            if (state is AgentResellDetailSuccessful) {
              return Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(children: [
                    WidgetSectionTitle(title: 'information'),
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: ShapeDecoration(
                                  shape: StadiumBorder(),
                                  color: state.sell.statusPosted == 0
                                      ? Color(0xFF38d6ac)
                                      : Color(0xFFd0d0d0),
                                ),
                                child: Text(
                                    state.sell.statusPosted == 0
                                        ? LocalizationsUtil.of(context)
                                            .translate('online')
                                        : LocalizationsUtil.of(context)
                                            .translate('offline'),
                                    maxLines: 1,
                                    style: AppFont.REGULAR_WHITE_14)),
                            SizedBox(height: 20.0),
                            //user
                            SectionAgentInfo(sell: state.sell),

                            SizedBox(height: 20.0),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              width: double.infinity,
                              child: Text(
                                state.sell.requirement!,
                                style: AppFonts.regular14,
                                textAlign: TextAlign.justify,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xfff5f7f8),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                            SizedBox(height: 20.0),
                            ImageAuthenticatedList(images: state.sell.images!),
                            SizedBox(height: 32.0),
                            Text(
                              LocalizationsUtil.of(context)
                                  .translate('documents'),
                              style: AppFonts.bold16,
                            ),
                            SizedBox(height: 16.0),
                            //auth
                            ImageAuthenticatedList(
                                images: state.sell.imagesAuthenticated!),
                          ]),
                    ),
                    SizedBox(height: 20.0)
                  ])),
                  ProgressIndicatorWidget(isProgressing),
                ],
              );
            }

            if (state is AgentResellDetailFailure) {
              if (state.error.error is NoDataException)
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            if (state is AgentResellLoading) {
              return Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 140),
                  child: CardListSkeleton(
                    shrinkWrap: true,
                    length: 2,
                    config: SkeletonConfig(
                      theme: SkeletonTheme.Light,
                      isShowAvatar: false,
                      isCircleAvatar: false,
                      bottomLinesCount: 2,
                      radius: 0.0,
                    ),
                  ));
            }
            return SizedBox.shrink();
          })),
    );
  }
}

class SectionAgentInfo extends StatelessWidget {
  final SellModel sell;
  const SectionAgentInfo({required this.sell});

  @override
  Widget build(BuildContext context) {
    final List<KeyValueModel> fields = <KeyValueModel>[
      KeyValueModel(
        key: LocalizationsUtil.of(context).translate('apartment_with_colon'),
        value: '${sell.blockName} - ${sell.apartmentName}',
      ),
      KeyValueModel(
        key: LocalizationsUtil.of(context).translate(sell.type == 0
            ? 'desired_selling_price_with_colon'
            : 'the_proposed_leasing_price_with_colon'),
        value: '${StringUtil.numberFormat(sell.sellPrice)} VND' +
            (sell.type == 0
                ? ''
                : '/' + LocalizationsUtil.of(context).translate('month')),
      ),
      KeyValueModel(
        key:
            LocalizationsUtil.of(context).translate('brokerage_fee_with_colon'),
        value: '${sell.percentCommission} %',
      ),
    ];
    return Column(children: [
      for (KeyValueModel e in fields)
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Text(
                e.key,
                style: AppFonts.regular14.copyWith(
                      color: Color(
                        0xff808080,
                      ),
                    ),
              )),
              Expanded(
                child: Text(
                  e.value,
                  style: AppFonts.regular14,
                  maxLines: 2,
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        )
    ]);
  }
}

class ImageAuthenticatedList extends StatelessWidget {
  final List<ImageModel> images;
  const ImageAuthenticatedList({required this.images});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: images.length == 0 ? 0 : 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: images.length,
        itemBuilder: (BuildContext context, int index) {
          ImageModel item = images[index];
          debugPrint("URL: ${item.imageThumb}");
          return Padding(
            key: Key(item.id!),
            padding: const EdgeInsets.only(right: 10, top: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: <Widget>[
                  GestureDetector(
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          ParkingCardSkeleton(width: 100, height: 100),
                      imageUrl: item.imageThumb!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      List<String> _imgs = [];
                      images.forEach((element) => _imgs.add(element.image!));

                      AppRouter.pushDialog(context, AppRouter.imageViewPage,
                          ImageViewPageArgument(images: _imgs));
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
