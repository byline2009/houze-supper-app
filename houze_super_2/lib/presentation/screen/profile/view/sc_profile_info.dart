import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/pick_crop_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import '../widgets/index.dart';

//---SCREEN: Thông tin cá nhân---//

class ProfileInfoScreen extends StatefulWidget {
  @override
  _ProfileInfoScreenState createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends RouteAwareState<ProfileInfoScreen> {
  final repo = ProfileRepository();
  final ProgressHUD _progressHUD = Progress.instanceCreateWithNormal();
  final refreshController = RefreshController();
  final profileAPI = ProfileAPI();
  @override
  void dispose() {
    refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HomeScaffold(
          title: 'personal_information',
          child: FutureBuilder<ProfileModel?>(
            future: repo.getProfile(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return SomethingWentWrong();
              } else if (snapshot.hasData) {
                ProfileModel profile = snapshot.data!;

                return SmartRefresher(
                  controller: refreshController,
                  onRefresh: () => setState(() {}),
                  header: MaterialClassicHeader(),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _avatarSection(context: context, profile: profile),
                        // _authSection(
                        //   context: ctx,
                        //   verifyStatus: profile.verifyStatus,
                        // ),
                        PersonalInfoSection(profile: profile),
                        PolicySection(),
                        ButtonLogoutSection(
                          progressHUD: _progressHUD,
                        ),
                        BottomCurrentVersion(),
                      ],
                    ),
                  ),
                );
              }
              return ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  CardListSkeleton(
                    shrinkWrap: true,
                    length: 1,
                    config: SkeletonConfig(
                      theme: SkeletonTheme.Light,
                      isShowAvatar: true,
                      isCircleAvatar: true,
                      bottomLinesCount: 1,
                      radius: 0.0,
                    ),
                  ),
                  CardListSkeleton(
                    shrinkWrap: true,
                    length: 4,
                    config: SkeletonConfig(
                      theme: SkeletonTheme.Light,
                      bottomLinesCount: 2,
                      radius: 0.0,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        _progressHUD,
      ],
    );
  }

