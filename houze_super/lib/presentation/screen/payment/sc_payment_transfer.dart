import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/payment_bank_transfer_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_progress_indicator.dart';
import 'package:houze_super/presentation/screen/profile/widgets/personal_info_section.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/index.dart';

// Widgets
import 'package:houze_super/presentation/screen/payment/widgets/widget_message_box_QRCode.dart';
import 'package:houze_super/presentation/screen/payment/widgets/widget_manual_transfer_loading.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';

import 'package:houze_super/middle/model/token_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

import 'package:intl/intl.dart';

import 'bloc/payment/index.dart';
import 'bloc/payment/payment_bloc.dart';

//---SCREEN: Chuyển khoản thủ công---//

const String paymentTransferKey = 'paymentTransferKey';

class PaymentBankTransferArguments {
  final String id;
  final String buildingId;
  final String createdAt;
  final Function callback;

  PaymentBankTransferArguments({
    @required this.id,
    @required this.buildingId,
    @required this.createdAt,
    this.callback,
  });
}

class PaymentBankTransferScreen extends StatefulWidget {
  final PaymentBankTransferArguments args;

  PaymentBankTransferScreen(this.args);

  @override
  _PaymentBankTransferScreenState createState() =>
      _PaymentBankTransferScreenState();
}

class _PaymentBankTransferScreenState extends State<PaymentBankTransferScreen>
    with SingleTickerProviderStateMixin {
  final paymentBloc = PaymentBloc();
  final PaymentRepository paymentRepository = new PaymentRepository();
  Map<String, String> headers = new Map();
  final TokenModel tokens = Storage.getToken();

  AnimationController animationController;

  final _isProgressingSubject = StreamController<bool>.broadcast();
  int _countRequest = 0;
  final StreamController<bool> _imageLoadingController =
      StreamController<bool>();
  bool _isImageLoading = true;

  Stream<bool> get isProgressing => _isProgressingSubject.stream;

  int bankIndex = 0;

  final int nowTime = DateTime.now().millisecondsSinceEpoch;

  final int maxLevelClock = 300;

  int levelClock;

  PaymentBankTransfer bank;

  final _bankFields = <_BankField>[
    _BankField(
      bankCode: 'VCB',
      bankName: 'vcb_bank',
      assetPath: 'assets/images/payment/bank-vcb.png',
      assetActivePath: 'assets/images/payment/bank-vcb-active.png',
    ),
    _BankField(
      bankCode: 'ACB',
      bankName: 'acb_bank',
      assetPath: 'assets/images/payment/bank-acb.png',
      assetActivePath: 'assets/images/payment/bank-acb-active.png',
    ),
    _BankField(
      bankCode: 'TCB',
      bankName: 'tcb_bank',
      assetPath: 'assets/images/payment/bank-techcombank.png',
      assetActivePath: 'assets/images/payment/bank-techcombank-active.png',
    ),
    _BankField(
      bankCode: 'ICB',
      bankName: 'icb_bank',
      assetPath: 'assets/images/payment/bank-vtb.png',
      assetActivePath: 'assets/images/payment/bank-vtb-active.png',
    ),
    _BankField(
      bankCode: 'VBA',
      bankName: 'vba_bank',
      assetPath: 'assets/images/payment/bank-agribank.png',
      assetActivePath: 'assets/images/payment/bank-agribank-active.png',
    ),
    _BankField(
      bankCode: 'BIDV',
      bankName: 'bidv_bank',
      assetPath: 'assets/images/payment/bank-BIDV.png',
      assetActivePath: 'assets/images/payment/bank-BIDV-active.png',
    ),
    _BankField(
      bankCode: 'TPB',
      bankName: 'tpb_bank',
      assetPath: 'assets/images/payment/bank-TPBank.png',
      assetActivePath: 'assets/images/payment/bank-TPBank-active.png',
    ),
    _BankField(
      bankCode: 'VPB',
      bankName: 'vpb_bank',
      assetPath: 'assets/images/payment/bank-VPBank.png',
      assetActivePath: 'assets/images/payment/bank-VPBank-active.png',
    ),
  ];

  List<Field> fields = <Field>[];

  void backToMainPage() =>
      Navigator.of(Storage.scaffoldKey.currentContext).popUntil(
        (route) {
          if (!Navigator.of(Storage.scaffoldKey.currentContext).canPop()) {
            return true;
          }

          print("Route name: " + route.settings.name);
          // if (route.settings.name == AppRouter.MAIN_PAGE) {
          //   return true;
          // }
          return false;
        },
      );

  @override
  void initState() {
    super.initState();

    headers["Authorization"] = "Bearer ${tokens?.access}";

    if (widget.args.createdAt != null) {
      final int subTime = (nowTime -
              DateTime.parse(widget.args.createdAt).millisecondsSinceEpoch) ~/
          1000;

      if (subTime < maxLevelClock)
        levelClock = maxLevelClock - subTime;
      else
        levelClock = 0;
    } else {
      levelClock = maxLevelClock;
    }

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: levelClock),
    )..forward();
  }

  void clearCache() {
    DefaultCacheManager().emptyCache();

    imageCache?.clear();
    imageCache?.clearLiveImages();
  }

  @override
  void dispose() {
    animationController.dispose();
    clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('id: ${widget.args.id}');

    return HomeScaffold(
      title: 'manual_bank_transfer',
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder(
              cubit: paymentBloc,
              builder: (context, PaymentState state) {
                if (state is PaymentInitial)
                  paymentBloc.add(PaymentBankTransferEvent(
                      widget.args.id, widget.args.buildingId));

                if (state is PaymentBankTransferSuccessful) {
                  final List<PaymentBankTransfer> banks = state.banks;

                  bank ??= banks.first;

                  final PaymentInfoModel paymentInfo = state.paymentInfo;

                  final List<_BankField> bankFields = banks
                      .map((e) => _bankFields
                          .firstWhere((i) => i.bankCode == e.bankCode))
                      .toList();

                  fields = <Field>[
                    Field(
                      name: 'transfer_amount',
                      value: NumberFormat('#,###').format(paymentInfo.amount),
                    ),
                    Field(name: 'account_number', value: bank.bankOwnerNumber),
                    Field(name: 'receiver', value: bank.bankOwner),
                    Field(
                      name: 'bank_transfer_content',
                      value: paymentInfo.orderCodeV2,
                    ),
                  ];

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildSeeGuildButton(context),
                        Text(
                          LocalizationsUtil.of(context).translate(
                              'residents_transfer_money_to_one_of_the_following_banks'),
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff838383),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        buildBankSection(banks, bankFields),
                        buildQRSection(
                            context, bank.bankCode, paymentInfo.orderCodeV2),
                        ...fields.map(
                          (e) => buildField(context, e),
                        ),
                        buildGuidePainter(context),
                        buildBottomGuide(context),
                        BottomCountdown(
                          feePaymentId: widget.args.id,
                          animation: StepTween(
                            begin: levelClock,
                            end: 0,
                          ).animate(animationController),
                          callback: widget.args.callback,
                        ),
                      ],
                    ),
                  );
                }

                if (state is PaymentFailure) {
                  return SomethingWentWrong();
                }

                return ManualTransferLoading();
              },
            ),
          ),
          ProgressIndicatorWidget(isProgressing),
        ],
      ),
      // onPressed: widget.args.createdAt != null ? null : backToMainPage,
    );
  }

  Container buildBottomGuide(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: [
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: LocalizationsUtil.of(context).translate(
                      'to_change_to_another_payment_method_residents_please_select_the_with_space'),
                ),
                TextSpan(
                  text:
                      ' ${LocalizationsUtil.of(context).translate('cancel_payment_button')} ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('button_below_will_be_opened_after_5_minutes'),
                ),
              ],
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff838383),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: LocalizationsUtil.of(context).translate(
                      'in_case_residents_have_made_a_transfer_please_wait_with_space'),
                ),
                TextSpan(
                  text:
                      ' ${LocalizationsUtil.of(context).translate('15_minutes')} ',
                  style: TextStyle(color: Colors.black),
                ),
                TextSpan(
                  text:
                      '${LocalizationsUtil.of(context).translate('and_with_space')} ',
                ),
                TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('do_not_cancel_the_payment'),
                  style: TextStyle(
                    color: Color(0xffec1c23),
                  ),
                ),
              ],
              style: TextStyle(
                fontSize: 14,
                color: Color(0xff838383),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomPaint buildGuidePainter(BuildContext context) {
    return CustomPaint(
      painter: _TransferContentPainter(),
      child: Container(
        padding:const EdgeInsets.all(12.0),
        margin: EdgeInsets.only(top: 12.0, bottom: 20.0),
        child: Text(
          LocalizationsUtil.of(context).translate(
              'please_enter_the_exact_transfer_content_to_easily_confirm_it_is_deposit_by_resident'),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xffd68100),
          ),
        ),
        decoration: ShapeDecoration(
          color: Color(0xffffefc6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  Container buildField(BuildContext context, Field e) {
    return Container(
      margin: EdgeInsets.only(
        top: 16.0,
        bottom: 4.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationsUtil.of(context).translate(e.name),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF838383),
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                e?.value ?? '',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (e.name != 'receiver')
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0),
              ),
              padding:const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 12.0,
              ),
              color: Color(0xFFf2e8ff),
              child: Text(
                LocalizationsUtil.of(context).translate('copy'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: e.value));

                _toastInfo('copied');
              },
            ),
        ],
      ),
    );
  }

  Container buildBankSection(
    List<PaymentBankTransfer> banks,
    List<_BankField> bankFields,
  ) {
    print(bankFields.toString());
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 16.0,
            children: banks
                .map(
                  (e) => ChoiceChip(
                    padding: const EdgeInsets.all(0),
                    labelPadding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.white,
                    selectedColor: Colors.white,
                    label: Image.asset(
                      bankIndex == banks.indexOf(e)
                          ? bankFields
                              .firstWhere((i) => i.bankCode == e.bankCode)
                              .assetActivePath
                          : bankFields
                              .firstWhere((i) => i.bankCode == e.bankCode)
                              .assetPath,
                      width: 60.0,
                      height: 60.0,
                    ),
                    selected: bankIndex == banks.indexOf(e),
                    onSelected: (bool selected) async {
                      if (bankIndex != banks.indexOf(e)) {
                        _isImageLoading = true;
                        _isProgressingSubject.add(_isImageLoading);
                        _imageLoadingController.add(true);
                        setState(() => bankIndex = banks.indexOf(e));

                        bank = banks[bankIndex];

                        await Future.delayed(Duration(milliseconds: 200));

                        _isProgressingSubject.add(false);
                      }
                    },
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16.0),
          Text(
            LocalizationsUtil.of(context).translate(bankFields
                .singleWhere((e) => e.bankCode == bank.bankCode)
                .bankName),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _resetHeaders(String bankCode, String orderCodeV2) async {
    await paymentRepository.getQRBank(orderCodeV2, bankCode);
    final TokenModel tokens = Storage.getToken();
    if (_countRequest < 5) {
      setState(() {
        headers["Authorization"] = "Bearer ${tokens?.access}";
        _countRequest = _countRequest + 1;
      });
    }
  }

  Widget buildQRSection(
      BuildContext context, String bankCode, String orderCodeV2) {
    final _widthImage = MediaQuery.of(context).size.width * 50 / 100 - 20;
    final imageUrl =
        FeeV1Path.basePaymentUrlBankTransfer + "/$orderCodeV2?bank=$bankCode";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          InkWell(
            onTap: () {
              if (!_isImageLoading) {
                showQRCodePopup(context, orderCodeV2, bankCode);
              }
            },
            child: CachedNetworkImage(
              key: UniqueKey(),
              imageUrl: imageUrl,
              httpHeaders: headers,
              width: _widthImage,
              imageBuilder: (context, imageProvider) {
                _isImageLoading = false;
                _imageLoadingController.add(_isImageLoading);

                return SizedBox(
                  width: _widthImage,
                  child: Image(
                    image: imageProvider,
                    width: _widthImage,
                  ),
                );
              },
              placeholder: (context, url) {
                return ParkingCardSkeleton(
                  height: _widthImage,
                  width: _widthImage,
                );
              },
              errorWidget: (context, url, error) {
                _resetHeaders(bankCode, orderCodeV2);
                if (_countRequest >= 5) {
                  return Icon(
                    Icons.error_outline,
                    color: Color(0xff5b00e4),
                  );
                }
                return ParkingCardSkeleton(
                  height: _widthImage,
                  width: _widthImage,
                );
              },
            ),
          ),
          SizedBox(
            height: 220,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: MessageBoxQRCode(),
                ),
                StreamBuilder<bool>(
                    stream: _imageLoadingController.stream,
                    initialData: true,
                    builder: (context, streamSnapshot) {
                      if (!streamSnapshot.data) {
                        return FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding:const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 12.0,
                          ),
                          color: Color(0xFFf2e8ff),
                          child: Row(
                            children: <Widget>[
                              SvgPicture.asset(
                                'assets/svg/icon/ic-download.svg',
                                width: 16.0,
                                height: 16.0,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${LocalizationsUtil.of(context).translate('download')} QR Code',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            handleSaveImage(imageUrl);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildSeeGuildButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: FlatButton(
        padding:const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 12.0,
        ),
        color: AppColors.backgroundColorInfo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info,
              size: 20.0,
              color: AppColors.colorInfo,
            ),
            const SizedBox(width: 12),
            Text(
              LocalizationsUtil.of(context)
                  .translate('see_manual_transfer_instructions'),
              style: TextStyle(
                color: AppColors.colorInfo,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward,
              color: AppColors.colorInfo,
              size: 13,
            )
          ],
        ),
        onPressed: () =>
            AppRouter.pushNoParams(context, AppRouter.MANUAL_TRANSFER_PAGE),
      ),
    );
  }

  void showQRCodePopup(
      BuildContext context, String orderCodeV2, String bankCode) {
    final _screenSize = MediaQuery.of(context).size;
    final _maxWidth = _screenSize.width * 90 / 100;
    final _maxWidthImage = _screenSize.width * 70 / 100;
    final String _imageUrl =
        FeeV1Path.basePaymentUrlBankTransfer + "/$orderCodeV2?bank=$bankCode";

    AppDialog.showContentDialog(
        context: context,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: _maxWidth > 400 ? 400 : _maxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              const SizedBox(height: 10),
              CachedNetworkImage(
                key: UniqueKey(),
                imageUrl: _imageUrl,
                httpHeaders: headers,
                width: _maxWidthImage < 300 ? _maxWidthImage : 300,
                placeholder: (context, url) => ParkingCardSkeleton(
                  height: _maxWidthImage < 300 ? _maxWidthImage : 300,
                  width: _maxWidthImage < 300 ? _maxWidthImage : 300,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              const SizedBox(height: 48),
              WidgetButton.pink(
                '${LocalizationsUtil.of(context).translate('download')} QR Code',
                icon: SvgPicture.asset(
                  'assets/svg/icon/ic-download.svg',
                  width: 16.0,
                  height: 16.0,
                ),
                callback: () {
                  handleSaveImage(_imageUrl);
                },
              )
            ],
          ),
        ),
        closeShow: false);
  }

  void handleSaveImage(String imageUrl) async {
    try {
      var fetchedFile = await DefaultCacheManager().getSingleFile(imageUrl);

      print(fetchedFile.path);
      if (fetchedFile.path != null) {
        await ImageGallerySaver.saveFile(fetchedFile.path);
        _toastInfo('saved_to_the_gallery');
      } else {
        _toastInfo('can_not_save');
      }
    } catch (e) {
      _toastInfo('can_not_save');
    }
  }

  void _toastInfo(String info) {
    Fluttertoast.showToast(
        msg: LocalizationsUtil.of(context).translate(info),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 14.0);
  }
}

class _BankField {
  final String bankCode;
  final String assetPath;
  final String assetActivePath;
  final String bankName;

  _BankField({
    this.bankCode,
    this.assetPath,
    this.assetActivePath,
    this.bankName,
  });
}

class _TransferContentPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0xffffefc6);

    final path = Path()
      ..moveTo(30.0, 12.0)
      ..lineTo(36.0, 0)
      ..lineTo(42.0, 12.0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class BottomCountdown extends AnimatedWidget {
  BottomCountdown({
    this.animation,
    this.feePaymentId,
    this.callback,
  }) : super(listenable: animation);

  final Animation<int> animation;
  final String feePaymentId;
  final Function callback;
  final PaymentRepository paymentRepository = new PaymentRepository();

  void showYesNoPopup(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    AppDialog.showContentDialog(
        context: context,
        child: Container(
            padding: const EdgeInsets.all(20.0),
            width: _screenSize.width * 90 / 100,
            height: 305,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 10),
                Padding(
                  padding:const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                          LocalizationsUtil.of(context)
                              .translate("cancel_transfer_manually"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            //fontFamily: ThemeConstant.form_font_family,
                            fontSize: _screenSize.width < 350 ? 16 : 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 20),
                      Text(
                          '${LocalizationsUtil.of(context).translate("are_residents_sure_you_want_to_cancel_the_manual_transfer")}?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff808080),
                          )),
                      const SizedBox(height: 20),
                      Text(
                        '${LocalizationsUtil.of(context).translate("in_case_residents_have_made_a_transfer_please_wait_15_minutes_and_do_not_cancel_the_payment")}.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xff808080),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 44,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: WidgetButton.pink(
                          LocalizationsUtil.of(context).translate('confirm_no'),
                          callback: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: WidgetButton.outline(
                          LocalizationsUtil.of(context)
                              .translate('confirm_yes'),
                          callback: () async {
                            try {
                              var result = await paymentRepository
                                  .cancelFeePayment(feePaymentId);
                              print(result);
                              if (callback != null) {
                                callback();
                              }

                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: LocalizationsUtil.of(context)
                                      .translate('Error'),
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.grey,
                                  textColor: Colors.white,
                                  fontSize: 14.0);
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
        closeShow: false);
  }

  @override
  Widget build(BuildContext context) {
    final Duration clockTimer = Duration(seconds: animation.value);

    final String timerText =
        '${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return animation.isCompleted
        ? Container(
            margin: EdgeInsets.only(bottom: 20.0),
            child: Align(
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () => showYesNoPopup(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.close,
                      color: Color(0xffec1c23),
                    ),
                    const SizedBox(width: 5.0),
                    Text(
                      LocalizationsUtil.of(context)
                          .translate('cancel_payment_button'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffec1c23),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        : Container(
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 20.0),
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xfff5f5f5),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: LocalizationsUtil.of(context)
                          .translate('please_wait_with_space'),
                    ),
                    TextSpan(
                      text:
                          " $timerText ${LocalizationsUtil.of(context).translate('seconds')} ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: LocalizationsUtil.of(context).translate(
                          'if_you_want_to_cancel_the_payment_with_space'),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
  }
}
