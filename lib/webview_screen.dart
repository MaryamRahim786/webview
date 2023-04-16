import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController? webViewController;
  PullToRefreshController? refreshController;

  late var url;
  var initialUrl = "https://www.google.com/";
  double progress = 0;
  var urlController = TextEditingController();
  var isloading = false;

  @override
  void initState() {
    super.initState();
    refreshController = PullToRefreshController(
        onRefresh: () {
          webViewController!.reload();
        },
        options: PullToRefreshOptions(
            color: Colors.amber, backgroundColor: Colors.black));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              if (await webViewController!.canGoBack()) {
                webViewController!.goBack();
              }
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
              color: const Color.fromARGB(227, 255, 255, 255),
              borderRadius: BorderRadius.circular(12)),
          child: TextFormField(
            onFieldSubmitted: (value) {
              url = Uri.parse(value);
              if (url.scheme.isEmpty) {
                url = Uri.parse("${initialUrl}search?q=$value");
              }

              webViewController!.loadUrl(urlRequest: URLRequest(url: url));
            },
            textAlignVertical: TextAlignVertical.center,
            controller: urlController,
            decoration: const InputDecoration(
                hintText: "   Type here ..", suffixIcon: Icon(Icons.search)),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                webViewController!.reload();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: Stack(
            alignment: Alignment.center,
            children: [
              InAppWebView(
                onLoadStart: ((controller, url) {
                  var v = url.toString();

                  setState(() {
                    isloading = true;
                    urlController.text = v;
                  });
                }),
                onLoadStop: (controller, url) {
                  refreshController!.endRefreshing();
                  setState(() {
                    isloading = false;
                  });
                },
                onProgressChanged: (controller, progress) {
                  if (progress == 100) {
                    refreshController!.endRefreshing();
                  }
                  setState(() {
                    this.progress = progress / 100;
                  });
                },
                pullToRefreshController: refreshController,
                onWebViewCreated: (controller) {
                  webViewController = controller;
                },
                initialUrlRequest: URLRequest(url: Uri.parse(initialUrl)),
              ),
              Visibility(
                  visible: isloading,
                  child: CircularProgressIndicator(
                    value: progress,
                    valueColor: const AlwaysStoppedAnimation(Colors.red),
                  ))
            ],
          )),
        ],
      ),
    );
  }
}
