import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';
import 'package:pay_with_paymob/src/services/dio_helper.dart';
import 'package:pay_with_paymob/src/views/visa_view.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({
    super.key,
    required this.onPaymentSuccess,
    required this.price,
    required this.onPaymentError,
  });

  final VoidCallback onPaymentSuccess;
  final double price;
  final VoidCallback onPaymentError;

  @override
  PaymentViewState createState() => PaymentViewState();
}

class PaymentViewState extends State<PaymentView> {
  String paymentFirstToken = '';
  String paymentOrderId = '';
  String finalToken = '';
  final PaymentData paymentData = PaymentData();

  bool isLoading = true;
  bool _didNavigateToVisa = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _startCardPaymentFlow();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paymentData.style?.scaffoldColor,
      appBar: AppBar(
        backgroundColor: paymentData.style?.appBarBackgroundColor,
        foregroundColor: paymentData.style?.appBarForegroundColor,
        title: const Text('Card Payment'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: paymentData.style?.circleProgressColor ?? Colors.blue,
        ),
      );
    }

    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorMessage!,
            textAlign: TextAlign.center,
            style: paymentData.style?.textStyle,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _startCardPaymentFlow,
            style: paymentData.style?.buttonStyle ??
                ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _startCardPaymentFlow() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await _getAuthToken();
      await _getOrderRegistrationId();
      await _getPaymentRequest();

      if (finalToken.isEmpty) {
        throw Exception('Failed to generate payment token');
      }

      if (!mounted || _didNavigateToVisa) return;
      _didNavigateToVisa = true;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => VisaScreen(
            onError: widget.onPaymentError,
            onFinished: widget.onPaymentSuccess,
            finalToken: finalToken,
            iframeId: paymentData.iframeId,
          ),
        ),
      );
    } catch (error) {
      log('Paymob card flow error: $error');
      if (!mounted) return;
      setState(() {
        errorMessage = 'Unable to start card payment. Please try again.';
      });
      widget.onPaymentError();
    } finally {
      if (mounted && !_didNavigateToVisa) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _getAuthToken() async {
    final response = await DioHelper.postData(
      url: '/auth/tokens',
      data: {
        "api_key": paymentData.apiKey,
      },
    );
    paymentFirstToken = response.data['token'] as String;
  }

  Future<void> _getOrderRegistrationId() async {
    final response = await DioHelper.postData(
      url: '/ecommerce/orders',
      data: {
        "auth_token": paymentFirstToken,
        "delivery_needed": "false",
        "amount_cents": (widget.price * 100).round().toString(),
        "currency": "EGP",
        "items": [],
      },
    );
    paymentOrderId = response.data['id'].toString();
  }

  Future<void> _getPaymentRequest() async {
    final requestData = {
      "auth_token": paymentFirstToken,
      "amount_cents": (widget.price * 100).round().toString(),
      "expiration": 3600,
      "order_id": paymentOrderId,
      "billing_data": {
        "apartment": "NA",
        "email": paymentData.userData?.email ?? 'NA',
        "floor": "NA",
        "first_name": paymentData.userData?.name ?? 'NA',
        "street": "NA",
        "building": "NA",
        "phone_number": paymentData.userData?.phone ?? 'NA',
        "shipping_method": "NA",
        "postal_code": "NA",
        "city": "NA",
        "country": "NA",
        "last_name": paymentData.userData?.lastName ?? 'NA',
        "state": "NA",
      },
      "currency": "EGP",
      "integration_id": paymentData.integrationCardId,
      "lock_order_when_paid": "false",
    };

    final response = await DioHelper.postData(
      url: '/acceptance/payment_keys',
      data: requestData,
    );
    finalToken = response.data['token'] as String;
  }
}
