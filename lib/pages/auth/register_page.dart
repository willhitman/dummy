import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:lifestyle/pages/auth/login_page.dart';
import 'package:lifestyle/pages/home_page_admin.dart';
import 'package:lifestyle/services/auth_service.dart';

import '../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

AuthService authService = AuthService();

final formKey = GlobalKey<FormState>();

class _RegisterPageState extends State<RegisterPage> {
  String email = "";
  String password = "";
  String verifyPassword = "";
  String userName = "";
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 105),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Lifestyle",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Register to know the Menu",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "User Name",
                              prefixIcon: Icon(
                                Icons.account_circle,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              userName = val;
                            });
                          },
                          validator: (val) {
                            if (val!.length < 6) {
                              return "Username must be at least 4 characters long";
                            } else {
                              return null;
                            }
                          }),
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
                      TextFormField(
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Verify Password",
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Theme.of(context).primaryColor,
                              )),
                          onChanged: (val) {
                            setState(() {
                              verifyPassword = val;
                            });
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Must not be empty";
                            }
                            if (val != password) {
                              return "Passwords did not match";
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

                              elevation: 0,
                            ),
                            onPressed: () {
                              reister();
                            },
                            child: const Text(
                              "Register Now",
                              style: TextStyle(fontSize: 16),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(TextSpan(
                          text: "Already have an acoount? ",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                              text: "Login here",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextScreenReplace(context, const LogInPage());
                                },
                            )
                          ]))
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  reister() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailPassword(userName, email, password)
          .then(
        (value) async {
          if (value == true) {
            await HelperFunctions.saveUserLoggedINStatus(true);
            await HelperFunctions.saveUserEmailSF(email);
            await HelperFunctions.saveUserNameSF(userName);

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
