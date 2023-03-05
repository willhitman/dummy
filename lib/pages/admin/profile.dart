import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:lifestyle/widgets/follows.dart';

import '../../services/database_service.dart';
import '../../widgets/posts_template.dart';
import '../../widgets/widgets.dart';

class AdminProfile extends StatefulWidget {
  final String userID;
  const AdminProfile({Key? key, required this.userID}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String author = "";
  String author2 = "";
  final aboutformKey = GlobalKey<FormState>();
  final optionsformKey = GlobalKey<FormState>();
  bool _aboutLoading = false;
  String _uploadResult = "";
  bool isUploadingDoc = false;
  bool _regState = false;
  bool _regUserState = false;

  //preload followers
  var followers = [];
  //check followers greater than zero
  bool _hasFollowers = false;
  var ids = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRegState(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    final _controler = PageController(initialPage: 0);
    late File? _file;

    String about = "";
    return Scaffold(
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            widget.userID != FirebaseAuth.instance.currentUser!.uid
                ? SizedBox(
                    height: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        widget.userID != FirebaseAuth.instance.currentUser!.uid
                            ? InkWell(
                                child: Icon(Icons.arrow_back),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              )
                            : SizedBox(),
                        widget.userID == FirebaseAuth.instance.currentUser!.uid
                            ? const SizedBox()
                            : const Padding(
                                padding: EdgeInsets.only(left: 120.0),
                                child: Text(
                                  "The Menu",
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              )
                      ],
                    ),
                  )
                : SizedBox(),
            StreamBuilder(
                stream: DatabaseService().getSingleUser(widget.userID),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(100, 255, 255, 255),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                                child: Column(
                                  children: [
                                    const Center(
                                        child: Text(
                                      "Your Profile",
                                      style: TextStyle(fontSize: 20),
                                    )),
                                    //Profile picture
                                    const Icon(
                                      Icons.account_circle_rounded,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 50,
                                      child: Column(children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            widget.userID ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Text(
                                                    HelperFunctions.userNameKey)
                                                : Text(
                                                    snapshot.data["fullName"]),
                                            _regState
                                                ? const Icon(
                                                    Icons.verified,
                                                    color: Colors.yellowAccent,
                                                    size: 15,
                                                  )
                                                : const Icon(
                                                    Icons.verified,
                                                    color: Colors.transparent,
                                                    size: 15,
                                                  )
                                          ],
                                        ),
                                        widget.userID ==
                                                FirebaseAuth
                                                    .instance.currentUser!.uid
                                            ? Text(HelperFunctions.userEmailKey)
                                            : Text(snapshot.data["email"]),
                                      ]),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text('Posts'),
                                            const Icon(Icons.list),
                                            Text(snapshot.data["posts"].length
                                                .toString())
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        InkWell(
                                          child: Column(
                                            children: [
                                              const Text('Followers'),
                                              const Icon(
                                                  Icons.supervisor_account),
                                              Text((snapshot
                                                      .data["followers"].length)
                                                  .toString())
                                            ],
                                          ),
                                          onTap: () {
                                            showBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        225, 0, 0, 0),
                                                builder: (context) {
                                                  return SizedBox(
                                                      height: 550,
                                                      width: double.infinity,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Wrap(children: [
                                                          Column(
                                                            children: [
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  InkWell(
                                                                    child: const Icon(
                                                                      Icons
                                                                          .close,
                                                                      size: 20,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                    onTap: () =>
                                                                        Navigator.pop(
                                                                            context),
                                                                  )
                                                                ],
                                                              ),
                                                              FollowCard(
                                                                  data: snapshot
                                                                          .data[
                                                                      "followers"])
                                                            ],
                                                          ),
                                                        ]),
                                                      ));
                                                });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        InkWell(
                                          child: Column(
                                            children: [
                                              const Text('Following'),
                                              const Icon(Icons
                                                  .supervisor_account_outlined),
                                              Text((snapshot
                                                      .data["following"].length)
                                                  .toString())
                                            ],
                                          ),
                                          onTap: () {
                                            showBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        225, 0, 0, 0),
                                                builder: (context) {
                                                  return SizedBox(
                                                      height: 550,
                                                      width: double.infinity,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .end,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                  child: Icon(
                                                                    Icons.close,
                                                                    size: 20,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                  onTap: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                )
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                // stream followers here
                                                                FollowCard(
                                                                    data: snapshot
                                                                            .data[
                                                                        "following"])
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ));
                                                });
                                          },
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        //About Section here
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(100, 255, 255, 255),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(children: [
                                  const Text("About"),
                                  SizedBox(
                                      width: (_screenSize.width - 60),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              snapshot.data["description"]
                                                      .toString()
                                                      .isNotEmpty
                                                  ? Text(snapshot
                                                      .data["description"]
                                                      .toString())
                                                  : widget.userID ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                      ? const Text(
                                                          "Tap Edit icon to add description")
                                                      : const Text(".."),
                                              widget.userID ==
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid
                                                  ? SizedBox(
                                                      width: 20,
                                                      child: InkWell(
                                                        child: const Icon(
                                                            Icons.edit),
                                                        onTap: () {
                                                          showBottomSheet(
                                                              context: context,
                                                              backgroundColor:
                                                                  const Color
                                                                          .fromARGB(
                                                                      225,
                                                                      0,
                                                                      0,
                                                                      0),
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return SizedBox(
                                                                  height: 150,
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                    children: [
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 20),
                                                                        child: Text(
                                                                            "Edit your About"),
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            Form(
                                                                          key:
                                                                              aboutformKey,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  width: 300,
                                                                                  child: TextFormField(
                                                                                    decoration: textInputDecoration.copyWith(
                                                                                        labelText: "About",
                                                                                        prefixIcon: Icon(
                                                                                          Icons.question_mark,
                                                                                          color: Theme.of(context).primaryColor,
                                                                                        )),
                                                                                    onChanged: (val) {
                                                                                      setState(() {
                                                                                        about = val;
                                                                                      });
                                                                                    },
                                                                                    validator: (val) {
                                                                                      if (val!.length < 6) {
                                                                                        return "About must be at least 6 characters long";
                                                                                      } else {
                                                                                        return null;
                                                                                      }
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 10,
                                                                                ),
                                                                                InkWell(
                                                                                    onTap: () {
                                                                                      uploadAbout(about);
                                                                                    },
                                                                                    child: const Icon(
                                                                                      Icons.check_circle,
                                                                                      color: Colors.green,
                                                                                    ))
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  )),
                                                                );
                                                              });
                                                        },
                                                      ))
                                                  : const SizedBox()
                                            ]),
                                      )),
                                ])),
                          ),
                        ),
                      ],
                    );
                  }
                  return const CircularProgressIndicator();
                }),
            //Options Here
            widget.userID == FirebaseAuth.instance.currentUser!.uid
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(100, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          const Text("Options"),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                ),
                                onPressed: () {
                                  showBottomSheet(
                                      context: context,
                                      backgroundColor:
                                          const Color.fromARGB(200, 0, 0, 0),
                                      builder: (BuildContext context) {
                                        return SizedBox(
                                          height: 500,
                                          width: _screenSize.width,
                                          child: SingleChildScrollView(
                                              child: Column(
                                            children: [
                                              const SizedBox(height: 140),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 8.0),
                                                child: Text(
                                                  "Upload Relevant Documents",
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                  ),
                                                ),
                                              ),
                                              Form(
                                                key: optionsformKey,
                                                child: Row(
                                                  children: [
                                                    Column(children: [
                                                      const Text(
                                                        "Pick your Company Documents",
                                                        style: TextStyle(
                                                            fontSize: 20),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 50),
                                                        child: InkWell(
                                                          child: const Icon(
                                                            Icons
                                                                .folder_copy_rounded,
                                                            size: 50,
                                                          ),
                                                          onTap: () async {
                                                            FilePickerResult?
                                                                result =
                                                                await FilePicker
                                                                    .platform
                                                                    .pickFiles(
                                                              type: FileType
                                                                  .custom,
                                                              allowedExtensions: [
                                                                'pdf'
                                                              ],
                                                              allowMultiple:
                                                                  true,
                                                            );
                                                            if (result !=
                                                                null) {
                                                              List<File> files = result
                                                                  .paths
                                                                  .map((path) =>
                                                                      File(
                                                                          path!))
                                                                  .toList();
                                                              for (final fl
                                                                  in files) {
                                                                _file = fl;
                                                                uploadDoc(
                                                                    _file);
                                                              }
                                                            } else {
                                                              // User canceled the picker
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            _screenSize.width,
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20.0),
                                                          child: Text(
                                                            "Tap the Folder icon and select all relevent documents that prove you are a registered food service provider",
                                                          ),
                                                        ),
                                                      ),
                                                    ]),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )),
                                        );
                                      });
                                },
                                child: const Text(
                                  "Register as a Food Provider",
                                  style: TextStyle(fontSize: 16),
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            StreamBuilder(
                stream: DatabaseService().getPostsByUserID(widget.userID),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var doc in snapshot.data!.docs)
                          SizedBox(
                            height: _screenSize.height - 150,
                            child: PostTemplate(
                              likes: doc["likes"],
                              comments: doc["comments"],
                              url: doc["content"],
                              postid: doc.id.toString(),
                              caption: doc["caption"],
                              userID: doc["user"],
                            ),
                          )
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text("You have no Posts at the Moment"),
                    );
                  }
                  return const CircularProgressIndicator();
                })
          ],
        ),
      ),
    );
  }

  uploadDoc(file) async {
    await DatabaseService().uploadFile(file, widget.userID);
  }

  String afterWork(file) {
    showSnackBar(
        context, Colors.greenAccent, "Uploading Your Documents Please Wait");
    uploadDoc(file).then((value) {
      if (value == "successfull") {
        setState(() {
          _uploadResult = "successfull";
        });
        showSnackBar(context, Colors.greenAccent,
            "Uploading Your Documents Please Wait");
      } else {
        setState(() {
          _uploadResult = "error";
        });
        showSnackBar(context, Colors.greenAccent, "Uploading Documents Failed");
      }
      return _uploadResult;
      //  add values to DB here
    });
    return _uploadResult;
  }

  getAuthorName(var uid) async {
    DocumentSnapshot authorName =
        await DatabaseService().getPostAuthorName(uid);
    return authorName["fullName"];
  }

  String nameAuthor(uid) {
    getAuthorName(uid).then((value) {
      setState(() {
        author = value;
      });
    });
    return author;
  }

  nameFollowing(uid) {
    getAuthorName(uid).then((value) {
      setState(() {
        author2 = value;
      });
    });
    return author2;
  }

  uploadAbout(about) async {
    if (aboutformKey.currentState!.validate()) {
      setState(() {
        _aboutLoading = true;
      });
      await DatabaseService().addAbout(widget.userID, about).then((val) => {
            setState(() {
              _aboutLoading = false;
            })
          });
    }
  }

  getRegState(userid) {
    DatabaseService().userCollection.doc(userid).get().then((document) {
      setState(() {
        _regState = document["reg"];
      });
    });
    print(_regState);
    return _regState;
  }

  bool getRegUserState(userid) {
    DatabaseService().userCollection.doc(userid).get().then((document) {
      setState(() {
        _regUserState = document["reg"];
      });
    });
    print(_regUserState);
    return _regUserState;
  }
}
