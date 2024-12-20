import 'package:flutter/material.dart';
import 'package:whiztec/Controller/Auth_Controller.dart';

import 'PickUpPage.dart';
import 'RequestPage.dart';
class totab extends StatelessWidget {
  const totab({super.key});

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo[900],
            title: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Center(child: Text("WHIZTEC",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
            ),
            actions: <Widget>[
              IconButton(onPressed: (){
                AuthController().logout(context);
              }, icon: Icon(Icons.power_settings_new_outlined,color: Colors.white,)),

            ],
            bottom: TabBar(tabs: [
              Tab(text: "Request",),
              Tab(text: "Pickup",),
            ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.white,
            ),
          ),
          body: TabBarView(children: [
            UserReuest(),
            PickupStatusDetailsPage()
          ],
          ),
        )
    );
  }
}
