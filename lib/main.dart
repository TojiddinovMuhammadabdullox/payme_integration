import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uzpay/enums.dart';
import 'package:uzpay/objects.dart';
import 'package:uzpay/uzpay.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _controller = TextEditingController();

  final String PAYME_MERCHANT_ID = '587f72c72cac0d162c722ae2';
  final String TRANS_ID = 'transaction_001';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payme To\'lovi'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}')),
              ],
              decoration: const InputDecoration(
                hintText: "Summani kiriting...",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2.0),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
              ),
            ),
            const SizedBox(height: 25),
            ZoomTapAnimation(
              onTap: () => doPayment(
                amount: _controller.text.isNotEmpty
                    ? double.parse(_controller.text.toString())
                    : 0,
              ),
              child: Card(
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: SizedBox(
                    height: 90,
                    child: Image.asset(
                      'assets/images/payme_logo.png',
                      width: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void doPayment({required double amount}) async {
    if (amount > 500) {
      var paymentParams = Params(
        paymeParams: PaymeParams(
          transactionParam: TRANS_ID,
          merchantId: PAYME_MERCHANT_ID,
          accountObject: 'userId',
          headerColor: Colors.indigo,
          headerTitle: "Payme orqali to'lash",
        ),
      );

      try {
        await UzPay.doPayment(
          context,
          amount: amount,
          paymentSystem: PaymentSystem.Payme,
          paymentParams: paymentParams,
          browserType: BrowserType.External,
        );
        print('To\'lov muvaffaqiyatli amalga oshirildi.');
      } catch (e) {
        print('Xatolik yuz berdi: $e');
      }
    } else {
      print("To'lov imkonsiz, minimal summa 500 so'mdan yuqori!");
    }
  }
}
