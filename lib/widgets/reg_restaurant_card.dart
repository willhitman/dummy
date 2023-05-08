import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class ResUserCard extends StatefulWidget {
  final String userId;
  final String userName;
  const ResUserCard(data, {Key? key, required this.userId, required this.userName}) : super(key: key);

  @override
  State<ResUserCard> createState() => _ResUserCardState();
}

class _ResUserCardState extends State<ResUserCard> {
  late String author = "";
  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: ListTile(
          title: Text(widget.userId),
          subtitle: const Text("click to see posts"),
      ),
      onTap: (){

      },
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
      });
    });
    return author;
  }
}
