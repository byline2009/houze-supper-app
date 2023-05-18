import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';

class PolicySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xfff5f5f5),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: TextButton(
          onPressed: () {
            AppRouter.pushNoParams(context, AppRouter.HOUZE_POLICY_SCREEN);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  LocalizationsUtil.of(context).translate('policy_houze'),
                  textAlign: TextAlign.left,
                  style: AppFont.SEMIBOLD_BLACK_13,
                ),
              ),
              Text(
                LocalizationsUtil.of(context).translate('detail'),
                style: AppFont.SEMIBOLD_BLACK_13,
              ),
              SizedBox(width: 6),
              SvgPicture.asset(
                AppVectors.ic_arrow_right,
                color: Colors.black,
              ),
            ],
          )),
    );
  }
}
