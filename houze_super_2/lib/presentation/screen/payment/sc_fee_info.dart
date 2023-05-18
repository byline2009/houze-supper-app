import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/repo/fee_repository.dart';
import 'package:houze_super/presentation/common_widgets/widget_webview.dart';
import 'package:houze_super/presentation/custom_ui/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import '../../base/route_aware_state.dart';

class FeeInfoScreenArgument {
  final String id;
  final String? locale;
  const FeeInfoScreenArgument({required this.id, this.locale});
}

class FeeInfoScreen extends StatefulWidget {
  final FeeInfoScreenArgument arg;
  const FeeInfoScreen({Key? key, required this.arg}) : super(key: key);

  @override
  FeeInfoScreenState createState() => new FeeInfoScreenState(arg: this.arg);
}

class FeeInfoScreenState extends RouteAwareState<FeeInfoScreen> {
  final FeeInfoScreenArgument? arg;

  final feeRepository = FeeRepository();

  final _feeInfoBloc = BaseBloc();

	String webViewContent = '';

  FeeInfoScreenState({this.arg}) {
    _feeInfoBloc.resultFunc = (dynamic args) async {
      String token = Storage.getToken()!.access;
      return await feeRepository.getFeeDetail(
          feeId: widget.arg.id, token: token, locale: args['locale']);
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
		super.debugFillProperties(properties);
		String message = webViewContent;
    assert(() {
      return true;
    }());

		properties.add(DiagnosticsNode.message(message));
	}

  @override
  Widget build(BuildContext context) {
    final _language = Storage.getLanguage();

    return BaseScaffoldPresent(
        title: 'invoice',
        body: SafeArea(
          child: BlocProvider<BaseBloc>(
            create: (_) => _feeInfoBloc,
            child: BlocBuilder<BaseBloc, BaseState>(
                builder: (BuildContext context, BaseState webState) {
              if (webState is BaseInitial) {
                this._feeInfoBloc.add(BaseLoadList(params: {
                      "locale": _language.locale,
                    }));
              }

              if (webState is BaseFailure) {
                if (webState.error.error is NoDataException)
                  return SomethingWentWrong(true);
                else
                  return SomethingWentWrong();
              }

              if (webState is BaseListSuccessful) {
								webViewContent = webState.result;
                return WebviewWidget(content: webState.result);
              }

              return Center(child: CupertinoActivityIndicator());
            }),
          ),
        ));
  }


}
