import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class FollowCard extends StatefulWidget {
  var data;
   FollowCard({super.key, required this.data});

  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  String author = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if(widget.data.length>0 )
          Container (child:Column(children: [
              for( var x in widget.data)
                ListTile(leading: const Icon(Icons.account_circle),title: Text(nameAuthor(x)) )

    ],))]
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
      });
    });
    return author;
  }

}
