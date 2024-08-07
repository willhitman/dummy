import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/database_service.dart';
import '../../widgets/posts_template.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

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
  @override
  void dispose(){
    super.dispose();
    preload();
    posts;
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
                            userID: doc.data()["user"], DocumentReference: doc.reference,)
                    ]);

              }
              return const SizedBox();
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
