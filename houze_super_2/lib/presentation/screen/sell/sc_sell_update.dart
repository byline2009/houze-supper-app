import 'dart:async';
import 'dart:io';
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:houze_super/app/blocs/apartment/index.dart';
import 'package:houze_super/middle/api/agent_api.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/middle/repo/agent_repository.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/dropdown_custom.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/widget_progress_indicator.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnChangeImageHandler(List<ImageModel> images);

const String sellUpdateMakeImageKey = 'sellUpdateMakeImageKey';

const String sellUpdatePickerImageKey = 'sellUpdatePickerImageKey';

class SellUpdatePage extends StatefulWidget {
  final String id;

  SellUpdatePage({required this.id});

  @override
  _SellUpdatePageState createState() => _SellUpdatePageState();
}

class _SellUpdatePageState extends RouteAwareState<SellUpdatePage> {
  final _agentBloc = AgentBloc();

  final _apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );

  final _sellTicketModel = SellTicketModel(images: [], imagesAuthenticated: []);

  final AgentRepository _repo = AgentRepository();

  final List<TextEditingController> _controllers =
      List.generate(3, (i) => TextEditingController());

  bool _hasValidation = false;
  bool _loadedDetail = false;

  var _coverImages = <ImageModel>[];
  var _images = <ImageModel>[];

  ApartmentMessageModel? _value;

  final _isProgressingSubject = StreamController<bool>.broadcast();

  Stream<bool> get isProgressing => _isProgressingSubject.stream;

  void _checkValidation() {
    if (_controllers.every((e) => e.text.trim().isNotEmpty) &&
        _images.isNotEmpty &&
        _coverImages.isNotEmpty &&
        _value?.id != null)
      setState(() => _hasValidation = true);
    else
      setState(() => _hasValidation = false);
  }

  Future<void> _submit(BuildContext context) async {
    _isProgressingSubject.add(true);

    _sellTicketModel
      ..apartmentId = _value?.id
      ..sellPrice = "${int.parse(_controllers[0].text)}"
      ..percentCommission = double.parse(_controllers[1].text)
      ..requirement = _controllers[2].text
      ..statusPosted = 0;

    try {
      await _repo.updateAgentResell(id: widget.id, ticket: _sellTicketModel);
      DialogCustom.showSuccessDialog(
        buttonText: "ok",
        context: context,
        svgPath: AppVectors.icSellRent,
        title: 'update_successfully',
        content:
            'houze_agent_will_call_to_confirm_and_contact_you_when_they_have_potential_leads',
        onPressed: () =>
            Navigator.of(context).popUntil(ModalRoute.withName("/sell")),
      );
    } on DioError catch (err) {
      if (<DioErrorType>[
        DioErrorType.other,
        DioErrorType.connectTimeout,
        DioErrorType.receiveTimeout,
      ].contains(err.type))
        DialogCustom.showErrorDialog(
          buttonText: "ok",
          context: context,
          title: 'there_is_no_network',
          errMsg: 'please_check_your_network_and_try_connect_again',
        );
      else
        DialogCustom.showErrorDialog(
          context: context,
          title: 'update_failed',
          errMsg: err.error,
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

  Widget _buildDropdown(
      {required List<ApartmentMessageModel> apartments,
      required String apartmentName,
      required BuildContext context}) {
    return DropdownCustom(
      hintText: LocalizationsUtil.of(context).translate('select_an_apartment'),
      item: _value ??= apartments.firstWhere((e) => e.name == apartmentName),
      items: apartments,
      setItem: (value) {
        setState(() {
          _value = value;
        });
      },
    );
  }

  Row _buildTextField(
          {required String unit,
          required TextEditingController controller,
          required BuildContext context}) =>
      Row(
        children: [
          Container(
            width: 50.0,
            child: Text(
              unit,
              style: AppFont.MEDIUM_GRAY_838383,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            width: 1.0,
            color: Colors.black,
          ),
          SizedBox(width: 16.0),
          Flexible(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              keyboardAppearance: Brightness.light,
              inputFormatters: [
                FilteringTextInputFormatter.deny(
                  RegExp(unit != '%' ? '[., -]' : '[, -]'),
                ),
              ],
              style: AppFonts.medium14,
              decoration: InputDecoration(
                hintText: unit != '%'
                    ? LocalizationsUtil.of(context).translate('enter_price')
                    : LocalizationsUtil.of(context).translate('enter_percent'),
                hintStyle: AppFont.MEDIUM_GRAY_838383,
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
              ),
              onChanged: (String str) {
                _checkValidation();
              },
            ),
          )
        ],
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
              style: AppFonts.medium14,
              keyboardAppearance: Brightness.light,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                hintText: LocalizationsUtil.of(context).translate(
                  'please_input_more_info_of_your_apartment_(the_purchase_price_the_payment_progress)_as_well_as_the_time_the_agent_can_visit',
                ),
                hintStyle: AppFont.MEDIUM_GRAY_838383,
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
    _agentBloc.add(AgentResellLoadDetail(id: widget.id));
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
      title: 'for_sell_lease',
      child: Stack(
        children: [
          BlocProvider<AgentBloc>(
            create: (_) => _agentBloc,
            child: BlocBuilder<AgentBloc, AgentState>(
              builder: (_, AgentState state) {
                if (state is AgentResellDetailFailure)
                  return SomethingWentWrong();

                if (state is AgentResellDetailSuccessful) {
                  _sellTicketModel.type = state.sell.type;

                  final List<String> _list = [
                    state.sell.sellPrice!,
                    state.sell.percentCommission.toString(),
                    state.sell.requirement!,
                  ];

                  _sellTicketModel.sellPrice = state.sell.sellPrice;
                  _sellTicketModel.percentCommission =
                      state.sell.percentCommission;
                  _sellTicketModel.requirement = state.sell.requirement;

                  if (_loadedDetail == false) {
                    _controllers.forEach(
                        (e) => e.text = _list[_controllers.indexOf(e)]);
                    _loadedDetail = true;
                  }

                  _coverImages = state.sell.images!;

                  _images = state.sell.imagesAuthenticated!;

                  return SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildImageCoverSection(),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0)
                              .copyWith(top: 16.0),
                          child: Column(
                            children: [
                              _FieldApartment(
                                title: LocalizationsUtil.of(context)
                                    .translate('apartment_with_colon'),
                                widget: BlocProvider<ApartmentBloc>(
                                  create: (_) => _apartmentBloc,
                                  child: BlocBuilder<ApartmentBloc,
                                          List<ApartmentMessageModel>>(
                                      builder: (_,
                                          List<ApartmentMessageModel>
                                              apartments) {
                                    if (apartments.isNotEmpty)
                                      return _buildDropdown(
                                        context: context,
                                        apartments: apartments,
                                        apartmentName:
                                            state.sell.apartmentName!,
                                      );

                                    return Center(
                                        child: CupertinoActivityIndicator());
                                  }),
                                ),
                              ),
                              _Field(
                                title: LocalizationsUtil.of(context).translate(
                                    state.sell.type == 0
                                        ? 'desired_selling_price_with_colon'
                                        : 'the_proposed_leasing_price_with_colon'),
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
                                LocalizationsUtil.of(context)
                                    .translate('documents'),
                                style: AppFonts.bold16,
                              ),
                              const SizedBox(height: 10.0),
                              RichText(
                                text: TextSpan(
                                  style: AppFonts.regular14,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '* ',
                                      style: TextStyle(
                                          fontFamily:
                                              AppFont.font_family_display,
                                          color: Color(0xFFff6666)),
                                    ),
                                    TextSpan(
                                      text: LocalizationsUtil.of(context)
                                          .translate(
                                              'please_attaches_with_space'),
                                    ),
                                    TextSpan(
                                      text: LocalizationsUtil.of(context).translate(
                                          'apartment_authentication_documents_with_lower_case'),
                                      style: TextStyle(
                                        fontFamily: AppFont.font_family_display,
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
                              SizedBox(height: 16.0),
                              _SellImagePicker(
                                onChangeImages: (images) {
                                  setState(() => _images = images);
                                  _sellTicketModel.imagesAuthenticated =
                                      _images;

                                  _checkValidation();
                                },
                                images: _images,
                              ),
                              SizedBox(height: 50.0),
                              ButtonWidget(
                                defaultHintText: LocalizationsUtil.of(context)
                                    .translate('send'),
                                callback: () async {
                                  await _submit(context);
                                },
                                isActive: _hasValidation,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return SizedBox(
                  width: AppConstant.screenWidth.toDouble(),
                  height: AppConstant.screenHeight.toDouble(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150.0,
                        decoration: BoxDecoration(color: Color(0xFFd0d0d0)),
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ParkingCardSkeleton(
                              height: 80,
                              width: 60,
                              borderRadius: 4,
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: ParkingCardSkeleton(
                              height: 80,
                              width: 60,
                              borderRadius: 4,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListSkeleton(
                            length: 3,
                            shrinkWrap: true,
                            config: SkeletonConfig(
                                bottomLinesCount: 1,
                                isCircleAvatar: false,
                                isShowAvatar: false,
                                theme: SkeletonTheme.Light)),
                      )
                    ],
                  ),
                ); //Align(child: CupertinoActivityIndicator());
              },
            ),
          ),
          ProgressIndicatorWidget(isProgressing),
        ],
      ),
    );
  }
}

class _FieldApartment extends StatelessWidget {
  final String title;

  final Widget widget;

  _FieldApartment({required this.widget, required this.title});

  @override
  Column build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.regular14,
        ),
        SizedBox(height: 10.0),
        widget,
        SizedBox(height: 30.0),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String title;
  final Widget widget;

  _Field({required this.widget, required this.title});

  @override
  Column build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppFonts.regular14,
        ),
        SizedBox(height: 10.0),
        Container(
          height: 40.0,
          padding: widget is BlocProvider<ApartmentBloc>
              ? EdgeInsets.only(left: 20.0, right: 10.0)
              : null,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(),
              borderRadius: BorderRadius.circular(4.0),
            ),
          ),
          child: widget,
        ),
        SizedBox(height: 30.0),
      ],
    );
  }
}

