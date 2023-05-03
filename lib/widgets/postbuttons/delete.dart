import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets.dart';

class DeletePosts extends StatefulWidget {
  final DocumentReference;
  const DeletePosts({Key? key,required this.DocumentReference}) : super(key: key);

  @override
  State<DeletePosts> createState() => _DeletePostsState();
}

class _DeletePostsState extends State<DeletePosts> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("delete"),
      onPressed: () async {
        try{
          await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
             myTransaction.delete(widget.DocumentReference);
            showSnackBar(context, Colors.greenAccent, "Post has been Deleted");
            Navigator.of(context).pop();
          });
        } catch(e){

        }

      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("AlertDialog"),
      content: const Text(
          "Do you want to delete post? You will not be able to reverse this action"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
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
              child: const Icon(
                Icons.delete,
                size: 25,
              ),
              onTap: () {
                showAlertDialog(context);
              },
            ),
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }


}
