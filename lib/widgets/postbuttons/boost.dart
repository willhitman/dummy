import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/services/api.dart';
import 'package:http/http.dart' as http;

import '../../pages/admin/pay.dart';
import '../../services/database_service.dart';
import '../widgets.dart';

class boostButton extends StatefulWidget {
  final String docid;
  final String userID;

  // ignore: non_constant_identifier_names
  const boostButton({Key? key, required this.docid, required this.userID})
      : super(key: key);

  @override
  State<boostButton> createState() => _BoostButtonState();
}

class _BoostButtonState extends State<boostButton> {
  TextEditingController phone = TextEditingController();
  bool state = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(150, 0, 0, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                child: const Icon(
                  Icons.auto_graph,
                  size: 25,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                               PayWithEco(postID: widget.docid,)));
                },
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  sendPayments(phone, email) async {
    if(phone.length != 10){

    }
  }
}
