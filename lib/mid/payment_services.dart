import 'package:http/http.dart' as http;
import 'package:nampa_hub/mid/token_manager.dart';
import 'dart:convert';
import 'package:nampa_hub/src/config.dart';

class PayPalService {
  Future<Map<String, String>> createOrder() async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token can not be empty');
    }

    final uri = Uri.parse(createorder);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'orderId': data['id'],
        'approvalUrl': data['approvalUrl'],
      };
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<Map<String, String>> createAttend(double totalAmount,
      {String organizerPayPalEmail = '',
      double platformFeePercentage = 10}) async {
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Token can not be empty');
    }
    final uri = Uri.parse(attendpaid);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode({
        'amount': totalAmount,
      }),
    );

    print("Response : $response");
    print("Response status : ${response.statusCode}");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Response id: ${data['id']}");
      print("Response url: ${data['approvalUrl']}");
      return {
        'orderId': data['id'],
        'approvalUrl': data['approvalUrl'],
      };
    } else {
      throw Exception(
          'Failed to create attend with status code ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> capturePayment(String orderId) async {
    print("Order Id from inside function : $orderId");
    final uri = Uri.parse('$returnpayment?order_id=$orderId');
    print("final Url : $uri");

    final response =
        await http.get(uri, headers: {'Content-type': 'application/json'});
    print("response status : ${response.statusCode}");
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to capture order');
    }
  }
}
