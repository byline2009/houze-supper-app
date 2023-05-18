import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/flutter_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_boxes_container.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_text_base.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_appbar.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/facility_history_overview.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/history/sc_facility_history.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/widget_facility_title.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

const String facilityDetailKey = 'facilityDetailKey';

class FacilityDetailScreenArgument {
  final String faciliyID;
  final String charge;

  FacilityDetailScreenArgument({
    @required this.faciliyID,
    this.charge,
  });
}

class FacilityDetailScreen extends StatefulWidget {
  final FacilityDetailScreenArgument params;
  const FacilityDetailScreen({@required this.params});

  @override
  _FacilityDetailScreenState createState() => new _FacilityDetailScreenState();
}

class _FacilityDetailScreenState extends State<FacilityDetailScreen>
    with AutomaticKeepAliveClientMixin {
  String _id;
  final cubit = FacilityBloc();
  String _charge;
  var appTitle = "";
  FacilityDetailModel _facilityDetail;

  @override
  void initState() {
    super.initState();

    _id = widget.params.faciliyID;
    if (widget.params.charge != null) _charge = widget.params.charge;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _screenSize = MediaQuery.of(context).size;
    Container contentElement;
    Widget introElement;

    return BlocProvider<FacilityBloc>(
      create: (_) => cubit,
      child: BlocBuilder<FacilityBloc, FacilityState>(builder: (ctx, state) {
        if (_facilityDetail == null && state is FacilityInitial) {
          cubit.add(FacilityGetDetailEvent(id: _id));
          introElement = CupertinoActivityIndicator();
          contentElement = Container(
              padding: const EdgeInsets.all(20),
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
          appTitle = _facilityDetail.title;
          introElement = _facilityDetail.images.length > 0 &&
                  _facilityDetail.images != null
              ? CachedImageWidget(
                  cacheKey: facilityDetailKey,
                  imgUrl: _facilityDetail.images.first.image,
                )
              : Container(
                  color: Colors.grey,
                  child: Center(child: Icon(Icons.satellite, size: 20.0)),
                );

          contentElement = Container(
              color: Colors.white,
              child: ListView(
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    WidgetFacilityTitle(
                      model: _facilityDetail,
                      charge: _charge ?? '',
                      parentContext: context,
                    ),
                    WidgetBoxesContainer(
                      title: LocalizationsUtil.of(context)
                          .translate('recently_bookings'),
                      hasLine: false,
                      padding: const EdgeInsets.all(20),
                      styleTitle: AppFonts.bold.copyWith(fontSize: 16),
                      action: WidgetTextBase.textTopRight(
                          LocalizationsUtil.of(context).translate('see_all'),
                          () {
                        AppRouter.pushDialog(
                            context,
                            AppRouter.FACILITY_HISTORY_PAGE,
                            FacilityHistoryScreenArgument(
                                facility: _facilityDetail));
                      }),
                      child: const SizedBox.shrink(),
                    ),
                    FacilityHistoriesScreen(parentContext: context, id: _id)
                  ]));
        }

        return Column(children: <Widget>[
          Expanded(
            child: FadingStretchy(
              headerHeight: _screenSize.height * 30 / 100,
              blurContent: false,
              header: introElement,
              backgroundColor: Colors.white,
              appbarHandler: (double opacity) {
                return FadingAppbar(
                  backgroundColor: Colors.white.withOpacity(opacity),
                  leading: opacity < 0.5
                      ? WidgetButton.backCircleButton(context)
                      : IconButton(
                          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                  title: AnimatedOpacity(
                      opacity: opacity,
                      duration: duration,
                      child: Text(
                        appTitle,
                        style: AppFonts.bold22,
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
              body: contentElement,
            ),
          ),
          _buildRegisterButton(context)
        ]);
      }),
    );
  }

  _buildRegisterButton(BuildContext context) => Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
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
