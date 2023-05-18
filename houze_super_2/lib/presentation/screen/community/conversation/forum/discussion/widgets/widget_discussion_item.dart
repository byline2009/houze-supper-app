import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/api/like_poll_api.dart';
import 'package:houze_super/presentation/common_widgets/sc_image_view.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/hex_color.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:intl/intl.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/widgets/widget_more_options.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/widgets/like_animate.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/comment/view/sc_comment.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/bloc/discussion_bloc.dart';


const String discussionKey = 'discussionKey';
const double ICON_SIZE = 24.0;
typedef void CallBackhandler(dynamic value);

class WidgetDiscussionItem extends StatefulWidget {
  final CallBackhandler? callback;
  final bool? isDisableHeader;
  final DiscussionModel? discussionModel;
  final DiscussionBloc? discussionBloc;
  final bool? isRenderedInDetailPage;
  final int? totalComments;
  final Function(bool)? blockUserCallback;
  const WidgetDiscussionItem(
      {Key? key,
      this.callback,
      this.isDisableHeader,
      this.discussionModel,
      this.isRenderedInDetailPage,
      this.totalComments,
      this.discussionBloc,
      this.blockUserCallback})
      : super(key: key);

  @override
  _WidgetPollItemState createState() => _WidgetPollItemState();
}

class _WidgetPollItemState extends State<WidgetDiscussionItem> {
  bool _collapseDescriptionText = true;
  bool _isLoadLike = false;
  String? currentUserId = Storage.getUserID();
  final DiscussionController _controller = DiscussionController();

  @override
  void initState() {
    super.initState();
  }

