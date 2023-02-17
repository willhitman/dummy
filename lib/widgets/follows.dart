import 'package:flutter/material.dart';

class FollowCard extends StatefulWidget {
  final String user;
  final bool regState;
  const FollowCard({Key? key, required this.user, required this.regState}) : super(key: key);

  @override
  State<FollowCard> createState() => _FollowCardState();
}

class _FollowCardState extends State<FollowCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ListTile(
        leading: const Icon(Icons.account_circle),
        title: Row(
          children: [
            Text(widget.user),
            widget.regState? const Icon(Icons.verified, color: Colors.yellowAccent,size: 15,) : const Icon(Icons.verified, color: Colors.transparent, size: 15,)
          ],
        ),
      ),
    );
  }
}
