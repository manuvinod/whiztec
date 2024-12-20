import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whiztec/Controller/Auth_Controller.dart';
import 'package:whiztec/Login&Signin/SignInPage.dart';

class Loginpage extends StatelessWidget {
   Loginpage({super.key});
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
                    controller: Auth.emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                        prefixIcon: Icon(Icons.email,color: Colors.indigo[900],),
                      border: OutlineInputBorder()
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: Auth.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: Icon(Icons.lock,color: Colors.indigo[900],),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
                SizedBox(height: 200,),
                ElevatedButton(onPressed: ()=>Auth.Login(context),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo[900],minimumSize:Size(370, 60),shape: BeveledRectangleBorder()),
                    child: Text("Log-IN",style: TextStyle(color: Colors.white,fontSize: 20),)),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 110),
                  child: Row(
                    children: [
                      Text("Creat a new account"),
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Signinpage(),));
                      }, child: Text("SignIN"))
                    ],
                  ),
                ),
              ],
            ));
      }),
    );
  }
}
