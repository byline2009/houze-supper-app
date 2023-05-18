import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_webview.dart';
import 'package:houze_super/presentation/screen/base/bloc/base_bloc.dart';
import 'package:houze_super/presentation/screen/base/bloc/base_event.dart';
import 'package:houze_super/presentation/screen/base/bloc/base_state.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

class ReceiptInfoScreenArgument {
  final String id;
  const ReceiptInfoScreenArgument({@required this.id});
}

class ReceiptInfoScreen extends StatefulWidget {
  final ReceiptInfoScreenArgument agr;

  const ReceiptInfoScreen({@required this.agr});

  @override
  ReceiptInfoScreenState createState() => ReceiptInfoScreenState(agr: this.agr);
}

class ReceiptInfoScreenState extends State<ReceiptInfoScreen> {
  final ReceiptInfoScreenArgument agr;
  final feeRepository = FeeRepository();

  final _feeInfoBloc = BaseBloc();

  ReceiptInfoScreenState({this.agr}) {
    _feeInfoBloc.resultFunc = (dynamic args) async {
      String token = Storage.getToken().access;
      return await feeRepository.getReceiptDetail(
          receiptId: agr.id, token: token, locale: args['locale']);
    };
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _feeInfoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _language = Storage.getLanguage();

    return HomeScaffold(
        title: 'receipt',
        child: BlocProvider<BaseBloc>(
          create: (_) => _feeInfoBloc,
          child: BlocBuilder<BaseBloc, BaseState>(
              builder: (BuildContext context, BaseState webState) {
            if (webState is BaseInitial) {
              this._feeInfoBloc.add(BaseLoadList(params: {
                    "locale": _language.locale,
                  }));
            }

            if (webState is BaseListSuccessful) {
              return WebviewWidget(content: webState.result);
            }

            if (webState is BaseFailure) {
              if (webState.error.error is NoDataException)
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            return Center(child: CupertinoActivityIndicator());
          }),
        ));
  }
}
