import 'package:flutter/material.dart';


class CardStat extends StatefulWidget {
  final String val;
  const CardStat({super.key, required this.val,});

  @override
  State<CardStat> createState() => _cardStatState();
}

class _cardStatState extends State<CardStat> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context){
    return Card(
      child: Column(
        children: [
          const Text("Users"),
          const SizedBox(height: 10,),
          Text(widget.val)
        ],
      ),
    );
  }
}