class _SellImagePicker extends StatefulWidget {
  final List<ImageModel> images;
  final OnChangeImageHandler? onChangeImages;
  final bool isCoverImage;

  _SellImagePicker({
    required this.images,
    this.onChangeImages,
    this.isCoverImage: false,
  });

  @override
  __SellImagePickerState createState() => __SellImagePickerState();
}

class __SellImagePickerState extends State<_SellImagePicker> {
  bool isUploading = false;

  final api = AgentAPI();

  Future<void> loadAssets() async {
    try {
      List<File> imageSelected =
          await ChristianPickerImage.pickImages(maxImages: 1);

      if (imageSelected.length == 0) {
        return;
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

      final imageUploaded = widget.isCoverImage
          ? await api.uploadImage(imageCompressed!)
          : await api.uploadAuthenticationImage(imageCompressed!);

      imageCompressed.deleteSync();

      widget.images.add(imageUploaded);
      widget.onChangeImages!(widget.images);

      this.setState(() {
        isUploading = false;
      });
    } on Exception catch (e) {
      print(e);
      this.setState(() {
        isUploading = false;
      });
    }
  }

  void removeImage(int imageIndex) {
    setState(() => widget.images.removeAt(imageIndex));
    widget.onChangeImages!(widget.images);
  }

  Widget makePickerImage(BuildContext context) {
    if (widget.images.length == 5) {
      return SizedBox.shrink();
    }

    return isUploading
        ? Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 80.0,
            child: SizedBox(
              child: CupertinoActivityIndicator(),
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
                              cacheKey: sellUpdatePickerImageKey,
                              imgUrl: widget.images.first.imageThumb!,
                              width: 150.0,
                              height: 150.0,
                            )
                          : Text(
                              LocalizationsUtil.of(context).translate(
                                  'please_upload_more_property_photos'),
                              style: AppFonts.medium16,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: TextButton(
                      onPressed: () {
                        loadAssets();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.all(0)),
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => Colors.white.withOpacity(0.8)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 15,
                                color: Colors.black,
                              ),
                              SizedBox(width: 2.0),
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
            return Padding(
              key: Key(widget.images[index].id!),
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Stack(
                children: <Widget>[
                  CachedImageWidget(
                    cacheKey: sellUpdateMakeImageKey,
                    imgUrl: widget.images[index].imageThumb!,
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
