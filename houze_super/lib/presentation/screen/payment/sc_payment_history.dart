import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/presentation/common_widgets/bottom_sheet_switch_widget.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';
import 'package:houze_super/presentation/common_widgets/stateful/toggle_filter_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/payment_history_bloc.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:responsive/flex_widget.dart';
import 'package:responsive/responsive_row.dart';

import 'bloc/payment/payment_event.dart';
import 'order/draft_item.dart';

//---SCREEN: Lịch sử giao dịch---//

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistoryScreen>
    with
        AutomaticKeepAliveClientMixin<PaymentHistoryScreen>,
        TickerProviderStateMixin {
  final _refreshController = RefreshController(initialRefresh: true);
  final _paymentHistoryBloc = PaymentHistoryBloc();
  var controlFilter = {'status': -1};
  @override
  void dispose() {
    if (_paymentHistoryBloc != null) _paymentHistoryBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    this
        ._paymentHistoryBloc
        .add(TransactionLoadList(page: 1, status: controlFilter['status']));
  }

  Widget contentList() {
    return BlocProvider<PaymentHistoryBloc>(
      create: (_) => _paymentHistoryBloc,
      child: BlocBuilder<PaymentHistoryBloc, PaymentHistoryPageModel>(
        builder: (
          BuildContext context,
          PaymentHistoryPageModel _transactionHistoryPageModel,
        ) {
          if (_transactionHistoryPageModel.isLoading) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ParkingCardSkeleton(
                      height: 210, width: MediaQuery.of(context).size.width),
                ),
              ],
            );
          }

          if (_transactionHistoryPageModel.total == -2)
            return SomethingWentWrong(true);

          if (_transactionHistoryPageModel.total == 0) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  SvgPicture.asset(AppVectors.ic_404_invoice),
                  const SizedBox(height: 15),
                  Text(
                    LocalizationsUtil.of(context)
                        .translate("transaction_history_not_yet"),
                    style:
                        AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  ),
                ],
              ),
            );
          }

          _refreshController.loadComplete();
          _refreshController.refreshCompleted();

          return Scrollbar(
            child: SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              header: MaterialClassicHeader(),
              footer: WidgetFooter(
                datasource: _transactionHistoryPageModel.transactions,
                shouldLoadMore: _transactionHistoryPageModel.isNext,
              ),
              onRefresh: () {
                this._paymentHistoryBloc.add(GetTransactionByStatus(
                    page: 1, status: controlFilter['status']));
              },
              onLoading: () {
                if (mounted) {
                  this._paymentHistoryBloc.add(
                      TransactionLoadList(status: controlFilter['status']));
                }
              },
              child: ListView.builder(
                key: PageStorageKey<String>('PaymentHistoryScreen'),
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: _transactionHistoryPageModel.transactions.length,
                itemBuilder: (c, index) {
                  final paymentOrder =
                      _transactionHistoryPageModel.transactions[index];
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    child: DraftItem(
                      order: paymentOrder,
                      template: EnumDraftItemTemplate.history,
                      size: EnumDraftItemSize.full,
                      callbackDetail: () {
                        AppRouter.push(
                          context,
                          AppRouter.PAYMENT_DETAIL_PAGE,
                          {
                            "apartment_id": paymentOrder.apartmentId,
                            "id": paymentOrder.id,
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
              child: ResponsiveRow(
                  columnsCount: 17,
                  spacing: 10.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    FlexWidget(
                      child: ToggleFilterWidget(
                          defaultText: 'status',
                          except: "-1",
                          cancelCallback: () {
                            controlFilter['status'] = -1;
                            this._paymentHistoryBloc.add(GetTransactionByStatus(
                                page: 1, status: controlFilter['status']));
                          },
                          callback: (response) {
                            BottomSheetSwitchWidget.showBottomSheet(
                                context: context,
                                title: LocalizationsUtil.of(context)
                                    .translate('select_a_status'),
                                defaultValue:
                                    controlFilter['status'].toString(),
                                noHeight: true,
                                options: [
                                  KeyValueModel(
                                    key: "-1",
                                    value: LocalizationsUtil.of(context)
                                        .translate('all_status'),
                                  ),
                                  KeyValueModel(
                                    key: "0",
                                    value: LocalizationsUtil.of(context)
                                        .translate('payment_status_pending'),
                                  ),
                                  KeyValueModel(
                                    key: "1",
                                    value: LocalizationsUtil.of(context)
                                        .translate('payment_status_successful'),
                                  ),
                                  KeyValueModel(
                                      key: "2",
                                      value: LocalizationsUtil.of(context)
                                          .translate('payment_status_failed')),
                                ],
                                callback: (dynamic option) {
                                  controlFilter['status'] =
                                      int.parse((option as KeyValueModel).key);
                                  this._paymentHistoryBloc.add(
                                        GetTransactionByStatus(
                                            page: 1,
                                            status: controlFilter['status']),
                                      );
                                  response(option);
                                });
                          }),
                      xs: 6,
                    ),
//                SizedBox(width: 5),
//                FlexWidget(
//                  child: ToggleFilterWidget(
//                    defaultText: 'Thời gian',
//                  ),
//                  xs: 6,
//                ),
                  ])),
          const SizedBox(height: 20),
          Expanded(
            child: contentList(),
          ),
        ]);
  }

  @override
  bool get wantKeepAlive => false;
}
