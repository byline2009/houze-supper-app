import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/style/style_hone_page.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

class BottomSheetSwitchWidget {
  static void showBottomSheet({
    @required BuildContext context,
    @required String title,
    dynamic defaultValue,
    dynamic callback,
    bool noHeight = false,
    @required List<KeyValueModel> options,
  }) async {
    final _onTap = (dynamic item) async {
      HapticFeedback.lightImpact();
      if (callback != null) {
        callback(item);
      }
      Navigator.pop(context);
      await Future.delayed(Duration(milliseconds: 500));
    };

    showModalBottomSheet(
        context: context,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        builder: (context) {
          return Container(
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(StyleHomePage.borderRadius),
                        topRight: Radius.circular(StyleHomePage.borderRadius),
                      )),
                  height: noHeight
                      ? null
                      : StyleHomePage.bottomSheetHeight(context),
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(20),
                          margin: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset(AppVectors.icClose),
                              ),
                              Expanded(
                                  child: Text(
                                LocalizationsUtil.of(context).translate(title),
                                textAlign: TextAlign.center,
                                style: AppFonts.medium18
                                    .copyWith(letterSpacing: 0.29),
                              )),
                            ],
                          )),
                      Expanded(
                          child: ListView(
                        padding: const EdgeInsets.all(0),
                        shrinkWrap: true,
                        primary: false,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: options.map((item) {
                          return GestureDetector(
                              child: Container(
                                  decoration: BaseWidget.dividerBottom(
                                      height: 1, color: Color(0xfff5f5f5)),
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Radio(
                                          value: item.key,
                                          activeColor: Color(0xff6001d2),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          //groupValue: item.key,
                                          groupValue: defaultValue,
                                          hoverColor: Color(0xff6001d2),
                                          focusColor: Color(0xff6001d2),
                                          onChanged: (dynamic value) {
                                            _onTap(item);
                                          },
                                        ),
                                        const SizedBox(width: 10),
                                        Text(item.value,
                                            style: AppFonts.medium14
                                                .copyWith(color: Colors.black))
                                      ])),
                              onTap: () {
                                _onTap(item);
                              });
                        }).toList(),
                      ))
                    ],
                  )));
        });
  }
}
