import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/bottom_sheet/header_bottom_sheet.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/empty_page.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/list_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton_config.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton_theme.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/voting_bloc.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/voting_event.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_repo.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/widget/widget_confirm_dialog.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/widget/widget_poll_item.dart';
import 'package:houze_super/presentation/screen/home/home_tab/style/style_hone_page.dart';
import 'package:houze_super/utils/index.dart';

class ActionType {
  final String id;
  final String choice;
  const ActionType({this.id, this.choice});
}

class VoteInfo {
  final userChoiceID;
  final String apartmentName;
  final bool isVoted;
  final CurrentUser currentUser;
  final User user;
  final int role;
  final int currentRole;
  final Choice choice;
  const VoteInfo(
      {this.apartmentName,
      this.isVoted,
      this.currentUser,
      this.user,
      this.role,
      this.currentRole,
      this.choice,
      this.userChoiceID});
}

class VotingDetailArguments {
  final String threadID;
  final PollModel model;
  const VotingDetailArguments({this.threadID, this.model});
}

class VotingDetailScreen extends StatefulWidget {
  final VotingDetailArguments arg;
  const VotingDetailScreen({Key key, this.arg}) : super(key: key);

  @override
  _VotingDetailScreenState createState() => _VotingDetailScreenState();
}

class _VotingDetailScreenState extends State<VotingDetailScreen> {
  final _votingBloc = VotingBloc();
  int currentIndexActivity = 0;
  int currentApartment = 0;
  String agreeID;
  String disagreeID;
  List<ActionType> _listActionType = [];
  final ProgressHUD _progressToolkit = Progress.instanceCreateWithNormal();
  final _pollRepo = PollRepository();
  VotingModel _model;
  Future _apartmentInformation;
  Future _apartmentAreaWithColon;
  Future _apartmentVoteDoneMsg;
  Future _changeApartment;
  Future _apartmentWithColon;

  _getListOption() {
    if (widget.arg.model.poll.choices.length > 0) {
      for (int i = 0; i < widget.arg.model.poll.choices.length; i++) {
        _listActionType.add(ActionType(
            id: widget.arg.model.poll.choices[i].id,
            choice: widget.arg.model.poll.choices[i].description ?? ""));
      }
    }
  }

