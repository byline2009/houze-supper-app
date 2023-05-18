import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/common_widgets/stateless/text_limit_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler();

class HouzexPayMEPopup extends StatelessWidget {
  final CallBackHandler callback;
  const HouzexPayMEPopup({
    @required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            8.0,
          ),
        ),
      ),
      content: Container(
        height: 432,
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(
                8.0,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: 220.0,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                      child: //SvgPicture.('icons/heart.png',  package: 'my_icons'),

                          Image.asset(
                        AppImages.icHouzexPayME,
                        height: 220.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: SvgPicture.asset(
                            AppVectors.icClose,
                            height: 14,
                            width: 14,
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              15.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    top: 15,
                    left: 20,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextLimitWidget(
                      '''Từ nay, cư dân có thể thanh toán trực tiếp trên ứng dụng Houze thông qua ví điện tử PayME. Nhanh tay tiến hành tạo ví để bắt đầu sử dụng ví điện tử ngay hôm nay!''',
                      maxLines: 4,
                      textAlign: TextAlign.left,
                      style: AppFonts.regular15,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: WidgetButton.pink(
                  'Tiến hành tạo ví PayME',
                  callback: () {
                    Navigator.pop(context);
                    callback();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
