import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/database_service.dart';

class Chatbubble extends StatefulWidget {
  final String comment;
  final String author_id;

  const Chatbubble({Key? key, required this.comment, required this.author_id})
      : super(key: key);

  @override
  State<Chatbubble> createState() => _ChatbubbleState();
}

class _ChatbubbleState extends State<Chatbubble> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(100, 255, 255, 255),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                  child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Row(children: [
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
                              )
                      ])
                      //get author Name

                      ),
                )),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(widget.comment),
                  )),
            )
          ],
        ),
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
