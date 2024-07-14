import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/database_service.dart';
import '../../widgets/widgets.dart';

class PayWithEco extends StatefulWidget {
  final String postID;
  const PayWithEco({super.key, required this.postID});

  @override
  State<PayWithEco> createState() => _PayWithEcoState();
}

class _PayWithEcoState extends State<PayWithEco> {
  TextEditingController phone = TextEditingController();
  bool state = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Text(
                  "Please enter your phone number below, do not close this screen till transaction finishes",
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "This is the boost and promote option, your post will be reach a wider target audience. Valid for a week(7 days)",
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                            ))
                        : const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.orangeAccent)),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            elevation: 0,
                          ),
                          onPressed: () async {
                            ProcessTransaction();
                          },
                          child: !state
                              ? const Text(
                                  "Make Payment",
                                  style: TextStyle(fontSize: 16),
                                )
                              : const Text("Please Wait")),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ProcessTransaction() async {
    setState(() {
      state = true;
    });
    var url = Uri.parse('http://enlightenedminds.pythonanywhere.com/pay');
    var response = await http.post(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'phone': phone.text.trim(),
          'email': FirebaseAuth.instance.currentUser!.email.toString()
        }));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      String status = json['state'];
      if (status == "true") {
        showSnackBar(context, Colors.greenAccent, "Payment Success");
        //  update post
        DatabaseService()
            .createPay(
                FirebaseAuth.instance.currentUser!.uid.toString(), status,widget.postID)
            .then((value) =>
                {showSnackBar(context, Colors.greenAccent, "Post Boosted")});
      } else if (status == "false") {
        showSnackBar(context, Colors.redAccent, "Payment Failed");
      } else {
        showSnackBar(context, Colors.greenAccent,
            "Hold tight, we are verifying your payment");

        DatabaseService()
            .createPay(
                FirebaseAuth.instance.currentUser!.uid.toString(), status, widget.postID)
            .then((value) => {
                  Future.delayed(const Duration(seconds: 5), () async {
                    var url = Uri.parse(
                        'http://enlightenedminds.pythonanywhere.com/check');
                    var response = await http.post(url,
                        headers: {
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'url': status,
                        }));
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');

                    if (response.statusCode == 200) {
                      Map<String, dynamic> json = jsonDecode(response.body);
                      String status = json['state'];
                      if (status == "true") {
                        showSnackBar(
                            context, Colors.greenAccent, "Payment Sucess");
                      } else if (status == "false") {
                        showSnackBar(context, Colors.redAccent,
                            "Payment Failed, Try Again");
                      }
                    }
                  })
                });
        //  check url now and possibly update post
      }
    }
    setState(() {
      state = false;
    });
  }
}
