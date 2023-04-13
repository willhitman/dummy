import 'package:flutter/material.dart';

import '../../widgets/posts_template.dart';
class SinglePost extends StatefulWidget {
  final String likes;
  final String comments;
  final String url;
  final String postid;
  final String caption;
  final String userid;
  const SinglePost({Key? key, required this.likes, required this.comments, required this.url, required this.postid, required this.caption, required this.userid}) : super(key: key);

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  final _controler = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  PageView(
        controller: _controler,
        scrollDirection: Axis.vertical,
        children: [
          PostTemplate (
              likes: widget.likes,
              comments: widget.comments,
              url: widget.url,
              postid: widget.postid,
              caption: widget.caption,
              userID: widget.userid)
        ])
    );

  }
}
