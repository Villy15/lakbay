import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';


class PaymentWebView extends ConsumerStatefulWidget {
  final Uri uri;

  const PaymentWebView({super.key, required this.uri});

  @override
  // ignore: library_private_types_in_public_api
  _PaymentWebViewState createState() => _PaymentWebViewState();


}

class _PaymentWebViewState extends ConsumerState<PaymentWebView> {
  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Handle back button press
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You backed off from the payment.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(false);
        return false;
      },
      child: Scaffold(
        appBar: _appBar(context, 'Booking Payment'),
        body: WebView(
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
        ),
      ),
    );
  }
}



AppBar _appBar(BuildContext context, String title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(color: Theme.of(context).colorScheme.primary)
    ),
    iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
  );
}

// class PaymentWebView extends StatefulWidget {
//   final Uri uri;

//   const PaymentWebView({super.key, required this.uri});

//   @override
//   _PaymentWebViewState createState() => _PaymentWebViewState();
// }

// class _PaymentWebViewState extends State<PaymentWebView> {
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: widget.uri.toString(),
//       javascriptMode: JavascriptMode.unrestricted,
//       navigationDelegate: (NavigationRequest request) {
//         if (request.url.startsWith('https://lakbay.com/payment-success')) {
//           // Handle payment success
//           Navigator.of(context).pop(true);
//           return NavigationDecision.prevent;
//         }
//         if (request.url.startsWith('https://lakbay.com/payment-failure') ||
//             request.url.startsWith('https://lakbay.com/payment-cancel')) {
//           // Handle payment failure or cancellation
//           Navigator.of(context).pop(false);
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     );
//   }
// }