  _onCallBack(dynamic value) {
    if (widget.callback != null) {
      widget.callback!(widget.discussionModel?.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([_controller]),
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            padding: widget.isDisableHeader == false
                ? const EdgeInsets.only(left: 20, right: 20, top: 20)
                : const EdgeInsets.only(left: 20, right: 20),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isDisableHeader == false) _discusionHeader(context),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tagDiscussion(widget.discussionModel?.category ?? 0),
                    Text(
                      "${DateFormat('HH:mm').format(DateTime.parse(widget.discussionModel?.publishedDate).toLocal())} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.discussionModel?.publishedDate).toLocal())}",
                      style: TextStyle(
                          color: Color(0xff838383),
                          fontSize: 13.0,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            widget.discussionModel?.description ?? '',
                            maxLines:
                                _collapseDescriptionText == false ? 100 : 2,
                            //style: AppFonts.regular15,
                            style: AppFonts.regular15,
                          ),
                        ),
                        if (_checkDescriptionLength(
                                widget.discussionModel?.description ?? "") ==
                            true)
                          _collapseDescText(),
                      ],
                    ),
                  ],
                ),
                if (widget.discussionModel?.images != null &&
                    widget.discussionModel!.images!.length > 0)
                  _discussionImage(context),
                const SizedBox(
                  height: 15.0,
                ),
                _likeAndCommentSection(
                    discussionModel: widget.discussionModel!),
                const SizedBox(
                  height: 25.0,
                ),
              ],
            ),
          );
        });
  }

  Widget _discusionHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                  child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                child: Stack(
                  children: <Widget>[
                    widget.discussionModel?.user?.imageThumb == null
                        ? CircleAvatar(
                            radius: 20.0,
                            child: SvgPicture.asset(
                              "assets/svg/gender/avt-${widget.discussionModel!.user?.gender != null ? widget.discussionModel!.user!.gender : 'O'}.svg",
                            ),
                          )
                        : CachedImageWidget(
                            cacheKey: 'avatarKey',
                            imgUrl:
                                widget.discussionModel!.user?.imageThumb ?? "",
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
                    (widget.discussionModel?.displayType ?? 0) ==
                            AppConstant.DISPLAY_NAME
                        ? widget.discussionModel!.user?.fullname ?? ""
                        : '0' +
                            widget.discussionModel!.user!.phoneNumber
                                .toString()
                                .substring(0, 6) +
                            '***',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            if (currentUserId == widget.discussionModel!.userId)
              MoreOptions(
                callback: _onCallBack,
                isRenderedInDetailPage: widget.isRenderedInDetailPage,
                discussionBloc: widget.discussionBloc,
                discussionModel: widget.discussionModel,
                isOtherOption: false,
              )
            else
              MoreOptions(
                callback: _onCallBack,
                isRenderedInDetailPage: widget.isRenderedInDetailPage,
                discussionBloc: widget.discussionBloc,
                discussionModel: widget.discussionModel,
                isOtherOption: true,
                blockUserCallback: (value) {
                  if (value) {
                    if (value) {
                      widget.blockUserCallback!(true);
                    } else {
                      widget.blockUserCallback!(false);
                    }
                  }
                },
              )
          ],
        )
      ],
    );
  }

  Widget _discussionImage(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 40;
    return GestureDetector(
      onTap: () {
        AppRouter.pushDialog(
          context,
          AppRouter.imageViewPage,
          ImageViewPageArgument(
              images: widget.discussionModel!.images!.map((i) {
            return i.image!;
          }).toList()),
        );
      },
      child: Stack(
        children: <Widget>[
          Container(
            child: CachedImageWidget(
              cacheKey: discussionKey,
              imgUrl: widget.discussionModel!.images![0].image!,
              width: width,
              height: width * 0.65,
            ),
          ),
          Positioned(
            bottom: 12,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppVectors.icDisableAttachImage,
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  Text(
                    '${widget.discussionModel!.images!.length}',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
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
          // style: AppFonts.semibold13.copyWith(
          //   color: Color(0xff6001d2),
          // ),
          style: AppFont.SEMIBOLD_PURPLE_6001d2_13,
        ),
      ),
    );
  }

  _checkDescriptionLength(String str) {
    if (str.length > 120) {
      return true;
    }
    return false;
  }

  void _toggleLike({required DiscussionModel discussionModel}) async {
    HapticFeedback.heavyImpact();
    if (_isLoadLike == false) {
      _isLoadLike = true;
      LikePollAPI().likePoll(threadId: discussionModel.id ?? "").then((value) {
        if (value != null) {
          LikeModel likeModel = value;
          setState(() {
            widget.discussionModel?.likeCount = likeModel.likeCount;
            discussionModel.hasLike = likeModel.hasLike;
            _isLoadLike = false;
          });
        }
      }).catchError((onError) {
        _isLoadLike = false;
      });
    }

    setState(() {
      discussionModel.hasLike = !discussionModel.hasLike!;
    });
  }

  _updateCommentCount({required int count}) {
    widget.discussionBloc!.add(UpdateCommentQuantity(
        id: widget.discussionModel?.id ?? "", quantity: count));
  }

  _navigateToCommentPage() {
    AppRouter.push(
        context,
        AppRouter.SOCIAL_COMMENT_PAGE,
        SocialCommentScreenArgument(
            threadId: widget.discussionModel?.id ?? "",
            callback: _updateCommentCount,
            renderedInDiscussion: true));
  }

  Widget _likeAndCommentSection({required DiscussionModel discussionModel}) {
    return Container(
      child: Row(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: LikeAnimate(
                  isLike: widget.discussionModel?.hasLike == false,
                  press: () {
                    //Firebase Analytics
                    GetIt.instance<FBAnalytics>().sendEventReactDiscussion(
                        userID: Storage.getUserID() ?? "");
                    _toggleLike(discussionModel: discussionModel);
                    _controller.updateLike();
                  },
                ),
              ),
              Text(
                widget.discussionModel!.likeCount.toString(),
                //style: AppFonts.medium14.copyWith(color: Colors.black),
                style: AppFonts.medium14,
              )
            ],
          ),
          const SizedBox(
            width: 20.0,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.padded,
              padding: EdgeInsets.all(0),
            ),
            onPressed: () {
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
                  widget.totalComments != null &&
                          (widget.totalComments ?? 0) > 0
                      ? widget.totalComments.toString()
                      : widget.discussionModel!.commentCount.toString(),
                  //style: AppFonts.medium14.copyWith(color: Colors.black),
                  style: AppFonts.medium14,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tagDiscussion(int category) {
    switch (category) {
      case AppConstant.CATEGORY_GENERAL:
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xfff5f5f5),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Text(
            LocalizationsUtil.of(context).translate('general_discussion'),
            style: TextStyle(
                color: Colors.black,
                fontSize: 13.0,
                fontWeight: FontWeight.w600),
          ),
        );
      case AppConstant.CATEGORY_BUY:
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: HexColor('#ffe0b2'),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Text(
            LocalizationsUtil.of(context).translate('need_to_buy'),
            style: TextStyle(
                color: Color(0xffe3a500),
                fontSize: 13.0,
                fontWeight: FontWeight.w600),
          ),
        );
      case AppConstant.CATEGORY_SELL:
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Color(0xfff2e8ff),
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          child: Text(
            LocalizationsUtil.of(context).translate('for_sale'),
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 13.0,
                fontWeight: FontWeight.w600),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class DiscussionController extends ChangeNotifier {
  bool isLike = true;

  void updateLike() {
    isLike = !isLike;
    notifyListeners();
  }
}
