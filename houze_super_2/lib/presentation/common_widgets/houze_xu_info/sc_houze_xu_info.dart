import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_limit_model.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'networking/repository/point_limit_repo.dart';
import 'widgets/widget_how_to_get_points.dart';
import 'widgets/widget_points_limit.dart';

//---SCREEN: Thông tin Houze Xu---//

const int TAB_HOW_TO_GET_POINT = 0;
const int TAB_POINTS_LIMIT = 1;

class HouzeXuInfoPageArgument {
  final Function callback;
  final bool disabledChangeBuilding;
  const HouzeXuInfoPageArgument(
      {required this.callback, this.disabledChangeBuilding = false});
}

class HouzeXuInfoPage extends StatefulWidget {
  final HouzeXuInfoPageArgument? arg;

  HouzeXuInfoPage({Key? key, this.arg}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HouzeXuInfoPageState();
}

class _HouzeXuInfoPageState extends State<HouzeXuInfoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _didChangeBuilding = false;
  List<PointLimitModel> pointLimit = <PointLimitModel>[];

  Future getPointLimit() async {
    var pointLimitRepo = PointLimitRepository();
    var result = await pointLimitRepo.getXuEarnInfo();

    setState(() {
      pointLimit = result;
    });
  }

  @override
  void initState() {
    super.initState();
    getPointLimit();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.arg?.callback != null && this._didChangeBuilding) {
          widget.arg!.callback();
        }
        Navigator.of(context).pop();
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                if (widget.arg?.callback != null && this._didChangeBuilding) {
                  widget.arg!.callback();
                }
                Navigator.of(context).pop();
              }),
          centerTitle: true,
          title: Text(
            LocalizationsUtil.of(context).translate('information') +
                ' Houze Xu',
            // style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
            style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          bottom: TabBar(
            unselectedLabelColor: Color(0xff838383),
            // unselectedLabelStyle: AppFonts.regular15.copyWith(
            //   color: Color(0xff838383),
            // ),
            unselectedLabelStyle:
                AppFonts.regular15.copyWith(color: Color(0xff838383)),
            labelColor: Color(0xff6001d2),
            // labelStyle: AppFonts.bold15.copyWith(color: Color(0xff6001d2)),
            labelStyle: AppFont.BOLD_PURPLE_6001d2_15,
            tabs: [
              Tab(
                child: Text(
                  LocalizationsUtil.of(context).translate("how_to_get_points"),
                ),
              ),
              Tab(
                child: Text(
                  LocalizationsUtil.of(context).translate("points_limit"),
                ),
              )
            ],
            indicatorColor: Color(0xff6001d2),
            indicatorSize: TabBarIndicatorSize.tab,
            controller: _tabController,
          ),
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            WidgetHowToGetPoint(
                didChangeBuildingCallback: (value) {
                  if (value) {
                    this._didChangeBuilding = true;
                  }
                },
                disabledChangeBuilding: widget.arg!.disabledChangeBuilding),
            WidgetPointsLimit(pointLimit: pointLimit),
          ],
          controller: _tabController,
        ),
      ),
    );
  }
}
