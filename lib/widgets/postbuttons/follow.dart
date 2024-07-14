import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/services/database_service.dart';

import '../widgets.dart';

class followButton extends StatefulWidget {
  final String userID;
  const followButton({super.key, required this.userID});

  @override
  State<followButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<followButton> {
  followFunction(){
    if(widget.userID==FirebaseAuth.instance.currentUser!.uid){
      return showSnackBar(context,Colors.redAccent,"You Can Not Follow Yourself!");
    } else{
      DatabaseService().followAuthor(widget.userID, FirebaseAuth.instance.currentUser!.uid);
      print(widget.userID);
      print(FirebaseAuth.instance.currentUser!.uid);
      return showSnackBar(context,Colors.greenAccent,"Follow Successfull");
    }
  }
  @override
  Widget build(BuildContext context) {
    print(widget.userID);
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(150, 0, 0, 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            InkWell(
              child: const Icon(
                Icons.supervisor_account,
                size: 25,
              ),
              onTap: () async {
                followFunction();
              },
            ),
            const SizedBox(
              height: 5,
            ),
            StreamBuilder(
                stream: DatabaseService()
                    .getSingleUser(widget.userID),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data["followers"].length.toString());
                  }
                  return const Text("-");
                })
          ],
        ),
      ),
    );
  }

}
