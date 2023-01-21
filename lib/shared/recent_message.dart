

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class recentMessage extends StatefulWidget {
  final String comment;
  final String authID;
  const recentMessage({Key? key, required this.comment, required this.authID}) : super(key: key);

  @override
  State<recentMessage> createState() => _recentMessageState();
}

class _recentMessageState extends State<recentMessage> {
  bool _regState = false;
  ValueNotifier<String> author = ValueNotifier("");
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.chat_bubble_outline),
      title: Text(widget.comment),
      subtitle: ValueListenableBuilder(
          valueListenable: author,
          builder: (context, author, _) {
            return Text(author.toString());
          }),
    );
  }
  _getAuthorName(var uid) async {
    DocumentSnapshot authorName =
    await DatabaseService().getPostAuthorName(uid);
    return authorName["fullName"];
  }

  _nameAuthor(uid) {
    _getAuthorName(uid).then((value) {
      setState(() {
        author.value = value;
      });
    });
  }

  getRegState(userid) {
    DatabaseService().userCollection.doc(userid).get().then((document) {
      setState(() {
        _regState = document["reg"];
      });
    });
    print(_regState);
    return _regState;
  }
}
