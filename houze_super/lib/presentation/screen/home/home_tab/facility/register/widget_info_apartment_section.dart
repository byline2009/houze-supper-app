import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_state.dart';
import 'package:houze_super/utils/constants/constants.dart';

class WidgetApartmentInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        builder: (_, ProfileState state) {
      if (state.isInitial) context.read<ProfileBloc>().add(ProfileLoadEvent());

      if (state.hasError) return SomethingWentWrong();

      if (state.hasData) {
        var fullName = "----";
        var phoneNumber = "----";

        final result = state.profile;
        fullName = result.fullname;
        phoneNumber = '(+' +
            result.intlCode.toString() +
            ') ' +
            result.phoneNumber.toString();

        return Column(children: <Widget>[
          const SizedBox(height: 19),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LocalizationsUtil.of(context)
                      .translate('full_name_with_colon_0'),
                  style: AppFonts.medium.copyWith(color: Color(0xff808080)),
                ),
                Text(fullName,
                    style: AppFonts.medium14.copyWith(color: Colors.black))
              ]),
          const SizedBox(height: 8),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LocalizationsUtil.of(context)
                      .translate('phone_number_with_colon'),
                  style: AppFonts.medium.copyWith(color: Color(0xff808080)),
                ),
                Text(phoneNumber,
                    style: AppFonts.medium14.copyWith(color: Colors.black))
              ]),
          const SizedBox(height: 19),
        ]);
      }
      return const SizedBox.shrink();
    });
  }
}
