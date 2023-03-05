import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:lifestyle/pages/home_page_admin.dart';
import 'package:lifestyle/widgets/widgets.dart';

import '../../services/database_service.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NewPost> {
  late File? _image ;
  final picker = ImagePicker();
  bool _isLoading = false;
  TextEditingController captionController = TextEditingController();
  bool _regState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _image = null;
    getRegState(FirebaseAuth.instance.currentUser!.uid);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: <Widget>[
                  Container(
                    child: _image == null
                        ? Center(
                            child: ElevatedButton(
                              child: const Icon(Icons.add_a_photo),
                              onPressed: () => getImage(),
                            ),
                          )
                        : Center(child: Image.file(_image!)),
                  ),
                  Container(
                    child: _image == null
                        ?
                        // display nothing if image is empty
                        Container()
                        : Container(
                            alignment: Alignment.bottomCenter,
                            child: TextFormField(
                              controller: captionController,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                              decoration: const InputDecoration(
                                  hintText: "Caption ...",
                                  filled: true,
                                  fillColor: Colors.black,
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  border: InputBorder.none),
                            ),
                          ),
                  ),
                ],
              ),
        floatingActionButton: _image == null
            ? Container()
            : FloatingActionButton(
                backgroundColor: Colors.white,
                child: const Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () async {
                  if (_image != null) {
                    setState(() {
                      _isLoading = true;
                    });
                    final cap = captionController.text.isNotEmpty
                        ? captionController.text.trim()
                        : "";
                    print(cap);
                    final uploadimage = DatabaseService(
                            uid: FirebaseAuth.instance.currentUser!.uid)
                        .uploadImage(_image, cap, _regState);
                    await uploadimage;
                    String result = uploadimage.toString();
                    print(result);
                    if (result == "Uploaded image") {
                      // add caption to post and uid

                    } else {
                      showSnackBar(
                          context, Colors.red, "Failed to create post");
                    }
                    setState(() {
                      _isLoading = false;
                    });
                    nextScreen(context, const HomePageAdmin());
                  }
                },
              ));
  }

  getImage() async {
    // You can also change the source to gallery like this: "source: ImageSource.camera"
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        showSnackBar(
            context, Colors.orange, "Please pick image to create post");
      }
    });
  }
  getRegState(userid){
    DatabaseService().userCollection.doc(userid).get().then((document){
      setState(() {
        _regState = document["reg"];
      });

    });
    print(_regState);
    return _regState;
  }
}
