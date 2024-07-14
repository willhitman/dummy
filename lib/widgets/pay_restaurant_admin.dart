import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class PaymentCard extends StatefulWidget {
  final String userId;
  final String amount;
  const PaymentCard(data, {super.key, required this.userId, required this.amount});

  @override
  State<PaymentCard> createState() => _ResUserCardState();
}

class _ResUserCardState extends State<PaymentCard> {
  late String author = "";
  late String amount = "";
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: ListTile(

        title: Text((nameAuthor(widget.userId))),
        subtitle: Text("RTGS $amount"),
      ),

    );
  }
  getAuthorName(var uid) async {
    DocumentSnapshot authorName =
    await DatabaseService().getPostAuthorName(uid);
    return authorName["fullName"];
  }

  String nameAuthor(uid) {
    getAuthorName(uid).then((value) {
      setState(() {
        author = value;
        print("the authur is $author");
        amount = widget.amount;
      });
    });
    return author;
  }

}
