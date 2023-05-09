import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../services/database_service.dart';
import '../../widgets/admin/card_stat.dart';
import '../../widgets/pay_restaurant_admin.dart';
import '../../widgets/reg_restaurant_card.dart';

class AdminView extends StatefulWidget {
  const AdminView({Key? key}) : super(key: key);

  @override
  State<AdminView> createState() => _AdminViewState();
}
//post per premium user
//paid users
// total promoted posts
//registered restaurants

class _AdminViewState extends State<AdminView> {
  String users = "";
  late String author = "The Menu";
  var doc;
  Stream<QuerySnapshot>? usersStream;
  Stream<QuerySnapshot>? pay;
  preload() {
    usersStream = DatabaseService().getUserByReg();
  }

  preload1() {
    pay = DatabaseService().getsPay();
  }

  userCount() {
    String countVal = "";
    // DatabaseService().getUserCount().then((count){
    //   countVal = count.toString();
    //   print("ttttttttt");
    //   print((countVal));
    //   users = countVal;
    //   print(users);
    // });
    // users = countVal;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preload();
    preload1();
  }

  @override
  void dispose() {
    super.dispose();
    preload();
    preload1();
    getPayCount();
    getBoostCount();
    getRegCount();
    getRegPosts();
    getUserPosts();
    getUserCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("The Menu"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("General Infomation"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Card(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Users"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(userCountInt().toString())
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Posts"),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(postsCountInt().toString())
                                  ],
                                ),
                              ),
                            ),
                            Card(
                              child: Center(
                                child: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Registered Users Posts",
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(regPostInt().toString())
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        //Profile picture
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Registered Users Posts"),
                        Column(
                          children: [
                            StreamBuilder(
                                stream: usersStream,
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    print('hasData');
                                    var docs = snapshot.data.docs;
                                    return Column(
                                      children: [
                                        for (doc in docs)
                                          ResUserCard(
                                            (doc.data()["fullName"].toString()),
                                            userId: (doc.data()['fullName'])
                                                .toString(),
                                            userName:
                                                (doc.data()['uid']).toString(),
                                          )
                                      ],
                                    );
                                    return ListTile(
                                      leading: Text("click to see posts"),
                                      title: doc.data()["likes"],
                                    );
                                    // return PageView(
                                    //     controller: _controler,
                                    //     scrollDirection: Axis.vertical,
                                    //     children: [
                                    //       for (doc in docs)
                                    //         PostTemplate (
                                    //           likes: doc.data()["likes"],
                                    //           comments: doc.data()["comments"],
                                    //           url: doc.data()["content"],
                                    //           postid: doc.id.toString(),
                                    //           caption: doc.data()["caption"],
                                    //           userID: doc.data()["user"], DocumentReference: doc.reference,)
                                    //     ]);
                                  }
                                  return SizedBox();
                                }),
                          ],
                        )
                      ]),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 255, 255, 255),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Restaurant Monetary Information"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Users Verified"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(userRegInt().toString())
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Posts Boosted"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(postBoostInt().toString())
                                ],
                              ),
                            ),
                          ),
                          Card(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Center(child: Text("Payments Made")),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(postPayInt().toString())
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text("Payments"),
                          StreamBuilder(
                              stream: pay,
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  print('Payments');
                                  var docs = snapshot.data.docs;
                                  return Column(
                                    children: [
                                      for (doc in docs)
                                        PaymentCard(
                                          doc.data()["user"].toString(),
                                          userId: doc.data()["user"].toString(),
                                          amount:
                                              doc.data()["amount"].toString(),
                                        )
                                    ],
                                  );
                                  return ListTile(
                                    leading: Text("click to see posts"),
                                    title: doc.data()["likes"],
                                  );
                                  // return PageView(
                                  //     controller: _controler,
                                  //     scrollDirection: Axis.vertical,
                                  //     children: [
                                  //       for (doc in docs)
                                  //         PostTemplate (
                                  //           likes: doc.data()["likes"],
                                  //           comments: doc.data()["comments"],
                                  //           url: doc.data()["content"],
                                  //           postid: doc.id.toString(),
                                  //           caption: doc.data()["caption"],
                                  //           userID: doc.data()["user"], DocumentReference: doc.reference,)
                                  //     ]);
                                }
                                return SizedBox();
                              }),
                        ],
                      )

                      //Profile picture
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//  user count
  getUserCount() async {
    String users = await DatabaseService().getUserCount();
    return users;
  }

  String usersCount = "";
  String userCountInt() {
    getUserCount().then((count) {
      setState(() {
        usersCount = count;
        // print(count);
      });
      // print(usersCount);
    });
    return usersCount;
  }
// end user count

//get total posts
  getUserPosts() async {
    String posts = await DatabaseService().getUserPosts();
    return posts;
  }

  String postsCount = "";
  String postsCountInt() {
    getUserPosts().then((count) {
      setState(() {
        postsCount = count;
        // print(count);
      });
      // print(postsCount);
    });
    return postsCount;
  }

//  get total registered users
  getRegCount() async {
    String reg = await DatabaseService().getRegUserCount();
    return reg;
  }

  String usersReg = "";
  String userRegInt() {
    getRegCount().then((count) {
      setState(() {
        usersReg = count;
        print(count);
      });
      // print(usersReg);
    });
    return usersReg;
  }

//  boost
  getBoostCount() async {
    String boost = await DatabaseService().getBoostPostCount();
    return boost;
  }

  String postBoost = "";
  String postBoostInt() {
    getBoostCount().then((count) {
      setState(() {
        postBoost = count;
        print(count);
      });
      // print(postBoost);
    });
    return postBoost;
  }

//  get pay
  getPayCount() async {
    String pay = await DatabaseService().getPayCount();
    return pay;
  }

  String postPay = "";
  String postPayInt() {
    getPayCount().then((count) {
      setState(() {
        postPay = count;
        print(count);
        getPayCount();
      });
      // print(postPay);
    });
    return postPay;
  }

  //registered posts count
  getRegPosts() async {
    String reg = await DatabaseService().getRegPostCount();
    return reg;
  }

  String regPost = "";
  String regPostInt() {
    getRegPosts().then((count) {
      setState(() {
        regPost = count;
        print(count);
      });
      // print(regPost);
    });
    return regPost;
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