  @override
  void initState() {
    _votingBloc.add(GetUserChoiceEvent(id: widget.arg.threadID));
    _apartmentInformation =
        ServiceConverter.getTextToConvert("apartment_information");
    _apartmentAreaWithColon =
        ServiceConverter.getTextToConvert("apartment_area_with_colon");
    _apartmentVoteDoneMsg =
        ServiceConverter.getTextToConvert("apartment_vote_done_msg");
    _changeApartment = ServiceConverter.getTextToConvert("change_apartment");
    _apartmentWithColon =
        ServiceConverter.getTextToConvert("apartment_with_colon");
    _getListOption();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _appbar(),
          body: SafeArea(
            child: BlocProvider(
              create: (_) => _votingBloc,
              child: BlocBuilder<VotingBloc, List<VotingModel>>(
                builder:
                    (BuildContext context, List<VotingModel> _votingModel) {
                  if (_votingModel == null) {
                    return Center(
                        child: Text(LocalizationsUtil.of(context)
                            .translate("lost_connection")));
                  }

                  if (!_votingBloc.isNext &&
                      _votingModel != null &&
                      _votingModel.length == 0) {
                    return EmptyPage(
                      svgPath: AppVectors.icFacility,
                      content: 'there_is_no_information',
                    );
                  }

                  if (_votingModel.length > 0) {
                    List<VoteInfo> _listApartment = [];
                    for (int i = 0; i < _votingModel.length; i++) {
                      _listApartment.add(VoteInfo(
                          apartmentName: _votingModel[i].apartmentName,
                          isVoted:
                              _votingModel[i].choice != null ? true : false,
                          currentUser: _votingModel[i].currentUser,
                          user: _votingModel[i].user,
                          role: _votingModel[i].role,
                          currentRole: _votingModel[i].currentRole,
                          choice: _votingModel[i].choice ?? null,
                          userChoiceID: _votingModel[i].id));
                    }

                    //remove duplicate apartment
                    Map<String, VoteInfo> _list = {};
                    for (var item in _listApartment) {
                      _list[item.apartmentName] = item;
                    }
                    _listApartment.clear();
                    _listApartment.addAll(_list.values.toList());

                    return Stack(
                      children: [
                        ListView(
                          padding: const EdgeInsets.only(bottom: 100.0),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0,
                                  left: 20.0,
                                  bottom: 15.0,
                                  right: 20.0),
                              child: Text(
                                _votingModel[currentApartment].title,
                                style: AppFonts.medium16
                                    .copyWith(letterSpacing: 0.26),
                              ),
                            ),
                            _apartmentInfoSection(
                              _listApartment,
                              _votingModel[currentApartment].buildingName,
                            ),
                            _userInfoSection(_votingModel[currentApartment]),
                            Container(
                              height: 50.0,
                              width: double.infinity,
                              padding: const EdgeInsets.only(left: 20.0),
                              color: Color(0xfff5f5f5),
                              child: Row(
                                children: [
                                  Text(
                                    LocalizationsUtil.of(context)
                                        .translate("option"),
                                    style: AppFonts.medium
                                        .copyWith(color: Color(0xff808080)),
                                  ),
                                ],
                              ),
                            ),
                            _selectionSection(_listApartment),
                          ],
                        ),
                        _listApartment[currentApartment].isVoted == false
                            ? _submitButton(_listApartment)
                            : const SizedBox.shrink(),
                      ],
                    );
                  }

                  return VotingLoading();
                },
              ),
            ),
          ),
        ),
        _progressToolkit
      ],
    );
  }

  Widget _apartmentInfoSection(List<VoteInfo> list, String building) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 50.0,
      width: double.infinity,
      color: Color(0xfff5f5f5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
              future: _apartmentInformation,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                return Text(
                  LocalizationsUtil.of(context).translate(snap.data),
                  style: AppFonts.medium.copyWith(color: Color(0xff808080)),
                );
              }),
          GestureDetector(
            onTap: () {
              _showModalBottomSheet(
                  contextParent: context,
                  listApartment: list,
                  building: building);
            },
            child: Row(
              children: [
                Text(
                  list[this.currentApartment].apartmentName,
                  style: AppFonts.medium14.copyWith(color: Color(0xff6001d2)),
                ),
                SizedBox(
                  width: 5.0,
                ),
                SvgPicture.asset(AppVectors.icDropDown,
                    height: 16.0, width: 16.0),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _userInfoSection(VotingModel model) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: Stack(
                    overflow: Overflow.clip,
                    children: <Widget>[
                      model.currentUser.imageThumb != null
                          ? CachedImageWidget(
                              cacheKey: pollKey,
                              imgUrl: model.currentUser.imageThumb,
                              width: 40.0,
                              height: 40.0,
                            )
                          : CircleAvatar(
                              radius: 20.0,
                              child: SvgPicture.asset(
                                "assets/svg/gender/avt-${model.currentUser.gender != null ? model.currentUser.gender : 'O'}.svg",
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(model.currentUser.fullname, style: AppFonts.bold15),
            ],
          ),
          _fieldDetail(
              key: LocalizationsUtil.of(context).translate("role_with_colon"),
              value: _role(model.currentRole)),
          FutureBuilder(
              future: _apartmentAreaWithColon,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                return _fieldDetail(
                    key: LocalizationsUtil.of(context).translate(snap.data),
                    value: model.apartmentArea.toString() + " m2");
              }),
          _fieldDetail(
              key: LocalizationsUtil.of(context)
                  .translate("vote_in_exchange_with_colon"),
              value: model.point.toString() +
                  " ${LocalizationsUtil.of(context).translate("vote")}"),
        ],
      ),
    );
  }

  Widget _fieldDetail({String key, String value}) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: AppFonts.regular15.copyWith(
              color: Color(0xff838383),
            ),
          ),
          Text(
            value,
            style: AppFonts.bold15,
          )
        ],
      ),
    );
  }

  Widget _optionField(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, bottom: 30.0, left: 10.0),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2,
            child: Radio(
              value: _listActionType[index].id,
              activeColor: Color(0xff6001d2),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              hoverColor: Color(0xff6001d2),
              focusColor: Color(0xff6001d2),
              onChanged: (_) async {
                setState(() {
                  currentIndexActivity = index;
                });
              },
              groupValue: _listActionType[currentIndexActivity].id,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            _listActionType[index].choice,
            style: AppFonts.medium14.copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }

  Widget _selectionSection(List<VoteInfo> listApartment) {
    return listApartment[currentApartment].isVoted == false
        ? Container(
            child: Column(
              children: [
                widget.arg.model.status != 2 // check if voting is over
                    ? ListView.builder(
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listActionType.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                currentIndexActivity = index;
                              });
                            },
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  _optionField(index),
                                  Container(
                                    color: Color(0xfff5f5f5),
                                    height: 1.0,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: Text(
                            LocalizationsUtil.of(context)
                                .translate('voting_is_over'),
                            style: AppFonts.bold.copyWith(fontSize: 25.0)),
                      ),
              ],
            ),
          )
        : _isVotedSection(listApartment[currentApartment]);
  }

  Widget _isVotedSection(VoteInfo info) {
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppVectors.icVoteSuccess,
                width: 16.0,
                height: 16.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              FutureBuilder(
                future: _apartmentVoteDoneMsg,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    LocalizationsUtil.of(context).translate(snap.data),
                    style: TextStyle(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff00aa7d)),
                  );
                },
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
              child: Column(
                children: [
                  Text(
                    info.choice.description,
                    style: AppFonts.bold24,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalizationsUtil.of(context).translate('performer'),
                        style: AppFonts.regular15.copyWith(
                          color: Color(0xff838383),
                        ),
                      ),
                      Text(info.user.fullname, style: AppFonts.bold15)
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalizationsUtil.of(context)
                            .translate('role_with_colon'),
                        style: AppFonts.regular15.copyWith(
                          color: Color(0xff838383),
                        ),
                      ),
                      Text(_role(info.role), style: AppFonts.bold15)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String _role(int role) {
    if (role == 0) {
      return LocalizationsUtil.of(context).translate('resident');
    }
    if (role == 1) {
      return LocalizationsUtil.of(context).translate('tenant');
    }
    if (role == 2) {
      return LocalizationsUtil.of(context).translate('owner');
    }
    return "";
  }

  Widget _appbar() {
    return AppBar(
        title: Text(
          LocalizationsUtil.of(context).translate('voting'),
          style: AppFonts.semibold18,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
  }

  Widget _submitButton(List<VoteInfo> list) {
    if (widget.arg.model.status == 2) {
      return const SizedBox.shrink();
    }
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ButtonWidget(
          defaultHintText:
              LocalizationsUtil.of(context).translate('submit_your_vote'),
          callback: () {
            showConfirmActivityDialog(list);
          },
          isActive: true,
        ),
      ),
    );
  }

  _showModalBottomSheet(
      {BuildContext contextParent,
      List<VoteInfo> listApartment,
      String building}) {
    showModalBottomSheet(
      context: contextParent,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      builder: (context) {
        return SafeArea(
          maintainBottomViewPadding: true,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(StyleHomePage.borderRadius),
                topRight: Radius.circular(
                  StyleHomePage.borderRadius,
                ),
              ),
            ),
            height: StyleHomePage.bottomSheetHeight(context),
            child: Column(
              children: [
                FutureBuilder(
                    future: _changeApartment,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      return HeaderBottomSheet(
                          title: LocalizationsUtil.of(context)
                              .translate(snap.data),
                          parentContext: contextParent);
                    }),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    primary: false,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: listApartment.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentApartment = index;
                            Navigator.of(context).pop();
                          });
                        },
                        child: Container(
                          decoration: BaseWidget.dividerBottom(
                              height: 1, color: Color(0xfff5f5f5)),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          margin: const EdgeInsets.only(
                            left: 15,
                          ),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 1.2,
                                child: Radio(
                                  value: listApartment[index].apartmentName,
                                  activeColor: Color(0xff6001d2),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  hoverColor: Color(0xff6001d2),
                                  focusColor: Color(0xff6001d2),
                                  onChanged: (_) async {
                                    setState(() {
                                      currentApartment = index;
                                      Navigator.of(context).pop();
                                    });
                                  },
                                  groupValue: listApartment[currentApartment]
                                      .apartmentName,
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    building,
                                    style: AppFonts.medium14
                                        .copyWith(color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Row(
                                    children: [
                                      FutureBuilder(
                                        future: _apartmentWithColon,
                                        builder: (context, snap) {
                                          if (snap.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            LocalizationsUtil.of(context)
                                                .translate(snap.data),
                                            style: AppFonts.regular13.copyWith(
                                              color: Color(0xff838383),
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(
                                        width: 2.0,
                                      ),
                                      Text(
                                        listApartment[index].apartmentName,
                                        style: AppFonts.medium14
                                            .copyWith(color: Colors.black),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showConfirmActivityDialog(List<VoteInfo> list) {
    AppDialog.showContentDialog(
      context: context,
      child: WidgetConfirmDialog(
        parentContext: context,
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
            children: <TextSpan>[
              TextSpan(
                  text: LocalizationsUtil.of(context)
                          .translate('voting_confirm_msg1') +
                      ' '),
              TextSpan(
                  style: AppFonts.bold15,
                  text: LocalizationsUtil.of(context).translate(
                          _listActionType[currentIndexActivity].choice) +
                      "\n"),
              TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('voting_confirm_msg2')),
            ],
          ),
        ),
        confirmCallback: () async {
          Navigator.pop(context);
          _progressToolkit.state.show();
          try {
            final rs = await _pollRepo.sendVote(
                userChoiceID: list[this.currentApartment].userChoiceID,
                choiceID: _listActionType[currentIndexActivity].id);

            if (rs != null) {
              showSuccessDialog(context: context);
              this._model = rs;
            }
          } catch (err) {
            if (<DioErrorType>[
              DioErrorType.DEFAULT,
              DioErrorType.CONNECT_TIMEOUT,
              DioErrorType.RECEIVE_TIMEOUT,
            ].contains(err.type))
              DialogCustom.showErrorDialog(
                context: context,
                title: 'there_is_no_network',
                errMsg: 'please_check_your_network_and_try_connect_again',
                callback: () => Navigator.pop(context),
              );
            else
              DialogCustom.showErrorDialog(
                context: context,
                title: 'there_is_an_issue_please_try_again_later_1',
                errMsg: err.toString(),
                callback: () => Navigator.pop(context),
              );
          } finally {
            _progressToolkit.state.dismiss();
          }
        },
      ),
      closeShow: false,
      barrierDismissible: true,
    );
  }

  void showSuccessDialog({
    @required BuildContext context,
  }) {
    AppDialog.showContentDialog(
        context: context,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.43,
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    SvgPicture.asset(
                      AppVectors.icVote,
                      width: 80.0,
                      height: 80.0,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Text(LocalizationsUtil.of(context).translate('voting_success'),
                  textAlign: TextAlign.center,
                  style: AppFonts.bold.copyWith(fontSize: 18)),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                                .translate('voting_success_msg1') +
                            ' '),
                    TextSpan(
                        text: '\n' +
                            LocalizationsUtil.of(context)
                                .translate('voting_success_msg2')),
                  ],
                ),
              ),
              SizedBox(height: 40),
              WidgetButton.pink(
                LocalizationsUtil.of(context).translate('done_0'),
                callback: () async {
                  Navigator.pop(context);
                  if (this._model != null) {
                    //return data to previous page
                    Navigator.pop(context, this._model);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        closeShow: false,
        barrierDismissible: false);
  }
}

class VotingLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: ListSkeleton(
        length: 4,
        shrinkWrap: true,
        config: SkeletonConfig(
          isCircleAvatar: false,
          isShowAvatar: false,
          theme: SkeletonTheme.Light,
          bottomLinesCount: 2,
        ),
      ),
    );
  }
}
