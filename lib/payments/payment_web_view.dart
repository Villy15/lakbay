import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class PaymentWebView extends StatefulWidget {
  final Uri uri;

  const PaymentWebView({super.key, required this.uri});

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.uri.toString(),
      javascriptMode: JavascriptMode.unrestricted,
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://lakbay.com/payment-success')) {
          // Handle payment success
          Navigator.of(context).pop(true);
          return NavigationDecision.prevent;
        }
        if (request.url.startsWith('https://lakbay.com/payment-failure') ||
            request.url.startsWith('https://lakbay.com/payment-cancel')) {
          // Handle payment failure or cancellation
          Navigator.of(context).pop(false);
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    );
  }
}