// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:houze_super/middle/model/ekyc_model.dart';
// import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
// import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
// import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
// import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:houze_super/presentation/screen/ekyc/bloc/ekyc_bloc.dart';
// import 'package:houze_super/presentation/screen/ekyc/bloc/ekyc_event.dart';
// import 'package:houze_super/presentation/screen/ekyc/bloc/ekyc_state.dart';
// import 'package:houze_super/presentation/screen/profile/widgets/personal_info_section.dart';
// import 'package:houze_super/utils/index.dart';

// const String photoReviewKey = 'photoReviewKey';

// class EKYCReviewScreen extends StatelessWidget {
//   final Map<String, dynamic> args;

//   EKYCReviewScreen({@required this.args});

//   final List<String> _cardTypeList = [
//     'id_card_or_identity_card',
//     'passport',
//   ];

//   final List<Field> _fields = [];

//   @override
//   Widget build(BuildContext context) {
//     final bool _isReviewPage = args['title'].contains('B');

//     EKYCModel instance = EKYCModel();

//     if (_isReviewPage) {
//       instance = EKYCModel.fromJson(args['instance'])..status = 0;

//       _fields.addAll(<Field>[
//         Field(
//           name: 'type_of_document',
//           value: _cardTypeList[instance.cardType],
//         ),
//         Field(
//           name: 'number_id_in_document',
//           value: instance.card,
//         ),
//         Field(
//           name: 'full_name_0',
//           value: instance.fullName,
//         ),
//       ]);
//     }

//     if (!_isReviewPage && args['instance'] != null) {
//       WidgetsBinding.instance.addPostFrameCallback(
//         (_) => DialogCustom.showSuccessDialog(
//           context: context,
//           svgPath: AppVectors.ekyc,
//           title: 'verification_completed',
//           content:
//               'the_process_is_completed_our_system_will_send_you_the_result_soon',
//         ),
//       );
//     }
//     final _ekycBloc = EKYCBloc();
//     return HomeScaffold(
//       title: LocalizationsUtil.of(context).translate(
//           _isReviewPage ? 'check_your_information' : 'verify_your_information'),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0).copyWith(bottom: 0),
//         child: _isReviewPage
//             ? SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildTopSection(
//                       instance: instance,
//                       isAuthPage: false,
//                       context: context,
//                     ),
//                     _buildInfoSection(context: context, fields: _fields),
//                     _buildImageSection(context: context, instance: instance),
//                     _isReviewPage
//                         ? _buildBottomSection(context)
//                         : const SizedBox.shrink(),
//                   ],
//                 ),
//               )
//             : BlocProvider<EKYCBloc>(
//                 create: (_) => _ekycBloc,
//                 child: BlocBuilder<EKYCBloc, EKYCState>(
//                   cubit: _ekycBloc,
//                   builder: (_, EKYCState state) {
//                     final refreshController = RefreshController();

//                     Future<void> onRefresh() async {
//                       _ekycBloc.add(EKYCLoad());
//                       refreshController.refreshCompleted();
//                     }

//                     if (state is EKYCInitial) _ekycBloc.add(EKYCLoad());

//                     if (state is EKYCGetFailure) return SomethingWentWrong();

//                     if (state is EKYCGetSuccessful) {
//                       instance = state.eKYC;

//                       _fields
//                         ..clear()
//                         ..addAll(<Field>[
//                           Field(
//                             name: 'type_of_document',
//                             value: _cardTypeList[instance.cardType],
//                           ),
//                           Field(
//                             name: 'number_id_in_document',
//                             value: instance.card,
//                           ),
//                           Field(
//                             name: 'full_name_0',
//                             value: instance.fullName,
//                           ),
//                         ]);

//                       return SmartRefresher(
//                         controller: refreshController,
//                         onRefresh: onRefresh,
//                         header: MaterialClassicHeader(),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _buildTopSection(
//                                 instance: instance,
//                                 isAuthPage: true,
//                                 context: context,
//                               ),
//                               _buildInfoSection(
//                                 context: context,
//                                 fields: _fields,
//                               ),
//                               _buildImageSection(
//                                 context: context,
//                                 instance: instance,
//                               ),
//                               _isReviewPage
//                                   ? _buildBottomSection(context)
//                                   : const SizedBox.shrink(),
//                             ],
//                           ),
//                         ),
//                       );
//                     }

