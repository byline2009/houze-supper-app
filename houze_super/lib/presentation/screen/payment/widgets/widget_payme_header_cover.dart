// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:houze_super/common/blocs/app_event_bloc.dart';

// import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
// import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
// import 'package:houze_super/presentation/screen/profile/bloc/profile_state.dart';
// import 'package:houze_super/utils/constants/share_keys.dart';
// import 'package:houze_super/utils/index.dart';


// class PayMEHeaderCover extends StatefulWidget {
//   PayMEHeaderCover({
//     @required this.progressToolkit,
//   });
//   final ProgressHUD progressToolkit;

//   @override
//   _PayMEHeaderCoverState createState() => _PayMEHeaderCoverState();
// }

// class _PayMEHeaderCoverState extends State<PayMEHeaderCover> {
//   StreamSubscription<BlocEvent> _subPayMEChanngeState;

//   @override
//   void initState() {
//     super.initState();
//     _subPayMEChanngeState = AppEventBloc().listenEvent(
//       eventName: EventName.payMEChangeState,
//       handler: _handleStatePayME,
//     );
//   }

//   void _handleStatePayME(BlocEvent evt) {
//     final value = evt.value;
//     if (!mounted) return;
//     if (value is PlatformException && !StringUtil.isEmpty(value.code)) {
//       if (value.code == ShareKeys.kExpired &&
//           !value.message.contains('Thông tin xác thực không hợp lệ')) {
//         context.read<ProfileBloc>().add(ProfileLoadEvent());
//       }
//       return;
//     }

//     if (value is String && !StringUtil.isEmpty(value)) {
//       if (value == ShareKeys.kExpired) {
//         context.read<ProfileBloc>().add(ProfileLoadEvent());
//       }
//       return;
//     }
//   }

//   @override
//   void dispose() async {
//     if (_subPayMEChanngeState != null) _subPayMEChanngeState.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<ProfileBloc, ProfileState>(
//       builder: (contex, state) {
//         if (state.isInitial) {
//           contex.read<ProfileBloc>().add(ProfileLoadEvent());
//         }

//         if (state.hasError) {
//           return Center(
//             child: Text(
//               state.error.toString(),
//               style: AppFonts.semibold13.copyWith(
//                 color: Colors.white,
//               ),
//             ),
//           );
//         }

//         if (state.hasData) {
//           return PayMEInitializer(
//             loading: const Center(
//               child: CupertinoActivityIndicator(),
//             ),
//             progressToolkit: widget.progressToolkit,
//             token: state.profile.paymeToken,
//           );
//         }
//         if (state.hasLoading)
//           return Center(
//             child: CupertinoActivityIndicator(),
//           );
//         return const SizedBox.shrink();
//       },
//     );
//   }
// }
