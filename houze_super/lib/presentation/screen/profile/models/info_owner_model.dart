import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class InfoOwnerElement extends Equatable {
  final String hint;
  final String title;

  InfoOwnerElement({@required this.hint, @required this.title});

  @override
  List<Object> get props => [title, hint];
}

final List<InfoOwnerElement> infoOwnerList = List.generate(5, (i) {
  switch (i) {
    case 0:
      return InfoOwnerElement(
        hint: 'company_name',
        title: 'Công ty Cổ phần Houze Group',
      );
      break;

    case 1:
      return InfoOwnerElement(
        hint: 'address_with_colon',
        title: '114 Ngô Quyền, Phường 8, Quận 5, TP. HCM',
      );
      break;

    case 2:
      return InfoOwnerElement(
          hint: 'tax_code',
          title:
              '''0316156148\nSở kế hoạch và đầu tư thành phố Hồ Chí Minh cấp ngày 24/03/2020''');
      break;

    case 3:
      return InfoOwnerElement(
        hint: 'Email:',
        title: 'info@houze.group',
      );
      break;
    default:
      break;
  }
  return InfoOwnerElement(
    hint: 'Hotline:',
    title: '0886048899',
  );
});
