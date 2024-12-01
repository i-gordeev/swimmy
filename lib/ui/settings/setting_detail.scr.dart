import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../theme/custom_icons.dart';
import '../shared_widgets/insertsvg.wgt.dart';

class SettingsDetail extends StatefulWidget {
  final String title;
  final String link;
  const SettingsDetail({super.key, required this.title, required this.link});

  @override
  State<SettingsDetail> createState() => _SettingsDetailState();
}

class _SettingsDetailState extends State<SettingsDetail> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.link));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const InsertSvg(CustomIcons.back, width: 32, color: Colors.white),
        ),
        title: Text(widget.title),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
