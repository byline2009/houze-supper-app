// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:houze_super/middle/api/profile_api.dart';
// import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
// import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
// import 'package:houze_super/utils/index.dart';

// class ChangePasswordScreen extends StatefulWidget {
//   @override
//   _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
// }

// class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
//   final _formKey = GlobalKey<FormState>();

//   final _api = ProfileAPI();

//   final String whiteSpace = ' ';

//   bool isValidated = false;
//   final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
//   final controllers =
//       List<TextEditingController>.generate(3, (i) => TextEditingController());

//   final obscureFields = List<bool>.generate(3, (i) => true);

//   final fieldData = <Map<String, TextEditingController>>[];

//   void _checkValidate() {
//     if (controllers.any((e) => e.text.length < 6) ||
//         controllers.any((e) => e.text.contains(whiteSpace)) ||
//         (controllers[1].text != controllers[2].text &&
//             (controllers[1].text.contains(whiteSpace) ||
//                 controllers[2].text.contains(whiteSpace))) ||
//         controllers[0].text == controllers[2].text)
//       setState(() => isValidated = false);
//     else
//       setState(() => isValidated = true);
//   }

//   String generateErrorText(String value, TextEditingController controller) {
//     if (controller.text.isEmpty) return null;

//     if (controller.text.contains(whiteSpace)) {
//       return 'Mật khẩu không được chứa khoảng trắng';
//     }
//     if (controller.text.length < 6) {
//       return LocalizationsUtil.of(context)
//           .translate("password_must_be_at_least_six_characters");
//     }

//     if (controller == controllers.last) {
//       if (controllers[1].text != controllers[2].text)
//         return LocalizationsUtil.of(context)
//             .translate("your_passwords_don't_match");
//       else {
//         if (controllers[0].text == controllers[2].text) {
//           return LocalizationsUtil.of(context)
//               .translate("old_password_match_new_password");
//         } else {
//           return LocalizationsUtil.of(context)
//               .translate("your_passwords_match");
//         }
//       }
//     }

//     return null;
//   }

//   Future<void> _submit(BuildContext _) async {
//     progressToolkit.state.show();

//     try {
//       // await _api.changePassword(
//       //   context: _,
//       //   oldPassword: controllers.first.text,
//       //   newPassword: controllers.last.text,
//       // );
//     } finally {
//       progressToolkit.state.dismiss();
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     fieldData.addAll([
//       {'please_enter_current_password': controllers[0]},
//       {'please_enter_new_password': controllers[1]},
//       {'please_confirm_new_password': controllers[2]},
//     ]);
//   }

//   @override
//   void dispose() {
//     controllers.forEach((e) => e.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
//       child: HomeScaffold(
//         title: 'change_your_password',
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: EdgeInsets.all(20.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   children: [
//                     ListView.separated(
//                       shrinkWrap: true,
//                       itemCount: fieldData.length,
//                       separatorBuilder: (_, int i) => SizedBox(height: 30.0),
//                       itemBuilder: (_, int i) => _buildField(
//                         title: fieldData[i].keys.single,
//                         controller: fieldData[i].values.single,
//                       ),
//                     ),
//                     SizedBox(height: 100.0),
//                     ElevatedButtonCustom(
//                       buttonText: 'confirm_change_password',
//                       onPressed: isValidated ? () => _submit(context) : null,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             progressToolkit,
//             // ProgressIndicatorWidget(isProgressing),
//           ],
//         ),
//       ),
//     );
//   }

//   Column _buildField({
//     required String title,
//     required TextEditingController controller,
//   }) {
//     final OutlineInputBorder inputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(5.0),
//       borderSide: BorderSide(
//         color: controller.text.length < 6 ? Color(0xFFb5b5b5) : Colors.black,
//       ),
//     );
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           LocalizationsUtil.of(context).translate(title),
//           style: AppFont.REGULAR_GRAY_838383_15,
//         ),
//         SizedBox(
//           height: 10.0,
//         ),
//         StatefulBuilder(
//           builder: (_, StateSetter setState) {
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Flexible(
//                   child: TextFormField(
//                     controller: controller,
//                     autofocus: true,
//                     cursorColor: AppColor.black,
//                     obscureText: obscureFields[controllers.indexOf(controller)],
//                     keyboardAppearance: Brightness.light,
//                     style: AppFonts.bold16,
//                     decoration: InputDecoration(
//                       isDense: true,
//                       suffixIcon: IconButton(
//                         icon: obscureFields[controllers.indexOf(controller)]
//                             ? Icon(
//                                 Icons.visibility_off,
//                                 color: Colors.black,
//                               )
//                             : Icon(
//                                 Icons.visibility,
//                                 color: Color(0xFF6001d2),
//                               ),
//                         onPressed: () => setState(
//                           () => obscureFields[controllers.indexOf(controller)] =
//                               !obscureFields[controllers.indexOf(controller)],
//                         ),
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 12.0),
//                       border: InputBorder.none,
//                       hintText: LocalizationsUtil.of(context).translate(
//                           'password_must_be_at_least_six_characters'),
//                       hintStyle: AppFont.REGULAR_GREY,
//                       errorStyle: controllers.every((element) =>
//                                   !element.text.contains(whiteSpace) &&
//                                   element.text.length >= 6) &&
//                               controllers[1].text == controllers.last.text &&
//                               controllers.last.text.length >= 6 &&
//                               controllers[0].text != controllers[2].text
//                           ? TextStyle(color: Color(0xFF00aa7d))
//                           : null,
//                       enabledBorder: inputBorder,
//                       focusedBorder: inputBorder,
//                       focusedErrorBorder: inputBorder,
//                       errorBorder: inputBorder,
//                     ),
//                     onChanged: (value) => _checkValidate(),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     validator: (value) => generateErrorText(value, controller),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
