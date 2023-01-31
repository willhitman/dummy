import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../services/database_service.dart';
import '../../widgets/posts_template.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  Stream<QuerySnapshot>? posts;
  QuerySnapshot? postAuthorSnapShot;
  bool state = false;
  bool _hasFollowers = false;
  var followers = [];
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
            stream: DatabaseService()
                .getSingleUser(FirebaseAuth.instance.currentUser!.uid),
            builder: (context, AsyncSnapshot snapshot) {

              if(snapshot.hasData){
                followers = snapshot.data["following"];

              return StreamBuilder(
                  stream: posts,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      var docs = snapshot.data.docs;
                      // for (doc in docs) print(doc.id);
                      if (followers.contains(doc.data()["user"])) {
                        return PageView(
                            controller: _controler,
                            scrollDirection: Axis.vertical,
                            children: [
                              for (doc in docs)
                                PostTemplate(
                                    likes: doc.data()["likes"],
                                    comments: doc.data()["comments"],
                                    url: doc.data()["content"],
                                    postid: doc.id.toString(),
                                    caption: doc.data()["caption"],
                                    userID: doc.data()["user"])
                            ]);
                      }
                      return const SizedBox();
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  });} return const SizedBox();
            }));
  }

  makeFollowerList(var data) {
    if (data.length > 0) {
      _hasFollowers = true;
      for (var x in data) {
        followers.add(x);
      }
    } else {}
  }
}
