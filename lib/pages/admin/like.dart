import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/database_service.dart';
import '../../shared/notificationBubble.dart';

class AdminLikes extends StatefulWidget {
  const AdminLikes({Key? key}) : super(key: key);

  @override
  State<AdminLikes> createState() => _AdminLikesState();
}

class _AdminLikesState extends State<AdminLikes> {
  Stream<QuerySnapshot>? notify;
  String caption = "";
  @override
  void initState() {
    // TODO: implement initState
    notify = DatabaseService()
        .getNotifications(FirebaseAuth.instance.currentUser!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var doc;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Center(
                      child: Text(
                    "Notifications",
                    style: TextStyle(fontSize: 20),
                  )),
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: notify,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var docs = snapshot.data.docs;
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          for (doc in docs)
                            notificationBubble(
                                likes: doc.data()["likes"].toString(),
                                postName: nameAuthor(doc.id),
                                docID: doc.id,
                                comments: doc.data()["comments"].toString())
                        ],
                      ),
                    );
                    // for (doc in docs) print(doc.id);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
        ],
      ),
    );
  }

  PostCaption(var docid) async {
    DocumentSnapshot caption = await DatabaseService().getSinglePost(docid);
    return caption["caption"];
  }

  String nameAuthor(docid) {
    PostCaption(docid).then((value) {
      setState(() {
        caption = value;
      });
    });
    return caption;
  }
}
