
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MobileWalletScreen extends StatefulWidget {
  final String redirectUrl;
  final VoidCallback onSuccess;
  final VoidCallback onError;
  const MobileWalletScreen({
    super.key,
    required this.redirectUrl,
    required this.onSuccess, required this.onError,
  });

  @override
  State<MobileWalletScreen> createState() => _MobileWalletScreenState();
}

class _MobileWalletScreenState extends State<MobileWalletScreen> {
  bool _didHandlePaymentResult = false;


  @override
  void initState() {
    super.initState();
  }

  void _handlePaymobResult(String url) {
    if (_didHandlePaymentResult) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    final isPostPay = uri.path.contains('/api/acceptance/post_pay');
    if (!isPostPay) return;
    final success = uri.queryParameters['success'];
    if (success == null) return;
    _didHandlePaymentResult = true;
    if (success == 'true') {
      widget.onSuccess();
    } else {
      widget.onError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setBackgroundColor(const Color(0x00000000))
              ..setNavigationDelegate(
                NavigationDelegate(
                  onNavigationRequest: (NavigationRequest request) async {
                    _handlePaymobResult(request.url);
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..addJavaScriptChannel(
                'Toaster',
                onMessageReceived: (JavaScriptMessage message) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(message.message)),
                  );
                },
              )
              ..loadRequest(Uri.parse(widget.redirectUrl))),
      ),
    );
  }
}
