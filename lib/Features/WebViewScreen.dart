// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_plugin_android_lifecycle/flutter_plugin_android_lifecycle.dart';

// class WebViewScreen extends StatefulWidget {
//   final String url;
//   final String title;

//   const WebViewScreen({super.key, required this.url, required this.title});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends ActivityAwareState<WebViewScreen> {
//   late final WebViewController _controller;
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) {
//             setState(() {
//               _isLoading = true;
//             });
//           },
//           onPageFinished: (url) {
//             setState(() {
//               _isLoading = false;
//             });
//           },
//           onWebResourceError: (error) {
//             setState(() {
//               _isLoading = false;
//             });
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Error loading website: ${error.description}')),
//             );
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(widget.url));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (_isLoading)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
// }