//                     return Align(child: CupertinoActivityIndicator());
//                   },
//                 ),
//               ),
//       ),
//       bottomSheet: _isReviewPage
//           ? _buildBottomSheet(
//               context: context,
//               instance: instance,
//             )
//           : null,
//     );
//   }

//   Container _buildTopSection({
//     @required bool isAuthPage,
//     @required EKYCModel instance,
//     @required BuildContext context,
//   }) {
//     final String status = instance.status == 0
//         ? 'pending'
//         : instance.status == 1
//             ? 'successful'
//             : 'rejected_1';

//     final Color statusColor = instance.status == 0
//         ? Color(0xFFd68100)
//         : instance.status == 1
//             ? Color(0xFF00aa7d)
//             : Color(0xFFc50000);

//     final Color statusBackgroundColor = instance.status == 0
//         ? Color(0xFFffefc6)
//         : instance.status == 1
//             ? Color(0xFFd3fff3)
//             : Color(0xFFfdcbcb);

//     return isAuthPage
//         ? Container(
//             margin: EdgeInsets.only(bottom: 20.0),
//             child: Container(
//               height: 30.0,
//               padding: const EdgeInsets.only(left: 12.0, right: 16.0),
//               decoration: ShapeDecoration(
//                 color: statusBackgroundColor,
//                 shape: StadiumBorder(),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.fiber_manual_record,
//                     color: statusColor,
//                     size: 8.0,
//                   ),
//                   SizedBox(width: 8.0),
//                   Text(
//                     LocalizationsUtil.of(context).translate(status),
//                     style: AppFonts.medium.copyWith(
//                       color: statusColor,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           )
//         : Padding(
//             padding:
//                 EdgeInsets.symmetric(horizontal: 40.0).copyWith(bottom: 30.0),
//             child: Text(
//               LocalizationsUtil.of(context).translate(
//                   'check_your_information_and_your_document_photos_below_again'),
//               style: AppFonts.regular15,
//               textAlign: TextAlign.center,
//             ),
//           );
//   }

//   RaisedButtonCustom _buildBottomSheet({
//     @required BuildContext context,
//     @required EKYCModel instance,
//   }) {
//     return RaisedButtonCustom(
//       buttonText: 'start_to_take_a_your_selfie',
//       onPressed: () => AppRouter.pushDialog(
//         context,
//         AppRouter.CAMERA_SCREEN,
//         args
//           ..update('title', (value) => 'S')
//           ..update('sub_title', (value) => '')
//           ..update(
//             'instance',
//             (value) => instance.toJson(),
//           ),
//       ),
//     );
//   }

//   Column _buildBottomSection(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: double.infinity,
//           margin: EdgeInsets.only(bottom: 40.0),
//           child: FlatButtonCustom(
//             buttonText: 'take_pictures_again',
//             onPressed: () => AppRouter.pushDialog(
//               context,
//               AppRouter.CAMERA_SCREEN,
//               args..update('title', (value) => 'F'),
//             ),
//           ),
//         ),
//         Container(
//           margin:
//               EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 112.0),
//           child: Text(
//             LocalizationsUtil.of(context).translate(
//               'one_more_step_to_complete_the_process_of_personal_information_verification',
//             ),
//             style: AppFonts.regular15,
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ],
//     );
//   }

//   Column _buildImageSection({
//     @required BuildContext context,
//     @required EKYCModel instance,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           LocalizationsUtil.of(context).translate('document_photos'),
//           style: AppFonts.medium,
//         ),
//         SizedBox(height: 10.0),
//         ...[instance.cardFrontImage, instance.cardBackImage].map(
//           (e) => Container(
//             margin: EdgeInsets.only(bottom: 16.0),
//             child: instance.portraitImage != null
//                 ? CachedImageWidget(cacheKey: photoReviewKey, imgUrl: e)
//                 : Image.file(
//                     File(e),
//                     filterQuality: FilterQuality.high,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }

//   Column _buildInfoSection({BuildContext context, List<Field> fields}) {
//     return Column(
//       children: fields
//           .map(
//             (e) => Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   LocalizationsUtil.of(context).translate(e.name),
//                   style: AppFonts.medium,
//                 ),
//                 SizedBox(height: 10.0),
//                 Container(
//                   height: 48.0,
//                   width: double.infinity,
//                   padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                   decoration: BoxDecoration(
//                     color: Color(0xfff5f5f5),
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: Text(
//                       LocalizationsUtil.of(context).translate(e.value),
//                       style: AppFonts.medium,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 40.0),
//               ],
//             ),
//           )
//           .toList(),
//     );
//   }
// }
