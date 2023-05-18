import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/custom_ui/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/qrcode/widget_qrcode_body.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/qrcode/widget_qrcode_header.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import '../../../../../base/route_aware_state.dart';
import '../../../../../index.dart';

class QRCodeDetailScreenArgument {
  final String id;
  const QRCodeDetailScreenArgument({required this.id});
}

class QRCodeDetailScreen extends StatefulWidget {
  final QRCodeDetailScreenArgument args;
  const QRCodeDetailScreen({required this.args});

  @override
  State<StatefulWidget> createState() => _QRCodeDetailScreenState();
}

class _QRCodeDetailScreenState extends RouteAwareState<QRCodeDetailScreen> {
  final _userCouponBloc = BaseBloc();
  final _merchantRepository = MerchantRepository();

  @override
  void initState() {
    super.initState();

    _userCouponBloc.resultFunc = (dynamic args) async {
      return _merchantRepository.getUserCouponById(widget.args.id);
    };
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldPresent(
        title: 'voucher_code',
        body: BlocProvider<BaseBloc>(
          create: (_) => _userCouponBloc,
          child: BlocBuilder<BaseBloc, BaseState>(
              builder: (BuildContext context, BaseState promotionState) {
            if (promotionState is BaseInitial) {
              _userCouponBloc.add(BaseLoadList());
            }

            if (promotionState is BaseLoading) {
              return Container(
                  child: Center(child: CupertinoActivityIndicator()),
                  color: Colors.white);
            }

            if (promotionState is BaseFailure) {
              if (promotionState.error.error is NoDataException)
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            if (promotionState is BaseListSuccessful) {
              final promotionQR =
                  promotionState.result as PrivatePromotionModel;

              return ListView(
                  padding: const EdgeInsets.all(0),
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    WidgetQRCodeHeader(data: promotionQR),
                    WidgetQRCodeBody(data: promotionQR)
                  ]);
            }
            return SizedBox.shrink();
          }),
        ));
  }
}
