// Web implementation: open article in a new browser tab and provide a close button
import 'dart:html' as html;
import 'package:flutter/material.dart';

class PlatformWebView extends StatefulWidget {
  final String url;
  const PlatformWebView({super.key, required this.url});

  @override
  State<PlatformWebView> createState() => _PlatformWebViewState();
}

class _PlatformWebViewState extends State<PlatformWebView> {
  @override
  void initState() {
    super.initState();
    // Open the URL in a new tab
    html.window.open(widget.url, '_blank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Text('Opened article in a new tab. Close that tab to return.'),
      ),
    );
  }
}
