import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/shared/recent_message.dart';
import 'package:lifestyle/widgets/comment_bubble.dart';
import 'package:lifestyle/widgets/widgets.dart';

class notificationBubble extends StatefulWidget {
  final String docID;
  final String postName;
  final String likes;
  final String comments;
  const notificationBubble(
      {Key? key,
      required this.docID,
      required this.likes,
      required this.comments,
      required this.postName})
      : super(key: key);

  @override
  State<notificationBubble> createState() => _notificationBubbleState();
}

class _notificationBubbleState extends State<notificationBubble> {
  bool _deleting = false;
  String _userName = "";
  Stream<QuerySnapshot>? comments;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingComments();
  }
  gettingComments() async {
    comments = await DatabaseService().getsPostComments(widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Center(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color.fromARGB(100, 255, 255, 255),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Your Post"),
                      Text(widget.postName),
                      Text("date")
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // likes
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 25),
                        child: Container(
                          width: 60,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(100, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                checkCount(widget.likes) ? const Text("0"): Text(widget.likes)
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        checkCount(widget.comments) ? showSnackBar(context,Colors.orange,"You currently have zero likes") : showBottomSheet(
                            context: context,
                            backgroundColor: Color.fromARGB(190, 0, 0, 0),
                            builder: (BuildContext context) {
                              print("here");
                              return SizedBox(
                                height: 500,
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: FutureBuilder<DocumentSnapshot>(
                                      future: DatabaseService().getSinglePost(widget.docID),
                                      builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot){
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }

                                        if (snapshot.hasData && !snapshot.data!.exists) {
                                          return Text("Document does not exist");
                                        }

                                        if (snapshot.hasData) {
                                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                                          _userName =  nameAuthor(data['recentSender']);
                                          return SingleChildScrollView( 
                                            child: Column(
                                              children: [
                                                const Text("Your fans"),
                                                Text(nameAuthor(data["users"].toString())),

                                              ],
                                            ),
                                          );
                                        }
                                        return Text("loading");
                                      }
                                  ),
                                ),
                              );
                            });
                      },
                    ),

                    //comments ################################
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 25),
                        child: Container(
                          width: 60,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(100, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.chat_bubble,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                checkCount(widget.comments) ? const Text("0"): Text(widget.comments)
                              ],
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        checkCount(widget.comments) ? showSnackBar(context,Colors.orange,"You currently have zero likes") : showBottomSheet(
                            context: context,
                            backgroundColor: const Color.fromARGB(190, 0, 0, 0),
                            builder: (BuildContext context) {
                              print("here");
                              return SizedBox(
                                height: 500,
                                child: SingleChildScrollView(
                                  child: FutureBuilder<DocumentSnapshot>(
                                      future: DatabaseService().getSinglePost(widget.docID),
                                      builder: (BuildContext context, AsyncSnapshot <DocumentSnapshot> snapshot){
                                        if (snapshot.hasError) {
                                          return Text("Something went wrong");
                                        }

                                        if (snapshot.hasData && !snapshot.data!.exists) {
                                          return Text("Document does not exist");
                                        }

                                        if (snapshot.connectionState == ConnectionState.done) {
                                          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
                                          _userName =  nameAuthor(data['recentSender']);
                                          return SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const Text("Recent Comment"),
                                                recentMessage(comment: data["comment"], authID: data["sender"]),
                                                const Text("More Comments"),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(10),
                                                      color: Colors.black87,
                                                    ),
                                                    width: double.infinity,
                                                    height: 400,
                                                    alignment: Alignment.centerLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: StreamBuilder(
                                                          stream: comments,
                                                          builder: (context,
                                                              AsyncSnapshot snapshot) {
                                                            if (snapshot.hasData) {
                                                              CircularProgressIndicator();

                                                              // get the new doc
                                                              return ListView.builder(
                                                                  itemCount: snapshot
                                                                      .data.docs.length,

                                                                  itemBuilder:
                                                                      (context, index) {

                                                                    return Chatbubble(comment: snapshot
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
                                            ),
                                          );
                                        }
                                        return Text("loading");
                                      }
                                  ),
                                ),
                              );
                            });
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _deleting
                        ? const Center(
                            child: SizedBox(
                                height: 10,
                                width: 10,
                                child: CircularProgressIndicator(
                                    color: Colors.white)),
                          )
                        : InkWell(
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            onTap: () async {
                              print("tap");
                              deleteNotify(widget.docID);
                            },
                          )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  deleteNotify(docid) async {
    print(widget.likes);

    setState(() {
      _deleting = true;
    });
    await DatabaseService().clearNotifications(docid, FirebaseAuth.instance.currentUser!.uid).then((value) => {
          setState(() {
            _deleting = false;
          })
        });
  }
  checkCount(String value){
    if (value == "null"){
      return true;
    } else {
      return false;
    }

  }
  getAuthorName(var uid)  async{
    DocumentSnapshot authorName = await  DatabaseService().getPostAuthorName(uid);
    return authorName["fullName"];
  }
  String nameAuthor(uid){
    getAuthorName(uid).then((value){
      setState(() {
        _userName = value;
      });
    });
    return _userName;
  }

}


