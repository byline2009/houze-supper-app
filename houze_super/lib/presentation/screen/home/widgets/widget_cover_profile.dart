import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/flutter_skeleton.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_point_bloc/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

class WidgetHeaderCoverProfile extends StatelessWidget {
  const WidgetHeaderCoverProfile();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: BlocBuilder<ProfileLoadPointBloc, ProfileLoadPointState>(
        builder: (c, ProfileLoadPointState s) {
          if (s.isInitial) {
            context.read<ProfileLoadPointBloc>().add(
                  ProfileLoadPointEvent(),
                );
          }
          if (s.hasError) {
            print('[*** WidgetProfile]: Error: ${s.error}');
            return Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BaseWidget.avatar(
                    size: 48,
                  ),
                  const SizedBox(width: 15),
                  SizedBox(
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          Storage.getUserName(),
                          style: AppFonts.bold16.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Houze Xu: 0',
                          style: AppFonts.bold15.copyWith(
                            color: Color(
                              0xffffcc44,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (s.hasData) {
            final ProfileModel _profileModel = s.profile;
            final TotalPointModel _totalPointModel = s.totalPoint;
            return buildHeader(
              _profileModel,
              _totalPointModel,
            );
          }
          return _loading();
        },
      ),
    );
  }

  Widget _loading() => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: ListSkeleton(
          length: 1,
          shrinkWrap: true,
          config: SkeletonConfig(
            bottomLinesCount: 0,
            isCircleAvatar: true,
            isShowAvatar: true,
            theme: SkeletonTheme.Light,
          ),
        ),
      );

  Widget buildHeader(
    ProfileModel profileModel,
    TotalPointModel totalPointModel,
  ) =>
      Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 20,
          right: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BaseWidget.avatar(
              imageUrl: profileModel.imageThumb,
              fullname: profileModel.fullname,
              size: 48,
            ),
            const SizedBox(
              width: 15,
            ),
            SizedBox(
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    profileModel.fullname,
                    style: AppFonts.bold16.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Houze Xu: ' +
                        _addCommaToTotalPoint(
                            totalPointModel.amount.toString()),
                    style: AppFonts.bold15.copyWith(
                      fontSize: 15,
                      color: Color(
                        0xffffcc44,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  String _addCommaToTotalPoint(String point) {
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    Function mathFunc = (Match match) => '${match[1]},';
    return point.replaceAllMapped(reg, mathFunc);
  }
}
