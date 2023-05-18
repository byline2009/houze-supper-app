import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_event.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_state.dart';

class WidgetApartmentInfo extends StatelessWidget {
  final _profileBloc = ProfileBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
        create: (_) => _profileBloc,
        child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (_, ProfileState state) {
          if (state is ProfileInitial) _profileBloc.add(ProfileLoad());

          if (state is ProfileLoadFailure) return SomethingWentWrong();

          if (state is ProfileLoadSuccessful) {
            var fullName = "----";
            var phoneNumber = "----";

            final result = state.profile;
            fullName = result.fullname ?? '';
            phoneNumber = '(+' +
                result.intlCode.toString() +
                ') ' +
                result.phoneNumber.toString();

            return Column(children: <Widget>[
              SizedBox(height: 19),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        LocalizationsUtil.of(context)
                            .translate('full_name_with_colon_0'),
                        style: AppFonts.medium14.copyWith(
                          color: Color(
                            0xff5B00E4,
                          ),
                        )),
                    Text(fullName, style: AppFonts.medium14)
                  ]),
              SizedBox(height: 8),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                        LocalizationsUtil.of(context)
                            .translate('phone_number_with_colon'),
                        style: AppFonts.medium14.copyWith(
                          color: Color(
                            0xff5B00E4,
                          ),
                        )),
                    Text(phoneNumber, style: AppFonts.medium14)
                  ]),
              SizedBox(height: 19),
            ]);
          }
          return SizedBox.shrink();
        }));
  }
}
