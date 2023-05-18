import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef WebVoidFunc = void Function();

class WebviewWidget extends StatefulWidget {
  final String? title;
  final String? url;
  final String? content;
  final WebVoidFunc? doneEvent;

  const WebviewWidget({this.title, this.url, this.content, this.doneEvent});

  WebviewWidgetState createState() => WebviewWidgetState();
}

class WebviewWidgetState extends State<WebviewWidget> {
  final ProgressHUD progressToolkit = Progress.instanceCreateCirle();

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool _isShow = false;

  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  Widget contentWithUrl(url) {
    return AnimatedOpacity(
        duration: duration,
        opacity: _isShow ? 1 : 0,
        child: WebView(
          initialUrl: url.replaceAll(new RegExp(r' '), '%20'),
          javascriptMode: JavascriptMode.unrestricted,
          userAgent:
              "Mozilla/5.0 (iPhone; CPU iPhone OS 10_3 like Mac OS X) AppleWebKit/602.1.50 (KHTML, like Gecko) CriOS/56.0.2924.75 Mobile/14E5239e Safari/602.1",
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageStarted: (String url) {
            progressToolkit.state.show();
          },
          onPageFinished: (String url) {
            setState(() {
              _isShow = true;
              progressToolkit.state.dismiss();
            });
          },
          javascriptChannels: Set.from([
            JavascriptChannel(
                name: 'actionScript',
                onMessageReceived: (JavascriptMessage msg) {
                  Navigator.of(context).popUntil((route) {
                    return (route.settings.name == AppRouter.ROOT);
                  });
                }),
          ]),
          gestureNavigationEnabled: true,
        ));
  }

  Widget contentWithContent(content) {
    String url = Utils.convertURL(content);

    return AnimatedOpacity(
        duration: duration,
        opacity: _isShow ? 1 : 0,
        child: WebView(
            navigationDelegate: (NavigationRequest request) async {
              if (Platform.isIOS) {
                return NavigationDecision.navigate;
              }
              print('navigation to $request}');
              if (request.url.length > 0 &&
                  (request.url.startsWith('https://') ||
                      request.url.startsWith('http://'))) {
                var u = request.url;
                if (await canLaunch(u))
                  await launch(u);
                else {
                  final snackBar = SnackBar(
                    content: Text(
                      'Could not launch $u',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              progressToolkit.state.show();
              _controller.complete(webViewController);
            },
            onPageStarted: (String url) {
              progressToolkit.state.show();
            },
            onPageFinished: (String url) {
              setState(() {
                _isShow = true;
                progressToolkit.state.dismiss();
              });
            },
            gestureNavigationEnabled: true,
            gestureRecognizers: Platform.isAndroid
                ? {Factory(() => EagerGestureRecognizer())}
                : null));
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild webview ..." + DateTime.now().toString());
    late Widget content;

    if (widget.url != null) {
      content = this.contentWithUrl(widget.url);
    } else if (widget.content != null) {
      content = this.contentWithContent(widget.content);
    }

    if (widget.title == null) {
      return Stack(children: <Widget>[content, progressToolkit]);
    }

    return Scaffold(
        appBar: AppBar(
            title: Text(LocalizationsUtil.of(context).translate(widget.title),
                style: AppFonts.bold16),
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0.0),
        body: SafeArea(
            child: Container(
                color: Colors.white,
                child: Stack(children: <Widget>[content, progressToolkit]))));
  }
}
