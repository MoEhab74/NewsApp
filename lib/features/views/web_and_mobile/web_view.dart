import 'package:flutter/material.dart';

// Use conditional platform implementations
import 'webview_mobile.dart'
    if (dart.library.html) 'webview_web.dart';

class WebviewPage extends StatelessWidget {
  final String url;

  const WebviewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return PlatformWebView(url: url);
  }
}
