import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiztec/Controller/Auth_Controller.dart';

import 'loginPage.dart';

class Signinpage extends StatelessWidget {
   Signinpage({super.key});
   final _formKey = GlobalKey<FormState>();


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Consumer<AuthController>(
        builder: (context,Auth,child){
          return Form(
            key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image(image: AssetImage("assets/images/whizteclogo2.jpg")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                     controller: Auth.EmailController,
                     decoration: InputDecoration(
                       hintText: "Enter your Email",
                         prefixIcon: Icon(Icons.email,color: Colors.indigo[900],),

                         border: OutlineInputBorder()
                     ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: Auth.UsernameController,
                      decoration: InputDecoration(
                        hintText: "Enter your Name",
                          prefixIcon: Icon(Icons.person,color: Colors.indigo[900],),

                          border: OutlineInputBorder()
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: Auth.PasswordController,
                      decoration: InputDecoration(
                          hintText: "password",
                          prefixIcon: Icon(Icons.lock,color: Colors.indigo[900],),
                          border: OutlineInputBorder()
                      ),
                      obscureText: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: Auth.ConfirmpasswordController,
                      decoration: InputDecoration(
                          hintText: "confirm Password",
                          prefixIcon: Icon(Icons.lock,color: Colors.indigo[900],),
                          border: OutlineInputBorder()
                      ),
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return "please confirm your password ";
                        }else if(value!=Auth.PasswordController.text){
                          return "Password do not match";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 50,),
                  ElevatedButton(onPressed: (){
                    if(_formKey.currentState!.validate()){
                      Provider.of<AuthController>(context,listen: false).Reister(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage(),));
                    }
                  },style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900],minimumSize: Size(370, 60),shape: BeveledRectangleBorder()),
                      child: Text("Sign-IN",style: TextStyle(color: Colors.white,fontSize: 20),)),
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.only(left: 110),
                    child: Row(
                      children: [
                        Text("Already have an account"),
                        TextButton(onPressed: (){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage(),));
                        }, child: Text("LogIN",))
                      ],
                    ),
                  ),
                ],
              ),

          );
        },
      ),
    );
  }
}

