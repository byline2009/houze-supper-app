import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/sqflite.dart';

class SOSScreen extends StatefulWidget {
  SOSScreen({Key key}) : super(key: key);

  @override
  SOSScreenScreenState createState() => SOSScreenScreenState();
}

class SOSScreenScreenState extends State<SOSScreen> {
  BuildingMessageModel _messageModel;

  @override
  void initState() {
    super.initState();
  }

  Future<BuildingMessageModel> _getBuilding() async {
    if (this._messageModel != null) {
      return this._messageModel;
    }
    List<BuildingMessageModel> _listBuilding = await Sqflite.getBuildingList();
    _messageModel =
        _listBuilding.singleWhere((f) => f.id == Sqflite.currentBuildingID);

    return _messageModel;
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldPresent(
      title: '',
      body: Container(
          color: Colors.white,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            shrinkWrap: true,
            children: <Widget>[
              SvgPicture.asset(AppVectors.ic_sos_large),
              const SizedBox(height: 15),
              Text(
                  LocalizationsUtil.of(context)
                      .translate("emergency_with_exclamation_mark"),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold24),
              const SizedBox(height: 15),
              Text(
                LocalizationsUtil.of(context).translate("sos_desc"),
                textAlign: TextAlign.center,
                style: AppFonts.regular15.copyWith(
                  color: Color(0xff838383),
                ),
              ),
              const SizedBox(height: 10),
              FutureBuilder(
                future: _getBuilding(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print(snapshot.connectionState.toString().toUpperCase());
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Center(child: CupertinoActivityIndicator());
                    default:
                      if (snapshot.hasError)
                        return SomethingWentWrong();
                      else {
                        var building = snapshot.data as BuildingMessageModel;

                        return building.hotLine != null
                            ? Container(
                                height: 48,
                                margin: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    gradient: AppColors.gradient,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: ButtonWidget(
                                  isActive: true,
                                  defaultHintText:
                                      LocalizationsUtil.of(context).translate(
                                            'call_the_hotline_with_colon',
                                          ) +
                                          " ${building.hotLine}",
                                  callback: () {
                                    Utils.makePhoneCall(
                                        phone: building.hotLine);
                                  },
                                ))
                            : Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Color(0xffdac0ff),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                margin: EdgeInsets.all(20),
                                child: Center(
                                    child: Text(
                                        LocalizationsUtil.of(context).translate(
                                          "sorry_for_this_inconvenience_we're_updating_the_hotline",
                                        ),
                                        style: AppFonts.medium14
                                            .copyWith(color: Colors.black))));
                      }
                  }
                },
              ),
            ],
          )),
    );
  }
}
