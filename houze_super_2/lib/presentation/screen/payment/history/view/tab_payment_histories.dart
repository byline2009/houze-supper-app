import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/chat/widgets/widget_footer.dart';
import 'package:houze_super/presentation/screen/payment/history/bloc/filter_bloc.dart';
import 'package:houze_super/presentation/screen/payment/history/widgets.dart/widgets.dart';
import 'package:houze_super/presentation/screen/payment/order/draft_item.dart';

import '../../sc_payment_detail.dart';

typedef void CallBackHandler(int idSelected);

class PaymentFilterStatus {
  final int id;
  final String value;

  PaymentFilterStatus({
    required this.id,
    required this.value,
  });
}

class TabPaymentHistories extends StatefulWidget {
  const TabPaymentHistories({Key? key}) : super(key: key);

  @override
  State<TabPaymentHistories> createState() => _TabPaymentHistoriesState();
}

class _TabPaymentHistoriesState extends State<TabPaymentHistories> {
  late int _currentId;
  final _refreshController = RefreshController();
  final _listTemp = <PaymentHistoryModel>[];
  List<PaymentHistoryModel> _list = <PaymentHistoryModel>[];
  int page = 0;
  bool shouldLoadMore = false;
  bool _didTap = true;
  late final List<PaymentFilterStatus> paymentStatusList;
  ApartmentRepository _repoApartment = ApartmentRepository();

  // late Future<ApartmentAccModel> _totalWalletApartment;

  @override
  void initState() {
    super.initState();
    _currentId = -1;

    paymentStatusList = [
      PaymentFilterStatus(
        id: -1,
        value: 'all_status',
      ),
      PaymentFilterStatus(
        id: 0,
        value: 'payment_status_pending',
      ),
      PaymentFilterStatus(
        id: 1,
        value: 'payment_status_successful',
      ),
      PaymentFilterStatus(
        id: 2,
        value: 'payment_status_failed',
      ),
    ];

    // _totalWalletApartment = _repoApartment.getApartmentAccByID(id: '');
  }

