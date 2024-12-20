import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Admin/PickupAgent.dart';
import '../Admin/RequestPage.dart';
import '../Admin/Tab.dart';
import '../Login&Signin/loginPage.dart';
import '../User/UserHome.dart';

class AuthController extends ChangeNotifier{
  final TextEditingController UsernameController=TextEditingController();
  final TextEditingController PasswordController=TextEditingController();
  final TextEditingController EmailController=TextEditingController();
  final TextEditingController ConfirmpasswordController=TextEditingController();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();
  final FirebaseAuth Auth=FirebaseAuth.instance;
  final FirebaseAuth auth=FirebaseAuth.instance;
  Reister(context)async{
    try{
      String Email=EmailController.text.trim();
      String Username=UsernameController.text.trim();
      String Password=PasswordController.text.trim();
      String ConfirmPassword=ConfirmpasswordController.text.trim();
      EmailController.clear();
      UsernameController.clear();
      PasswordController.clear();
      ConfirmpasswordController.clear();
      if(Password!=ConfirmPassword){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password do not match!"))
        );
        return;
      }
      UserCredential userCredential=await Auth.createUserWithEmailAndPassword(email: Email, password: Password);
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      await firestore.collection("Users").doc(userCredential.user!.uid).set({
        "UserID":userCredential.user!.uid,
        "Email":Email,
        "Password":Password,
        "Username":Username
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration successful")));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: $e')),
      );
    }
    notifyListeners();
  }
  notifyListeners();
  Login(context)async{
    try{
      String email=emailController.text.trim();
      String password=passwordController.text.trim();
      UserCredential userCredential=await auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseFirestore firestore=FirebaseFirestore.instance;
      DocumentSnapshot userDoc=await firestore.collection("Users").doc(userCredential.user!.uid).get();
      emailController.clear();
      passwordController.clear();
      if(userDoc.exists){
        Map<String,dynamic>userData=userDoc.data() as Map<String,dynamic>;
        if(userData["Email"]=="whiztechadmin@1123.com"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>totab() ,));
        }else if(userData["Email"]=="pickupagent@1123.com"){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PickupAgentPage(),));
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PickupRequestPage(),));
        }
      }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in: Enter your correct Email & password"))
      );
    }
    notifyListeners();
  }
  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Loginpage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
}