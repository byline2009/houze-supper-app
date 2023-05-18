import 'package:equatable/equatable.dart';

class InfoOwnerElement extends Equatable {
  final String hint;
  final String title;

  InfoOwnerElement({required this.hint, required this.title});

  @override
  List<Object> get props => [title, hint];
}

final List<InfoOwnerElement> infoOwnerList = List.generate(5, (i) {
  switch (i) {
    case 0:
      return InfoOwnerElement(
        //
        // hint: 'Tên công ty:',
        hint: 'company_name',
        title: 'Công ty Cổ phần Houze Group',
      );

    case 1:
      return InfoOwnerElement(
        // hint: 'Địa chỉ:',
        hint: 'address_with_colon',
        title: '46 - 48 Tạ Hiện, Phường Thạnh Mỹ Lợi, TP. Thủ Đức, TP. HCM',
      );

    case 2:
      return InfoOwnerElement(
          // hint: 'Mã số thuế:',
          hint: 'tax_code',
          title:
              '''Giấy chứng nhận Đăng ký Kinh doanh số 0316177275\ndo Sở Kế hoạch và Đầu tư Thành phố Hồ Chí Minh cấp ngày 05/03/2020''');

    case 3:
      return InfoOwnerElement(
        hint: 'email_info',
        title: 'support@houze.vn',
      );
    default:
      break;
  }
  return InfoOwnerElement(
    hint: 'hot_line',
    title: '085 9999 424',
  );
});
