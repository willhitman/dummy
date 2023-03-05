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
  bool _regState = false;

  preload() {
    posts = DatabaseService().getsPostsFilter();
  }

  @override
  void initState() {
    preload();
    super.initState();
  }

  var doc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
            stream: posts,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                print('hasData');
                var docs = snapshot.data.docs;
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
                            userID: doc.data()["user"])
                    ]);
                for (doc in docs) {
                  // if(getRegState(doc.data()['user'])){
                  PageView(
                      controller: _controler,
                      scrollDirection: Axis.vertical,
                      children: [
                        for (doc in docs)
                          getRegState(doc.data()['user'])
                              ? PostTemplate(
                                  likes: doc.data()["likes"],
                                  comments: doc.data()["comments"],
                                  url: doc.data()["content"],
                                  postid: doc.id.toString(),
                                  caption: doc.data()["caption"],
                                  userID: doc.data()["user"])
                              : SizedBox()
                      ]);
                }
                // followers.contains((doc.data()["user"]))
                // var regstate = doc.data()['user'];
              }
              return SizedBox();
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

  bool getRegState(userid) {
    DatabaseService().userCollection.doc(userid).get().then((document) {
      setState(() {
        _regState = document["reg"];
      });
    });
    print(_regState);
    return _regState;
  }
}
