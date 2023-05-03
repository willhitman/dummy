import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lifestyle/widgets/posts_template.dart';

import '../../services/database_service.dart';

class AdminPosts extends StatefulWidget {
  const AdminPosts({Key? key}) : super(key: key);

  @override
  State<AdminPosts> createState() => _AdminPostsState();
}

class _AdminPostsState extends State<AdminPosts> {
  Stream<QuerySnapshot>? posts;
  QuerySnapshot? postAuthorSnapShot;
  String author =  "";
  bool state = false;
  final _controler = PageController(initialPage: 0);
  @override
  void initState() {
    preload();

    super.initState();
  }

  preload() {
    posts = DatabaseService().getsPosts();
  }



  var doc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: posts,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                var docs = snapshot.data.docs;
                // for (doc in docs) print(doc.id);
                return PageView(
                    controller: _controler,
                    scrollDirection: Axis.vertical,
                    children: [
                      for (doc in docs)
                        PostTemplate (
                            likes: doc.data()["likes"],
                            comments: doc.data()["comments"],
                            url: doc.data()["content"],
                            postid: doc.id.toString(),
                            caption: doc.data()["caption"],
                            userID: doc.data()["user"], DocumentReference: doc.reference,)
                    ]);

              } else if (snapshot.hasData && !snapshot.data!.exists) {
                return const Center(child: Text("Document does not exist"));
              }
              return const Center(child:Text("tasked"));

            }));
  }



}
