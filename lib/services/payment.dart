import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {

  Map<String, dynamic>? paymentIntentData;

  Future<bool> makePayment(BuildContext context, String total) async {
    bool result = false;
    try {
      paymentIntentData =
      await createPaymentIntent(total, 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              testEnv: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'ANNIE')).then((value) {});


      ///now finally display payment sheeet
      result = await displayPaymentSheet(context);
    } catch (e, s) {
      print('exception:$e$s');
    }
    return result;
  }

   createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer sk_test_51HyKMUIbLkWdqIr1msedCojtarC5DwRwpiRXmmyZYyDt4fnmpZtuqpBSp5capmJ3aKdEveAwY0kxcBogXHYQhKTJ00MMd64hHF',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  Future<bool> displayPaymentSheet(BuildContext context) async {
    bool result = false;
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: paymentIntentData!['client_secret'],
            confirmPayment: true,
          )).then((newValue) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("paid successfully")));
        result = true;
        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
    return result;
  }
}