import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_state.dart';

import '../../../index.dart';

class SectionPersionalInfo extends StatelessWidget {
  final ParkingVehicle item;

  const SectionPersionalInfo({@required this.item});
  //Service converter
  Future<String> serviceConverter() {
    final service =
        ServiceConverter.convertTypeBuilding("apartment_with_colon");
    return service;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (c, ProfileState s) {
        if (s.isInitial) context.read<ProfileBloc>().add(ProfileLoadEvent());
        if (s.isLoading) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
        if (s.hasError) {
          return SomethingWentWrong();
        }
        if (s.hasData) {
          ProfileModel p = s.profile;
          return WidgetBoxesContainer(
              title: 'personal_information',
              styleTitle: AppFonts.bold.copyWith(fontSize: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            LocalizationsUtil.of(context)
                                .translate('full_name_with_colon_1'),
                            style: AppFonts.regular
                                .copyWith(color: Color(0xff808080))),
                        Text(p.fullname,
                            style:
                                AppFonts.medium14.copyWith(color: Colors.black))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FutureBuilder(
                            future: serviceConverter(),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                  LocalizationsUtil.of(context)
                                      .translate(snap.data),
                                  style: AppFonts.regular
                                      .copyWith(color: Color(0xff808080)));
                            }),
                        Text(item.apartment.name.toString(),
                            style:
                                AppFonts.medium14.copyWith(color: Colors.black))
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            LocalizationsUtil.of(context)
                                .translate('phone_number_with_colon'),
                            style: AppFonts.regular
                                .copyWith(color: Color(0xff808080))),
                        Text(p.phoneNumber.toString(),
                            style:
                                AppFonts.medium14.copyWith(color: Colors.black))
                      ],
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
