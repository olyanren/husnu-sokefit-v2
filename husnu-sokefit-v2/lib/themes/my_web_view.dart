import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'custom_text.dart';

class MyWebView extends StatefulWidget {
  final String title;
  final String url;
  String successUrl;
  String errorUrl;

  MyWebView(
      {@required this.title,
      @required this.url,
      this.successUrl,
      this.errorUrl});

  _WebViewState createState() =>
      _WebViewState(this.title, this.url, this.successUrl, this.errorUrl);
}

class _WebViewState extends State<MyWebView> {
  String url;
  String title;
  String finishUrl;
  String errorUrl;

  _WebViewState(this.title, this.url, this.finishUrl, this.errorUrl);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains(this.finishUrl)) {
        Navigator.pop(
            context, Uri.decodeFull(url.substring(url.lastIndexOf('?') +'?message='.length)));
      } else if (url.contains(this.errorUrl)) {
        Navigator.pop(context,
            'Hata: ' +Uri.decodeFull(url.substring(url.lastIndexOf('?') +'?message='.length)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: this.url,
      appBar: new AppBar(
        title: new CustomText(title, color: Colors.yellow),
      ),
    );
  }
}
