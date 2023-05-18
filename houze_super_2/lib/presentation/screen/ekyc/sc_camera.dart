// import 'dart:async';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:houze_super/middle/model/ekyc_model.dart';
// import 'package:houze_super/presentation/common_widgets/widget_camera_scaffold.dart';
// import 'package:houze_super/presentation/common_widgets/widget_progress_indicator.dart';
// import 'package:houze_super/presentation/index.dart';
// import 'package:image/image.dart' as lib;
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// import '../../../main.dart';

// class CameraScreen extends StatefulWidget {
//   final Map<String, dynamic> args;

//   const CameraScreen({required this.args});

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   late EKYCModel instance;

//   late CameraController controller;

//   late Future<void> _initializeControllerFuture;

//   late bool isCard;

//   late double cameraWidth, cameraHeight;

//   final _isProgressingSubject = StreamController<bool>.broadcast();

//   Stream<bool> get isProgressing => _isProgressingSubject.stream;

//   Future<void> _takePhoto(BuildContext context) async {
//     _isProgressingSubject.add(true);

//     try {
//       await _initializeControllerFuture;

//       final xFile = await controller.takePicture();

//       lib.Image? img = lib.decodeImage(File(xFile.path).readAsBytesSync());

//       img = lib.copyRotate(img!, 90);

//       if (widget.args['title'].contains('S')) {
//         if (Platform.isAndroid)
//           img = lib.flipVertical(img);
//         else if (Platform.isIOS) img = lib.flipHorizontal(img);
//       }

//       double intX;
//       double intY;
//       double cropImgWidth;
//       double cropImgHeight;

//       final double ratioHeight = img.height / cameraHeight;
//       final double ratioWidth = img.width / cameraWidth;

//       if (widget.args['title'].contains('S')) {
//         intX = 32 * ratioWidth;
//         intY = intX;
//         cropImgWidth = img.width - 2 * intX;
//         cropImgHeight = cropImgWidth * 4 / 3 * ratioHeight / ratioWidth;
//       } else {
//         intX = 20 * ratioWidth;
//         intY = img.height / 6;
//         cropImgWidth = img.width - 2 * intX;
//         cropImgHeight = cropImgWidth * 2 / 3 * ratioHeight / ratioWidth;
//       }

//       final lib.Image cropImg = lib.copyCrop(
//         img,
//         intX.ceil(),
//         intY.ceil(),
//         cropImgWidth.ceil(),
//         cropImgHeight.ceil(),
//       );

//       final cropImgPath = join(
//         (await getTemporaryDirectory()).path,
//         '${DateTime.now()}.jpg',
//       );

//       final File cropImgFile = File(cropImgPath)
//         ..writeAsBytesSync(lib.encodePng(cropImg));

//       isCard
//           ? widget.args['title'].contains('F')
//               ? instance.cardFrontImage = cropImgPath
//               : instance.cardBackImage = cropImgPath
//           : instance.portraitImage = cropImgPath;

//       AppRouter.push(
//         context,
//         AppRouter.EKYC_PHOTO_REVIEW,
//         widget.args
//           ..update(
//             'instance',
//             (value) => instance.toJson(),
//           ),
//       );
//     } catch (err) {
//       print(err);
//     } finally {
//       _isProgressingSubject.add(false);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     instance = EKYCModel.fromJson(widget.args['instance']);
//     isCard = !widget.args['title'].contains('S');

//     controller = CameraController(
//       isCard ? cameras.first : cameras.last,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );

//     _initializeControllerFuture = controller.initialize();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     _isProgressingSubject.close();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String title = isCard
//         ? widget.args['title'].contains('F')
//             ? 'take_a_your_front_document'
//             : 'take_a_your_back_document'
//         : 'take_a_your_selfie';

//     final String adviceText = !widget.args['title'].contains('S')
//         ? 'please_put_your_card_inside_the_border_and_make_sure_the_quality_of_the_photo_to_be_clear'
//         : 'please_put_your_face_inside_the_border';

//     return WillPopScope(
//       onWillPop: () async => false,
//       child: CameraScaffold(
//         title: title,
//         subtitle: widget.args['sub_title'],
//         body: Column(
//           children: [
//             _buildAdvice(context: context, adviceText: adviceText),
//             _buildCamera(context),
//           ],
//         ),
//         onPressed: () => _takePhoto(context),
//       ),
//     );
//   }

//   Flexible _buildCamera(BuildContext context) {
//     return Flexible(
//       child: Stack(
//         children: [
//           CustomPaint(
//             foregroundPainter: isCard
//                 ? CardPainter(
//                     getWidth: (value) => cameraWidth = value,
//                     getHeight: (value) => cameraHeight = value,
//                   )
//                 : SelfiePainter(
//                     getWidth: (value) => cameraWidth = value,
//                     getHeight: (value) => cameraHeight = value,
//                   ),
//             child: FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (_, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done)
//                   return CameraPreview(controller);
//                 else
//                   return Align(child: CupertinoActivityIndicator());
//               },
//             ),
//           ),
//           ProgressIndicatorWidget(isProgressing),
//         ],
//       ),
//     );
//   }

//   Widget _buildAdvice({BuildContext? context, String? adviceText}) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//         vertical: 10.0,
//         horizontal: isCard ? 32.0 : 40,
//       ),
//       child: Text(
//         LocalizationsUtil.of(context).translate(adviceText),
//         style: AppFonts.regular15,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
