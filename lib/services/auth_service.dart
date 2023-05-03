import 'package:firebase_auth/firebase_auth.dart';
import 'package:lifestyle/helper/helper_function.dart';
import 'package:lifestyle/services/database_service.dart';

class AuthService {
  // create an Auth Instance
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // login
  Future loginWithUserNamePassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await HelperFunctions.saveUserLoggedINStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      if (user != null) {
        // call database to update user
        await HelperFunctions.saveUserLoggedINStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        // login
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return (e.message);
    }
  }

  // register
  Future registerUserWithEmailPassword(
      String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      await HelperFunctions.saveUserLoggedINStatus(true);
      await HelperFunctions.saveUserEmailSF(email);
      await HelperFunctions.saveUserNameSF(fullName);
      if (user != null) {
        // call database to update user
        await DatabaseService(uid: user.uid).savingUserData(fullName, email);
        await HelperFunctions.saveUserLoggedINStatus(true);
        await HelperFunctions.saveUserEmailSF(email);
        await HelperFunctions.saveUserNameSF(fullName);
        // login
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      return (e.message);
    }
  }

// logout user
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedINStatus(false);
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
