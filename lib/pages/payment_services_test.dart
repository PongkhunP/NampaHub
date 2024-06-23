import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nampa_hub/src/config.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:nampa_hub/mid/payment_services.dart';

class PayPalPayment extends StatefulWidget {
  final double attendFee;
  const PayPalPayment({super.key, required this.attendFee});

  @override
  _PayPalPaymentState createState() => _PayPalPaymentState();
}

class _PayPalPaymentState extends State<PayPalPayment> {
  final PayPalService payPalService = PayPalService();
  String? approvalUrl;
  String? orderId;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (String url) async {
          print('Page started loading: $url');
          if (url.startsWith(returnpayment)) {
            final Uri uri = Uri.parse(url);
            print("Token : $uri");
            final String? orderId = uri.queryParameters['token'];
            print("Token : $orderId");
            if (orderId != null) {
              await _capturePayment(orderId);
              print("capture successfully");
            }
          } else if (url.startsWith(cancelpayment)) {
            Navigator.pop(context, 'Payment cancelled');
          }
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        onWebResourceError: (WebResourceError error) {
          print('Web resource error: $error');
        },
      ));
    _createAttend();
  }

  Future<void> _createOrder() async {
    try {
      final response = await payPalService.createOrder();
      setState(() {
        approvalUrl = response['approvalUrl'];
      });
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create order: $error')),
      );
    }
  }

  Future<void> _createAttend() async {
    try {
      final result = await payPalService.createAttend(widget.attendFee);
      setState(() {
        approvalUrl = result['approvalUrl'];
        orderId = result['orderId'];
      });

      if (approvalUrl != null) {
        print('Loading approval URL: $approvalUrl');
        _controller.loadRequest(Uri.parse(approvalUrl!));
      } else {
        print('Approval URL is null');
      }
    } catch (error) {
      print('Error creating order: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create attend: $error')),
      );
    }
  }

  Future<void> _capturePayment(String orderId) async {
    try {
      print("Order Id from inside function : $orderId");
      final result = await payPalService.capturePayment(orderId);
      print('Payment captured: $result');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Payment successful')),
      // );
      // Navigator.pop(context, 'Payment successful');
    } catch (error) {
      print('Error capturing payment: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to capture payment: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PayPal Payment'),
      ),
      body: approvalUrl == null
          ? Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }
}
