import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

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
      child: FlatButton(
          padding: const EdgeInsets.all(0),
          onPressed: () {
            AppRouter.pushNoParams(
              context,
              AppRouter.policy,
            );
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  LocalizationsUtil.of(context).translate('policy_houze'),
                  textAlign: TextAlign.left,
                  style: AppFonts.semibold.copyWith(
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                LocalizationsUtil.of(context).translate('detail'),
                style: AppFonts.semibold.copyWith(
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 6),
              SvgPicture.asset(
                AppVectors.ic_arrow_right,
                color: Colors.black,
              ),
            ],
          )),
    );
  }
}
