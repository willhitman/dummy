// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // refrenses for collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection("post");

  final CollectionReference payCollection =
  FirebaseFirestore.instance.collection("pay");

  final CollectionReference notifyCollection =
      FirebaseFirestore.instance.collection("notifyMe");

// firebase storage
  final storageRef = FirebaseStorage.instance;
  bool state = false;
  Future savingUserData(
    String fullName,
    String email,
  ) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "description": "",
      "email": email,
      "posts": [],
      "followers":[],
      "following":[],
      "profilePic": "",
      "uid": uid,
      'reg': false,
      'admin' : false
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }


  //get user by ID
  getSingleUser(String ID) {
    return userCollection.doc(ID).snapshots();
  }

  // creating a post sir
  Future createPost(String id, content, String type, String caption, bool regstate) async {
    String date = DateFormat('yyyy-MM-dd-HH-ss').format(DateTime.now());
    postCollection.add({
      "content": content,
      "type": type,
      "caption": caption,
      "likes": 0,
      "comments": 0,
      "user": id,
      "users": [],
      "tags": [],
      "reg": regstate,
      "date": date,
      'boost':false
    }).then((docRef) => {
          userCollection.doc(id).update({
            "posts": FieldValue.arrayUnion([docRef.id])
          })
        });
  }


  // get the posts
  getsPosts() {
    return postCollection.orderBy("date", descending: true).snapshots();
  }
  getsPostsFilter() {
    return postCollection.where('boost', isEqualTo: true).orderBy("date", descending: true).snapshots();
  }
  getUserByReg(){
    return userCollection.where('reg', isEqualTo: true).snapshots();

  }

  getsSinglePost(docid) {
    return postCollection.doc(docid).get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      print(data);
      return data;
    });
  }
  getPostsByUserID(String ID){
    return postCollection.where("user", isEqualTo: ID).orderBy("date", descending: true).snapshots();
  }

  getsPostComments(String docid) {
    return postCollection
        .doc(docid)
        .collection("comments")
        .orderBy("time")
        .snapshots();
  }

  likePost(String docId) async {
    await postCollection
        .doc(docId)
        .set({"likes": FieldValue.increment(1)}, SetOptions(merge: true));
  }
  addAbout(String docId, String about) async {
    await userCollection
        .doc(docId)
        .set({"description": about}, SetOptions(merge: true));
  }

  registerLike(String docid, String userid) async {
    postCollection.doc(docid).update({
      "users": FieldValue.arrayUnion([userid])

    });
  }
  checkUserStatus(String userID) async{
    await userCollection.doc(userID).get().then((document){
      state = document["reg"];
      return state;
    });
  }

  checkMembership(String docid, String userid) async {
    var mylist = [];
    await postCollection.doc(docid).get().then((document) {
      if(document.exists) {
        for (var user in document["users"]) {
          mylist.add(user);
        }
      }
    });

    // print(mylist.contains(userid));
    return mylist.contains(userid);
  }

  userLikePost(String docid, String authorID,String userID) async{
    // add user to likers
    await registerLike(docid, userID);
    // increment likes
    await likePost(docid);
    // set notification
    await notifyChangeComment(docid, authorID, "like");
  }
  //follow auth
  followAuthor(String authID, String userID) async {
    await userCollection.doc(authID).get().then((document){
      var mylist = [];
      for (var user in document["followers"]) {
        mylist.add(user);
      }
      if(!mylist.contains(userID)) {
        // return showSnackBar(context, Colors.green, "Already followed");
        follow(authID, userID);
      }
    });

  }
  //follow
  follow(String authID, String userID) async {
    await userCollection
        .doc(authID)
        .set({"followers":FieldValue.arrayUnion([userID])}, SetOptions(merge: true));
    await userCollection
        .doc(userID)
        .set({"following":FieldValue.arrayUnion([authID])}, SetOptions(merge: true));
  }
  // Post User Data
  getPostAuthorName(postAuthorID) {
    return userCollection.doc(postAuthorID).get();
  }

  //Get Post Caption
  getSinglePost(String postid) {
    return postCollection.doc(postid).get();
  }

  getUserName() async {
    Stream<QuerySnapshot> userData =
        userCollection.where("uid", isEqualTo: uid).snapshots();
    userData.first.then(
      (element) {
        element.docs.asMap().forEach((key, value) {
          HelperFunctions.saveUserNameSF(element.docs[key]["fullName"]);
          HelperFunctions.saveUserEmailSF(element.docs[key]["email"]);
          HelperFunctions.saveUserEmailSF(element.docs[key]["email"]);
          HelperFunctions.saveUserEmailSF(element.docs[key]["email"]);
        });
      },
    );
  }

  getPostAuthor(String uid) async {
    QuerySnapshot snapshot =
        await userCollection.where("uid", isEqualTo: uid).get();

    return snapshot;
  }

  // get group by name
  searchPostAuthorName(String uid) {
    return postCollection.where("uid", isEqualTo: uid).get();
  }


  // check user membership

  sendComment(String docid, String uid, String authID,
      Map<String, dynamic> comment) async {
    postCollection.doc(docid).collection('comments').add(comment);
    postCollection.doc(docid).update({
      'recentComment': comment['comment'],
      'recentSender': comment['sender'],
      'recentCommentTime': comment['time'].toString(),
    });
    await postCollection
        .doc(docid)
        .update({"comments": FieldValue.increment(1)});
    await notifyChangeComment(docid, authID, "comment");
  }

  notifyChangeComment(String docid, String authorID, String job) async {
    if (job == "comment") {
      userCollection
          .doc(authorID)
          .collection("notifyMe")
          .doc(docid)
          .set({"comments": FieldValue.increment(1)}, SetOptions(merge: true));
    } else if (job == "like") {
      userCollection
          .doc(authorID)
          .collection("notifyMe")
          .doc(docid)
          .set({"likes": FieldValue.increment(1)}, SetOptions(merge: true));
    }
  }

  getNotifications(String uid) {
    return userCollection.doc(uid).collection("notifyMe").snapshots();
  }

  clearNotifications(String docid, uid) async {
    await userCollection.doc(uid).collection("notifyMe").doc(docid).delete();
  }

  uploadImage(img, caption, bool regstate) async {
    var random = Random();
    var rand = random.nextInt(1000000000);
    // Give the image a random name
    String name = "image:$rand";
    try {
      final ext = extension(img.path);
      final image = storageRef.ref("image").child('$name$ext');
      await image.putFile(img);
      String url = await image.getDownloadURL();
      print(url);
      createPost(uid!, url, "image", caption, regstate);
      return ("Uploaded image");
      print("Uploaded image");
      // ignore: nullable_type_in_catch_clause
    } on FirebaseException catch (e) {
      print(e);
      return ("error");
    }
  }
  uploadFile(file, userid) async{
    try{
      String name = basenameWithoutExtension(file.path);
      String ext = extension(file.path);
      String newName = '$name:$userid$ext';
      final fileUpload = storageRef.ref("Files/$userid").child(newName);
      await fileUpload.putFile((file));
      String url = await fileUpload.getDownloadURL();
      print(url);
      return("successfull");
    } on FirebaseException catch(e){
      print(e);
      return ("error");
    }
  }

  String getExt(String res) {
    return res.substring(res.indexOf(".") + 1);
  }
//  create payment
  Future createPay(String id, url, postId) async {
    payCollection.add({
      "user": id,
      "url": url,
      "post": postId,
      'amount':"10"
    }).then((value) => {
    postCollection.doc(postId).update({
    'boost': true,
    })});

  }


//  statistics
// get doc count
 getUserCount() async{
   AggregateQuerySnapshot query = await  userCollection.count().get() ;
   return query.count.toString();
 }
  getUserPosts() async{
    AggregateQuerySnapshot query = await  postCollection.count().get() ;
    return query.count.toString();
  }
  getRegUserCount() async {
    AggregateQuerySnapshot query =
    await userCollection.where("reg", isEqualTo: true).count().get();
    return query.count.toString();
  }
  //Registered users posts
  getRegPostCount() async {
    AggregateQuerySnapshot query =
    await postCollection.where("reg", isEqualTo: true).count().get();
    return query.count.toString();
  }

  getBoostPostCount() async {
    AggregateQuerySnapshot query =
    await postCollection.where("boost", isEqualTo: true).count().get();
    return query.count.toString();
  }
  getPayCount() async{
    AggregateQuerySnapshot query = await  payCollection.count().get() ;
    return query.count.toString();
  }

  getsPay() {
    return payCollection.snapshots();
  }


}
