import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/widgets/comment_bubble.dart';

import '../widgets.dart';

class boostButton extends StatefulWidget {
  final String docid;
  final String userID;
  // ignore: non_constant_identifier_names
  const boostButton(
      {Key? key,
        required this.docid,
        required this.userID})
      : super(key: key);

  @override
  State<boostButton> createState() => _BoostButtonState();
}

class _BoostButtonState extends State<boostButton> {

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
                      showBottomSheet(
                          context: context,
                          backgroundColor: const Color.fromARGB(100, 0, 0, 0),
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                                child: Wrap(

                                ));
                          });
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

}
