import 'package:flutter/material.dart';

import '../../pages/admin/pay.dart';

class boostButton extends StatefulWidget {
  final String docid;
  final String userID;

  // ignore: non_constant_identifier_names
  const boostButton({super.key, required this.docid, required this.userID});

  @override
  State<boostButton> createState() => _BoostButtonState();
}

class _BoostButtonState extends State<boostButton> {
  TextEditingController phone = TextEditingController();
  bool state = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(150, 0, 0, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              InkWell(
                child: const Icon(
                  Icons.auto_graph,
                  size: 25,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                               PayWithEco(postID: widget.docid,)));
                },
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  sendPayments(phone, email) async {
    if(phone.length != 10){

    }
  }
}
