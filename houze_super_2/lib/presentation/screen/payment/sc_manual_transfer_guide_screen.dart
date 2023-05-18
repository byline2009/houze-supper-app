import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ManualTransferScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'manual_transfer_guide',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            buildStep(
              context,
              step: 'first_step',
              content: buildFirstStepContent(context),
            ),
            buildStep(
              context,
              step: 'second_step',
              content: buildSecondStepContent(context),
            ),
            buildStep(
              context,
              step: 'third_step',
              content: buildThirdStepContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Column buildThirdStepContent(BuildContext context) {
    final TextStyle textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xff838383),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: textStyle,
            children: <TextSpan>[
              TextSpan(
                text: LocalizationsUtil.of(context).translate(
                    'make_a_bank_transfer_and_wait_for_the_receipt_to_return_on_the_dkra_resident_application_absolutely'),
              ),
              TextSpan(
                text:
                    ' ${LocalizationsUtil.of(context).translate('do_not_cancel_the_payment')} ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text:
                    '${LocalizationsUtil.of(context).translate('after_transferring_money')}.',
              ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
        RichText(
          text: TextSpan(
            style: textStyle,
            children: <TextSpan>[
              TextSpan(
                text:
                    '${LocalizationsUtil.of(context).translate('this_process_should_take')} ',
              ),
              TextSpan(
                text: LocalizationsUtil.of(context)
                    .translate('about_5_to_15_minutes'),
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column buildSecondStepContent(BuildContext context) {
    final widthImageQR = MediaQuery.of(context).size.width * 35 / 100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff838383),
            ),
            children: <TextSpan>[
              TextSpan(
                text: toBeginningOfSentenceCase(
                        LocalizationsUtil.of(context).translate('enter'))! +
                    ' ',
              ),
              TextSpan(
                text: LocalizationsUtil.of(context).translate(
                        'the_exact_information_and_transfer_content') +
                    ' ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: LocalizationsUtil.of(context)
                        .translate('for_a_smooth_payment_process_with_colon') +
                    ':',
              ),
            ],
          ),
        ),
        SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'assets/images/payment/img-huongdan.png',
              ),
              Positioned(
                right: 15.0,
                top: 70.0,
                child: SvgPicture.asset('assets/svg/payment/ic-touch.svg'),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xff838383),
            ),
            children: <TextSpan>[
              TextSpan(
                text: LocalizationsUtil.of(context)
                        .translate('or_residents_can_use') +
                    ' ',
              ),
              TextSpan(
                text: LocalizationsUtil.of(context)
                        .translate('the_qr_scanning_feature') +
                    ' ',
                style: TextStyle(color: Colors.black),
              ),
              TextSpan(
                text: LocalizationsUtil.of(context).translate(
                    'to_manipulate_tacs_more_conveniently_and_quickly'),
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/payment/img-QR-code.png',
              width: widthImageQR < 240 ? widthImageQR : 240,
            )
          ],
        ),
      ],
    );
  }

  Column buildFirstStepContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationsUtil.of(context).translate(
              'open_the_banking_application_which_resident_is_using'),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xff838383),
          ),
        ),
        SizedBox(height: 10.0),
        Image.asset('assets/images/payment/image-banks.png'),
      ],
    );
  }

  Container buildStep(BuildContext context,
      {String? step, required Widget content}) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate(step),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.0),
          content,
        ],
      ),
    );
  }
}
