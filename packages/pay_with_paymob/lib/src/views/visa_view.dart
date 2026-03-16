import 'package:flutter/material.dart';
import 'package:pay_with_paymob/src/helpers/paymob_snack_bar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VisaScreen extends StatefulWidget {
  const VisaScreen({
    super.key,
    required this.finalToken,
    required this.iframeId,
    required this.onFinished,
    required this.onError,
  });
  final String finalToken;
  final String iframeId;
  final VoidCallback onFinished;
  final VoidCallback onError;
  @override
  State<VisaScreen> createState() => _VisaScreenState();
}

class _VisaScreenState extends State<VisaScreen> {
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
      widget.onFinished();
    } else {
      widget.onError();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: null,
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
                showPaymobSnackBar(context, message.message);
              },
            )
            ..loadRequest(
              Uri.parse(
                'https://accept.paymob.com/api/acceptance/iframes/?payment_token=',
              ),
            ),
        ),
      ),
    );
  }
}
