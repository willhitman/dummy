import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/widgets/widgets.dart';

class LikeButton extends StatefulWidget {
  final String docid;
  final String userID;

  var number;
  LikeButton(
      {super.key,
      required this.number,
      required this.docid,
      required this.userID});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {

  @override
  void innitState() {
    super.initState();
    checkStatus();
  }
  bool _status = false;
  @override
  Widget build(BuildContext context) {
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
              child: !_status
                  ? const Icon(
                      Icons.favorite_outline,
                      size: 25,
                    )
                  : const Icon(
                      Icons.favorite,
                      size: 25,
                      color: Colors.red,
                    ),
              onTap: () {
                if (!_status) {
                  checkStatus().then((value){
                    Like();
                  });
                } else {
                  showSnackBar(context, Colors.greenAccent, "Already liked");
                }
              },
            ),
            const SizedBox(
              height: 5,
            ),
            Text(widget.number.toString())
          ],
        ),
      ),
    );
  }

  checkStatus() async {
    await DatabaseService()
        .checkMembership(widget.docid, FirebaseAuth.instance.currentUser!.uid)
        .then((value) {
          print(value);
          setState(() {
            _status = value;
          });
    });
    return _status;
  }

  Like() async {
    print(!_status);
    if (!_status) {
      await DatabaseService().userLikePost(
          widget.docid, widget.userID, FirebaseAuth.instance.currentUser!.uid);
    }
  }
}
