import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class NewsDetailsPage extends StatelessWidget {
  NewsDetailsPage({Key? key, required this.newsUrl, required this.title})
      : super(key: key);

  final String title;
  final String newsUrl;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              Share.share('Check out this interesting news!\n $newsUrl');
            },
            icon: Icon(Icons.share),
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          initialUrl: newsUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
