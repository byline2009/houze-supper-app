import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../index.dart';

class SectionPersionalInfo extends StatelessWidget {
  final ParkingVehicle item;

  SectionPersionalInfo({required this.item});
  final bloc = ProfileBloc();
  //Service converter
  Future<String> serviceConverter() {
    final service =
        ServiceConverter.convertTypeBuilding("apartment_with_colon");
    return service;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: bloc,
      builder: (c, s) {
        if (s is ProfileInitial) bloc.add(ProfileLoad());
        if (s is ProfileLoading) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: CardListSkeleton(
                length: 4,
                shrinkWrap: true,
                config: SkeletonConfig(
                    theme: SkeletonTheme.Light,
                    isCircleAvatar: false,
                    isShowAvatar: false,
                    bottomLinesCount: 1)),
          );
        }
        if (s is ProfileLoadFailure) {
          return SomethingWentWrong();
        }
        if (s is ProfileLoadSuccessful) {
          ProfileModel p = s.profile;
          return WidgetBoxesContainer(
              title: 'personal_information',
              styleTitle: AppFonts.bold16,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            LocalizationsUtil.of(context)
                                .translate('full_name_with_colon_1'),
                            style: AppFonts.regular14.copyWith(
                              color: Color(
                                0xff808080,
                              ),
                            )),
                        Text(p.fullname ?? '', style: AppFonts.medium14)
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: serviceConverter(),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return SizedBox.shrink();
                              }
                              return Text(
                                  LocalizationsUtil.of(context)
                                      .translate(snap.data),
                                  style: AppFonts.regular14.copyWith(
                                    color: Color(
                                      0xff808080,
                                    ),
                                  ));
                            }),
                        Text(item.apartment!.name.toString(),
                            style: AppFonts.medium14)
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            LocalizationsUtil.of(context)
                                .translate('phone_number_with_colon'),
                            style: AppFonts.regular14.copyWith(
                              color: Color(
                                0xff808080,
                              ),
                            )),
                        Text(p.phoneNumber.toString(), style: AppFonts.medium14)
                      ],
                    ),
                    SizedBox(height: 20)
                  ],
                ),
              ));
        }
        return SizedBox.shrink();
      },
    );
  }
}
