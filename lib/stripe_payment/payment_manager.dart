import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_stripe/stripe_payment/keys.dart';

abstract class PaymentManager {


static Future<void> makePayment(int amount , String currency) async {
try {
         String clientSecret=await _getClientSecret((amount*100).toString(), currency);
      await __initializePaymentSheet(clientSecret);
      Stripe.instance.presentPaymentSheet();

} catch (e) {
  throw Exception(e.toString());
}

}




  static _getClientSecret(String amount, String currency)async {
      Dio dio = Dio();
        var response= await dio.post(
        'https://api.stripe.com/v1/payment_intents',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${ApiKeys.testSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      ),
      data: {
        'amount': amount,
        'currency': currency,
      },
    );
    return response.data["client_secret"];
  }
  
  static __initializePaymentSheet(String clientSecret) {
    Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: 'karim',
      ),
    );
  }
      

  
  
  }