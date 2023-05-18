import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/index.dart';

import '../../../../../../common_widgets/button_widget.dart';
import '../../discussion/bloc/report_bloc.dart';
import '../../discussion/bloc/report_state.dart';

typedef void ReportSendRequest(String reportContent);

class ReportBottomSheet extends StatefulWidget {
  final ReportBloc reportBloc;
  final FocusNode focusNode;
  final TextEditingController controller;
	final ReportSendRequest callback;

  ReportBottomSheet(this.reportBloc,
      {Key? key, FocusNode? focusNode, TextEditingController? controller, required this.callback})
      : this.focusNode = focusNode ?? FocusNode(),
        this.controller = controller ?? TextEditingController(),
        super(key: key);

  @override
  State<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends State<ReportBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  StreamController<ButtonSubmitEvent> _sendButtonController =
      StreamController<ButtonSubmitEvent>.broadcast();
  bool? _isActive;

  @override
  void initState() {
    _sendButtonController.sink.add(ButtonSubmitEvent(false));

    widget.controller.addListener(() {
      if (widget.controller.text.trim().length > 0) {
        setState(() {
          this._isActive = true;
        });
      } else {
        this._isActive = null;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _sendButtonController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;

    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return GestureDetector(
          onTap: () {
            //FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SafeArea(
						child: Container(
							padding: EdgeInsets.only(
									bottom: MediaQuery.of(context).viewInsets.bottom),
							color: Color(0xff737373),
							child: Container(
								decoration: const BoxDecoration(
										color: Colors.white,
										borderRadius: BorderRadius.only(
											topLeft: Radius.circular(20),
											topRight: Radius.circular(20),
										)),
								padding: const EdgeInsets.symmetric(vertical: 14),
								height: (300 / 667) * _screenSize.height,
								child: BlocBuilder(
									bloc: widget.reportBloc,
									builder: (context, reportState) {
										if (reportState is ReportInitial) {
											return AnimatedContainer(
												curve: Curves.easeOutQuad,
												duration: Duration(milliseconds: 250),
												child: Stack(
													children: [
														Column(
															mainAxisAlignment: MainAxisAlignment.start,
															crossAxisAlignment: CrossAxisAlignment.start,
															mainAxisSize: MainAxisSize.max,
															children: <Widget>[
																const _ReportBottomSheetHeader(),
																const SizedBox(
																	height: 20.0,
																),
																Padding(
																	padding: EdgeInsets.only(left: 20),
																	child: Text(
																		LocalizationsUtil.of(context)
																				.translate("report_content"),
																		style: AppFonts.medium16,
																	),
																),
																Padding(
																	padding: const EdgeInsets.only(left: 20.0),
																	child: Form(
																		key: _formKey,
																		child: TextField(
																			autofocus: true,
																			focusNode: widget.focusNode,
																			controller: widget.controller,
																			decoration: InputDecoration(
																				border: InputBorder.none,
																				hintText: LocalizationsUtil.of(context)
																						.translate("input_description_here"),
																				hintStyle: AppFont.MEDIUM_GRAY_9C9C9C_11
																						.copyWith(
																								fontSize:
																										18.0), //MEDIUM_GRAY_9C9C9C_18,
																				labelStyle: AppFonts.medium18.copyWith(
																						letterSpacing: 0.29,
																						fontWeight: FontWeight.w500),
																			),
																			keyboardType: TextInputType.multiline,
																			maxLines: 5,
																			onChanged: (String value) {
																				if (value.trim().isEmpty == false) {
																					_formKey.currentState!.validate();
																					_sendButtonController.sink
																							.add(ButtonSubmitEvent(true));
																				} else {
																					_sendButtonController.sink
																							.add(ButtonSubmitEvent(false));
																				}
																			},
																		),
																	),
																),
																Expanded(
																	child: Container(
																		padding: const EdgeInsets.symmetric(
																				horizontal: 20.0),
																		alignment: Alignment.bottomCenter,
																		child: ButtonWidget(
																			callback: () async {
																				if (_formKey.currentState!.validate()) {
																					widget.callback.call(widget.controller.text);
																				}
																			},
																			defaultHintText:
																					LocalizationsUtil.of(context)
																							.translate("send_report"),
																			isSimple: true,
																			controller: _sendButtonController,
																			isActive: this._isActive ?? false,
																		),
																	),
																),
																const SizedBox(
																	height: 30,
																),
															],
														),
														const _CloseReportBottomSheet()
													],
												),
											);
										}
										if (reportState is ReportLoading) {
											return Stack(
												children: [
													Column(
														mainAxisSize: MainAxisSize.max,
														children: <Widget>[
															const _ReportBottomSheetHeader(),
															Container(
																height: 1,
																width: _screenSize.width,
																color: Color(0xffdcdcdc),
															),
															const SizedBox(
																height: 20.0,
															),
															Padding(
																padding: const EdgeInsets.only(top: 20.0),
																child: const CupertinoActivityIndicator(),
															),
														],
													),
													_CloseReportBottomSheet()
												],
											);
										}
										if (reportState is ReportSuccessful) {
											return Stack(
												children: [
													Column(
														mainAxisSize: MainAxisSize.max,
														children: <Widget>[
															const _ReportBottomSheetHeader(),
															const SizedBox(
																height: 20.0,
															),
															SvgPicture.asset(
																	'assets/svg/community/ic-report-post.svg',
																	height: 40,
																	width: 40),
															Text(
																	LocalizationsUtil.of(context)
																			.translate("send_report_successfully"),
																	style: TextStyle(
																			fontSize: 18, fontWeight: FontWeight.w500))
														],
													),
													const _CloseReportBottomSheet()
												],
											);
										}
										if (reportState is ReportFailure) {
											return Stack(
												children: [
													Column(
														mainAxisSize: MainAxisSize.max,
														children: <Widget>[
															const _ReportBottomSheetHeader(),
															const SizedBox(
																height: 20.0,
															),
															SvgPicture.asset(
																'assets/svg/community/ic-report-post.svg',
																height: 40,
																width: 40,
															),
															Text(
																	LocalizationsUtil.of(context).translate(
																			'there_is_an_issue_please_try_again_later_0'),
																	style: TextStyle(
																			fontSize: 18, fontWeight: FontWeight.w500))
														],
													),
													const _CloseReportBottomSheet(),
												],
											);
										}
										return const SizedBox.shrink();
									},
								),
							),
						),
					),
        );
      },
    );
  }
}

class _ReportBottomSheetHeader extends StatelessWidget {
  const _ReportBottomSheetHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            LocalizationsUtil.of(context).translate("report"),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

class _CloseReportBottomSheet extends StatelessWidget {
  const _CloseReportBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: ElevatedButton(
        style: ButtonStyle(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: MaterialStateProperty.resolveWith((states) => 0),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0.0)),
          overlayColor:
              MaterialStateColor.resolveWith((states) => Colors.transparent),
          backgroundColor:
              MaterialStateProperty.resolveWith((states) => Colors.white),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: SvgPicture.asset(AppVectors.icClose),
      ),
    );
  }
}
