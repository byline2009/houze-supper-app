import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/view/sc_comment.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/widgets/like_animate.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/bloc/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/view/sc_voting_detail.dart';
import 'package:houze_super/utils/constants/app_constants.dart';
import 'package:houze_super/utils/constants/app_fonts.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:intl/intl.dart';
import '../../../index.dart';

const String pollKey = 'pollKey';
const double ICON_SIZE = 24.0;

class WidgetPollItem extends StatefulWidget {
  final PollModel pollModel;
  final PollBloc pollBloc;
  const WidgetPollItem({Key key, this.pollModel, this.pollBloc})
      : super(key: key);

  @override
  _WidgetPollItemState createState() => _WidgetPollItemState();
}

class _WidgetPollItemState extends State<WidgetPollItem> {
  bool _collapseDescriptionText = true;
  Future _serviceConverter;
  @override
  void initState() {
    _serviceConverter = ServiceConverter.getTextToConvert("building_manager");
    super.initState();
  }

  String _getDate(PollModel model) {
    return "${DateFormat('HH:mm').format(DateTime.parse(model.publishedDate).toLocal())} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(model.publishedDate).toLocal())}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5.0),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Container(
                    child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  child: Stack(
                    overflow: Overflow.clip,
                    children: <Widget>[
                      CachedImageWidget(
                        cacheKey: pollKey,
                        imgUrl: widget.pollModel.user.imageThumb ?? "",
                        width: 40.0,
                        height: 40.0,
                      ),
                    ],
                  ),
                )),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pollModel.user.fullname,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    FutureBuilder(
                        future: _serviceConverter,
                        builder: (ctx, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return CupertinoActivityIndicator();
                          }
                          return Text(
                            widget.pollModel.user.role.length > 0
                                ? widget.pollModel.user.role
                                : LocalizationsUtil.of(context)
                                    .translate(snap.data),
                            style: TextStyle(
                                color: Color(0xff838383),
                                fontSize: 13.0,
                                fontWeight: FontWeight.w600),
                          );
                        }),
                  ],
                ),
              ),
              widget.pollModel.publishedDate != null
                  ? Text(
                      _getDate(widget.pollModel),
                      style: TextStyle(
                          color: Color(0xff838383),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 10.0),
                child: Text(
                  widget.pollModel.title,
                  style: AppFonts.bold15,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Text(
                      widget.pollModel.description,
                      maxLines: _collapseDescriptionText == false ? 30 : 2,
                      style: AppFonts.regular15,
                    ),
                  ),
                  _checkDescriptionLength(widget.pollModel.description)
                      ? _collapseDescText()
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
          _pollSection(),
          SizedBox(
            height: 25.0,
          ),
          _likeAndCommentSection(pollModel: widget.pollModel),
          SizedBox(
            height: 25.0,
          ),
        ],
      ),
    );
  }

  _updateTotalComment({int count}) {
    if (count > widget.pollModel.commentCount) {
      widget.pollBloc
          .add(UpdateTotalComment(id: widget.pollModel.id, total: count));
    }
  }

  _navigateToCommentPage() async {
    AppRouter.push(
        context,
        AppRouter.SOCIAL_COMMENT_PAGE,
        SocialCommentScreenArgument(
            threadId: widget.pollModel.id,
            callback: _updateTotalComment,
            renderedInDiscussion: false));
  }

  Widget _collapseDescText() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _collapseDescriptionText = !_collapseDescriptionText;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Text(
              _collapseDescriptionText == false
                  ? LocalizationsUtil.of(context).translate('see_less')
                  : LocalizationsUtil.of(context).translate('more'),
              style: AppFonts.semibold13.copyWith(color: Color(0xff6001d2))),
        ));
  }

  _checkDescriptionLength(String str) {
    if (str.length > 120) {
      return true;
    }
    return false;
  }

  _percentVote(int numA, int numB) {
    if (numA != 0 && numB != 0) {
      return int.parse(((numA / numB) * 100).toStringAsFixed(0)).toString();
    }
    return "0";
  }

  int _totalVote() {
    var total = 0;
    for (int i = 0; i < widget.pollModel.poll.choices.length; i++) {
      total += widget.pollModel.poll.choices[i].choiceCount;
    }
    return total;
  }

  _linearProgressIndicatorValue(int numA, int numB) {
    if (numA != 0 && numB != 0) {
      return double.parse(((numA / numB)).toStringAsFixed(1));
    }
    return 0.0;
  }

  Widget _pollSection() {
    return widget.pollModel.poll.choices.length > 0
        ? Container(
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Color(0xfff5f5f5),
            ),
            child: Column(
              children: [
                ListView.builder(
                  padding: const EdgeInsets.all(0),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.pollModel.poll.choices.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: index != widget.pollModel.poll.choices.length - 1
                          ? const EdgeInsets.only(bottom: 20.0)
                          : const EdgeInsets.only(bottom: 0.0),
                      child: _optionSection(index),
                    );
                  },
                ),
                _voteButton()
              ],
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _optionSection(int index) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "${widget.pollModel.poll.choices[index].description}: ",
              style: AppFonts.semibold.copyWith(
                fontSize: 13,
              ),
            ),
            Expanded(
                child: Text(
              "${widget.pollModel.poll.choices[index].choiceCount} " +
                  LocalizationsUtil.of(context).translate('vote'),
              style: AppFonts.semibold13.copyWith(color: Color(0xff6001d2)),
            )),
            Text(
              _percentVote(widget.pollModel.poll.choices[index].choiceCount,
                      _totalVote()) +
                  "%",
              style: AppFonts.semibold.copyWith(
                fontSize: 13,
              ),
            )
          ],
        ),
        SizedBox(
          height: 5.0,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: LinearProgressIndicator(
            minHeight: 5.0,
            value: _linearProgressIndicatorValue(
                widget.pollModel.poll.choices[index].choiceCount, _totalVote()),
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(0xff6001d2),
            ),
          ),
        )
      ],
    );
  }

  Widget _voteButton() {
    if (widget.pollModel.canVote == true && widget.pollModel.status == 1) {
      return GestureDetector(
        onTap: () {
          _navigateToVotingDetail(context);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 30.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: Center(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate('participate_in_voting'),
                  style: AppFonts.bold.copyWith(fontSize: 16),
                ),
              ),
            ),
          ),
        ),
      );
    } else if (widget.pollModel.status == 2) {
      return GestureDetector(
        onTap: () {
          _navigateToVotingDetail(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
          child: Text(LocalizationsUtil.of(context).translate('voting_is_over'),
              style: AppFonts.bold.copyWith(fontSize: 16)),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _navigateToVotingDetail(BuildContext context) async {
    final rs = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return VotingDetailScreen(
            arg: VotingDetailArguments(
                threadID: widget.pollModel.id, model: widget.pollModel),
          );
        },
        settings: RouteSettings(name: AppRouter.VOTING_DETAIL_PAGE),
        maintainState: false,
      ),
    );
    if (rs != null) {
      print("===============> Model: ${json.encode(rs)}");
      widget.pollBloc
          .add(UpdatePollChoices(id: widget.pollModel.id, model: rs.poll));
    }
  }

  void _toggleLikePoll({PollModel pollModel}) async {
    HapticFeedback.heavyImpact();
    setState(() {
      if (pollModel.hasLike) {
        LikePollAPI().likePoll(threadId: pollModel.id).then((value) {
          if (value != null) {
            LikeModel likeModel = value;
            setState(() {
              widget.pollModel.likeCount = likeModel.likeCount;
            });
          }
        });
        pollModel.hasLike = false;
      } else {
        LikePollAPI().likePoll(threadId: pollModel.id).then((value) {
          if (value != null) {
            LikeModel likeModel = value;
            setState(() {
              widget.pollModel.likeCount = likeModel.likeCount;
            });
          }
        });
        pollModel.hasLike = true;
      }
    });
  }

  Widget _likeAndCommentSection({PollModel pollModel}) {
    return Container(
      child: Row(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: LikeAnimate(
                  isLike: widget.pollModel.hasLike == false,
                  press: () {
                    _toggleLikePoll(pollModel: pollModel);
                  },
                ),
              ),
              Text(
                widget.pollModel.likeCount.toString(),
                style: AppFonts.medium14.copyWith(color: Colors.black),
              )
            ],
          ),
          SizedBox(
            width: 20.0,
          ),
          GestureDetector(
            onTap: () {
              _navigateToCommentPage();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: SvgPicture.asset(
                    AppVectors.icComment,
                    width: ICON_SIZE,
                    height: ICON_SIZE,
                  ),
                ),
                Text(
                  pollModel.commentCount.toString(),
                  style: AppFonts.medium14.copyWith(color: Colors.black),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
