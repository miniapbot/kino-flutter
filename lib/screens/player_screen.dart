import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../api/client.dart';

class PlayerScreen extends StatefulWidget {
  final int kpId;

  const PlayerScreen({super.key, required this.kpId});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(ApiClient.getPlayerUrl(widget.kpId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Плеер'),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}