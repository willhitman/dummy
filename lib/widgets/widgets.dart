import 'package:flutter/material.dart';

// text input decoration
const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),
  focusedBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
  enabledBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  errorBorder:
      OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
);
// end of text input decoration

// routing

void nextScreen(context, page) {
  // this method creates an array of pages very bad do not use especially on register and login page switch unless you want to violate the unique key constraint of formkey
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}
// end of routing

// show a Snackbar
void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(

    content: Text(
      message,
      style: const TextStyle(fontSize: 14),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
  ));
}
