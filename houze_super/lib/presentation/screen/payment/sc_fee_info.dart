import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateful/widget_webview.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/bloc/base_bloc.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

/*----Screen: Hóa đơn || Hoá đơn */
class FeeInfoScreenArgument {
  final String id;
  final String locale;
  const FeeInfoScreenArgument({
    @required this.id,
    this.locale,
  });
}

class FeeInfoScreen extends StatefulWidget {
  final FeeInfoScreenArgument arg;
  const FeeInfoScreen({
    Key key,
    @required this.arg,
  }) : super(key: key);

  @override
  FeeInfoScreenState createState() => new FeeInfoScreenState(arg: this.arg);
}

class FeeInfoScreenState extends State<FeeInfoScreen> {
  final FeeInfoScreenArgument arg;

  final _feeInfoBloc = BaseBloc();

  FeeInfoScreenState({this.arg}) {
    _feeInfoBloc.resultFunc = (dynamic args) async {
      String token = Storage.getToken().access;
      final feeRepository = FeeRepository();
      return await feeRepository.getFeeDetail(
        feeId: widget.arg.id,
        token: token,
        locale: args['locale'],
      );
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
    return BaseScaffoldPresent(
        title: 'invoice',
        body: SafeArea(
          child: BlocProvider<BaseBloc>(
            create: (_) => _feeInfoBloc,
            child: BlocBuilder<BaseBloc, BaseState>(
                builder: (BuildContext context, BaseState webState) {
              if (webState is BaseInitial) {
                final _language = Storage.getLanguage();
                this._feeInfoBloc.add(
                      BaseLoadList(
                        params: {
                          "locale": _language.locale,
                        },
                      ),
                    );
              }

              if (webState is BaseFailure) {
                if (webState.error.error is NoDataException)
                  return SomethingWentWrong(true);
                else
                  return SomethingWentWrong();
              }

              if (webState is BaseListSuccessful) {
                return WebviewWidget(content: webState.result);
              }

              return Center(child: CupertinoActivityIndicator());
            }),
          ),
        ));
  }
}
