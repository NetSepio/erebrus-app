import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InAppWebViewScreen extends StatefulWidget {
  @override
  _InAppWebViewScreenState createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late InAppWebViewController webViewController;
  final TextEditingController urlController = TextEditingController();
  double progress = 0;

  @override
  void initState() {
    super.initState();
    urlController.text = "https://erebrus.io/";
  }

  void loadUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://www.google.com/search?q=${Uri.encodeComponent(url)}';
    }
    webViewController.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: TextField(
                controller: urlController,
                onTap: () {
                  urlController.clear();
                },
                decoration: InputDecoration(
                    hintText: "Enter URL or search query",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(1000)),
                    contentPadding: EdgeInsets.only(left: 15)),
                keyboardType: TextInputType.url,
                onSubmitted: (url) {
                  loadUrl(url);
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                webViewController.reload();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          if (progress < 1.0) LinearProgressIndicator(value: progress),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(urlController.text)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                useHybridComposition: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  urlController.text = url?.toString() ?? '';
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  urlController.text = url?.toString() ?? '';
                });
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  this.progress = progress / 100;
                });
              },
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (await webViewController.canGoBack()) {
                    webViewController.goBack();
                  }
                },
                child: Icon(Icons.arrow_back),
              ),
              ElevatedButton(
                onPressed: () async {
                  loadUrl("https://erebrus.io/");
                },
                child: Icon(Icons.home),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (await webViewController.canGoForward()) {
                    webViewController.goForward();
                  }
                },
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
