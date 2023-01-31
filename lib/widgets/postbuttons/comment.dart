import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/widgets/comment_bubble.dart';

import '../widgets.dart';

class CommentButton extends StatefulWidget {
  final String docid;
  final String userID;
  String _author = "";
  var number;

  // ignore: non_constant_identifier_names
  CommentButton(
      {Key? key,
      required this.number,
      required this.docid,
      required this.userID})
      : super(key: key);

  @override
  State<CommentButton> createState() => _CommentButtonState();
}

class _CommentButtonState extends State<CommentButton> {
  TextEditingController _comment =  TextEditingController();
  Stream<QuerySnapshot>? comments;
  AsyncSnapshot commentcount = const AsyncSnapshot.nothing();

  gettingComments() async {
    comments = await DatabaseService().getsPostComments(widget.docid);
  }

  @override
  void initState() {
    gettingComments();
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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
                  Icons.chat_bubble_outline,
                  size: 25,
                ),
                onTap: () {
                  showBottomSheet(
                      context: context,
                      backgroundColor: const Color.fromARGB(100, 0, 0, 0),
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                            child: Wrap(
                          children: [
                            SizedBox(
                              height: 555,
                              width: double.infinity,
                              child: Column(
                                children: [
                                  SizedBox(height: 5,),
                                 Container(height: 5,width: 40,decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(10),
                                   color: Colors.grey
                                 ),),
                                  SizedBox(height: 5,),
                                  const Text(
                                    "Comments",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black87,
                                          ),
                                          width: double.infinity,
                                          height: 500,
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: StreamBuilder(
                                                stream: comments,
                                                builder: (context,
                                                    AsyncSnapshot snapshot) {
                                                  if (snapshot.hasData) {
                                                    const CircularProgressIndicator();

                                                    // get the new doc
                                                    return ListView.builder(
                                                        itemCount: snapshot
                                                            .data.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          // _nameAuthor(snapshot
                                                          //         .data
                                                          //         .docs[index]
                                                          //     ['sender']);
                                                             return Chatbubble( comment: snapshot
                                                                  .data
                                                                  .docs[index]['comment'], author_id: snapshot
                                                                  .data
                                                                  .docs[index]['sender'],);
                                                        });
                                                  } else {
                                                    return const Center(
                                                      child: Text(
                                                        "be the first to comment",
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Stack(alignment: Alignment.bottomCenter, children: [
                              Container(
                                color: Colors.black,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 290,
                                      child: TextField(
                                        controller: _comment,
                                        decoration:
                                            textInputDecoration.copyWith(
                                                labelText: "Comment",
                                                prefixIcon: Icon(
                                                  Icons.chat_bubble_outline,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                )),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: InkWell(
                                        child: const Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        onTap: () {
                                          sendComments();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ])
                          ],
                        ));
                      });
                },
              ),
              const SizedBox(
                height: 5,
              ),
              Text(widget.number.toString())
            ],
          ),
        ),
      ),
    ));
  }

  sendComments() {
    if (_comment.text.trim().isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "comment": _comment.text,
        "sender": FirebaseAuth.instance.currentUser!.uid,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      DatabaseService().sendComment(
          widget.docid,
          FirebaseAuth.instance.currentUser!.uid,
          widget.userID,
          chatMessageMap);
      setState(() {
        _comment.clear();
      });
    }
  }


}
