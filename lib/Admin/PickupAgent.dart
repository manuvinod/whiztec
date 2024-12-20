import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Controller/Auth_Controller.dart';
import 'agentUpdation.dart';

class PickupAgentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Center(
          child: Text(
            'Pickup Agent',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              AuthController().logout(context);
            },
            icon: Icon(Icons.power_settings_new_outlined, color: Colors.white),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pick').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No pickup requests available.'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var request = snapshot.data!.docs[index];
              var userName = request['userName'] ?? 'Unknown User';
              var itemDetails = request['itemDetails'] ?? 'N/A';
              var location = request['location'] ?? 'N/A';
              var pickupDate = request['pickupDate'] ?? 'N/A';
              var documentId = request.id;

              return Column(
                children: [
                  ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$userName',style: TextStyle(color: Colors.indigo[900],fontWeight: FontWeight.bold),),
                      ],
                    ),
                    subtitle: Text('Date: $pickupDate'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PickupDetailsPage(
                              userName: userName,
                              itemDetails: itemDetails,
                              location: location,
                              pickupDate: pickupDate,
                              pickupDocId: documentId,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[900]),
                      child: Text(
                        "Status",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 15),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
