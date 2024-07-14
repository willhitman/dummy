import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class likeBubble extends StatefulWidget {
  final String author_id;
  const likeBubble({super.key, required this.author_id});

  @override
  State<likeBubble> createState() => _likeBubbleState();
}

class _likeBubbleState extends State<likeBubble> {
  bool _regState = false;
  ValueNotifier<String> author = ValueNotifier("");

  @override
  void initState() {
    _nameAuthor(widget.author_id);
    getRegState(widget.author_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle),
      title: Row(
        children: [
          ValueListenableBuilder(
              valueListenable: author,
              builder: (context, author, _) {
                return Text(author.toString());
              }),
          _regState
              ? const Icon(
                  Icons.verified,
                  color: Colors.yellowAccent,
                  size: 15,
                )
              : const Icon(
                  Icons.verified,
                  color: Colors.transparent,
                  size: 15,
                ),
        ],
      ),
      trailing: const Icon(
        Icons.favorite,
        color: Colors.redAccent,
      ),
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
