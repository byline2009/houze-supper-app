import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_status_tag.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/parking/detail/widget_section_vehicle_info.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';

import 'package:houze_super/utils/constants/constants.dart';

import 'widget_not_box.dart';
import 'widget_qr_code.dart';
import 'widget_section_persional_info.dart';

class ParkingDetail extends StatelessWidget {
  final ParkingVehicle item;
  const ParkingDetail({@required this.item});

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'parking_card_detail',
      child: ListView(
          padding: const EdgeInsets.all(0),
          physics: const AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SectionQRCode(item: item),
            WidgetSectionTitle(
                title: 'registration_date',
                trailing: item.dateRegistration != null
                    ? Text(
                        DateUtil.format(
                            "dd/MM/yyyy", item.dateRegistration),
                        style:
                            AppFonts.medium.copyWith(color: Color(0xff808080)),
                      )
                    : const SizedBox.shrink()),
            SectionVehicleStatusTag(item: item),
            NoteBox(item: item),
            BlocProvider(
                create: (contex) =>
                    ProfileBloc(profileRepo: ProfileRepository()),
                child: SectionPersionalInfo(item: item)),
            SectionVehicleInfo(item: item)
          ]),
    );
  }
}
