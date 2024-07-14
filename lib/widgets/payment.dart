import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lifestyle/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class paymentUI extends StatefulWidget {
  final String postId;
  const paymentUI({super.key, required this.postId});

  @override
  State<paymentUI> createState() => _paymentUIState();
}

class _paymentUIState extends State<paymentUI> {
  TextEditingController phone = TextEditingController();
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Column(
          children: [
            !state
                ? SizedBox(
                    width: double.infinity,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: phone,
                      decoration: textInputDecoration.copyWith(
                          labelText: "Number eg (0777777777)",
                          prefixIcon: Icon(
                            Icons.chat_bubble_outline,
                            color: Theme.of(context).primaryColor,
                          )),
                    ),
                  )
                : const SizedBox(
                    child: Center(
                      child:
                          CircularProgressIndicator(color: Colors.orangeAccent),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            !state
                ? SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orangeAccent,
                          elevation: 0,
                        ),
                        onPressed: () async {
                          setState(() {
                            state = true;
                          });
                          sendPayments(phone.text.toString(),
                              FirebaseAuth.instance.currentUser!.email);
                          setState(() {
                            state = false;
                          });
                        },
                        child: const Text(
                          "Make Payment",
                          style: TextStyle(fontSize: 16),
                        )),
                  )
                : const SizedBox(
                    child: Center(
                        child: Text(
                            "Transaction Processing, Do Not Close this window")),
                  )
          ],
        ),
      ),
    );
  }

  sendPayments(phone, email) async {
    if (phone.length != 10) {
      var url = Uri.parse('http://enlightenedminds.pythonanywhere.com/pay');
      var response = await http.post(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{'phone': phone, 'email': email}));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        String status = json['state'];
        if (status == "true") {
          showSnackBar(context, Colors.greenAccent, "Payment Sucess");
        } else if (status == "false") {
          showSnackBar(context, Colors.redAccent, "Payment Failed");
        } else {
          showSnackBar(context, Colors.greenAccent,
              "Hold tight, we are verifying your payment");


          //  check url now and possibly update post
        }
      }
    }
  }
}
