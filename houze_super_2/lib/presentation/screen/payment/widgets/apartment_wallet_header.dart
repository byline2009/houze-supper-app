import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';

import 'package:houze_super/utils/index.dart';

class ApartmentWallet extends StatefulWidget {
  const ApartmentWallet({Key? key}) : super(key: key);

  @override
  State<ApartmentWallet> createState() => _ApartmentWalletState();
}

class _ApartmentWalletState extends State<ApartmentWallet> {
  late Future<ApartmentAccModel> _totalWalletApartment;
  ApartmentRepository _repoApartment = ApartmentRepository();

  @override
  void initState() {
    super.initState();
    _totalWalletApartment = fetchApartmentAcc();
  }

  Future<ApartmentAccModel> fetchApartmentAcc() async {
    return await _repoApartment.getApartmentAccByID(id: '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ApartmentAccModel>(
      future:
          _totalWalletApartment, // a previously-obtained Future<String> or null
      builder:
          (BuildContext context, AsyncSnapshot<ApartmentAccModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.none) {
          return CupertinoActivityIndicator();
        }
        if (snapshot.hasData && snapshot.data!.total > 0) {
          return GestureDetector(
            onTap: () {
              AppDialog.showContentDialog(
                  title: '',
                  context: Storage.scaffoldKey.currentContext!,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svg/wallet_blue.svg',
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                '''${LocalizationsUtil.of(context).translate("apartment_wallet_msg")}''',
                                textAlign: TextAlign.center,
                                style: AppFonts.regular14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  closeShow: true,
                  barrierDismissible: true);
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 56,
              decoration: BoxDecoration(
                  color: Color(0xff4500ae),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              padding: EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    'assets/svg/wallet_blue.svg',
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder(
                          future: ServiceConverter.getTextToConvert(
                              "apartment_wallet"),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            return Text(
                              LocalizationsUtil.of(context)
                                  .translate(snap.data),
                              style: AppFonts.semibold13.copyWith(
                                color: Color(0xffdcdcdc),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        Text(
                            '${StringUtil.numberFormat(snapshot.data!.total)} đ',
                            style:
                                AppFonts.bold18.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.info_outline_rounded,
                    color: Color(0xffdcdcdc),
                  )
                ],
              ),
            ),
          );
        } else {
          return Text(
            'Houze Pay',
            style: AppFonts.bold18.copyWith(color: Colors.white),
          );
        }
      },
    );
  }
}
