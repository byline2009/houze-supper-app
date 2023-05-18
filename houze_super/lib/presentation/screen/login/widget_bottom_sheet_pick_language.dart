import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/language_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/utils/index.dart';

const String switchBuildingKey = 'switchBuildingKey';
typedef void CallBackHandler(LanguageModel value);

class PickLanguageBottomSheet {
  static void showBottomSheet(
      {@required BuildContext contextParent,
      @required double height,
      @required LanguageModel currentLanguage,
      @required CallBackHandler callback}) {
    showModalBottomSheet(
        context: contextParent,
        backgroundColor: Colors.white,
        elevation: 0.0,
        isScrollControlled: true,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        builder: (context) {
          return SafeArea(
            maintainBottomViewPadding: true,
            bottom: true,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(StyleHomePage.borderRadius),
                      topRight: Radius.circular(StyleHomePage.borderRadius))),
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  HeaderBottomSheet(
                      title: LocalizationsUtil.of(context)
                          .translate('select_language'),
                      parentContext: context),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      primary: false,
                      itemCount: AppConstant.languages.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        LanguageModel item = AppConstant.languages[index];
                        return GestureDetector(
                            child: Container(
                                key: Key(item.locale),
                                decoration: BaseWidget.dividerBottom(
                                    height: 1, color: Color(0xfff5f5f5)),
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Radio(
                                          value: item.locale,
                                          activeColor: Color(0xff6001d2),
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                          groupValue: currentLanguage.locale,
                                          hoverColor: Color(0xff6001d2),
                                          focusColor: Color(0xff6001d2),
                                          onChanged: (String value) {
                                            callback(item);
                                            Navigator.pop(context);
                                          }),
                                      const SizedBox(width: 10),
                                      Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Color(0xfff5f5f5),
                                            border: Border.all(
                                                width: 0,
                                                color: Colors.transparent),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0)),
                                          ),
                                          child: Center(
                                              child: SvgPicture.asset(
                                            item.flag,
                                          ))),
                                      const SizedBox(width: 10),
                                      Text(item.name,
                                          style: AppFonts.medium14
                                              .copyWith(color: Colors.black))
                                    ])),
                            onTap: () {
                              callback(item);
                              Navigator.pop(context);
                            });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
