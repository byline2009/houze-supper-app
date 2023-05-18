import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_appbar.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/facility_history_overview.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

const String facilityDetailKey = 'facilityDetailKey';

class FacilityDetailScreenArgument {
  final String faciliyID;
  final String? charge;

  FacilityDetailScreenArgument({
    required this.faciliyID,
    this.charge,
  });
}

class FacilityDetailScreen extends StatefulWidget {
  final FacilityDetailScreenArgument params;
  const FacilityDetailScreen({required this.params});

  @override
  _FacilityDetailScreenState createState() => new _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends RouteAwareState<FacilityDetailScreen>
    with AutomaticKeepAliveClientMixin {
  late String _id;
  final facilityBloc = FacilityBloc();
  String? _charge;
  var appTitle = "";
  FacilityDetailModel? _facilityDetail;

  @override
  void initState() {
    super.initState();
    //Firebase Analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewBuildingFacility(userID: Storage.getUserID() ?? "");
    _id = widget.params.faciliyID;
    if (widget.params.charge != null) _charge = widget.params.charge;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _screenSize = MediaQuery.of(context).size;
    Container? contentElement;
    Widget? introElement;

    return BlocProvider<FacilityBloc>(
      create: (_) => facilityBloc,
      child: BlocBuilder<FacilityBloc, FacilityState>(builder: (ctx, state) {
        if (state is FacilityInitial) {
          facilityBloc.add(FacilityGetDetailEvent(id: _id));
          introElement = CupertinoActivityIndicator();
          contentElement = Container(
              padding: EdgeInsets.all(20),
              child: ListSkeleton(
                shrinkWrap: true,
                length: 3,
                config: SkeletonConfig(
                  theme: SkeletonTheme.Light,
                  isShowAvatar: false,
                  isCircleAvatar: false,
                  bottomLinesCount: 3,
                ),
              ));
        }

        if (state is FacilityFailureState) {
          if (state.error.error is NoDataException)
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SomethingWentWrong(true),
            );
          else
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: SomethingWentWrong(),
            );
        }

        if (state is GetFacilityDetailSuccess) {
          _facilityDetail = state.result;
          appTitle = _facilityDetail!.title!;
          introElement = _facilityDetail?.images != null &&
                  _facilityDetail!.images!.length > 0
              ? CachedImageWidget(
                  cacheKey: facilityDetailKey,
                  imgUrl: _facilityDetail!.images!.first.image!,
                )
              : Container(
                  color: Colors.grey,
                  child: Center(child: Icon(Icons.satellite, size: 20.0)),
                );

          contentElement = Container(
              color: Colors.white,
              child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    WidgetFacilityTitle(
                      model: _facilityDetail!,
                      charge: _charge ?? '',
                      parentContext: context,
                    ),
                    FacilityHistoriesScreen(
                        parentContext: context,
                        id: _id,
                        facilityDetail: _facilityDetail)
                  ]));
        }

        return Column(children: <Widget>[
          Expanded(
            child: FadingStretchy(
              headerHeight: _screenSize.height * 30 / 100,
              blurContent: false,
              header: introElement ?? Container(),
              backgroundColor: Colors.white,
              appbarHandler: (double opacity) {
                return FadingAppbar(
                  backgroundColor: Colors.white.withOpacity(opacity),
                  leading: opacity < 0.5
                      ? WidgetButton.backCircleButton(context)
                      : IconButton(
                          icon:
                              Icon(Icons.arrow_back_ios, color: AppColor.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                  title: AnimatedOpacity(
                      opacity: opacity,
                      duration: duration,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          appTitle,
                          softWrap: false,
                          style: AppFont.BOLD_BLACK_22,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                );
              },
              headerActions: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      color: Colors.white,
                      child: IconButton(
                        color: Colors.white,
                        icon: SvgPicture.asset(AppVectors.ic_info),
                        onPressed: () {
                          //Firebase Analytics
                          GetIt.instance<FBAnalytics>()
                              .sendEventViewHistoryRegistryList(
                                  userID: Storage.getUserID() ?? "");
                          AppRouter.pushDialog(
                              context,
                              AppRouter.FACILITY_DETAIL_INFORMATION,
                              _facilityDetail);
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                    ))
              ],
              headerActionsSize: 20,
              body: contentElement ?? Container(),
            ),
          ),
          _buildRegisterButton(context)
        ]);
      }),
    );
  }

  _buildRegisterButton(BuildContext context) => Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
      child: ButtonWidget(
          defaultHintText: LocalizationsUtil.of(context).translate('register'),
          isActive: true,
          callback: () {
            AppRouter.pushDialog(
              context,
              AppRouter.FACILITY_REGISTER_PAGE,
              FacilityRegisterScreenArgument(
                facilityId: widget.params.faciliyID,
                title: appTitle,
                callback: (data) {
                  //Allow refresh
                  setState(
                    () {
                      _facilityDetail = null;
                    },
                  );
                },
              ),
            );
          }),
      width: double.infinity);

  @override
  bool get wantKeepAlive => true;
}
