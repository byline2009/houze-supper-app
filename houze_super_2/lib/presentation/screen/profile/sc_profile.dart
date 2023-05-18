import 'dart:async';
import 'dart:io';
import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_tween_animation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:houze_super/presentation/screen/profile/index.dart';
import 'package:houze_super/presentation/screen/profile/sc_building_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/firebase_analytic/firebase_analytics.dart';
import 'bloc/profile_event.dart';
import 'bloc/profile_state.dart';
import 'widgets/avatar_widget.dart';
import 'widgets/gradient_scaffold.dart';

typedef void CallBackPressedItem();

const String profileKey = 'profileKey';
const String defaultHouzeLogoUrl = 'assets/images/logo-default.png';
const String defaultMainTitle = 'houze_app_icon';
const String defaultSubtitle = 'Bấm để đổi sang biểu tượng này';
const String currentSelectedAppIconKey = 'currentSelectedAppIcon';
const List<String> listAvailableIcon = [
  "nozomi",
  "moonlight",
  "ipsc",
  "vanphuc",
  "hadopm",
  "default",
  "MainActivity"
];

class ItemProfile {
  final String icon;
  final String title;
  final String subtitle;
  final CallBackPressedItem callback;

  const ItemProfile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.callback,
  });
}

class FilterActionType {
  String key;
  String mainTitle;
  String subTitle;
  String img;
  bool isSelected;
  FilterActionType({
    required this.key,
    required this.mainTitle,
    required this.subTitle,
    required this.img,
    required this.isSelected,
  });
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends RouteAwareState<ProfileScreen> {
  final _profileBloc = ProfileBloc();
  SharedPreferences? preferences;
  late String? currentSelectedAppIcon;
  Future? listBuilding;
  @override
  void initState() {
    super.initState();
    initializePreference().whenComplete(() {
      if (mounted) setState(() {});
    });
    listBuilding = _getBuildingList();
  }

  Future<void> initializePreference() async {
    this.preferences = await SharedPreferences.getInstance();
  }

  Future<List<BuildingMessageModel>> _getBuildingList() async {
    return await Sqflite.getBuildingList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => _profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (_, ProfileState state) {
          if (state is ProfileInitial) _profileBloc.add(ProfileLoad());

          if (state is ProfileLoadFailure)
            return GradientScaffold(
                title: 'profile',
                subtitle: Storage.getUserName().toString(),
                body: SomethingWentWrong());

          if (state is ProfileLoadSuccessful) {
            final ProfileModel profile = state.profile;
            currentSelectedAppIcon =
                this.preferences?.getString(currentSelectedAppIconKey);
            print("===================> Current icon: " +
                currentSelectedAppIcon.toString());
            return GradientScaffold(
              title: 'profile',
              subtitle: profile.fullname ?? "",
              body: FutureBuilder(
                  future: listBuilding,
                  builder: (ctx, snap) {
                    if (!snap.hasData) {
                      return CircularProgressIndicator();
                    }
                    List<BuildingMessageModel> _list = [];
                    if (snap.hasData) {
                      _list = snap.data as List<BuildingMessageModel>;
                    }
                    return TweenAnimationWidget(
                      duration: Duration(milliseconds: 500),
                      widget: Container(
                        height: double.infinity,
                        child: GridViewProfileItem(
                          profile: profile,
                          currentSelectedAppIcon:
                              currentSelectedAppIcon ?? null,
                          listBuilding: _list,
                        ),
                        color: Colors.transparent,
                      ),
                    );
                  }),
            );
          }
          return GradientScaffold(
            title: 'profile',
            subtitle: '',
            body: Container(
              alignment: Alignment.center,
              child: CupertinoActivityIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class GridViewProfileItem extends StatefulWidget {
  final ProfileModel profile;
  final String? currentSelectedAppIcon;
  final List<BuildingMessageModel> listBuilding;
  const GridViewProfileItem(
      {required this.profile,
      this.currentSelectedAppIcon,
      required this.listBuilding});
  @override
  _GridViewProfileItemState createState() => _GridViewProfileItemState();
}

class _GridViewProfileItemState extends State<GridViewProfileItem> {
  late int currentIndexActivity;
  bool isDisableAppIconChaging = false;
  String _title = "";
  //set default logo
  List<FilterActionType> _listActionType = [
    FilterActionType(
        key: 'default',
        mainTitle: defaultMainTitle,
        subTitle: defaultSubtitle,
        img: defaultHouzeLogoUrl,
        isSelected: false),
  ];

  @override
  void initState() {
    super.initState();

    _filterListLogo();

    final prefs = Storage.prefs;
    List<String> list = [];
    for (int i = 0; i < _listActionType.length; i++) {
      list.add(_listActionType[i].key);
    }

    if (widget.currentSelectedAppIcon != null) {
      if (list.contains(widget.currentSelectedAppIcon) == false) {
        // if current selected logo is removed, set logo back to default
        prefs?.setString(currentSelectedAppIconKey, "default");
        int index = _listActionType
            .indexWhere((element) => element.key.contains("default"));
        _listActionType.forEach((element) => element.isSelected = false);
        currentIndexActivity = index;
        _listActionType[currentIndexActivity].isSelected = true;

        if (Platform.isAndroid) {
          DynamicIconFlutter.setIcon(
              icon: "default", listAvailableIcon: listAvailableIcon);
        } else {
          DynamicIconFlutter.setAlternateIconName(null);
        }
      } else {
        String str = widget.currentSelectedAppIcon ?? 'default';
        int index =
            _listActionType.indexWhere((element) => element.key.contains(str));
        //set current select
        currentIndexActivity = index;
        _listActionType[index].isSelected = true;
      }
    } else {
      //default select
      currentIndexActivity = _listActionType.length - 1;
      _listActionType[currentIndexActivity].isSelected = true;
      //reset default icon after logging out
      _resetDefaultIcon();
    }
  }

  void _resetDefaultIcon() {
    print("_resetDefaultIcon");
    if (widget.currentSelectedAppIcon == "default") {
      return;
    }
    final prefs = Storage.prefs;
    if (prefs?.getBool(is_logout) == true &&
        prefs?.getBool(is_logout) != null) {
      prefs?.setString(currentSelectedAppIconKey, "default");
      currentIndexActivity = _listActionType.length - 1;
      if (Platform.isAndroid) {
        DynamicIconFlutter.setIcon(
            icon: "default", listAvailableIcon: listAvailableIcon);
      } else {
        DynamicIconFlutter.setAlternateIconName(null);
      }
      prefs?.setBool(is_logout, false);
    }
  }

  void _filterListLogo() {
    List<BuildingMessageModel> _listBuildingModel = widget.listBuilding;

    //remove duplicate company's logo
    Map<String, BuildingMessageModel> _filterLogoCompany = {};
    for (var item in _listBuildingModel) {
      _filterLogoCompany[item.company?.logo ?? ""] = item;
    }
    var _filteredListCompany = _filterLogoCompany.values.toList();

    //remove duplicate building's logo
    Map<String, BuildingMessageModel> _filterLogoBuilding = {};
    for (var item in _listBuildingModel) {
      _filterLogoBuilding[item.logo ?? ""] = item;
    }
    var _filteredListBuilding = _filterLogoBuilding.values.toList();

    //merge
    var _list =
        [..._filteredListCompany, ..._filteredListBuilding].toSet().toList();

    for (var i = 0; i < _list.length; i++) {
      //list building logo
      if (_list[i].logo != null) {
        if (listAvailableIcon.contains(_list[i].logo) == true) {
          _listActionType.insert(
              _listActionType.length - 1,
              FilterActionType(
                  key: _list[i].logo!,
                  mainTitle: _list[i].name!,
                  subTitle: defaultSubtitle,
                  img: _list[i].logo!,
                  isSelected: false));
        }
      }
      if (_list[i].company?.logo != null) {
        if (listAvailableIcon.contains(_list[i].company!.logo) == true) {
          _listActionType.insert(
              _listActionType.length - 1,
              FilterActionType(
                  key: _list[i].company!.logo!,
                  mainTitle: _list[i].company?.name ?? '',
                  subTitle: defaultSubtitle,
                  img: _list[i].company!.logo!,
                  isSelected: false));
        }
      }
    }

    //remove duplicate logo
    Map<String, FilterActionType> _filterLogo = {};
    for (var item in _listActionType) {
      _filterLogo[item.key] = item;
    }
    _listActionType = _filterLogo.values.toList();
    for (var i = 0; i < _listActionType.length; i++) {
      print("Logo: " + _listActionType[i].key);
    }

    //disable changing app icon if needed
    _disableChangingAppIcon();
  }

  _disableChangingAppIcon() {
    final prefs = Storage.prefs;
    if (_listActionType.length == 1) {
      isDisableAppIconChaging = true;
      currentIndexActivity = _listActionType.length - 1;
      prefs?.setString(currentSelectedAppIconKey, "default");
    }
  }

  _onCallBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _list = <ItemProfile>[
      ItemProfile(
          icon: AppVectors.houzePoint,
          title: 'personal_information',
          subtitle: 'change_your_avatar_verify_information',
          callback: () {
            AppRouter.pushNoParams(
              context,
              AppRouter.PROFILE,
              maintainState: false,
            );
          }),
      ItemProfile(
          icon: AppVectors.houzePoint,
          title: 'houze_point',
          subtitle: 'receive_houze_point_exchange_a_gift',
          callback: () {
            AppRouter.pushNoParamsWithCallback(
                context, AppRouter.HOUSE_XU_PAGE, _onCallBack);
          }),
      ItemProfile(
          icon: AppVectors.home,
          title: 'building_info',
          subtitle: 'your_building_location',
          callback: () {
            AppRouter.pushParamsWithCallback(
                context,
                AppRouter.BUILDING_INFO_PAGE,
                InfoArguments(title: this._title),
                _onCallBack);
          }),
      ItemProfile(
          icon: AppVectors.shield,
          title: 'password_and_security',
          subtitle: 'change_your_password_enhance_security',
          callback: () {
            AppRouter.pushNoParams(
              context, //AppRouter.DAILY_STEP_COUNT
              AppRouter.CHANGE_PASSWORD,
            );
          }),
      ItemProfile(
          icon: AppVectors.facility,
          title: 'history_facility',
          subtitle: 'facility_and_service_booking_information',
          callback: () {
            AppRouter.pushNoParamsWithCallback(
                context, AppRouter.UTILITY_HISTORY, _onCallBack);
          }),
      ItemProfile(
        icon: AppVectors.phone,
        title: 'customer_support',
        subtitle: 'contact_houze_to_support_your_troubleshooting',
        callback: _launchHouzeBuildingWeb,
      ),
    ];
    var _spacingBetween = 15.0;
    var _paddingVertical = 42.0;
    var _itemWidth = MediaQuery.of(context).size.width * 0.5 -
        MediaQuery.of(context).size.width * 0.065;
    var _itemHeight = _itemWidth * 0.75;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 42),
      child: Column(
        children: [
          Wrap(
            spacing: _spacingBetween,
            runSpacing: _paddingVertical,
            children: _list
                .map(
                  (item) => Container(
                    key: Key(item.title),
                    width: _itemWidth,
                    height: _itemHeight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        primary: Colors.transparent,
                        elevation: 0,
                        tapTargetSize: MaterialTapTargetSize.padded,
                        padding: EdgeInsets.all(0),
                      ),
                      onPressed: item.callback,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: _itemWidth,
                            constraints: BoxConstraints(minHeight: _itemHeight),
                            padding: const EdgeInsets.fromLTRB(
                                10.0, 38.0, 10.0, 4.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              border: Border.all(style: BorderStyle.none),
                              boxShadow: <BoxShadow>[
                                const BoxShadow(
                                  offset: Offset(0, 2.0),
                                  blurRadius: 10.0,
                                  color: Color.fromRGBO(0, 0, 0, 0.1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (item.icon != AppVectors.home)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Text(
                                      LocalizationsUtil.of(context)
                                          .translate(item.title),
                                      style: AppFont.SEMIBOLD_BLACK_13,
                                    ),
                                  )
                                else
                                  FutureBuilder(
                                      future: ServiceConverter.getTextToConvert(
                                          "building_info"),
                                      builder: (context, snap) {
                                        if (snap.connectionState ==
                                            ConnectionState.waiting) {
                                          return const SizedBox.shrink();
                                        }

                                        this._title = snap.data as String;

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 0.0),
                                          child: Text(
                                            LocalizationsUtil.of(context)
                                                .translate(snap.data),
                                            style: AppFont.SEMIBOLD_BLACK_13,
                                          ),
                                        );
                                      }),
                                const SizedBox(height: 4.0),
                                Text(
                                    LocalizationsUtil.of(context)
                                        .translate(item.subtitle),
                                    style: AppFont.SEMIBOLD_GRAY_B5B5B5_13,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.start),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 10.0,
                            top: -12.0,
                            child: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFdcdcdc)),
                              child: item.title != _list.first.title
                                  ? SvgPicture.asset(
                                      item.icon,
                                    )
                                  : AvatarWidget(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          isDisableAppIconChaging ? Container() : _changeAppIconSection()
        ],
      ),
    );
  }

  Widget _changeAppIconSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            children: [
              SvgPicture.asset(
                AppVectors.handPhone,
                width: 30,
                height: 30,
              ),
              const SizedBox(
                width: 10.0,
              ),
              Text(LocalizationsUtil.of(context).translate('change_app_icon'),
                  style: AppFont.BOLD_BLACK_15),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Text(
            LocalizationsUtil.of(context).translate('change_app_icon_msg'),
            style: AppFonts.semibold13.copyWith(
              color: Color(
                0xff838383,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _listActionType.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Container(
                decoration: BaseWidget.dividerBottom(
                    height: 1, color: Color(0xfff5f5f5)),
                padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
                child: Container(
                  child: _appIconItem(context, _listActionType[index], index),
                ),
              ),
              onTap: () async {
                if (_listActionType[index].isSelected == true) {
                  return;
                }
                //change app icon
                changeIconAndShowSuccess(context: context, index: index);
                //Firebase Analytics
                GetIt.instance<FBAnalytics>().sendEventAppIconPick(
                    userID: widget.profile.id ?? "",
                    appIconID: _listActionType[index].key);
              },
            );
          },
        )
      ],
    );
  }

  Future<void> _launchHouzeBuildingWeb() async {
    final String houzeBuildingUrl = "https://houzebuilding.com/";

    await Utils.launchURL(url: houzeBuildingUrl);
  }

  Widget _appIconItem(BuildContext context, FilterActionType type, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Transform.scale(
            scale: 1.2,
            child: Radio(
              value: LocalizationsUtil.of(context)
                  .translate(_listActionType[index].mainTitle),
              activeColor: Color(0xff6001d2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              hoverColor: Color(0xff6001d2),
              focusColor: Color(0xff6001d2),
              onChanged: (_) async {
                //change app icon
                changeIconAndShowSuccess(context: context, index: index);
              },
              groupValue: LocalizationsUtil.of(context).translate(
                  _listActionType[this.currentIndexActivity].mainTitle),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10.0, left: 10.0),
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xfff2f2f2), width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/logo-${type.key}.png",
                      width: 40.0,
                      height: 40.0,
                    )
                  ],
                ),
              )),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationsUtil.of(context).translate(type.mainTitle),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Text(
                type.isSelected == false
                    ? LocalizationsUtil.of(context)
                        .translate("click_to_change_icon")
                    : LocalizationsUtil.of(context).translate("current_icon"),
                style: type.isSelected == false
                    ? TextStyle(
                        color: Color(0xff838383),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600)
                    : TextStyle(
                        color: Color(0xff6001d2),
                        fontSize: 13.0,
                        fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void changeIconAndShowSuccess({
    required BuildContext context,
    required int index,
  }) {
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.4,
          alignment: Alignment.center,
          padding:
              const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  children: <Widget>[
                    Image.asset(
                      "assets/images/logo-${_listActionType[index].key}.png",
                      width: 75.0,
                      height: 75.0,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                  LocalizationsUtil.of(context).translate('icon_has_been_changed'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold18),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppFonts.regular15.copyWith(
                    color: Color(
                      0xff808080,
                    ),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                                .translate('change_app_icon_success_msg1') +
                            ' '),
                    TextSpan(
                        text: '\n' + LocalizationsUtil.of(context)
                                .translate('change_app_icon_success_msg2')),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              WidgetButton.pink(
                LocalizationsUtil.of(context).translate('close_action'),
                callback: () async {
                  final prefs = await SharedPreferences.getInstance();
                  //save current selected app icon
                  prefs.setString(
                      currentSelectedAppIconKey, _listActionType[index].key);
                  String? str = prefs.getString(currentSelectedAppIconKey);
                  print("========>Current app icon key: " + str.toString());

                  setState(() {
                    this.currentIndexActivity = index;
                    _listActionType
                        .forEach((element) => element.isSelected = false);
                    _listActionType[index].isSelected = true;
                  });
                  Navigator.pop(context);
                  if (Platform.isAndroid) {
                    Future.delayed(Duration(seconds: 2), () async {
                      DynamicIconFlutter.setIcon(
                          icon: _listActionType[index].key,
                          listAvailableIcon: listAvailableIcon);
                    });
                  } else {
                    try {
                      if (await DynamicIconFlutter.supportsAlternateIcons) {
                        await DynamicIconFlutter.setAlternateIconName(
                            _listActionType[index].key);
                        print("App icon change successful");
                        return;
                      }
                    } on PlatformException {
                      if (await DynamicIconFlutter.supportsAlternateIcons) {
                        await DynamicIconFlutter.setAlternateIconName(null);
                        print("Change back to default app icon");
                        return;
                      } else {
                        print("Failed to change app icon");
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
        closeShow: false,
        barrierDismissible: false);
  }
}
