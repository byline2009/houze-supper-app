import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/profile_model.dart';
import 'package:houze_super/utils/index.dart';
import 'package:intl/intl.dart';

class Field {
  final String name;
  final String value;

  const Field({required this.name, required this.value});
}

class PersonalInfoSection extends StatelessWidget {
  final ProfileModel profile;

  const PersonalInfoSection({Key? key, required this.profile})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final List<Field> genders = <Field>[
      Field(name: 'gender_O', value: 'O'),
      Field(name: 'gender_F', value: 'F'),
      Field(name: 'gender_M', value: 'M'),
    ];

    final List<Field> list = <Field>[
      Field(name: 'phone_number_1', value: '0${profile.phoneNumber}'),
      Field(
        name: 'birthday',
        value: profile.birthday != null
            ? DateFormat('dd/MM/y').format(DateTime.parse(profile.birthday!))
            : "n/a",
      ),
      Field(
        name: 'gender',
        value: genders.firstWhere((e) => e.value == profile.gender).name,
      ),
      Field(
        name: 'nation',
        value: profile.country == 'O' ? 'unknown' : 'vietnam',
      ),
    ];

    return Container(
      margin: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .map(
              (e) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocalizationsUtil.of(context).translate(e.name),
                    style: AppFonts.medium14.copyWith(
                      color: Color(
                        0xff838383,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    LocalizationsUtil.of(context).translate(e.value),
                    style: AppFonts.regular15,
                  ),
                  e != list.last
                      ? Divider(
                          thickness: 1.0,
                          height: 30.0,
                          color: AppColor.gray_dcdcdc,
                        )
                      : SizedBox.shrink(),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
