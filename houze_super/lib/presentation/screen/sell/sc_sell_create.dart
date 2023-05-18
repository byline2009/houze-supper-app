import 'dart:async';
import 'dart:io';

import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';

import 'package:houze_super/middle/api/agent_api.dart';
import 'package:houze_super/middle/api/profile_api.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/repo/agent_repository.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_button_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_progress_indicator.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../index.dart';

typedef void OnChangeImageHandler(List<ImageModel> images);

const String sellCreateMakeImageKey = 'sellCreateMakeImageKey';

const String sellCreatePickerImageKey = 'sellCreatePickerImageKey';

class SellCreatePage extends StatefulWidget {
  final String type;

  SellCreatePage({@required this.type});

  @override
  _SellCreatePageState createState() => _SellCreatePageState();
}

class _SellCreatePageState extends State<SellCreatePage> {
  final _apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );

  final SellTicketModel _sellTicketModel = SellTicketModel();

  final AgentRepository _repo = AgentRepository();

  final List<TextEditingController> _controllers =
      List.generate(3, (i) => TextEditingController());

  bool _hasValidation = false;

  var _coverImages = <ImageModel>[];
  var _images = <ImageModel>[];

  ApartmentMessageModel apartment;

  final _isProgressingSubject = StreamController<bool>.broadcast();

  Stream<bool> get isProgressing => _isProgressingSubject.stream;

  void _checkValidation() {
    if (_controllers.every((e) => e.text.isNotEmpty) &&
        _images.isNotEmpty &&
        _coverImages.isNotEmpty &&
        apartment.id != null)
      setState(() => _hasValidation = true);
    else
      setState(() => _hasValidation = false);
  }

  Future<void> _submit(BuildContext context) async {
    _isProgressingSubject.add(true);

    _sellTicketModel
      ..apartmentId = apartment.id
      ..sellPrice = "${int.parse(_controllers[0].text)}"
      ..percentCommission = double.parse(_controllers[1].text)
      ..requirement = _controllers[2].text
      ..type = widget.type.startsWith('s') ? 0 : 1
      ..statusPosted = 0;

    try {
      await _repo.sendAgentResell(_sellTicketModel);
      DialogCustom.showSuccessDialog(
        context: context,
        svgPath: AppVectors.icSellRent,
        title: 'upload_successfully',
        content:
            'houze_agent_will_call_to_confirm_and_contact_you_when_they_have_potential_leads',
        onPressed: () {
          Navigator.of(context).popUntil((route) {
            return (route.settings.name == AppRouter.forSellLease);
          });
        },
      );
    } catch (err) {
      if (<DioErrorType>[
        DioErrorType.DEFAULT,
        DioErrorType.CONNECT_TIMEOUT,
        DioErrorType.RECEIVE_TIMEOUT,
      ].contains(err.type))
        DialogCustom.showErrorDialog(
          context: context,
          title: 'there_is_no_network',
          errMsg: 'please_check_your_network_and_try_connect_again',
          callback: () => Navigator.pop(context),
        );
      else
        DialogCustom.showErrorDialog(
          context: context,
          title: 'upload_failed',
          errMsg: err.toString(),
          callback: () => Navigator.pop(context),
        );
    } finally {
      _isProgressingSubject.add(false);
    }
  }

  Widget _buildImageCoverSection() {
    return _SellImagePicker(
      isCoverImage: true,
      onChangeImages: (images) {
        setState(() => _coverImages = images);
        _sellTicketModel.images = _coverImages;

        _checkValidation();
      },
      images: _coverImages,
    );
  }

  Container _buildTextField(
          {@required String unit,
          @required TextEditingController controller,
          BuildContext context}) =>
      Container(
        height: 48.0,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 50.0,
              child: Text(
                unit,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: 1.0,
              color: Colors.black,
            ),
            const SizedBox(width: 16.0),
            Flexible(
              child: TextField(
                controller: controller,
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(
                    RegExp(unit != '%' ? '[., -]' : '[, -]'),
                  ),
                ],
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: unit != '%'
                      ? LocalizationsUtil.of(context).translate('enter_price')
                      : LocalizationsUtil.of(context)
                          .translate('enter_percent'),
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFb5b5b5),
                    fontWeight: FontWeight.normal,
                  ),
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                ),
                onChanged: (String str) => _checkValidation(),
              ),
            )
          ],
        ),
      );

  Column _buildDescriptionField(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate('description_with_colon'),
            style: AppFonts.regular14,
          ),
          SizedBox(height: 10.0),
          Container(
            height: 140.0,
            margin: EdgeInsets.only(bottom: 30.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(color: Color(0xFFdcdcdc)),
            ),
            child: TextField(
              controller: _controllers[2],
              keyboardAppearance: Brightness.light,
              style: AppFonts.medium,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                hintText: LocalizationsUtil.of(context).translate(
                    'please_input_more_info_of_your_apartment_(the_purchase_price_the_payment_progress)_as_well_as_the_time_the_agent_can_visit'),
                hintStyle: AppFonts.medium.copyWith(color: Color(0xff808080)),
                hintMaxLines: 6,
                border: InputBorder.none,
              ),
              onChanged: (str) => _checkValidation(),
            ),
          ),
        ],
      );

  @override
  void initState() {
    super.initState();

    _apartmentBloc.add(ApartmentLoadList());
  }

  @override
  void dispose() {
    _controllers.forEach((e) => e.dispose());
    _isProgressingSubject.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: widget.type == 'sell'
          ? "create_a_sell_posting"
          : "create_a_lease_posting",
      child: GestureDetector(
        onTap: () {
          bool isKeyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;
          if (isKeyboardShowing) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  _buildImageCoverSection(),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.0)
                        .copyWith(top: 16.0),
                    child: Column(
                      children: [
                        _Field(
                          title: LocalizationsUtil.of(context)
                              .translate('apartment_with_colon'),
                          widget: BlocProvider<ApartmentBloc>(
                            create: (_) => _apartmentBloc,
                            child: BlocBuilder<ApartmentBloc,
                                List<ApartmentMessageModel>>(
                              builder:
                                  (_, List<ApartmentMessageModel> apartments) {
                                return DropdownCustom(
                                  hintText: LocalizationsUtil.of(context)
                                      .translate('select_an_apartment'),
                                  item: apartment,
                                  items: apartments,
                                  setItem: (value) => apartment = value,
                                );
                              },
                            ),
                          ),
                        ),
                        _Field(
                          title: widget.type == 'sell'
                              ? LocalizationsUtil.of(context)
                                  .translate("desired_selling_price_with_colon")
                              : LocalizationsUtil.of(context).translate(
                                  'the_proposed_leasing_price_with_colon'),
                          widget: _buildTextField(
                              unit: 'VND',
                              controller: _controllers[0],
                              context: context),
                        ),
                        _Field(
                          title: LocalizationsUtil.of(context)
                              .translate('brokerage_fee_with_colon'),
                          widget: _buildTextField(
                              unit: '%',
                              controller: _controllers[1],
                              context: context),
                        ),
                        _buildDescriptionField(context),
                      ],
                    ),
                  ),
                  Container(
                    height: 5.0,
                    width: double.infinity,
                    color: Color(0xFFf5f5f5),
                  ),
                  Container(
                    margin: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LocalizationsUtil.of(context).translate('documents'),
                          style: AppFonts.bold.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 10.0),
                        RichText(
                          text: TextSpan(
                            style: AppFonts.regular,
                            children: <TextSpan>[
                              TextSpan(
                                text: '* ',
                                style: TextStyle(
                                    fontFamily: AppFonts.font_family_display,
                                    color: Color(0xFFff6666)),
                              ),
                              TextSpan(
                                  text: LocalizationsUtil.of(context)
                                      .translate('please_attaches_with_space')),
                              TextSpan(
                                text: LocalizationsUtil.of(context).translate(
                                    'apartment_authentication_documents_with_lower_case'),
                                style: TextStyle(
                                  fontFamily: AppFonts.font_family_display,
                                  color: Color(0xFF7a1dff),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: LocalizationsUtil.of(context).translate(
                                    "apartment_authentication_documents_example"),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _SellImagePicker(
                          onChangeImages: (images) {
                            setState(() => _images = images);
                            _sellTicketModel.imagesAuthenticated = _images;

                            _checkValidation();
                          },
                          images: _images,
                        ),
                        const SizedBox(height: 50.0),
                        RaisedButtonCustom(
                          buttonText: 'send',
                          onPressed: _hasValidation
                              ? () async => await _submit(context)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ProgressIndicatorWidget(isProgressing),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String title;

  final Widget widget;

  _Field({@required this.widget, @required this.title});

  @override
  Column build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.regular14,
        ),
        const SizedBox(height: 10.0),
        widget,
        const SizedBox(height: 30.0),
      ],
    );
  }
}

class _SellImagePicker extends StatefulWidget {
  final List<ImageModel> images;
  final OnChangeImageHandler onChangeImages;
  final bool isCoverImage;

  _SellImagePicker({
    @required this.images,
    this.onChangeImages,
    this.isCoverImage: false,
  });

  @override
  __SellImagePickerState createState() => __SellImagePickerState();
}

class __SellImagePickerState extends State<_SellImagePicker> {
  bool isUploading = false;

  final AgentAPI api = AgentAPI();

  final profileAPI = ProfileAPI();

  Future<void> loadAssets() async {
    try {
      List<File> imageSelected =
          await ChristianPickerImage.pickImages(maxImages: 1);

      if (imageSelected == null || imageSelected.length == 0) {
        return null;
      }

      this.setState(() {
        isUploading = true;
      });

      String filePath = imageSelected[0].path;

      var dir = await getTemporaryDirectory();
      var targetPath = dir.absolute.path + "/" + basename(filePath);
      var imageCompressed = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        minHeight: 1280,
        minWidth: 1280,
        quality: 60,
        keepExif: false,
      );

      await profileAPI.getProfile(); //refresh token

      final imageUploaded = widget.isCoverImage
          ? await api.uploadImage(imageCompressed)
          : await api.uploadAuthenticationImage(imageCompressed);

      imageCompressed.deleteSync();

      if (imageUploaded != null) {
        widget.images.add(imageUploaded);
        widget.onChangeImages(widget.images);
      }

      this.setState(() {
        isUploading = false;
      });
    } on Exception catch (e) {
      print(e.toString());
      this.setState(() {
        isUploading = false;
      });
    }
  }

  void removeImage(int imageIndex) {
    setState(() => widget.images.removeAt(imageIndex));
    widget.onChangeImages(widget.images);
  }

  Widget makePickerImage(BuildContext context) {
    if (widget.images.length == 5) {
      return const SizedBox.shrink();
    }

    return isUploading
        ? Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 80.0,
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 20.0,
              width: 20.0,
            ),
          )
        : widget.isCoverImage
            ? Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150.0,
                    decoration: BoxDecoration(color: Color(0xFFd0d0d0)),
                    child: Center(
                      child: widget.images.isNotEmpty
                          ? CachedImageWidget(
                              cacheKey: sellCreatePickerImageKey,
                              imgUrl: widget.images.first.imageThumb,
                              width: 150.0,
                              height: 150.0,
                            )
                          : Text(
                              LocalizationsUtil.of(context).translate(
                                  'please_upload_more_property_photos'),
                              style: AppFonts.medium16
                                  .copyWith(letterSpacing: 0.26),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FlatButton(
                      onPressed: loadAssets,
                      padding: const EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: Colors.white.withOpacity(0.8),
                      shape: OutlineInputBorder(
                        borderSide: BorderSide(style: BorderStyle.none),
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(8.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 15,
                              ),
                              const SizedBox(width: 2.0),
                              Text(
                                LocalizationsUtil.of(context)
                                    .translate('choose_photos'),
                                style: AppFonts.regular12,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : DottedBorder(
                child: Container(
                  width: 60.0,
                  height: 80.0,
                  child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: loadAssets,
                  ),
                ),
              );
  }

  Widget makeImageList() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index) {
            ImageModel item = widget.images[index];
            return Padding(
              key: Key(item.id),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Stack(
                children: <Widget>[
                  CachedImageWidget(
                    cacheKey: sellCreateMakeImageKey,
                    imgUrl: item.imageThumb,
                    width: 60.0,
                    height: 80.0,
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: GestureDetector(
                      // behavior: HitTestBehavior.opaque,
                      onTap: () => removeImage(index),
                      child: SizedBox(
                        height: 22.0,
                        width: 22.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCoverImage
        ? SizedBox(
            height: widget.images.isEmpty ? 150.0 : 250.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                makePickerImage(context),
                makeImageList(),
              ],
            ),
          )
        : Container(
            height: 100,
            alignment: Alignment.topLeft,
            child: Row(
              children: <Widget>[
                makePickerImage(context),
                makeImageList(),
              ],
            ),
          );
  }
}
