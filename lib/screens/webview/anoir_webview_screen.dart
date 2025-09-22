import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/anoir_primary_appbar.dart';
import '../../style/colors.dart';



class AnoirWebviewScreen extends StatefulWidget {
  String url;
  AnoirWebviewScreen({required this.url});

  @override
  State<AnoirWebviewScreen> createState() => _AnoirWebviewScreenState();
}

class _AnoirWebviewScreenState extends State<AnoirWebviewScreen> {

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      // iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true);

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  int index = 0;
  // When load end
  whenLoadEnd(String A) {
    setState(() {
      index = 1;
    });
  }

  // begin ready
  loadStart(String A) {
    setState(() {
      index = 0;
    });
  }

  @override
  void initState() {
    log('URL == ${widget.url}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AnoirPrimaryAppbar(title: '',),
      body: IndexedStack(
        index: index,
        children: [
          Center(child: CircularProgressIndicator(color: AppColors.primaryBlueColor,),),
          buildInAppWebView()
         ],
      )
    );
  }

  buildInAppWebView(){
    return InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: settings,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT);
              },
              shouldOverrideUrlLoading:(controller, navigationAction) async {
                var uri = navigationAction.request.url!;
                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  // if (await canLaunchUrl(uri)) {
                  //   // Launch the App
                  //   await launchUrl(
                  //     uri,
                  //   );
                  //   // and cancel the request
                  //   return NavigationActionPolicy.CANCEL;
                  // }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController?.endRefreshing();
                setState(() {
                  index = 1;
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onReceivedError: (controller, request, error) {
                pullToRefreshController?.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController?.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {
                if (kDebugMode) {
                  print(consoleMessage);
                }
              },
            );
  }
}
