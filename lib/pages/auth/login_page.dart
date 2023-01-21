import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/pages/auth/register_page.dart';
import 'package:lifestyle/services/database_service.dart';
import 'package:lifestyle/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../helper/helper_function.dart';
import '../home_page_admin.dart';

class LogInPage extends StatefulWidget {
  LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() {
    return _LogInPageState();
  }
}

String email = "";
String password = "";

class _LogInPageState extends State<LogInPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _isLoading
          ? SafeArea(
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 150),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "LifeStyle",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "See whats happening",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              email = val;
                              print(email);
                            });
                          },
                          validator: (val) {
                            return RegExp(
                                        "([!#-'*+/-9=?A-Z^-~-]+(.[!#-'*+/-9=?A-Z^-~-]+)*|\"([]!#-[^-~ \t]|(\\[\t -~]))+\")@([!#-'*+/-9=?A-Z^-~-]+(.[!#-'*+/-9=?A-Z^-~-]+)*|[[\t -Z^-~]*])")
                                    .hasMatch(val!)
                                ? null
                                : "Please Enter a valid Email";
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Theme.of(context).primaryColor,
                                )),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                                print(password);
                              });
                            },
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must be at least 6 characters long";
                              } else {
                                return null;
                              }
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 0,
                              ),
                              onPressed: () {
                                login();
                              },
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 16),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text.rich(TextSpan(
                            text: "Don't have an acoount? ",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Register here",
                                style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    nextScreenReplace(context, RegisterPage());
                                  },
                              )
                            ]))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  login() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService.loginWithUserNamePassword(email, password).then(
        (value) async {
          if (value == true) {
            QuerySnapshot snapshot = await DatabaseService(
                    uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(email);
            // storing values to shared preferrences
            await HelperFunctions.saveUserLoggedINStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(snapshot.docs[0]['fullName']);
            // ignore: use_build_context_synchronously
            nextScreen(context, const HomePageAdmin());
          } else {
            showSnackBar(context, Colors.redAccent, value);
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    }
  }
}