  Container _avatarSection({
    BuildContext? context,
    ProfileModel? profile,
  }) {
    final profileRepository = ProfileRepository();

    Widget avatar;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(LocalizationsUtil.of(context).translate('profile_picture'),
              style: AppFont.SEMIBOLD_BLACK_14),
          SizedBox(height: 10.0),
          PickCropImage(
            callback: (File file) async {
              await profileAPI.getProfile(); //refresh token
              final resultUpload = await profileRepository.uploadProfile(file);
              return resultUpload;
            },
            buildElement: (dynamic params, String state) {
              final rsUpload = params as ImageModel?;

              if (rsUpload != null && rsUpload.id != "") {
                avatar = BaseWidget.avatar(
                  imageUrl: rsUpload.imageThumb!,
                  size: 80,
                );
              } else {
                avatar = BaseWidget.avatar(
                  imageUrl: profile!.imageThumb ?? '',
                  fullname: profile.fullname ?? '',
                  size: 80,
                );
              }

              return ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[avatar],
                ),
              );
            },
            showIcon: true,
          ),
          SizedBox(height: 16.0),
          Text(
            profile!.fullname ?? '',
            style: AppFonts.bold18,
          ),
        ],
      ),
    );
  }

  // Widget _authSection({BuildContext context, int verifyStatus}) {
  //   final Color color = <int>[0, 3].contains(verifyStatus)
  //       ? Color(0xFFc50000)
  //       : verifyStatus == 1
  //           ? Color(0xFFd68100)
  //           : Color(0xFF6001d2);

  //   final Color backgroundColor = <int>[0, 3].contains(verifyStatus)
  //       ? Color(0xFFfdcbcb)
  //       : verifyStatus == 1
  //           ? Color(0xFFffefc6)
  //           : Color(0xFFf2e8ff);

  //   final String notification = <int>[0, 3].contains(verifyStatus)
  //       ? "your_account_isn't_verified"
  //       : verifyStatus == 1
  //           ? "your_account_is_awaiting_approval"
  //           : "your_account_is_verified";

  //   final String textButton =
  //       <int>[1, 2].contains(verifyStatus) ? 'detail' : 'perform';

  //   void _action(bool value) => value
  //       ? AppRouter.push(
  //           context,
  //           AppRouter.EKYC_REVIEW,
  //           <String, String>{'title': 'S'},
  //         )
  //       : _showModalBottomSheet(context);

  //   return Container(
  //     height: 48.0,
  //     margin: EdgeInsets.symmetric(horizontal: 5.0),
  //     child: TextButton(
  //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //       padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
  //       onPressed: () => _action(<int>[1, 2].contains(verifyStatus)),
  //       color: backgroundColor,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Expanded(
  //             child: Text(
  //               LocalizationsUtil.of(context).translate(notification),
  //               style: AppFont.SEMIBOLD_BLACK_13.copyWith(color: color),
  //             ),
  //           ),
  //           Text(
  //             LocalizationsUtil.of(context).translate(textButton),
  //             style: AppFont.SEMIBOLD_BLACK_13
  //                 .copyWith(color: color, letterSpacing: 0.26),
  //           ),
  //           SizedBox(width: 5.0),
  //           SvgPicture.asset(AppVectors.ic_arrow_right_red, color: color)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _showModalBottomSheet(BuildContext context) {
  //   final getLanguage = Storage.getLanguage();

  //   return showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(
  //         top: Radius.circular(16.0),
  //       ),
  //     ),
  //     builder: (_) => SafeArea(
  //       child: SingleChildScrollView(
  //         padding: const EdgeInsets.all(20.0),
  //         child: ListBody(
  //           children: [
  //             Container(
  //               width: double.infinity,
  //               child: Stack(
  //                 children: [
  //                   Align(
  //                     child: Text(
  //                       LocalizationsUtil.of(_)
  //                           .translate('verify_your_information'),
  //                       style: AppFonts.medium18,
  //                     ),
  //                   ),
  //                   Align(
  //                     alignment: Alignment.centerLeft,
  //                     child: InkWell(
  //                       child: Icon(Icons.close),
  //                       onTap: () => Navigator.of(_).pop(),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(height: 30.0),
  //             SvgPicture.asset(AppVectors.ekyc),
  //             SizedBox(height: 20.0),
  //             Text(
  //               LocalizationsUtil.of(_).translate(
  //                 'verify_your_information_to_access_other_features_on_houze_and_enhance_your_account_security',
  //               ),
  //               style: AppFonts.regular15,
  //               textAlign: TextAlign.center,
  //             ),
  //             SizedBox(height: 40.0),
  //             ElevatedButtonCustom(
  //               buttonText: 'start_to_authentication',
  //               onPressed: () {
  //                 Navigator.of(_).pop();
  //                 AppRouter.pushNoParams(_, AppRouter.EKYC);
  //               },
  //             ),
  //             SizedBox(height: 20.0),
  //             RichText(
  //               textAlign: TextAlign.center,
  //               text: TextSpan(
  //                 style: AppFont.REGULAR_GRAY_838383_15,
  //                 children: <TextSpan>[
  //                   TextSpan(
  //                     text: LocalizationsUtil.of(_).translate(
  //                       "by_choosing_continue_you_are_agreeing_to_houze's",
  //                     ),
  //                   ),
  //                   TextSpan(
  //                     text: LocalizationsUtil.of(_).translate(
  //                       'terms_&_conditions',
  //                     ),
  //                     style: AppFont.BOLD_PURPLE_6001d2_15,
  //                   ),
  //                   if (getLanguage.locale == 'vi')
  //                     TextSpan(
  //                       text: LocalizationsUtil.of(_).translate(
  //                         "houze's",
  //                       ),
  //                     ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
