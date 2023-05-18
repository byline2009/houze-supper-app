import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/middle/model/ekyc_model.dart';
import 'package:houze_super/presentation/common_widgets/dropdown_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_field_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';

class EKYCScreen extends StatefulWidget {
  @override
  _EKYCScreenState createState() => _EKYCScreenState();
}

class _EKYCScreenState extends State<EKYCScreen> {
  final instance = EKYCModel();

  _CardID? cardID;

  final cardIDList = <_CardID>[
    _CardID('id_card_or_identity_card'),
    _CardID('passport'),
  ];

  final idController = TextEditingController();
  final nameController = TextEditingController();

  final fieldsInfo = <FieldInfo>[];

  bool isValidate = false;

  void checkValidate() {
    if (idController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        cardID != null) {
      setState(() => isValidate = true);
    } else {
      setState(() => isValidate = false);
    }
  }

  @override
  void initState() {
    super.initState();

    fieldsInfo.addAll([
      FieldInfo(
        title: 'number_id_in_document',
        hint: 'enter_the_number_id',
        controller: idController,
      ),
      FieldInfo(
        title: 'full_name_0',
        hint: 'enter_your_name_in_document',
        controller: nameController,
      ),
    ]);
  }

  @override
  void dispose() {
    idController.dispose();
    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'verify_your_information',
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              buildIntroSection(context),
              pickIdSection(context),
              inputFieldSection(),
              buildButtonSection(),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButtonCustom buildButtonSection() {
    return ElevatedButtonCustom(
      buttonText: 'take_a_picture',
      onPressed: () => {
        if (isValidate)
          AppRouter.pushDialog(
            context,
            AppRouter.CAMERA_SCREEN,
            {
              'title': 'F',
              'sub_title': cardID!.name,
              'instance': instance.toJson(),
            },
          )
      },
    );
  }

  Container inputFieldSection() {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: Wrap(
        runSpacing: 40.0,
        children: fieldsInfo
            .map(
              (e) => FieldCustom(
                field: e,
                keyboardType:
                    e == fieldsInfo.first ? TextInputType.number : null,
                inputFormatters: e == fieldsInfo.first
                    ? [FilteringTextInputFormatter.deny(RegExp('[., -]'))]
                    : null,
                onChanged: (String value) {
                  e == fieldsInfo.first
                      ? instance.card = value
                      : instance.fullName = value;

                  checkValidate();
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Container pickIdSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate('type_of_document'),
            style: AppFonts.medium14,
          ),
          SizedBox(height: 10.0),
          DropdownCustom(
            hintText: 'select_a_type_of_document',
            item: cardID,
            items: cardIDList,
            setItem: (value) {
              setState(() => cardID = value);

              if (cardID != null)
                instance.cardType = cardIDList.indexOf(cardID!);

              checkValidate();
            },
          ),
        ],
      ),
    );
  }

  Container buildIntroSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate(
              'verify_your_personal_document',
            ),
            style: AppFonts.bold18,
          ),
          const SizedBox(height: 4.0),
          Text(
            LocalizationsUtil.of(context).translate(
              "your_information_will_be_secured_by_houze's_terms_and_conditions",
            ),
            style: AppFonts.regular15,
          ),
        ],
      ),
    );
  }
}

class _CardID {
  final String name;

  _CardID(this.name);
}
