import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HealthTipsWebView extends StatefulWidget {
  @override
  _HealthTipsWebViewState createState() => _HealthTipsWebViewState();
}

class _HealthTipsWebViewState extends State<HealthTipsWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse('https://www.healthline.com/health'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }
}