  void _handleTransactionDetailUpdatedByID(PaymentHistoryModel newTransaction) {
    final PaymentHistoryModel oldData = _list.firstWhere(
        (element) => element.id == newTransaction.id && element.status == 0);
    int index = _list.indexWhere((element) => element == oldData);
    if (index >= 0) {
      if (mounted) {
        setState(() {
          _list[index] = newTransaction;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // FutureBuilder<ApartmentAccModel>(
        //   future:
        //       _totalWalletApartment, // a previously-obtained Future<String> or null
        //   builder: (BuildContext context,
        //       AsyncSnapshot<ApartmentAccModel> snapshot) {
        //     if (snapshot.hasData && snapshot.data!.total > 0) {
        //       return Container(
        //           padding: const EdgeInsets.only(top: 15, left: 20),
        //           child: Row(
        //             children: [
        //               Icon(Icons.account_balance_wallet,
        //                   color: AppColor.purple_5b00e4),
        //               const SizedBox(width: 10),
        //               FutureBuilder(
        //                 future: ServiceConverter.getTextToConvert(
        //                     "apartment_wallet"),
        //                 builder: (context, snap) {
        //                   if (snap.connectionState == ConnectionState.waiting) {
        //                     return const SizedBox.shrink();
        //                   }
        //                   return Text(
        //                       LocalizationsUtil.of(context)
        //                           .translate(snap.data),
        //                       style: AppFont.MEDIUM);
        //                 },
        //               ),
        //               SizedBox(width: 5),
        //               Text('${StringUtil.numberFormat(snapshot.data!.total)}đ',
        //                   style: TextStyle(fontWeight: FontWeight.bold)),
        //             ],
        //           ));
        //     }

        //     return Container();
        //   },
        // ),
        _buildFilter(),
        const SizedBox(height: 20),
        Expanded(
          child: contentList(),
        ),
      ],
    );
  }

  Widget contentList() {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, state) {
        if (state.status == HistoryStatus.initial) {
          getAllHistories();
        }
        if (state.status == HistoryStatus.failure) {
          _refreshController.refreshCompleted();
        }

        if (state.status == HistoryStatus.loading && page == 0) {
          return Center(
            child: CupertinoActivityIndicator(),
          );
        }
        if (state.status == HistoryStatus.success && _listTemp.isEmpty) {
          final List<PaymentHistoryModel> test = state.histories;
          shouldLoadMore = test.length >= AppConstant.limitDefault;
          _listTemp.addAll(test);
          _list.addAll(test.toList());
        }

        return Scrollbar(
          child: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(),
            onRefresh: () {
              onRefresh(_currentId);
            },
            onLoading: onLoading,
            footer: WidgetFooter(
              datasource: _list,
              shouldLoadMore: shouldLoadMore,
            ),
            child: CustomScrollView(
              key: PageStorageKey<String>('TabViewHistory'),
              physics: const NeverScrollableScrollPhysics(),
              slivers: [
                if (_list.length == 0) ...[
                  SliverToBoxAdapter(
                      child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60.0),
                        SvgPicture.asset(AppVectors.ic_404_invoice),
                        const SizedBox(height: 15.0),
                        Text(
                          LocalizationsUtil.of(context)
                              .translate("transaction_history_not_yet"),
                          style: AppFonts.regular15.copyWith(
                            color: Color(
                              0xff808080,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
                if (_list.length > 0) ...[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      final paymentOrder = _list[index];
                      return AbsorbPointer(
                        absorbing: !this._didTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: DraftItem(
                            order: paymentOrder,
                            template: EnumDraftItemTemplate.history,
                            size: EnumDraftItemSize.full,
                            callbackDetail: () {
                              AppRouter.push(
                                context,
                                AppRouter.PAYMENT_DETAIL_PAGE,
                                PaymentDetailScreenArgument(
                                    id: paymentOrder.id!,
                                    callback: (newData) {
                                      _handleTransactionDetailUpdatedByID(
                                          newData);
                                    }),
                              );
                            },
                          ),
                        ),
                      );
                    }, childCount: _list.length),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void onRefresh(int status) {
    page = 0;
    _listTemp.clear();
    _list.clear();
    shouldLoadMore = true;
    context.read<FilterBloc>().add(
          FilterStatusSelected(
            idSelected: status,
            page: page,
          ),
        );
    _refreshController.refreshCompleted();
  }

  void onLoading() {
    if (shouldLoadMore) {
      this.page++;
      _listTemp.clear();
      context.read<FilterBloc>().add(FilterStatusSelected(
            idSelected: _currentId,
            page: page,
          ));
    }
    _refreshController.loadComplete();
  }

  Widget _buildFilter() {
    return Container(
      margin: EdgeInsets.only(
        top: 30,
        left: 20,
      ),
      child: GestureDetector(
        onTap: () {
          showSelection(callback: (idSelected) {
            onRefresh(idSelected);
          });
        },
        child: SizedBox(
          height: 40,
          width: 150,
          child: BlocBuilder<FilterBloc, FilterState>(
            builder: (context, state) {
              if (state.status == HistoryStatus.success ||
                  state.status == HistoryStatus.loading) {
                _currentId = state.idSelected;
                final PaymentFilterStatus item = paymentStatusList
                    .where((element) => element.id == state.idSelected)
                    .first;
                if (state.filter == StatusViewFilter.all) {
                  return FilterAllStatus();
                } else {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xff6001d2),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white,
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: <Widget>[
                                  TextLimitWidget(
                                      LocalizationsUtil.of(context)
                                          .translate(item.value),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFonts.semibold13
                                          .copyWith(color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          constraints: BoxConstraints(
                            maxWidth: 40.0,
                          ),
                          icon: Icon(
                            Icons.clear,
                            size: 18.0,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            getAllHistories();
                          },
                        )
                      ],
                    ),
                  );
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void showSelection({required CallBackHandler callback}) {
    showModalBottomSheet(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
      ),
      builder: (BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            LocalizationsUtil.of(context)
                                .translate("all_status"),
                            style: AppFonts.medium18),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: paymentStatusList.length,
                      padding: const EdgeInsets.all(0),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                            color: Theme.of(context).dividerColor, height: 1.0);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        PaymentFilterStatus item = paymentStatusList[index];
                        return GestureDetector(
                            child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Radio(
                                        value: item.id,
                                        activeColor: Color(0xff6001d2),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        groupValue: _currentId,
                                        hoverColor: Color(0xff6001d2),
                                        focusColor: Color(0xff6001d2),
                                        onChanged: (dynamic value) {
                                          Navigator.of(context).pop();

                                          callback(item.id);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        LocalizationsUtil.of(context)
                                            .translate(item.value),
                                        style: AppFonts.medium14,
                                      )
                                    ])),
                            onTap: () {
                              Navigator.of(context).pop();
                              callback(item.id);
                            });
                      },
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.transparent,
                    primary: Colors.transparent,
                    elevation: 0,
                    tapTargetSize: MaterialTapTargetSize.padded,
                    padding: EdgeInsets.only(top: 20),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(AppVectors.icClose),
                ),
              )
            ],
          ),
        );
      },
      context: context,
    );
  }

  void getAllHistories() {
    _currentId = -1;
    _list.clear();
    _listTemp.clear();
    page = 0;
    context.read<FilterBloc>().add(FilterLoadAllStatus());
  }
}
