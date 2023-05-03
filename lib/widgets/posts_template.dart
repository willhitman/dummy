import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lifestyle/pages/admin/profile.dart';
import 'package:lifestyle/widgets/postbuttons/boost.dart';
import 'package:lifestyle/widgets/postbuttons/comment.dart';
import 'package:lifestyle/widgets/postbuttons/delete.dart';
import 'package:lifestyle/widgets/postbuttons/follow.dart';
import 'package:lifestyle/widgets/postbuttons/like.dart';
import 'package:lifestyle/widgets/postbuttons/location.dart';
import 'package:video_player/video_player.dart';

import '../services/database_service.dart';

class PostTemplate extends StatefulWidget {
  final likes;
  final comments;
  final String postid;
  final String url;
  final String caption;
  final String userID;
  final DocumentReference;
  const PostTemplate(
      {Key? key,
      required this.likes,
      required this.comments,
      required this.postid,
      required this.caption,
      required this.url,
      required this.userID,
      required this.DocumentReference})
      : super(key: key);
  @override
  State<PostTemplate> createState() => _PostTemplateState();
}

class _PostTemplateState extends State<PostTemplate> {
  late String author = "lifestyle";
  bool _regState = false;

  @override
  void initState() {
    super.initState();
    getRegState(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // user post
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SizedBox(
              width: double.infinity,
              child: SizedBox.expand(
                  child: AspectRatio(
                aspectRatio: (screenSize.height / screenSize.width),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageUrl: widget.url,
                    placeholder: (context, url) => const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.orangeAccent,
                            ))),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),

                  // Image.network(
                  //   widget.url,
                  //   colorBlendMode: BlendMode.darken,
                  //   fit: BoxFit.cover,
                  // ),
                ),
              )),
            ),
          ),
        ),
        // buttons
        Container(
          alignment: const Alignment(1, 1),
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                followButton(
                  userID: widget.userID,
                ),
                const SizedBox(
                  height: 5,
                ),
                LikeButton(
                  number: widget.likes,
                  docid: widget.postid,
                  userID: widget.userID,
                ),
                CommentButton(
                  number: widget.comments,
                  docid: widget.postid,
                  userID: widget.userID,
                ),
                _regState
                    ? LocationButton(
                        location: nameAuthor(widget.userID).toString(),
                      )
                    : const SizedBox(
                        width: 2.0,
                      ),
                getOwner(widget.userID)
                    ? boostButton(
                        docid: widget.postid,
                        userID: widget.userID,
                      )
                    : const SizedBox(
                        width: 2.0,
                      ),
                getOwner(widget.userID)
                    ? DeletePosts(
                        DocumentReference: widget.DocumentReference,
                      )
                    : const SizedBox(
                        width: 2.0,
                      ),
              ],
            ),
          ),
        ),

        // user details and caption
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            alignment: const Alignment(-1, 1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      child: const SizedBox(
                        width: 50,
                        child: Icon(Icons.account_circle_rounded, size: 40),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AdminProfile(userID: widget.userID)));
                      },
                    ),
                    Container(
                      height: 30,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(150, 0, 0, 0),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(nameAuthor(widget.userID).toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
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
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(150, 0, 0, 0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: widget.caption),
                      // const TextSpan(text: " #flutter")
                    ])),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
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

  bool getOwner(userid) {
    if (_regState) {
      if (userid == FirebaseAuth.instance.currentUser!.uid) {
        return true;
      }
    }
    return false;
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
