import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:lifestyle/pages/admin/home.dart';
import 'package:lifestyle/pages/admin/like.dart';
import 'package:lifestyle/pages/admin/new.dart';
import 'package:lifestyle/pages/admin/posts.dart';
import 'package:lifestyle/pages/admin/profile.dart';
import 'package:lifestyle/pages/auth/login_page.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/widgets/widgets.dart';
import 'dart:io';
import '../services/auth_service.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class HomePageAdmin extends StatefulWidget {
  const HomePageAdmin({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePageAdmin> {
  late File? _image;
  final picker = ImagePicker();
  // these we will get from shared preferences
  String userName = "";
  String email = "";
  String groupName = "";
  AuthService authService = AuthService();
  @override
  void initState() {
    _image = null;
    super.initState();
    gettingUserData();
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserName();
  }

  // String manipulation to get group ID and name
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
  }

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  final List<Widget> _pages = [
    AdminHome(),
    AdminPosts(),
    NewPost(),
    AdminLikes(),
    AdminProfile( userID: FirebaseAuth.instance.currentUser!.uid,)
  ];
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    void _navigationBottomBar(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          automaticallyImplyLeading: false,
          title: const Text(
            "LifeStyle",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: _navigationBottomBar,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Posts"),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined), label: "Likes"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Profile"),
          ],
        ));
  }

  getImage() async {
    // You can also change the source to gallery like this: "source: ImageSource.camera"
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image has been selected.');
      }
    });
  }
}
