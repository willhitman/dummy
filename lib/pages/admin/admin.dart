import 'package:flutter/material.dart';

import '../../services/database_service.dart';
import '../../widgets/admin/card_stat.dart';

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
userCount(){
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
  void initState()  {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("The Menu"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Center(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 255, 255, 255),
                    borderRadius:
                    BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding:
                   EdgeInsets.symmetric(vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      const Text("General Infomation"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Card(
                            child: Column(
                              children: [
                                Text("Users"),
                                SizedBox(height: 10,),
                                Text(userCountInt().toString())
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                Text("Posts"),
                                SizedBox(height: 10,),
                                Text(postsCountInt().toString())
                              ],
                            ),
                          ),
                          Card(
                            child: Column(
                              children: [
                                Text("Payments"),
                                SizedBox(height: 10,),
                                Text("12")
                              ],
                            ),
                          )
                        ],
                      ),
                      //Profile picture

                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Center(
              child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Color.fromARGB(100, 255, 255, 255),
                  borderRadius:
                  BorderRadius.all(Radius.circular(10))),
              child: Padding(
                padding:
                EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:  [
                    const Text("Monitery Infomation"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Card(
                          child: Column(
                            children: [
                              Text("Users Verified"),
                              SizedBox(height: 10,),
                              Text(userRegInt().toString())
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              Text("Posts Boosted"),
                              SizedBox(height: 10,),
                              Text(postBoostInt().toString())
                            ],
                          ),
                        ),
                        Card(
                          child: Column(
                            children: [
                              Text("Payments Made"),
                              SizedBox(height: 10,),
                              Text(postPayInt().toString())
                            ],
                          ),
                        )
                      ],
                    ),
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
  getUserCount().then((count){
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
    getUserPosts().then((count){
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
    getRegCount().then((count){
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
    getBoostCount().then((count){
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
    getPayCount().then((count){
      setState(() {
        postPay = count;
        print(count);
      });
      // print(postPay);
    });
    return postPay;
  }
}