import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BasicMedicineWebView extends StatefulWidget {
  @override
  _BasicMedicineWebViewState createState() => _BasicMedicineWebViewState();
}

class _BasicMedicineWebViewState extends State<BasicMedicineWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse('https://www.webmd.com/drugs/2/index'))
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
